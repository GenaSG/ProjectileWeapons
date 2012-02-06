////////////////////////////////////////////////////////////////
// PeZBOT, version: 004p
// Author: PEZZALUCIFER
// Based on modwarfare
// Feel free to add this gsc to any mod you like, just give credit to PeZBOT.
// Any and all feedback is welcome --> perry_hart@hotmail.com
// This is pre-alpha code, meaning it is in no way feature complete, enjoy :)
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
init()
{
	if (getdvar("svr_pezbots") == "")			setdvar("svr_pezbots", 0);
	if (getdvar("svr_pezbots_team") == "")		setdvar("svr_pezbots_team", "autoassign");
	if (getdvar("svr_pezbots_drawdebug") == "")			setdvar("svr_pezbots_drawdebug", 0);
	if (getdvar("svr_pezbots_dogpack_size") == "")			setdvar("svr_pezbots_dogpack_size", 0);
	if (getdvar("svr_pezbots_skill") == "")			setdvar("svr_pezbots_skill", 0.5);
	if (getdvar("svr_pezbots_mode") == "")			setdvar("svr_pezbots_mode", "normal");

  //load waypoints for level
	LoadStaticWaypoints();

  if(getdvar("svr_pezbots_mode") == "dev")
  { 
    setdvar("svr_pezbots_drawdebug", 1);
  	thread StartDev();
    thread DrawStaticWaypoints();
  }
  else
  {
  	thread StartNormal();
  	thread WatchForBuggyBots();
    thread DrawStaticWaypoints();
  }
	
}

////////////////////////////////////////////////////////////
// Watch for buggybots
////////////////////////////////////////////////////////////
WatchForBuggyBots()
{

  while(1)
  {
    if(isDefined(level.players))
    {
      for(i = 0; i < level.players.size; i++)
      {
        player = level.players[i];
        
	      if(player.sessionstate == "playing" && isDefined(player.bIsBot) && player.bIsBot)
	      {
	        if(DistanceSquared(player.origin, player.lastOrigin) <= 4)
	        {
	          player.buggyBotCounter++;
          }
	        else
	        {
  	        player.lastOrigin = player.origin;
	          player.buggyBotCounter = 0;
	        }
	  
          //stuck so suicide
	  	    if(player.buggyBotCounter >= 200)
	  	    {
 		        newent = spawnstruct();
		        newent.isPlayer = true;
		        newent.isADestructable = false;
		        newent.entity = player;
		        newent.damageCenter = player.origin;
            
            //kill target
		        newent maps\mp\gametypes\_weapons::damageEnt(
			        player, // eInflictor = the entity that causes the damage (e.g. a claymore)
			        player, // eAttacker = the player that is attacking
			        10000, // iDamage = the amount of damage to do
			        "MOD_SUICIDE", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
			        "none", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
			        player.origin, // damagepos = the position damage is coming from
			        (0,1,0) // damagedir = the direction damage is moving in      
		        );
		      }
        }  		  
		  }
		}
		wait 0.05;
  }
}


////////////////////////////////////////////////////////////
// can we debugdraw???
///////////////////////////////////////////////////////////
CanDebugDraw()
{
  if(getdvarInt("svr_pezbots_drawdebug") >= 1)
    return true;
  else
    return false;
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
PreCache()
{

  precacheItem("m16_mp_pezbot_stand_idle");
  precacheItem("m16_mp_pezbot_stand_walk");
  precacheItem("m16_mp_pezbot_stand_run");
  precacheItem("m16_mp_pezbot_stand_back");
  precacheItem("m16_mp_pezbot_stand_left");
  precacheItem("m16_mp_pezbot_stand_right");  
  
  precacheItem("frag_mp_pezbot_stand_grenade");
  
  precacheItem("m16_mp_pezbot_dog_run");
  precacheItem("m16_mp_pezbot_dog_melee");
  
	precacheModel("german_sheperd_dog");
	precacheModel("viewhands_desert_opfor");  
  
/*
  precacheItem("mp5_mp_pezbot_stand_idle");
  precacheItem("mp5_mp_pezbot_stand_walk");
  precacheItem("mp5_mp_pezbot_stand_run");
  precacheItem("mp5_mp_pezbot_stand_back");
  precacheItem("mp5_mp_pezbot_stand_left");
  precacheItem("mp5_mp_pezbot_stand_right");

  precacheItem("saw_mp_pezbot_stand_idle");
  precacheItem("saw_mp_pezbot_stand_walk");
  precacheItem("saw_mp_pezbot_stand_run");
  precacheItem("saw_mp_pezbot_stand_back");
  precacheItem("saw_mp_pezbot_stand_left");
  precacheItem("saw_mp_pezbot_stand_right");
  
  precacheItem("winchester1200_mp_pezbot_stand_idle");
  precacheItem("winchester1200_mp_pezbot_stand_walk");
  precacheItem("winchester1200_mp_pezbot_stand_run");
  precacheItem("winchester1200_mp_pezbot_stand_back");
  precacheItem("winchester1200_mp_pezbot_stand_left");
  precacheItem("winchester1200_mp_pezbot_stand_right");
  
  precacheItem("m40a3_mp_pezbot_stand_idle");
  precacheItem("m40a3_mp_pezbot_stand_walk");
  precacheItem("m40a3_mp_pezbot_stand_run");
  precacheItem("m40a3_mp_pezbot_stand_back");
  precacheItem("m40a3_mp_pezbot_stand_left");
  precacheItem("m40a3_mp_pezbot_stand_right");
*/
  
}



////////////////////////////////////////////////////////////
// resets a bot
////////////////////////////////////////////////////////////
BotReset()
{
  self notify("BotReset");
  
  self StopShooting();
  self BotGoal_ClearGoals();
  
	if(isDefined(self.bIsDog) && self.bIsDog)
	{
  	self.state = "attackdog";
	  self.stance = "dog";
	}
	else
	{ 
    self.state = "combat";
	  self.stance = "stand";
	}
  
	self.vMoveDirection = (0,1,0);
	self.fMoveSpeed = 0.0;
	self.bFaceNearestEnemy = true;
	self.buggyBotCounter = 0;
	self.lastOrigin = self.origin;
	self.bIsBot = true;

	self.vObjectivePos = self.origin;
  self.bClampToGround = true;
  
	self.commandIssued = "-1";
	self.bFollowTheLeader = false;
 	self.bSuppressingFire = false;
	self.leader = undefined;
	self.currentStaticWp = -1;
	self.dodgeTimer = gettime();
  
  if(!isdefined(self.bIsDog))
  {
    self SetAnim(self.weaponPrefix, self.stance, "walk");
  }
}

////////////////////////////////////////////////////////////
// called when bot connects, restarts threads if they were stopped by disconnect
////////////////////////////////////////////////////////////
Connected()
{
  println("connected called on bot");

  if(isdefined(self.pers["team"]) && issubstr(self.name, "bot"))
  {
    if(!isdefined(self.bThreadsRunning) || (isdefined(self.bThreadsRunning) && self.bThreadsRunning == false))
    {
      println("Restarting threads for " + self.name);
      self.selectedClass = true;
      self.weaponPrefix = "m16_mp"; //fixme this is hax, should reselect weapon from menu etc..
      self BotReset();
      self thread PeZBOTMainLoop();
    }
  }
}

////////////////////////////////////////////////////////////
// called when bot disconnects
////////////////////////////////////////////////////////////
Disconnected()
{

}

////////////////////////////////////////////////////////////
// kicks all dogs
///////////////////////////////////////////////////////////
KickAllDogs()
{
	players = level.players;
	if(players.size > 0)
	{
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(isDefined(player.bIsBot) && player.bIsBot && isDefined(player.bIsDog))
			{
			  entityNumber = player getEntityNumber();
	      kick(entityNumber);
			}
		}
	}	

}


////////////////////////////////////////////////////////////
// kicks all bots
///////////////////////////////////////////////////////////
KickAllBots()
{

	if(getdvar("svr_pezbots_botKickCount") != "")
	{
	  //dont try kick bots twice.. duh
	  if(getdvarint("svr_pezbots_botKickCount") > 0)
	  {
      return;	  
	  }
	}

  //kick all bots	
  botKickCount = 0;
	players = level.players;
	if(players.size > 0)
	{
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(isDefined(player.bIsBot) && player.bIsBot)
			{
			  entityNumber = player getEntityNumber();
	      kick(entityNumber);
	      if(!isDefined(player.bIsDog)) //kick doggies but dont respawn them
	      {
	        botKickCount++;
	      }
			}
		}
	}	

	setDvar("svr_pezbots_botKickCount", botKickCount);
	

}

////////////////////////////////////////////////////////////
// sets player name (doesnt seems to work)
///////////////////////////////////////////////////////////
SetPlayerName(name)
{
  self setClientDvar("name", name);
  SetClientNameMode( "auto_change" );
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
PrintPlayerPos()
{
 
  while(1)
  {
    if(isDefined(level.players))
    {
      for(i = 0; i < level.players.size; i++)
      {
        if(!isDefined(level.players[i].bIsBot))
        {
          iprintln("pos: " + level.players[i].origin[0] + ", " + level.players[i].origin[1] + ", " + level.players[i].origin[2]);
        }
      }
    }
    wait 2.0;
  }
}

////////////////////////////////////////////////////////////
// returns one of the buttons pressed
////////////////////////////////////////////////////////////
GetButtonPressed()
{
  if(isDefined(self))
  {
    if(self attackbuttonpressed())
    {
      return "AddWaypoint";
    }
    else
    if(self adsbuttonpressed())
    {
      return "DeleteWaypoint";
    }
    else
    if(self usebuttonpressed())
    {
      return "LinkWaypoint";
    }
    else
    if(self fragbuttonpressed())
    {
      return "UnlinkWaypoint";
    }
    else
    if(self meleebuttonpressed())
    {
      return "SaveWaypoints";
    }
  }
  
  return "none";
}

////////////////////////////////////////////////////////////
// Start in dev mode 
///////////////////////////////////////////////////////////
StartDev()
{
	wait 5;
  level.wpToLink = -1;
  level.linkSpamTimer = gettime();
  level.saveSpamTimer = gettime();
  
  while(1)
  {
    level.playerPos = level.players[0].origin;
    switch(level.players[0] GetButtonPressed())
    {
      case "AddWaypoint":
      {
        AddWaypoint(level.playerPos);
        break;
      }
      
      case "DeleteWaypoint":
      {
        DeleteWaypoint(level.playerPos);
        level.wpToLink = -1;
        break;
      }
      
      case "LinkWaypoint":
      {
        LinkWaypoint(level.playerPos);
        break;
      }
      
      case "UnlinkWaypoint":
      {
        UnLinkWaypoint(level.playerPos);
        break;
      }
      
      case "SaveWaypoints":
      {
        SaveStaticWaypoints();
        break;
      }
    
      default:
        break;
    }

    wait 0.001;  
  }
}


////////////////////////////////////////////////////////////
// Adds a waypoint to the static waypoint list
////////////////////////////////////////////////////////////
AddWaypoint(pos)
{
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 30.0)
    {
      return;
    }
  }

  level.waypoints[level.waypointCount] = spawnstruct();
  level.waypoints[level.waypointCount].origin = pos;
  level.waypoints[level.waypointCount].type = "stand";
  level.waypoints[level.waypointCount].children = [];
  level.waypoints[level.waypointCount].childCount = 0;
  level.waypointCount++;

  iprintln("Waypoint Added");
  
}

////////////////////////////////////////////////////////////
// removes a waypoint from the static waypoint list
////////////////////////////////////////////////////////////
DeleteWaypoint(pos)
{
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 30.0)
    {

      //remove all links in children
      //for each child c
      for(c = 0; c < level.waypoints[i].childCount; c++)
      {
        //remove links to its parent i
        for(c2 = 0; c2 < level.waypoints[level.waypoints[i].children[c]].childCount; c2++)
        {
          // child of i has a link to i as one of its children, so remove it
          if(level.waypoints[level.waypoints[i].children[c]].children[c2] == i)
          {
            //remove entry by shuffling list over top of entry
            for(c3 = c2; c3 < level.waypoints[level.waypoints[i].children[c]].childCount-1; c3++)
            {
              level.waypoints[level.waypoints[i].children[c]].children[c3] = level.waypoints[level.waypoints[i].children[c]].children[c3+1];
            }
            //removed child
            level.waypoints[level.waypoints[i].children[c]].childCount--;
            break;
          }
        }
      }
      
      //remove waypoint from list
      for(x = i; x < level.waypointCount-1; x++)
      {
        level.waypoints[x] = level.waypoints[x+1];
      }
      level.waypointCount--;
      
      //reassign all child links to their correct values
      for(r = 0; r < level.waypointCount; r++)
      {
        for(c = 0; c < level.waypoints[r].childCount; c++)
        {
          if(level.waypoints[r].children[c] > i)
          {
            level.waypoints[r].children[c]--;
          }
        }
      
      }

      iprintln("Waypoint Deleted");
      
      return;
    }
  }
}


////////////////////////////////////////////////////////////
//Links one waypoint to another
////////////////////////////////////////////////////////////
LinkWaypoint(pos)
{
  //dont spam linkage
  if((gettime()-level.linkSpamTimer) < 1000)
  {
    return;
  }
  level.linkSpamTimer = gettime();
  
  wpToLink = -1;
  
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 30.0)
    {
      wpToLink = i;
      break;
    }
  }
  
  //if the nearest waypoint is valid
  if(wpToLink != -1)
  {
    //if we have already pressed link on another waypoint, then link them up
    if(level.wpToLink != -1 && level.wpToLink != wpToLink)
    {
      level.waypoints[level.wpToLink].children[level.waypoints[level.wpToLink].childcount] = wpToLink;
      level.waypoints[level.wpToLink].childcount++;
      
      level.waypoints[wpToLink].children[level.waypoints[wpToLink].childcount] = level.wpToLink;
      level.waypoints[wpToLink].childcount++;
      
      iprintln("Waypoint " + wpToLink + " Linked to " + level.wpToLink);
      level.wpToLink = -1;
    }
    else //otherwise store the first link point
    {
      level.wpToLink = wpToLink;
      iprintln("Waypoint Link Started");
    }

  }
  else
  {
    level.wpToLink = -1;
    iprintln("Waypoint Link Cancelled");
  }
}

////////////////////////////////////////////////////////////
//Breaks the link between two waypoints
////////////////////////////////////////////////////////////
UnLinkWaypoint(pos)
{
  //dont spam linkage
  if((gettime()-level.linkSpamTimer) < 1000)
  {
    return;
  }
  level.linkSpamTimer = gettime();
  
  wpToLink = -1;
  
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 30.0)
    {
      wpToLink = i;
      break;
    }
  }
  
  //if the nearest waypoint is valid
  if(wpToLink != -1)
  {
    //if we have already pressed link on another waypoint, then break the link
    if(level.wpToLink != -1 && level.wpToLink != wpToLink)
    {
      //do first waypoint
      for(i = 0; i < level.waypoints[level.wpToLink].childCount; i++)
      {
        if(level.waypoints[level.wpToLink].children[i] == wpToLink)
        {
          //shuffle list down
          for(c = i; c < level.waypoints[level.wpToLink].childCount-1; c++)
          {
            level.waypoints[level.wpToLink].children[c] = level.waypoints[level.wpToLink].children[c+1];
          }
          level.waypoints[level.wpToLink].childCount--;
          break;
        }
      }
      
      //do second waypoint  
      for(i = 0; i < level.waypoints[wpToLink].childCount; i++)
      {
        if(level.waypoints[wpToLink].children[i] == level.wpToLink)
        {
          //shuffle list down
          for(c = i; c < level.waypoints[wpToLink].childCount-1; c++)
          {
            level.waypoints[wpToLink].children[c] = level.waypoints[wpToLink].children[c+1];
          }
          level.waypoints[wpToLink].childCount--;
          break;
        }
      }
      
      iprintln("Waypoint " + wpToLink + " Broken to " + level.wpToLink);
      level.wpToLink = -1;
    }
    else //otherwise store the first link point
    {
      level.wpToLink = wpToLink;
      iprintln("Waypoint Link Started");
    }
  }
  else
  {
    level.wpToLink = -1;
    iprintln("Waypoint Link Cancelled");
  }
}

////////////////////////////////////////////////////////////
// Saves waypoints out to a file
////////////////////////////////////////////////////////////
SaveStaticWaypoints()
{


  if((gettime()-level.saveSpamTimer) < 1500)
  {
    return;
  }
  level.saveSpamTimer = gettime();
  
  setdvar("logfile", 1);
  
  filename = "PeZBOT_" + tolower(getdvar("mapname")) + "_WP.csv";
/*
  file = openfile(filename, "write");
  
  if(file == -1)
  {
    iprintln("Save Failed");
    return;
  }
*/

  println(filename);
  for(i = 0; i < level.waypointCount; i++)
  {
    string = i + "," + level.waypoints[i].origin[0] + " " + level.waypoints[i].origin[1] + " " + level.waypoints[i].origin[2] + ",";
    for(c = 0; c < level.waypoints[i].childCount; c++)
    {
      string = string + level.waypoints[i].children[c];
      if(c < level.waypoints[i].childCount-1)
      {
        string = string + " ";
      }
    }
    
    string = string + "," + level.waypoints[i].type;
  //  fprintln(file, string);
  println(string);
  }

//  fprintln(file, level.waypointCount + ",end");
  println(level.waypointCount + ",end");
  
//  closefile(file);

  setdvar("logfile", 0);
  
  iprintln("Save Successful");

  


}


////////////////////////////////////////////////////////////
// start in normal mode
///////////////////////////////////////////////////////////
StartNormal()
{
	wait 5;

	for(;;)
	{
		if(getdvarInt("svr_pezbots") > 0)
			break;
		wait 1;
	}

	testclients = getdvarInt("svr_pezbots");
	setDvar( "svr_pezbots", 0 );
	for(i = 0; i < testclients; i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i])) 
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
			
		ent[i].bIsBot = true;
	  ent[i] freezecontrols(true);

		switch (getdvar("svr_pezbots_team"))
		{
			case "autoassign":		ent[i] thread TestClient("autoassign");		break;
			case "allies":			ent[i] thread TestClient("allies");			break;
			case "axis":			ent[i] thread TestClient("axis");			break;
		}
  }
  
	thread StartNormal();
}

////////////////////////////////////////////////////////////
// spawn attack dogs
///////////////////////////////////////////////////////////
SpawnDogs()
{
  dogCount = getdvarInt("svr_pezbots_dogpack_size");
	for(i = 0; i < dogCount; i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i])) 
		{
			println("Could not add test client");
			wait 1;
			continue;
		}
			
		ent[i].bIsBot = true;
		ent[i].bIsDog = true;
		ent[i].dogOwner = self;
		ent[i].dogTimer = gettime();
	  ent[i] freezecontrols(true);
	  
	  ent[i] thread AttackDog(self.pers["team"]);
  }
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
AttackDog(team)
{

	while(!isdefined(self.pers["team"]))
		wait .05;

	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;

	self maps\mp\gametypes\_modwarfare::setClassChoice("sniper");		
  self.weaponPrefix = "m16_mp";
  
	self.selectedClass = true;
	self maps\mp\gametypes\_modwarfare::menuAcceptClass();
	
	self thread PeZBOTMainLoop();
}


////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
TestClient(team)
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;

	self notify("menuresponse", game["menu_team"], team);
	wait 0.5;

  //pick a random class
	switch(randomInt(5))
	{
		case 0:		self maps\mp\gametypes\_modwarfare::setClassChoice("assault");		
  		        self.weaponPrefix = "m16_mp";
		break;
		
		case 1:		self maps\mp\gametypes\_modwarfare::setClassChoice("specops");		
//  		        self.weaponPrefix = "mp5_mp";
  		        self.weaponPrefix = "m16_mp";
		break;
		
		case 2:		self maps\mp\gametypes\_modwarfare::setClassChoice("heavygunner");	
  		        self.weaponPrefix = "m16_mp";
//  		        self.weaponPrefix = "saw_mp";
		break;
		
		case 3:		self maps\mp\gametypes\_modwarfare::setClassChoice("demolitions");	
  		        self.weaponPrefix = "m16_mp";
//  		        self.weaponPrefix = "winchester1200_mp";
		break;
		
		case 4:		self maps\mp\gametypes\_modwarfare::setClassChoice("sniper");		
  		        self.weaponPrefix = "m16_mp";
//   		        self.weaponPrefix = "m40a3_mp";
		break;
	}
  
	self.selectedClass = true;
	self maps\mp\gametypes\_modwarfare::menuAcceptClass();
	
	self thread PeZBOTMainLoop();
	
}

////////////////////////////////////////////////////////////
// this spams weapon changes so they actually take effect.. sheesh!
////////////////////////////////////////////////////////////
AnimSpam()
{
  self endon("disconnect");
  while(1)
  {
    if(self.bSpamAnims)
    {
      self TakeAllWeapons();

      //build actual weapon string name
      self.pers["weapon"] = self.animWeapon  ;
      self giveweapon(self.pers["weapon"]);
      self givemaxammo(self.pers["weapon"]);
      self setspawnweapon(self.pers["weapon"]);
	    self switchtoweapon(self.pers["weapon"]);
	  }

    wait 0.0001;
  }
}

////////////////////////////////////////////////////////////
// weapon // current weapon
// stance // stand, crouch, prone, dog
// movementType // idle, walk, run, back, left, right, fire
///////////////////////////////////////////////////////////
SetAnim(weapon, stance, movementType)
{

  newWeapon = weapon + "_pezbot_" + stance + "_" + movementType;
  self.animWeapon = newWeapon;
  switch(movementType)
  {
    case "melee":
    case "grenade":
      self.bSpamAnims = false;
      break;
      
    default:
      self.bSpamAnims = false;
      break;
  };
  
  if(isdefined(self.pers["weapon"]))
  {
    self takeweapon(self.pers["weapon"]);
  }
/*
  else
  {
    self TakeAllWeapons();
  }
*/  
  if(isDefined(self.bIsDog) && self.bIsDog)
  {
    self TakeAllWeapons();
  }

  self TakeAllWeapons();

  //build actual weapon string name
  self.pers["weapon"] = newWeapon;
  self giveweapon(self.pers["weapon"]);
  self givemaxammo(self.pers["weapon"]);
//  self SetWeaponAmmoClip(self.pers["weapon"], 30);
//  self SetWeaponAmmoStock(self.pers["weapon"], 300);
  self setspawnweapon(self.pers["weapon"]);
	self switchtoweapon(self.pers["weapon"]);
	
//  println("giving " + self.pers["weapon"]);
	

}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
vectorcross( v1, v2 )
{
	return ( v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0] );
}

////////////////////////////////////////////////////////////
// offsets the eye pos a bit higher
///////////////////////////////////////////////////////////
GetEyePos()
{
  return (self getEye() + (0,0,20));
}

////////////////////////////////////////////////////////////
// IsFacingAtTarget
///////////////////////////////////////////////////////////
IsFacingAtTarget()
{
  if(!isDefined(self.bestTarget))
  {
    return false;
  }
  
  dirToTarget = VectorNormalize(self.bestTarget.origin-self.origin);
  
  forward = AnglesToForward(self GetPlayerAngles());
  
  dot = vectordot(dirToTarget, forward);
  
  if(dot > 0.75)
  {
    return true;
  }
  
  return false;

}


////////////////////////////////////////////////////////////
// CanSeeTarget
///////////////////////////////////////////////////////////
CanSeeTarget()
{
  if(!isDefined(self.bestTarget))
  {
    return false;
  }
  
  //do a ray to see if we can see the target
  visTrace = bullettrace(self GetEyePos(), self.bestTarget GetEyePos(), false, self);
  if(visTrace["fraction"] == 1)
  {
    if(CanDebugDraw())
    {
      line(self GetEyePos(), visTrace["position"], (1,7,0));
    }
    return true;
  }
  else
  {
    if(CanDebugDraw())
    {
      line(self GetEyePos(), visTrace["position"], (1,0,0));            
    }
    return false;
  }
}

////////////////////////////////////////////////////////////
// CanSee a player?
///////////////////////////////////////////////////////////
CanSee(target)
{
  //do a ray to see if we can see the target
  visTrace = bullettrace(self GetEyePos(), target GetEyePos(), false, self);
  if(visTrace["fraction"] == 1)
  {
    if(CanDebugDraw())
    {
      line(self GetEyePos(), visTrace["position"], (1,7,0));
    }
    return true;
  }
  else
  {
    if(CanDebugDraw())
    {
      line(self GetEyePos(), visTrace["position"], (1,0,0));            
    }
    return false;
  }
}

////////////////////////////////////////////////////////////
// CanSee a position
///////////////////////////////////////////////////////////
CanSeePos(target)
{
  //do a ray to see if we can see the target
  visTrace = bullettrace(self GetEyePos(), target, false, self);
  if(visTrace["fraction"] == 1)
  {
    if(CanDebugDraw())
    {
      line(self GetEyePos(), visTrace["position"], (1,7,0));
    }
    return true;
  }
  else
  {
    if(CanDebugDraw())
    {
      line(self GetEyePos(), visTrace["position"], (1,0,0));            
    }
    return false;
  }
}

////////////////////////////////////////////////////////////
// snaffled from gametypes/dom.gsc
///////////////////////////////////////////////////////////
getFlagTeam()
{
	return self.useObj maps\mp\gametypes\_gameobjects::getOwnerTeam();
}

////////////////////////////////////////////////////////////
// process commands from other players
///////////////////////////////////////////////////////////
ProcessCommands()
{
	self endon( "disconnect" );
	
  while(1)
  {
    players = level.players;
    
    bActionTaken = false;
    for(i = 0; i < players.size; i++)
    { 
      takeAction = "none";
      player = players[i];
      if(player != self && self IsEnemy(player) != true && isDefined(player.commandIssued) && player.commandIssued != "-1" && !isDefined(self.bIsDog))
      {
        //work out what action to take
	      switch(player.commandIssued)		
	      {
		      case "1": //"Follow Me!";
		        if(DistanceSquared(self.origin, player.origin) < (2000*2000))
		        {
		          takeAction = "follow";
		        }
		        else
		        {
      	      self maps\mp\gametypes\_quickmessages::quickresponses("2");
		        }
			      break;

		      case "2": //"Move in!";
		        takeAction = "movein";
			      break;

		      case "3": //"Fall back!";
			      break;

		      case "4": //"Suppressing fire!";
		        //cant change suppressing fire target while suppressing, must stop first
		        if(isDefined(self.bSuppressingFire) && self.bSuppressingFire == false)
		        {
		          if(DistanceSquared(self.origin, player.origin) < (1000*1000))
		          {
  		          takeAction = "suppress";
  		        }
  		      }
			      break;

		      case "5": //"Attack left flank!";
			      break;

		      case "6": //"Attack right flank!";
			      break;

		      case "7": //"Hold this position!";
			      break;
	      }
      }
      
      //do what we're told to do
	    switch(takeAction)
	    {
	      case "follow":
	        self.bFollowTheLeader = true;
 	        self.bSuppressingFire = false;
	        self.leader = player;
	        bActionTaken = true;
          self BotGoal_ClearGoals();
	        break;
	        
	      case "movein":
	        self.bFollowTheLeader = false;
 	        self.bSuppressingFire = false;
	        bActionTaken = true;
	        self.state = "combat";
          self BotGoal_ClearGoals();
	        break;
	        
	      case "suppress":
	        self.bFollowTheLeader = false;
	        self.bSuppressingFire = true;
	        self.leader = player;
	        bActionTaken = true;
	        from = self.leader.origin + (0,0,50);
	        to = from + (anglestoforward(self.leader getplayerangles())*5000);
	        trace = bulletTrace(from, to, true, self.leader);
	        self.suppressTarget = trace["position"];
	        if(isDefined(trace["normal"]))
	        {
	          self.suppressTarget = self.suppressTarget + (trace["normal"] * 30);
	        }

          self BotGoal_ClearGoals();
	    };
	    
	    if(bActionTaken)
	    {
	      self maps\mp\gametypes\_quickmessages::quickresponses("1");
	      break;
	    }
    }
    wait 0.000001;
  }
}


////////////////////////////////////////////////////////////
// Try play the current game type
///////////////////////////////////////////////////////////
TryPlayGame()
{

  //clear movein commands from leader if we have called it last frame
  if(isDefined(self.leader) && isDefined(self.bFollowTheLeader))
  {
    if(self.bFollowTheLeader == false && isDefined(self.leader.commandIssued) && self.leader.commandIssued == "2")
    {
      self.leader.commandIssued = "-1";
    }
  }

  //suppressing fire
  if(isDefined(self.bSuppressingFire) && self.bSuppressingFire && isDefined(self.leader) && isDefined(self.suppressTarget))
  {
    //can see the target or close enough to the leader..
    if(self CanSeePos(self.suppressTarget) || DistanceSquared(self.origin, self.leader.origin) <= (300*300))
    {
      self.state = "suppressingFire";
      if(self.state != "suppressingFire")
      {
        self BotGoal_ClearGoals();
      }
    }
    else //cant see target, so move to leader, he must be able to see it to have issued the command
    {
      self.vObjectivePos = self.leader.origin;
      self BotGoal_EnterGoal("DynWaypointFollowGoal");
    }
  }
  else
  //Follow the leader
  if(isDefined(self.bFollowTheLeader) && self.bFollowTheLeader && isDefined(self.leader))
  {
    leaderDistance = DistanceSquared(self.origin, self.leader.origin);
    //too far away from leader
    if(leaderDistance > (1000*1000))
    {
      self.bFollowTheLeader = false;
      self BotGoal_ClearGoals();
    }
    else
    if(leaderDistance > (200*200))
    {
      self.state = "followTheLeader";  
      self.vObjectivePos = self.leader.origin;
      self BotGoal_EnterGoal("DynWaypointFollowGoal");
    }
  }
  else  
  if(level.gametype == "dom")
  {
    if(self.state != "dom")
    {
      self BotGoal_ClearGoals();
    }
    self.state = "dom";
  }
  else //headquarters
  if(level.gametype == "koth")
  {
    if(self.state != "koth")
    {
      self BotGoal_ClearGoals();
    }
    self.state = "koth";
  }
  else
//            if(level.gametype == "dm" || level.gametype == "war")
  {
    if(isDefined(self.bestTarget))
    {
      self.vObjectivePos = self.bestTarget.origin;
      self PathToObjective();
    }
  }
/*            
  else //sabotage
  if(level.gametype == "sab")
  {
    self.state = "sab";
    self BotGoal_ClearGoals();
  }
  else //search and destroy
  if(level.gametype == "sd")
  {
    self.state = "sd";
    self BotGoal_ClearGoals();
  }
*/            

}

////////////////////////////////////////////////////////////
// Decide whether to follow static waypoints or path dynamically
////////////////////////////////////////////////////////////
PathToObjective()
{
  //waypoints are closer to our objective so path using waypoints
  if(isDefined(level.waypoints) && level.waypointCount > 0 && self AnyWaypointCloserToObjectiveThanMe(self.vObjectivePos))
  { 
    if(self.currentStaticWp == -1)
    {
      wpPos = level.waypoints[GetNearestStaticWaypoint(self.origin)].origin;
      
//      print3d(wpPos, "MOVING HERE!", (1,0,0), 3);
      
      distance = Distance(self.origin, wpPos);
//      print3d(self.origin, "Distance: " + distance, (1,0,0), 2);
      if(distance <= 10) //close enough to waypoint so start following
      {
        self BotGoal_EnterGoal("StaticWaypointFollowGoal");
      }
      else //too far from waypoint so move over to it
      { 
        self.vObjectivePos = wpPos;
        self BotGoal_EnterGoal("DynWaypointFollowGoal");
      }
    }
  }
  else
  {
    self BotGoal_EnterGoal("DynWaypointFollowGoal");
  }
}

////////////////////////////////////////////////////////////
// barks and growls from dogs
///////////////////////////////////////////////////////////
AttackDogSoundThread()
{
  self endon ("disconnect");
  
  while(1)
  {
    switch(randomint(2))
    {
      case 0:
        self playsound("dog_bark");
        break;
      case 1:
        self playsound("dog_growl");
        break;
    }
    
    wait randomfloatrange(7, 9);
  }

}

////////////////////////////////////////////////////////////
// allows bots to use hardpoints
///////////////////////////////////////////////////////////
HardpointUpdate()
{
  self endon ("disconnect");
  
  while(1)
  {
	  if(isDefined(self.pers["hardPointItem"]))
	  {
	    if(self maps\mp\gametypes\_hardpoints::triggerHardPoint(self.pers["hardPointItem"]))
	    {
	      self.pers["hardPointItem"] = undefined;
	    }
	  }
	  
	  wait 1;
	}
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
PeZBOTMainLoop()
{
	self endon( "disconnect" );

  self.bThreadsRunning = true;
  
  //wait for playing session state
	while(self.sessionstate != "playing")
	{
	  wait 0.05;
	}

  //attack dog
	if(isDefined(self.bIsDog) && self.bIsDog)
	{
  	self.state = "attackdog";
	  self.stance = "dog";
  	self SetAnim(self.weaponPrefix, self.stance, "run");
  	self thread AttackDogSoundThread();
  	self thread AnimSpam();
	}
	else //human
	{
  	self.state = "combat";
	  self.stance = "stand";
  	self SetAnim(self.weaponPrefix, self.stance, "walk");
  	self thread AnimSpam();
	}
	
  self StopShooting();
	self.dodgeTimer = gettime();
	self setmovespeedscale(0);
	self.bShooting = false;
	self.bThrowingGrenade = false;
	self.bMeleeAttacking = false;
	self.vObjectivePos = self.origin;
	self.currentGoal = "none";
	self.buggyBotCounter = 0;
	self.lastOrigin = self.origin;
	
	self.vMoveDirection = (0,1,0);
	self.fMoveSpeed = 0.0;
	self.bFaceNearestEnemy = true;
	self.currentStaticWp = -1;

  self.bClampToGround = true;
  self thread TargetBestEnemy();
  self thread ClampToGround();
  self thread ProcessCommands();
  self thread HardpointUpdate();
  self thread WatchStaticWaypointGoalEnd();
  
	for(;;)
	{
	  while(self.sessionstate != "playing")
	  {
	    wait 0.05;
	  }
	
	  //kill dogs after 2 minutes
	  if(isDefined(self.dogTimer))
	  {
	    if((gettime()-self.dogTimer) >= 120000 )
	    {
	      if(self.sessionstate != "dead")
	      {
 			    newent = spawnstruct();
			    newent.isPlayer = true;
			    newent.isADestructable = false;
			    newent.entity = self;
			    newent.damageCenter = self.bestTarget.origin;
          
          //kill target
			    newent maps\mp\gametypes\_weapons::damageEnt(
				    self, // eInflictor = the entity that causes the damage (e.g. a claymore)
				    self, // eAttacker = the player that is attacking
				    10000, // iDamage = the amount of damage to do
				    "MOD_SUICIDE", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				    "none", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				    self.origin, // damagepos = the position damage is coming from
				    (0,1,0) // damagedir = the direction damage is moving in      
			    );
			  }
	    }
	  }

		switch(self.state)
		{
			case "idle":
			  break;
			  
			case "combat":
		
        if(isDefined(self.bestTarget))
        {
          if(self CanSeeTarget())
          {
            self.bFaceNearestEnemy = true;
            
            //only shoot if facing target
            if(self IsFacingAtTarget())
            {
              //bang bang
              if(randomint(120) >= 1)
              {
                self thread ShootWeapon();
              }
              else //NADE!!
              {
                self thread ThrowGrenade();
                self waittill("StopShooting");
              }
            }
  
            //Dodge
            if((gettime()-self.dodgeTimer) > randomintrange(200, 600))
            {
              self.dodgeTimer = gettime();
              if(isDefined(level.waypoints) && level.waypointCount > 0)
              {
                //dodge to a random child of the nearest waypoint
                nearestWP = GetNearestStaticWaypoint(self.origin);
                self.vObjectivePos = level.waypoints[level.waypoints[nearestWP].children[randomint(level.waypoints[nearestWP].childCount)]].origin;
                self.currentStaticWp = -1;
                self.lastStaticWp = -1;
                self BotGoal_ClearGoals();
                self BotGoal_EnterGoal("StaticWaypointFollowGoal");
              }
              else
              {
                dodgeRange = 100.0;
                self.vObjectivePos = self.origin + (randomfloatrange(dodgeRange * -1.0, dodgeRange), randomfloatrange(dodgeRange * -1.0, dodgeRange), 0);
                self BotGoal_EnterGoal("DynWaypointFollowGoal");
              }
            }

          }
          else //try see target, etc
          {
            self StopShooting();
            self TryPlayGame();
          }
        }
      
			  break;
			
			case "dom":
			
			  //if we can see our target, go into combat
			  if(self CanSeeTarget())
			  {
          self.bFaceNearestEnemy = true;
			    self.state = "combat";
          self BotGoal_ClearGoals();
			  }
			  else //otherwise play domination
			  {
		      closestFlag = -1;
		      closestFlagDistance = 9999999999;
		      for(i = 0; i < level.flags.size; i++)
		      {
			      team = level.flags[i] getFlagTeam();
		        if(team != self.pers["team"])
		        {
		          distance = Distance(self.origin, level.flags[i].origin);
  		        
		          //check if flag is closer
		          if(distance < closestFlagDistance)
              {
		            closestFlag = i;
		            closestFlagDistance = distance;
		          }
		        }
		      }
  		    
		      //found closest flag not on our team, so go capture it
		      if(closestFlag != -1)
		      {
            self.vObjectivePos = level.flags[closestFlag].origin;
            
//            println("closest flag at " + level.flags[closestFlag].origin);

            if(distance(self.vObjectivePos, self.origin) <= 10)
            {
              self.buggyBotCounter = 0;
            }
  
            self PathToObjective();
          
		      }
		      else //hunt and kill enemies
		      {
		        if(isDefined(self.bestTarget))
		        {
		          self.vObjectivePos = self.bestTarget.origin;
//              self BotGoal_EnterGoal("DynWaypointFollowGoal");
              self PathToObjective();
		        }
		      }

 		      self TryPlayGame();
		    }
			
			  break;

			case "sd":
			  break;

			case "koth":
			
			  //if we can see our target, go into combat
			  if(self CanSeeTarget())
			  {
          self.bFaceNearestEnemy = true;
			    self.state = "combat";
          self BotGoal_ClearGoals();
			  }
			  else //otherwise play headquarters
			  {
			    if(isDefined(level.radioObject))
			    {
	          distance = Distance(self.origin, level.radioObject.trigger.origin);

            if(distance > 100.0)
            {  		        
              self.vObjectivePos = level.radioObject.trigger.origin;
            }
            else
            {
              self.vObjectivePos = self.origin;
              self.buggyBotCounter = 0;
            }
            self PathToObjective();
//            self BotGoal_EnterGoal("DynWaypointFollowGoal");
		      }
		      
		      self TryPlayGame();
		    }
			
			  break;

			case "sab":
			  break;
			  
			case "followTheLeader":

        if(isDefined(self.leader))
        {
          //stop moving if too close
          if(DistanceSquared(self.origin, self.leader.origin) <= (200*200))
          {
            self BotGoal_ClearGoals();
          }
          
          //clear command if it's a follow the leader command
          if(self.leader.commandIssued == "1")
          {
            self.leader.commandIssued = "-1";
            println(self.name + " clearing follow command");
          }
        }
        
        //if we can see bad guys shoot em
			  if(self CanSeeTarget())
			  {
          self.bFaceNearestEnemy = true;
			    self.state = "combat";
          self BotGoal_ClearGoals();
			  }
			  else
			  {
    			self TryPlayGame();
			  }
			
			  break;
			  
			case "suppressingFire":
        if(isDefined(self.leader))
        {
        
          //stop moving if too close
          if(DistanceSquared(self.origin, self.leader.origin) <= (300*300))
          {
            self BotGoal_ClearGoals();
          }
          
          //clear command if it's a suppressingfire command
          if(self.leader.commandIssued == "4")
          {
            self.leader.commandIssued = "-1";
            println(self.name + " clearing suppress command");
          }
        }
        //if we can see bad guys shoot em
			  if(self CanSeeTarget())
			  {
          self.bFaceNearestEnemy = true;
			    self.state = "combat";
          self BotGoal_ClearGoals();
			  }
			  else //face suppress target and shoot
			  {
          self.bFaceNearestEnemy = false;
          
  			  targetDirection = VectorNormalize(self.suppressTarget - self.origin);
  			
			    //turn to face target
          self SetBotAngles(vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self getplayerangles()), targetDirection, 0.25))));
          
          self thread ShootWeapon();

          direction = VectorNormalize((randomfloatrange(-1.0, 1.0), randomfloatrange(-1.0, 1.0), 0));
          safeMoveToPos = self FindSafeMoveToPos(direction, randomfloatrange(25.0, 75.0));
          moveSpeed = 3.0;
          
          //move
          self BotMove(safeMoveToPos, moveSpeed);
          
          //dodging so wait a while
          wait randomfloatrange(0.3, 0.6);

    			self TryPlayGame();
			  }
        
		    break;
		    
		  case "attackdog":

        if(isDefined(self.bestTarget))
        {
          self.vObjectivePos = self.bestTarget.origin;

          targetRange = DistanceSquared(self.bestTarget.origin, self.origin);
          if(targetRange < (150*150) && self CanSeeTarget())
          {
            self thread BotMelee();
          }
          else
          {
            self PathToObjective();
          }
        }
/*        
        else
        {
          print3d(self.origin, "No Target", (1,0,0), 2);
        }
*/
        break;		   
		    

	  };
	  
    if(CanDebugDraw())
    {
	    //debug
      print3d(self.origin + (0, 0, 75), "STATE: " + self.state, (1,0,0), 2);
      print3d(self.origin + (0, 0, 65), "GOAL: " + self.currentGoal, (1,0,0), 2);
      print3d(self.vObjectivePos, self.name + " ObjectivePos", (1,0,0), 2);
      print3d(self.origin + (0, 0, 85), "weapon: " + self GetCurrentWeapon(), (1,0,0), 2);
    }
    

    
	  wait 0.01;
	}

}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
CanMove(from, direction, distance)
{
  //ray cast against everything
  trace = bulletTrace(from, from + (direction * distance), true, self);

  //line to collision is red
//  line(from, trace["position"], (1,0,0));

//  print3d( self.origin + ( 0, 0, 65 ),"Fraction " + trace["fraction"], (1,0,0), 2);
 
  return (trace["fraction"] == 1.0);
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
ClampToGround()
{
	self endon( "disconnect" );

  while(1)
  {
    if(self.bClampToGround)
    {
      trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, self);

//      line(self.origin + (0,0,50), trace["position"], (1,0,1));
  
      if(trace["fraction"] < 1 && !isdefined(trace["entity"]))
      {
        //smooth clamp
//        self SetOrigin((trace["position"] * 0.5) + (self.origin * 0.5));
        self SetOrigin(trace["position"]);
      }
    }
    wait 0.001;
  }
}

////////////////////////////////////////////////////////////
// stops shooting by freezing controls
////////////////////////////////////////////////////////////
StopShooting()
{
  self notify("StopShooting");
  self freezecontrols(true);
  self.bShooting = false;
  self.bThrowingGrenade = false;
}



////////////////////////////////////////////////////////////
// noob hax, this just lets the test client jiggle happen for a bit so it can shoot
// fix this later, its BAAD MMKAY
///////////////////////////////////////////////////////////
ShootWeapon()
{
	self endon("StopShooting");
	self endon("disconnect");
	self endon("killed_player");
	
  if(self.bShooting)
  {
    return;
  }
  
//  println("enter shoot");
  
  if(isDefined(self.pers["weapon"]))
  {
    skill = Clamp(0.0, getdvarFloat("svr_pezbots_skill"), 1.0);
    
    self givemaxammo(self.pers["weapon"]);
    
    self freezecontrols(false);
    self.bShooting = true;
    wait 0.1+(skill*0.3);
    self freezecontrols(true);
    self.bShooting = false;
  }
  
  self notify("StopShooting");
  
//  println("exit shoot");
  
}


////////////////////////////////////////////////////////////
// noob hax, this just lets the test client jiggle happen for a bit so it can shoot
// fix this later, its BAAD MMKAY
///////////////////////////////////////////////////////////
ThrowGrenade()
{
	self endon("StopShooting");
	self endon("disconnect");
	self endon("killed_player");
	
  if(self.bThrowingGrenade)
  {
    return;
  }
  
  self BotGoal_ClearGoals();
  
  self SetAnim("frag_mp", "stand", "grenade");

  self.bThrowingGrenade = true;
  self freezecontrols(false);
  wait 0.75;
  self freezecontrols(true);
  self.bThrowingGrenade = false;

  self SetAnim(self.weaponPrefix, self.stance, "walk");

  self notify("StopShooting");
  
}


////////////////////////////////////////////////////////////
// returns true if attacker attacked me
///////////////////////////////////////////////////////////
AttackedMe(attacker)
{
  if(!isDefined(self.attackers))
  {
    return false;
  }
  
  for(i = 0; i < self.attackers.size; i++)
  {
    if(isDefined(self.attackers[i]) && self.attackers[i] == attacker)
    {
      return true;
    }
  }
  
  return false;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
SetBotAngles(angles)
{
  if(isDefined(self.bIsDog) && self.bIsDog)
  {
    adjustedAngles = (0, angles[1], 0);
    self setplayerangles(adjustedAngles);
  }
  else
  {
    self setplayerangles(angles);
  }
}
////////////////////////////////////////////////////////////
// will try target nearest enemy
// if someone is attacking the bot, and the bot can see its attacker, it will use that target
///////////////////////////////////////////////////////////
TargetBestEnemy()
{
	self endon( "disconnect" );
  
  while(1)
  {
		players = getentarray("player", "classname");
		nearestTarget = undefined;
		nearestDistance = 9999999999;
		
		if(players.size > 0)
		{
		  for(i = 0; i < players.size; i++)
		  {
			  player = players[i];
			  if(self IsEnemy(player) && isdefined(player.sessionstate) && player.sessionstate == "playing")
			  {
			    tempDist = DistanceSquared(self.origin, player.origin);
			    //if closer or attacked me and can see, then set nearest
			    if(tempDist < nearestDistance || (self AttackedMe(player) && self CanSee(player)))
			    {
			      if(isDefined(nearestTarget))
			      {  //if something has shot at me and i can see it, dont wanna go any further
			        if(!(self AttackedMe(nearestTarget) && self CanSee(nearestTarget)))
			        {
			          nearestDistance = tempDist;
			          nearestTarget = player;
			        }
			      }
			      else //just set nearest target
			      {
			        nearestDistance = tempDist;
			        nearestTarget = player;
			      }
			    }
			  }
			}
		  
		  self.bestTarget = nearestTarget;
		
		  //only face if allowed
      if(self.bFaceNearestEnemy && isdefined(self.bestTarget))
      {
		    //calc direction of nearest target
			  targetDirection = VectorNormalize(self.bestTarget.origin - self.origin);
  			
			  //turn to face target
//        targetAngles = vectorToAngles(targetDirection);
//			  self SetBotAngles(VectorSmooth(self getplayerangles(), targetAngles, 0.125));

        skill = (1.0 - Clamp(0.0, getdvarFloat("svr_pezbots_skill"), 1.0)) * 5.0;
        
        angles = vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self getplayerangles()), targetDirection, 0.25)));
        //spray and pray depending on skill
        if(skill > 0 && !isDefined(self.bIsDog) && self.bShooting)
        {
          angles = (angles[0]+randomfloatrange(skill*-1.0, skill), angles[1]+randomfloatrange(skill*-1.0, skill), angles[2]+randomfloatrange(skill*-1.0, skill));
        }
        
        self SetBotAngles(angles);

			}
	  }
			
    wait 0.001;
  }
}

////////////////////////////////////////////////////////////
// melee a target
///////////////////////////////////////////////////////////
BotMelee()
{
  if(self.bMeleeAttacking)
  {
    return;
  }

  //clear static waypoint usage so we dont get stuck  
  self.currentStaticWp = -1;
  
  //cancel any previous moves
  self notify("BotMovementComplete");
  self endon ("disconnect");
  self endon ("BotMeleeComplete");
	self endon ("killed_player");
  self.bMeleeAttacking = true;

	vMoveTarget = self.bestTarget.origin + (VectorNormalize(self.origin - self.bestTarget.origin) * 10);
	fMoveSpeed = 12.0;

  //play correct anim for movement
	self SetAnim(self.weaponPrefix, self.stance, "melee");
  
  while(self.bMeleeAttacking)
  {
    moveTarget = (vMoveTarget[0], vMoveTarget[1], self.origin[2]);
    distance = DistanceSquared(moveTarget, self.origin);

    //hit stuff while we lunge
    if(isDefined(self.bestTarget) && self.bestTarget.sessionstate != "dead" && DistanceSquared(self.bestTarget.origin, self.origin) <= ((fMoveSpeed*2)*(fMoveSpeed*2)))
    {
 			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.entity = self.bestTarget;
			newent.damageCenter = self.bestTarget.origin;
      
      killer = self;
      damageAmount = 10000;
      
      //give the kill to the dog owner
      if(isDefined(self.bIsDog) && self.bIsDog && isDefined(self.dogOwner))
      {
        killer = self.dogOwner;
        damageAmount = 25;
        self SetAnim(self.weaponPrefix, self.stance, "run");
      }

      //kill target
			newent maps\mp\gametypes\_weapons::damageEnt(
				killer, // eInflictor = the entity that causes the damage (e.g. a claymore)
				killer, // eAttacker = the player that is attacking
				damageAmount, // iDamage = the amount of damage to do
				"MOD_MELEE", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				self.pers["weapon"], // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				self.origin, // damagepos = the position damage is coming from
				VectorNormalize(self.bestTarget.origin-self.origin) // damagedir = the direction damage is moving in      
			);
			
      self.bMeleeAttacking = false;
      self notify("BotMeleeComplete");
    }        
    else
    {
      self SetOrigin(self.origin + (VectorNormalize(moveTarget-self.origin) * fMoveSpeed));
      self PushOutOfPlayers();
    }  
    
    if(distance <= (fMoveSpeed*fMoveSpeed) || !isDefined(self.bestTarget) || (isDefined(self.bestTarget) && self.bestTarget.sessionstate != "playing"))
    {
      self.bMeleeAttacking = false;
      if(isDefined(self.bIsDog) && self.bIsDog && isDefined(self.dogOwner))
      {
        self SetAnim(self.weaponPrefix, self.stance, "run");
      }
      self notify("BotMeleeComplete");
    }
    
    
    wait 0.0001;
  }

}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
BotMove(_vMoveTarget, _fMoveSpeed)
{
  //cancel any previous moves
  self notify( "BotMovementComplete" );

  //regular cheap movement  
	self.vMoveTarget = _vMoveTarget;
	self.fMoveSpeed =  _fMoveSpeed;
	
	//calc move direction
	moveDirection = VectorNormalize(self.vMoveTarget - self.origin);
	
	//get forward direction
  forward = anglesToForward(self getplayerangles());	

  //set new anim
  newMoveType = "idle";
  
  //get dot between forward and our move direction
  dot = vectordot(forward, moveDirection);
  
  //moving left or right
  if(abs(dot) < 0.125)
  {
    //work out if going left or right
    right = vectorcross(forward, (0,0,1));
    
    dot = vectordot(right, moveDirection);
    
    //going right
    if(dot > 0.0)
    {
      newMoveType = "right";
    }
    else //going left
    {
      newMoveType = "left";
    }
  }
  else
  //moving backwards
  if(dot < 0) 
  {
    newMoveType = "back";
  }
  else //moving forwards
  {
    //running
    if(_fMoveSpeed > 6.0)
    {
      newMoveType = "run";
    }
    else //walking
    {
      newMoveType = "walk";
    }
  }
  
  //always run if running
  if(_fMoveSpeed > 6.0)
  {
    newMoveType = "run";
  }

  
  //dogs ALWAYS run
	if(isDefined(self.bIsDog) && self.bIsDog)
  {
    newMoveType	= "run";
  }
  
  //play correct anim for movement
	self SetAnim(self.weaponPrefix, self.stance, newMoveType);
	
	//start move thread
  self thread BotMoveThread();

}

////////////////////////////////////////////////////////////
// push self out of other players
///////////////////////////////////////////////////////////
PushOutOfPlayers()
{

  //push out of other players
  players = level.players;
  for(i = 0; i < players.size; i++)
  {
    player = players[i];
    
    if(player == self)
      continue;
      
    distance = distance(player.origin, self.origin);
    minDistance = 20;
    if(distance < minDistance) //push out
    {
      
      pushOutDir = VectorNormalize((self.origin[0], self.origin[1], 0)-(player.origin[0], player.origin[1], 0));
      trace = bulletTrace(self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((minDistance-distance)+10)), false, self);

      //debug
      if(CanDebugDraw())
      {
        print3d(self.origin + (0, 0, 85), "PUSHOUT " + distance, (1,0,0), 2);
        line(self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((minDistance-distance)+10)), (1,0,0));
      }
      
      //no collision, so push out
      if(trace["fraction"] == 1)
      {
        pushoutPos = self.origin + (pushOutDir * (minDistance-distance));
        self SetOrigin((pushoutPos[0], pushoutPos[1], self.origin[2])); 
      }
    }
  }

}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
BotMoveThread()
{
	self endon("BotMovementComplete");
	self endon("disconnect");
	self endon("killed_player");
  self endon("BotReset");
  
  while(1)
  {
    moveTarget = (self.vMoveTarget[0], self.vMoveTarget[1], self.origin[2]);
    distance = DistanceSquared(moveTarget, self.origin);
    if(distance <= (self.fMoveSpeed*self.fMoveSpeed))
    {
      self.fMoveSpeed = 0.0;
      self notify( "BotMovementComplete" );
//      self SetAnim(self.weaponPrefix, self.stance, "idle");
    }
    else
    {
      //move
      self SetOrigin(self.origin + (VectorNormalize(moveTarget-self.origin) * self.fMoveSpeed));
      self PushOutOfPlayers();
    }
    wait 0.005;
  }
}

////////////////////////////////////////////////////////////
// smooth between two vectors by factor 'fFactor' in the form (vC = (vA * (1-factor)) + (vB * factor));)
///////////////////////////////////////////////////////////
VectorSmooth(vA, vB, fFactor)
{
  fFactorRecip = 1.0-fFactor;
  
  vRVal = ((vA * fFactorRecip) + (vB * fFactor));
  
  return vRVal;
}


////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
IsEnemy(player)
{

  if(player != self && player.sessionteam != "spectator" && player.pers["team"] != "spectator" && (player.pers["team"] != self.pers["team"] || getdvar("g_gametype") == "dm"))
  {
    return (true);
  }
  
  return (false);
}


////////////////////////////////////////////////////////////
// finds a safe spot to move to in the direction specified
///////////////////////////////////////////////////////////
FindSafeMoveToPos(direction, distance)
{
	from = self.origin + (0,0,20);
	bCanMove = false;
	//try move in direction 
  if(CanMove(from, direction, distance))
  {
    bCanMove = true;
  }
  else // try strafe
  {
    //get right direction from cross product
    direction = vectorcross(direction, (0,0,1));
    
    //dont always strafe right
    direction = direction * ((RandomInt(2) - 0.5) * 2.0);
    
    //halve distance for tight areas
    distance = distance * 0.5;
    
    //try strafe 
    if(CanMove(from, direction, distance))
    {
      bCanMove = true;
    }
    else //try strafe opposite direction
    {
      direction = direction * -1.0;
      if(CanMove(from, direction, distance))
      {
        bCanMove = true;
      }
    }
  }

  safePos = self.origin;
  
  //woohoo, i can move
  if(bCanMove)
  {
    safePos = self.origin + (direction*distance);
  }
  
  return (safePos);
}

////////////////////////////////////////////////////////////
// Starts a bot goal thread
///////////////////////////////////////////////////////////
BotGoal_EnterGoal(goal)
{
  if(isdefined(self.currentGoal) && self.currentGoal == goal)
  {
    return;
  }

//  println("Entering Goal" + goal);

  //clear all active goals so they dont fight with eachother (can probably fix this)
  self BotGoal_ClearGoals();

  //make sure we know what goal we are in  
  self.currentGoal = goal;
  
  switch(goal)
  {
    case "MeleeCombatGoal":
      self thread BotGoal_MeleeCombatGoal();
      break;  
      
    case "AttackDogCombatGoal":
      self thread BotGoal_AttackDogCombatGoal();
      break;
      
    case "DynWaypointFollowGoal":
      self thread BotGoal_DynWaypointFollowGoal();
      break;  
      
    case "StaticWaypointFollowGoal":
      self thread BotGoal_StaticWaypointFollowGoal();
      break;  
      
      
  };

}

////////////////////////////////////////////////////////////
// Ends all current goal threads
///////////////////////////////////////////////////////////
BotGoal_ClearGoals()
{
  self notify ( "MeleeCombatGoalComplete" );
  self notify ( "AttackDogCombatGoalComplete" );
  self notify ( "DynWaypointFollowGoalComplete" );
  self notify ( "StaticWaypointFollowGoalComplete" );
  self.currentGoal = "none";
}


////////////////////////////////////////////////////////////
// Melee combat goal for bot (Stabs, keeps in range etc)
///////////////////////////////////////////////////////////
BotGoal_MeleeCombatGoal()
{
  self endon ( "MeleeCombatGoalComplete" );
	self endon( "disconnect" );
	self endon("killed_player");
  
  while(1)
  {
    //stay in range
    if(isDefined(self.bestTarget))
    {
      //FIXME: should do both of these in the one function
      targetRange = Distance(self.bestTarget.origin, self.origin);
      direction = VectorNormalize(self.bestTarget.origin - self.origin);

      safeMoveToPos = self.origin;
      moveSpeed = 6.0;
      
      //too far away get closer
      if(targetRange > 100)
      {
        safeMoveToPos = self FindSafeMoveToPos(direction, 50.0);
        //move
        self BotMove(safeMoveToPos, moveSpeed);
      }
      else //in range, stabbage
      {
        //self thread BotMelee();
      }
      
    }
    wait 0.1;
  }
}


////////////////////////////////////////////////////////////
// AttackDogCombat goal for bot "bitey bitey, bite bite"
///////////////////////////////////////////////////////////
BotGoal_AttackDogCombatGoal()
{
  self endon("AttackDogCombatGoalComplete");
	self endon("disconnect");
	self endon("killed_player");
  
  while(1)
  {
    //stay in range
    if(isDefined(self.bestTarget))
    {
      //FIXME: should do both of these in the one function
      targetRange = DistanceSquared(self.bestTarget.origin, self.origin);
      direction = VectorNormalize(self.bestTarget.origin - self.origin);

      safeMoveToPos = self.origin;
      moveSpeed = 9.0;
      
      //too far away get closer
      if(targetRange > (150*150) && !self.bMeleeAttacking)
      {
        safeMoveToPos = self FindSafeMoveToPos(direction, 50.0);
        //move
        self BotMove(safeMoveToPos, moveSpeed);
      }
      else //in range..
      {
        self thread BotMelee();
      }
    }
    wait 0.001;
  }
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
ClampWpToGround(wpPos)
{
  trace = bulletTrace(wpPos, wpPos + (0,0,-300), false, undefined);
  
  if(trace["fraction"] < 1)
  {
    return trace["position"] + (0,0,30);
  }
  else
  {
    //probably under the ground, trace up
    trace = bulletTrace(wpPos, wpPos + (0,0,20), false, undefined);
    if(trace["fraction"] < 1)
    {
      return trace["position"] + (0,0,30);
    }
    else
    {
      return wpPos;
    }
  }

}

////////////////////////////////////////////////////////////
// Clamp a in between min and max
////////////////////////////////////////////////////////////
Clamp(min, a, max)
{
  return max(min(a, max), min);
}

////////////////////////////////////////////////////////////
// Builds a dynamic list of waypoints for the bot to follow, uses brute force wall following, 
// looks for exits nearest target direction, HAX!!! etc... ;)
// This function is still kinda bruteforce and dodgy but it will do for now :D
////////////////////////////////////////////////////////////
BuildDynWaypointList()
{

  self.dynWaypointCount = 0;
  self.currDynWaypoint = 0;

  from = self.origin + (0,0,30);
//  direction = anglesToForward(self getplayerangles());
  enemydirection = VectorNormalize(self.vObjectivePos - from);
  direction = enemydirection;
  distance = 30.0;
  self.dynWaypointList = [];
  bCanTurnToTarget = true; // if true we can turn to try go towards our target
  maxWaypointCount = randomintrange(40, 60);
  lastWallDirection = (1,0,0);
  bValidLastWallDirection = false;
  
  while(self.dynWaypointCount < maxWaypointCount)
  {
    
    //add a waypoint
    self.dynWaypointList[self.dynWaypointCount] = ClampWpToGround(from);
    self.dynWaypointCount++;
  
    trace = bulletTrace(from, from + (direction * distance), false, self);

    enemydirection = VectorNormalize(self.vObjectivePos - from);
    
    //didnt hit keep moving
    if(trace["fraction"] == 1)
    {
      from = trace["position"];
      
      //add a waypoint
      self.dynWaypointList[self.dynWaypointCount] = ClampWpToGround(from);
      self.dynWaypointCount++;
      
      //move towards target
      if(bCanTurnToTarget)
      {
        direction = enemydirection;
        bValidLastWallDirection = false;
      }
      else //see if we need to keep following wall
      {
        //try keep following wall
        if(bValidLastWallDirection)
        {
          //trace
          trace = bulletTrace(from, from + (lastWallDirection * distance * 2.0), false, self);
          
          //wall no longer there, head that way
          if(trace["fraction"] == 1)
          {
            direction = lastWallDirection;
            from = trace["position"];
            dot = vectorDot(enemydirection, direction);
            if(dot > 0.5)
            {
              bCanTurnToTarget = true;
            }
            bValidLastWallDirection = false;
          }
        }
        else //still next to wall keep going straight ahead
        {
          bCanTurnToTarget = false;
        }
      }
    }
    else // hit something, navigate around it
    {
      //dont turn to target we need to navigate around collision    
      bCanTurnToTarget = false;
      
      //get collision normal and position    
      colNormal = trace["normal"];
      colPos = trace["position"];
        
      //move out from collision
//      from = colPos + (colNormal * 20.0);
      from = colPos + (VectorNormalize(VectorSmooth(direction * -1.0, colNormal, 0.5)) * 20.0); //normals are dodgy, especially on corrigated iron, use a fake normal
      
      tanDirection = vectorcross(direction * -1.0, (0,0,1));
      //tanDirection = vectorcross(colNormal, (0,0,1));

      //we were already traveling along a wall, pick tangent direction that keeps us going forwards
      if(bValidLastWallDirection)
      {
        dot = vectordot(lastWallDirection * -1.0, tanDirection);
        
        if(dot < 0)
        {
          tanDirection = tanDirection * -1.0;
        }
        
        lastWallDirection = colNormal * -1.0;
        bValidLastWallDirection = true;
        direction = tanDirection;
      }
      else //choose direction that best matches target dir
      {
        dot = vectordot(enemydirection, tanDirection);
        
        if(dot < 0)
        {
          tanDirection = tanDirection * -1.0;
        }
        
        lastWallDirection = colNormal * -1.0;
        bValidLastWallDirection = true;
        direction = tanDirection;
      }
    }
   
    //end of waypoint list
    if(DistanceSquared(self.vObjectivePos, from) <= ((distance * 1.5)*(distance * 1.5)))
    {
      return true; 
    }
    
  }
    
  return true;
}

////////////////////////////////////////////////////////////
// Dynamic waypoint follow goal, follows a dynamically generated list of waypoints
///////////////////////////////////////////////////////////
BotGoal_DynWaypointFollowGoal()
{
  self endon ( "DynWaypointFollowGoalComplete" );
	self endon( "disconnect" );
	self endon("killed_player");
  
  //build waypoint list
  self BuildDynWaypointList();
  
  while(1)
  {
    //must not be shooting, jiggles will stuff up movement big time
//    self StopShooting();
  
    tempWp = (self.dynWaypointList[self.currDynWaypoint][0], self.dynWaypointList[self.currDynWaypoint][1], self.origin[2]);


    //prevent enemy facing
    if(self CanSeeTarget())
    {
      self.bFaceNearestEnemy = true;
    }
    else
    {
      self.bFaceNearestEnemy = false;
      //face movement direction        
      self SetBotAngles(vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self getplayerangles()), VectorNormalize(tempWp-self.origin), 0.5))));
    }
    
    distToWp = DistanceSquared(tempWp, self.origin);

    if(distToWp <= (10.0*10.0))
    {
      self.currDynWaypoint++;
      
      if(self.currDynWaypoint >= self.dynWaypointCount)
      {
        self.currentGoal = "none";
        self notify ( "DynWaypointFollowGoalComplete" );
      }
      else
      {
        tempWp = (self.dynWaypointList[self.currDynWaypoint][0], self.dynWaypointList[self.currDynWaypoint][1], self.origin[2]);
       
        //dogs are fast
       	if(isDefined(self.bIsDog) && self.bIsDog)
       	{
          self BotMove(tempWp, 9.0);
       	}
       	else //ppl are not ;)
       	{
          self BotMove(tempWp, 6.0);
       	}
      }
    }

    //draw waypointlist
    self DrawDynWaypointList();
    wait 0.01;
  }
}

////////////////////////////////////////////////////////////
// debug draw dynamic waypoint list
////////////////////////////////////////////////////////////
DrawDynWaypointList()
{
  if(CanDebugDraw())
  {
    for(i = 0; i < self.dynWaypointCount-1; i++)
    {
      line(self.dynWaypointList[i], self.dynWaypointList[i] + (0,0,200), (1,1,0));
      line(self.dynWaypointList[i], self.dynWaypointList[i+1], (0,1,1));
    }

    line(self.dynWaypointList[self.dynWaypointCount-1], self.dynWaypointList[self.dynWaypointCount-1] + (0,0,200), (1,1,0));
  }
}


////////////////////////////////////////////////////////////
// static waypoint implementation
// 1. Array of waypoints, each waypoint has a type (stand, crouch, prone, camp, climb, etc), and a position on the ground.
// 2. Array of connectivity, list of children for each waypoint
// Reasoning: Easy to find closest waypoint, and traverse children using connectivity
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// converts a string into a float
////////////////////////////////////////////////////////////
atof(string)
{
  setdvar("temp_float", string);
  return getdvarfloat("temp_float");
}

////////////////////////////////////////////////////////////
// converts a string into an integer
////////////////////////////////////////////////////////////
atoi(string)
{
  setdvar("temp_int", string);
  return getdvarint("temp_int");
}

////////////////////////////////////////////////////////////
// Loads static waypoint list from file
////////////////////////////////////////////////////////////
LoadStaticWaypoints()
{
  filename = "waypoints/PeZBOT_" + tolower(getdvar("mapname")) + "_WP.csv";
  
  level.waypointCount = 0;
  level.waypoints = [];
  
  while(1)
  {
    string = TableLookup(filename, 0, level.waypointCount, 1);
    
//    println("read '" + string + "'");
    
    if(!isDefined(string) || string == "" || string == "end")
    {
      if(!isDefined(string) || string == "")
      {
        println("Map does not support PeZBOT waypoints");
      }
      else
      {
        println("PeZBOT waypoints loaded successfully");
      }
      return;
    }
    
    //new waypoint
    level.waypoints[level.waypointCount] = spawnstruct();
  
		tokens = strtok(string, " ");

    //read origin
		level.waypoints[level.waypointCount].origin = (atof(tokens[0]), atof(tokens[1]), atof(tokens[2]));

    string = TableLookup(filename, 0, level.waypointCount, 2);
//    println("read '" + string + "'");
		tokens = strtok(string, " ");

		
		//read in child connectivity
		level.waypoints[level.waypointCount].children = [];
		level.waypoints[level.waypointCount].childCount = 0;
		level.waypoints[level.waypointCount].childCount = tokens.size;
		for(i = 0; i < level.waypoints[level.waypointCount].childCount; i++)
		{
		  level.waypoints[level.waypointCount].children[i] = atoi(tokens[i]);
		}

    //read Type
    level.waypoints[level.waypointCount].type = TableLookup(filename, 0, level.waypointCount, 3);

    //increment waypoint counter
    level.waypointCount++;
  }
}

////////////////////////////////////////////////////////////
// debug draw spawns, domination flags, hqs, bombs etc..
////////////////////////////////////////////////////////////
DrawLOI(pos, code)
{

  line(pos + (20,0,0), pos + (-20,0,0), (1,0.75, 0));
  line(pos + (0,20,0), pos + (0,-20,0), (1,0.75, 0));
  line(pos + (0,0,20), pos + (0,0,-20), (1,0.75, 0));
  
  Print3d(pos, code, (1,0,0), 4);

}

////////////////////////////////////////////////////////////
// debug draw static waypoint list
////////////////////////////////////////////////////////////
DrawStaticWaypoints()
{
  while(1)
  {
    if(CanDebugDraw() && isDefined(level.waypoints) && isDefined(level.waypointCount) && level.waypointCount > 0)
    {
      for(i = 0; i < level.waypointCount; i++)
      {
      
        color = (0,0,1);

        //red for unlinked wps
        if(level.waypoints[i].childCount == 0)
        {
          color = (1,0,0);
        }
        else
        if(level.waypoints[i].childCount == 1) //purple for dead ends
        {
          color = (1,0,1);
        }
        else //green for linked
        {
          color = (0,1,0);
        }

        if(isdefined(level.players) && isdefined(level.players[0]))
        {
          distance = distance(level.waypoints[i].origin, level.players[0].origin);
          if(distance <= 30.0)
          {
            strobe = abs(sin(gettime()/10.0));
            color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
          }
        }

        line(level.waypoints[i].origin, level.waypoints[i].origin + (0,0,200), color);
        
        for(x = 0; x < level.waypoints[i].childCount; x++)
        {
          line(level.waypoints[i].origin + (0,0,5), level.waypoints[level.waypoints[i].children[x]].origin + (0,0,5), (0,0,1));
        }
//        print3d(level.waypoints[i].origin + (0,0,90), "Type: " + level.waypoints[i].type, (1,1,1), 2);
//        print3d(level.waypoints[i].origin + (0,0,100), "Pos: " + level.waypoints[i].origin[0] + ", " + level.waypoints[i].origin[1] + ", " + level.waypoints[i].origin[2], (1,1,1), 2);
//        print3d(level.waypoints[i].origin + (0,0,110), "Index: " + i, (1,1,1), 2);
      }
      
      //draw spawnpoints  
      
      DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
      DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");
      
      DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
      DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
      DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS");

      //draw domination flags
	    DrawSpawnPoints(getEntArray("flag_primary", "targetname"), "F");
	    DrawSpawnPoints(getEntArray("flag_secondary", "targetname"), "F");

      //draw radios
      DrawSpawnPoints(getentarray("hq_hardpoint", "targetname"), "R");

      //draw bombzones
      DrawSpawnPoints(getEntArray("bombzone", "targetname"), "B");
      DrawSpawnPoints(getEntArray("sab_bomb_axis", "targetname"), "B");
      DrawSpawnPoints(getEntArray("sab_bomb_allies", "targetname"), "B");
    }
    wait 0.001;
  }
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
DrawSpawnPoints(spawnpoints, code)
{
  if(isdefined(spawnpoints))
  {
	  for(i = 0; i < spawnpoints.size; i++)
	  {
		  spawnpoint = spawnpoints[i];

      DrawLOI(spawnpoint.origin, code);
    }
  }
}

////////////////////////////////////////////////////////////
// returns an index to the nearest static waypoint
////////////////////////////////////////////////////////////
GetNearestStaticWaypoint(pos)
{

  if(!isDefined(level.waypoints) || level.waypointCount == 0)
  {
    return -1;
  }

  nearestWaypoint = -1;
  nearestDistance = 9999999999;
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = Distance(pos, level.waypoints[i].origin);
    
    if(distance < nearestDistance)
    {
      nearestDistance = distance;
      nearestWaypoint = i;
    }
  }
  
  return nearestWaypoint;
}



////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
CheckIfChildGetsUsCloser(currentWpIdx, pos, ignoreWpIdx, closestWpToPos)
{
  currWpIdx = currentWpIdx;

  waypointsVisited = [];
  totalDistance = 0;
  waypointsVisited[waypointsVisited.size] = ignoreWpIdx;
  for(r = 0; r < 25; r++)
  {
    //got to waypoint, don't go any further
    if(currWpIdx == closestWpToPos)
    {
//      print3d(level.waypoints[currWpIdx].origin, "FOUND CLOSEST!!", (1,0,1), 2);
      break;
    }
  
    lastWPIdx = currWpIdx;
    currWpIdx = GetNearestStaticWaypointChild(pos, lastWPIdx, waypointsVisited);
    
    //dead end, dont use this one
    if(currWpIdx == -1)
    {
//      print3d(level.waypoints[lastWPIdx].origin, "DEAD END!!", (1,0,0), 2);
      return 9999999999;
    }
    
    waypointsVisited[waypointsVisited.size] = lastWPIdx;

//    print3d(level.waypoints[currWpIdx].origin, "Distance: " + distance(pos, level.waypoints[currWpIdx].origin), (1,0,0), 3);
    
    //accumulate distance
    totalDistance += distance(level.waypoints[lastWPIdx].origin, level.waypoints[currWpIdx].origin);

    //debug line
//    line(level.waypoints[lastWPIdx].origin, level.waypoints[currWpIdx].origin, (0,1,0));

    //got to waypoint, don't go any further
    if(currWpIdx == closestWpToPos)
    {
      break;
    }
  }
  
  return totalDistance;

}


////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
CheckIfChildGetsUsCloser2(stepCount, currentWpIdx, pos, waypointsVisited, closestWpToPos)
{
  stepCount++;
  if(stepCount > 10)
  {
    return 0;
  }

  //add wp to visited list
  waypointsVisited[waypointsVisited.size] = currentWpIdx;

  totalDistance = 0;
  for(i = 0; i < level.waypoints[currentWpIdx].childCount; i++)
  {
    //eliminate children, nearest one first
    nearest = GetNearestStaticWaypointChild(stepCount, pos, level.waypoints[currentWpIdx].children[i], waypointsVisited);
    if(nearest != -1)
    {
      //debug line
  //    line(level.waypoints[currentWpIdx].origin, level.waypoints[nearest].origin, (0,1,0));

      totalDistance += CheckIfChildGetsUsCloser2(stepCount, nearest, pos, waypointsVisited, closestWpToPos);
    }
    else
    {
      break;
    }
  }
  
  return totalDistance;
}


////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
CheckIfChildGetsUsCloser3(currentWpIdx, pos, ignoreWpIdx, closestWpToPos)
{
  currWpIdx = currentWpIdx;

  waypointsVisited = [];
  waypointsVisited[waypointsVisited.size] = ignoreWpIdx;
  for(r = 0; r < randomintrange(10, 25); r++)
  {
    //got to waypoint, don't go any further
    if(currWpIdx == closestWpToPos)
    {
//      print3d(level.waypoints[currWpIdx].origin, "FOUND CLOSEST!!", (1,0,1), 2);
      break;
    }
  
    lastWPIdx = currWpIdx;
    currWpIdx = GetNearestStaticWaypointChild2(pos, lastWPIdx, waypointsVisited);
    
    //dead end, dont use this one
    if(currWpIdx == -1)
    {
//      print3d(level.waypoints[lastWPIdx].origin, "DEAD END!!", (1,0,0), 2);
      return distance(level.waypoints[lastWPIdx].origin, pos);
    }
    
    waypointsVisited[waypointsVisited.size] = lastWPIdx;

//    print3d(level.waypoints[currWpIdx].origin, "Distance: " + distance(pos, level.waypoints[currWpIdx].origin), (1,0,0), 3);

    //debug line
//    line(level.waypoints[lastWPIdx].origin, level.waypoints[currWpIdx].origin, (0,1,0));

    //got to waypoint, don't go any further
    if(currWpIdx == closestWpToPos)
    {
      break;
    }
  }
  
  return distance(level.waypoints[currWpIdx].origin, pos);


}


////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
GetNearestStaticWaypointChild(pos, wpIndex, ignoreWpIdx)
{

  if(!isDefined(level.waypoints) || level.waypointCount == 0)
  {
    return -1;
  }

  nearestWaypoint = -1;
  nearestDistance = 9999999999;
  ignoreCount = 0;
  for(i = 0; i < level.waypoints[wpIndex].childCount; i++)
  {
    //check if we should ignore this wp because it's already been visited
    ignored = false;
    for(x = 0; x < ignoreWpIdx.size; x++)
    {
      if(ignoreWpIdx[x] == level.waypoints[wpIndex].children[i])
      {
        ignored = true;
        break;
      }
    }
    
    if(!ignored)
    {
      distance = distance(pos, level.waypoints[level.waypoints[wpIndex].children[i]].origin);
    
      if(distance < nearestDistance)
      {
        nearestDistance = distance;
        nearestWaypoint = level.waypoints[wpIndex].children[i];
      }
    }
  }
  
  return nearestWaypoint;
  
}


////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
GetNearestStaticWaypointChild2(pos, wpIndex, ignoreWpIdx)
{

  if(!isDefined(level.waypoints) || level.waypointCount == 0)
  {
    return -1;
  }

  nonIgnoredList = [];

  for(i = 0; i < level.waypoints[wpIndex].childCount; i++)
  {
    //check if we should ignore this wp because it's already been visited
    ignored = false;
    for(x = 0; x < ignoreWpIdx.size; x++)
    {
      if(ignoreWpIdx[x] == level.waypoints[wpIndex].children[i])
      {
        ignored = true;
        break;
      }
    }
    
    if(!ignored)
    {
      nonIgnoredList[nonIgnoredList.size] = level.waypoints[wpIndex].children[i];
    }
  }
  
  if(nonIgnoredList.size > 0)
  {
    if(randomint(100) > 5)
    {
      return GetNearestStaticWaypointChild(pos, wpIndex, ignoreWpIdx);
    }
    else
    {
      return nonIgnoredList[randomint(nonIgnoredList.size)];
    }
  }
  else
  {
    return -1;
  }
  
}

////////////////////////////////////////////////////////////
// returns true if there is any waypoint closer to pos than wpIndex
////////////////////////////////////////////////////////////
AnyWaypointCloser(pos, wpIndex)
{
  if(!isDefined(level.waypoints) || level.waypointCount == 0)
  {
    return false;
  }
  nearestWaypoint = wpIndex;
  nearestDistance = Distance(pos, level.waypoints[wpIndex].origin);
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = Distance(pos, level.waypoints[i].origin);
    
    if(distance < nearestDistance)
    {
      nearestDistance = distance;
      nearestWaypoint = i;
    }
  }

//  Print3d(level.waypoints[nearestWaypoint].origin, "CLOSEST", (1,0,0), 3);
  
  if(nearestWaypoint == wpIndex)
  {
    return false;
  }
  else
  {
    return true;  
  }
}


////////////////////////////////////////////////////////////
// returns true if there is any waypoint closer to objPos than self.origin
////////////////////////////////////////////////////////////
AnyWaypointCloserToObjectiveThanMe(objPos)
{
  if(!isDefined(level.waypoints) || level.waypointCount == 0)
  {
    return false;
  }

  meToObjPosDistance = Distance(objPos, self.origin);
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = Distance(objPos, level.waypoints[i].origin);
    
    if((distance+50) < meToObjPosDistance)
    {
      return true;
    }
  }

  return false;  
}


////////////////////////////////////////////////////////////
// watch for StaticWaypointFollowGoal Complete
////////////////////////////////////////////////////////////
WatchStaticWaypointGoalEnd()
{
	self endon("disconnect");

  while(1)
  {
    if(self.currentGoal != "StaticWaypointFollowGoal")
    {
      self.currentStaticWp = -1;
//      print3d(self.origin, "resetting wp", (0,1,0), 5);
    }
    
    wait 0.01;
  }
}

////////////////////////////////////////////////////////////
// static waypoint follow goal, follows static waypoints
///////////////////////////////////////////////////////////
BotGoal_StaticWaypointFollowGoal()
{
  self endon("StaticWaypointFollowGoalComplete");
	self endon("disconnect");
	self endon("killed_player");

  if(!isDefined(level.waypoints) || level.waypointCount == 0)
  {
    self.currentGoal = "none";
    self notify("StaticWaypointFollowGoalComplete");
  }  
  
  while(1)
  {

    //get waypoint nearest to ourselves  
    if(self.currentStaticWp == -1)
    {
//      print3d(self.origin + (0,0,40), "invalid WP", (1,0,0), 2);

      self.currentStaticWp = GetNearestStaticWaypoint(self.origin);
    }
    
    //get waypoint pos    
    tempWp = level.waypoints[self.currentStaticWp].origin;


    //!!!DEBUG!!!
    //perform astar search
//    AStarSearch(self.currentStaticWp, GetNearestStaticWaypoint(self.vObjectivePos));
    
    //prevent enemy facing
    if(self CanSeeTarget())
    {
      self.bFaceNearestEnemy = true;
    }
    else
    {
      self.bFaceNearestEnemy = false;

      //face movement direction        
      self SetBotAngles(vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self getplayerangles()), VectorNormalize(tempWp-self.origin), 0.5))));
    }

    //clamp to xz plane    
    distToWp = Distance((tempWp[0], tempWp[1], self.origin[2]), self.origin);
    
    //pick next waypoint or end
//    print3d(self.origin, "distToWp: " + distToWp, (1,0,0), 2);
    if(distToWp <= 10)
    {
//      print3d(self.origin, self.name + " close enough", (1,0,0), 2);
      //if there isn't any waypoint that is closer than our current waypoint then end our goal
      if(!AnyWaypointCloser(self.vObjectivePos, self.currentStaticWp))
      {
        //fixme: should do a check to make sure that one of the child paths doesn't get us closer
        self.currentGoal = "none";
        self.currentStaticWp = -1;
        self.lastStaticWp = -1;
//        print3d(self.origin+(0,0,10), "NONECLOSER!!!", (1,0,0), 2);
        
        self notify("StaticWaypointFollowGoalComplete");
      }
      else
      {
//        print3d(self.origin + (0,0,10), self.name + " searching", (1,0,0), 2);

        //get child waypoint nearest to our objective
        //get waypoint nearest our target
        targetWpIdx = GetNearestStaticWaypoint(self.vObjectivePos);
        
        //find shortest path to our destination
        self.currentStaticWp = AStarSearch(self.currentStaticWp, targetWpIdx);
        
        tempWp = level.waypoints[self.currentStaticWp].origin;
        
        //move there
        //dogs are fast
        if(isDefined(self.bIsDog) && self.bIsDog)
        {
          self BotMove(tempWp, 9.0);
        }
        else //ppl are not ;)
        {
          if(self.bFaceNearestEnemy)
          {
            self BotMove(tempWp, 6.0); //walk
          }
          else
          {
            self BotMove(tempWp, 9.0); //sprint
          }
        }
      }
    }
    else //bugging out so try move
    if(self.buggyBotCounter >= 25)
    {
      self.currentStaticWp = -1;
      self.currentGoal = "none";
      self.buggyBotCounter = 0;
      self notify("StaticWaypointFollowGoalComplete");
    }
    else
    if(self.fMoveSpeed == 0) //couldnt make it to our waypoint, ohh well
    {
      self.currentStaticWp = -1;
      self.currentGoal = "none";
      self notify("StaticWaypointFollowGoalComplete");
    }
    wait 0.1;
  }
}


////////////////////////////////////////////////////////////
// AStarSearch, performs an astar search
///////////////////////////////////////////////////////////
/*

The best-established algorithm for the general searching of optimal paths is A* (pronounced “A-star”). 
This heuristic search ranks each node by an estimate of the best route that goes through that node. The typical formula is expressed as:

f(n) = g(n) + h(n)

where: f(n)is the score assigned to node n g(n)is the actual cheapest cost of arriving at n from the start h(n)is the heuristic 
estimate of the cost to the goal from n 

priorityqueue Open
list Closed


AStarSearch
   s.g = 0  // s is the start node
   s.h = GoalDistEstimate( s )
   s.f = s.g + s.h
   s.parent = null
   push s on Open
   while Open is not empty
      pop node n from Open  // n has the lowest f
      if n is a goal node 
         construct path 
         return success
      for each successor n' of n
         newg = n.g + cost(n,n')
         if n' is in Open or Closed,
          and n'.g < = newg
	       skip
         n'.parent = n
         n'.g = newg
         n'.h = GoalDistEstimate( n' )
         n'.f = n'.g + n'.h
         if n' is in Closed
            remove it from Closed
         if n' is not yet in Open
            push n' on Open
      push n onto Closed
   return failure // if no path found 
*/
AStarSearch(startWp, goalWp)
{
  pQOpen = [];
  pQSize = 0;
  closedList = [];
  listSize = 0;
  s = spawnstruct();
  s.g = 0; //start node
  s.h = distance(level.waypoints[startWp].origin, level.waypoints[goalWp].origin);
  s.f = s.g + s.h;
  s.wpIdx = startWp;
  s.parent = spawnstruct();
  s.parent.wpIdx = -1;
  
////////////////////////////////////////////////////////////////    
//  PQPush(pQOpen, s, pQSize); //push s on Open

  pQOpen[pQSize] = spawnstruct();
  pQOpen[pQSize] = s; //push s on Open
////////////////////////////////////////////////////////////////    
  pQSize++;

  //while Open is not empty  
  while(!PQIsEmpty(pQOpen, pQSize))
  {
/////////////////////////////////////////////////////////////////  
    //pop node n from Open  // n has the lowest f
//    n = PQPop(pQOpen, pQSize);
//    pQSize--;

    n = pQOpen[0];
    highestPriority = 9999999999;
    bestNode = -1;
    for(i = 0; i < pQSize; i++)
    {
      if(pQOpen[i].f < highestPriority)
      {
        bestNode = i;
        highestPriority = pQOpen[i].f;
      }
    } 
    
    if(bestNode != -1)
    {
      n = pQOpen[bestNode];
      //remove node from queue    
      for(i = bestNode; i < pQSize-1; i++)
      {
        pQOpen[i] = pQOpen[i+1];
      }
      pQSize--;
    }
    else
    {
      return;
    }
    

////////////////////////////////////////////////////////////////    

    //if n is a goal node; construct path, return success
    if(n.wpIdx == goalWp)
    {
     
      x = n;
      for(z = 0; z < 1000; z++)
      {
        parent = x.parent;
        if(parent.parent.wpIdx == -1)
        {
          return x.wpIdx;
        }
//        line(level.waypoints[x.wpIdx].origin, level.waypoints[parent.wpIdx].origin, (0,1,0));
        x = parent;
      }

      return;      
    }

    //for each successor nc of n
    for(i = 0; i < level.waypoints[n.wpIdx].childCount; i++)
    {
      //newg = n.g + cost(n,nc)
      newg = n.g + distance(level.waypoints[n.wpIdx].origin, level.waypoints[level.waypoints[n.wpIdx].children[i]].origin);
      
      //if nc is in Open or Closed, and nc.g <= newg then skip
      if(PQExists(pQOpen, level.waypoints[n.wpIdx].children[i], pQSize))
      {
////////////////////////////////////////////////////////////////    
//        nc = PQGet(pQOpen, level.waypoints[n.wpIdx].children[i], pQSize);
        nc = spawnstruct();
        for(p = 0; p < pQSize; p++)
        {
          if(pQOpen[p].wpIdx == level.waypoints[n.wpIdx].children[i])
          {
            nc = pQOpen[p];
            break;
          }
        }
////////////////////////////////////////////////////////////////    
        
        if(nc.g <= newg)
        {
          continue;
        }
      }
      else
      if(ListExists(closedList, level.waypoints[n.wpIdx].children[i], listSize))
      {
////////////////////////////////////////////////////////////////    
//        nc = ListGet(closedList, level.waypoints[n.wpIdx].children[i], listSize);

        nc = spawnstruct();
        for(p = 0; p < listSize; p++)
        {
          if(closedList[p].wpIdx == level.waypoints[n.wpIdx].children[i])
          {
            nc = closedList[p];
            break;
          }
        }
////////////////////////////////////////////////////////////////    

        if(nc.g <= newg)
        {
          continue;
        }
      }
      
//      nc.parent = n
//      nc.g = newg
//      nc.h = GoalDistEstimate( nc )
//      nc.f = nc.g + nc.h
      
      nc = spawnstruct();
      nc.parent = spawnstruct();
      nc.parent = n;
      nc.g = newg;
      nc.h = distance(level.waypoints[level.waypoints[n.wpIdx].children[i]].origin, level.waypoints[goalWp].origin);
	    nc.f = nc.g + nc.h;
	    nc.wpIdx = level.waypoints[n.wpIdx].children[i];

      //if nc is in Closed,
	    if(ListExists(closedList, nc.wpIdx, listSize))
	    {
	      //remove it from Closed
////////////////////////////////////////////////////////////////    
//	      ListRemove(closedList, nc.wpIdx, listSize);

        deleted = false;
        for(p = 0; p < listSize; p++)
        {
          if(closedList[p].wpIdx == nc.wpIdx)
          {
            for(x = p; x < listSize-1; x++)
            {
              closedList[x] = closedList[x+1];
            }
            deleted = true;
            break;
          }
          if(deleted)
          {
            break;
          }
        }
////////////////////////////////////////////////////////////////    
	      listSize--;
	    }
	    
	    //if nc is not yet in Open, 
	    if(!PQExists(pQOpen, nc.wpIdx, pQSize))
	    {
	      //push nc on Open
////////////////////////////////////////////////////////////////    
//	      PQPush(pQOpen, nc, pQSize);

        pQOpen[pQSize] = spawnstruct();
        pQOpen[pQSize] = nc;
////////////////////////////////////////////////////////////////    
        pQSize++;
	    }
	  }
	  
	  //Done with children, push n onto Closed
	  if(!ListExists(closedList, n.wpIdx, listSize))
	  {
////////////////////////////////////////////////////////////////    
//	    ListAdd(closedList, n, listSize);

      closedList[listSize] = spawnstruct();
      closedList[listSize] = n;
////////////////////////////////////////////////////////////////    
	    listSize++;
	  }
  }
}


////////////////////////////////////////////////////////////
// priority queue push function
////////////////////////////////////////////////////////////
PQPush(Q, n, QSize)
{
  Q[QSize] = spawnstruct();
  Q[QSize] = n;
}

////////////////////////////////////////////////////////////
// priority queue pop function (highest priority is actually smallest value because priority is actually a distance)
////////////////////////////////////////////////////////////
PQPop(Q, QSize)
{

  rVal = spawnstruct();
  rVal.wpIdx = -1;
  highestPriority = 9999999999;
  bestNode = -1;
  for(i = 0; i < QSize; i++)
  {
    if(Q[i].f < highestPriority)
    {
      bestNode = i;
      highestPriority = Q[i].f;
    }
  } 
  
  if(bestNode != -1)
  {
    rVal = Q[bestNode];
    //remove node from queue    
    for(i = bestNode; i < QSize-1; i++)
    {
      Q[i] = Q[i+1];
    }
    return rVal;
  }
  
  return rVal;
}

////////////////////////////////////////////////////////////
// PQIsEmpty, returns true if empty
////////////////////////////////////////////////////////////
PQIsEmpty(Q, QSize)
{
  if(QSize <= 0)
  {
    return true;
  }
  
  return false;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
PQGet(Q, n, QSize)
{
  for(i = 0; i < QSize; i++)
  {
    if(Q[i].wpIdx == n)
    {
      return Q[i];
    }
  }
  
  rVal = spawnstruct();
  rVal.wpIdx = -1;
  
  return rVal;
}

////////////////////////////////////////////////////////////
// returns true if n exists in the pQ
////////////////////////////////////////////////////////////
PQExists(Q, n, QSize)
{
  for(i = 0; i < QSize; i++)
  {
    if(Q[i].wpIdx == n)
    {
      return true;
    }
  }
  
  return false;
}

////////////////////////////////////////////////////////////
// list add
////////////////////////////////////////////////////////////
ListAdd(list, n, listSize)
{
  list[listSize] = spawnstruct();
  list[listSize] = n;
}

////////////////////////////////////////////////////////////
// list remove
////////////////////////////////////////////////////////////
ListRemove(list, n, listSize)
{
  for(i = 0; i < listSize; i++)
  {
    if(list[i].wpIdx == n.wpIdx)
    {
      for(x = i; x < listSize-1; x++)
      {
        list[x] = list[x+1];
      }
      return;
    }
  }
}


////////////////////////////////////////////////////////////
// returns true if n exists in the list
////////////////////////////////////////////////////////////
ListExists(list, n, listSize)
{
  for(i = 0; i < listSize; i++)
  {
    if(list[i].wpIdx == n)
    {
      return true;
    }
  }
  
  return false;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
ListGet(list, n, listSize)
{
  for(i = 0; i < listSize; i++)
  {
    if(list[i].wpIdx == n)
    {
      return list[i];
    }
  }
  
  rVal = spawnstruct();
  rVal.wpIdx = -1;
  
  return rVal;
}