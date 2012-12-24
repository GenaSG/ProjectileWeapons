#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
    thread loadWdrMod();
    thread loadPenetCoef();
    thread loadStoppingCoef();
    thread loadWeaponLength();
    thread loadWeaponSpeed();
    thread loadWeaponZoomLevel();
	thread loadWeaponDamage();
    thread levelcleanup();
    thread maps\mp\_createfx::add_effect("peneteffect", "explosions/grenadeexp_default");
	thread maps\mp\_createfx::add_effect("explodeeffect", "impacts/20mm_default_impact");
	thread maps\mp\_createfx::add_effect("hit", "tracers/ricochet");
	thread maps\mp\_createfx::add_effect("laserDot", "tracers/laserdot");
	precacheShader( "hint_health" );
	precacheShader("progress_bar_bg");
	precacheShader("progress_bar_fg");
	precacheShader("headicon_dead");
	precacheShader("progress_bar_fill");

	
//	brickexp = loadfx("test/brickblast_25");

}
wdrmod( eAttacker, iDamage, sWeapon, sHitLoc, sMeansOfDeath )
{

	if ( sMeansOfDeath != "MOD_MELEE" ) 
	{
		// Check if we support wdr for this weapon
		if ( isDefined( level.wdr[ sWeapon ] ) )
		{
			rangeMod = getDvarfloat( level.wdr[ sWeapon ] );
			targetDist = distance(eAttacker getPlayerEyes(), self getPlayerEyes())* 0.0254;
			//iDamage = iDamage/(1+rangeMod*targetDist);
            //ProjectileWeapons ARMOR
            if(sHitLoc == "torso_upper" || sHitLoc == "torso_lower" || sHitLoc == "right_arm_upper" || sHitLoc == "left_arm_upper" || sHitLoc == "right_arm_lower" || sHitLoc == "left_arm_lower" ||  sHitLoc == "right_hand" ||  sHitLoc == "left_hand" )
            {
                if(self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_armorvest" ) )
                {
                    penetCoef = 0;
                    penetCoef = (getDvarfloat( level.penetCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
                    stoppingCoef = 0;
                    stoppingCoef = (getDvarfloat( level.stoppingCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
			
                    if( eAttacker maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_bulletdamage" ) )
                    {
                        stoppingCoef =stoppingCoef + 1;
                    }
            
                    if( eAttacker maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_bulletpenetration" ) )
                    {
                    	penetCoef = penetCoef + 1;
                    }
                    
                    if( penetCoef < 1 )
                    {
                        iDamage = 0;
                    }
                    
                    else if( penetCoef >= 1 && penetCoef < 2)
                    {
                        iDamage = 0.25 * iDamage/(1+rangeMod*targetDist);	
                    } 
                    
                    else if( penetCoef >= 2 && penetCoef < 3)
                    {
                        iDamage = 0.5 * iDamage/(1+rangeMod*targetDist);	
                    } 
                    
                    else if(penetCoef >= 3)
                    {
                        iDamage = iDamage/(1+rangeMod*targetDist);
                    }
                    thread hitShellShock(stoppingCoef);
                }
                else
                {
                    penetCoef = 0;
                    penetCoef = (getDvarfloat( level.penetCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
                    stoppingCoef = 0;
                    stoppingCoef = (getDvarfloat( level.stoppingCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
                    if( eAttacker maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_bulletdamage" ) )
                    {
                        stoppingCoef =stoppingCoef + 1;
                    }
                    if( eAttacker maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_bulletpenetration" ) )
                    {
                    	penetCoef = penetCoef + 1;
                    }
                    if( penetCoef < 1 )
                    {
                        iDamage = 0.75 * iDamage/(1+rangeMod*targetDist);
                    }
                    else if( penetCoef >= 1 )
                    {
                        iDamage = iDamage/(1+rangeMod*targetDist);	
                    } 
                    thread hitShellShock(stoppingCoef);
                }
            }
            else if(sHitLoc == "head" || sHitLoc == "helmet")
            {
                    penetCoef = 0;
                    penetCoef = (getDvarfloat( level.penetCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
                    stoppingCoef = 0;
                    stoppingCoef = (getDvarfloat( level.stoppingCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
                    if( eAttacker maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_bulletdamage" ) )
                    {
                        stoppingCoef =stoppingCoef + 1;
                    }
                    if( eAttacker maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_bulletpenetration" ) )
                    {
                    	penetCoef = penetCoef + 1;
                    }
                    if( penetCoef < 1 )
                    {
                        iDamage = iDamage/(1+rangeMod*targetDist);
                    }
                        else if( penetCoef >= 1 )
                    {
                        iDamage = 2 * iDamage/(1+rangeMod*targetDist);
                    } 
				if(isSniper(eAttacker) && level.teamBased != 1)
				{
					eAttacker maps\mp\gametypes\_hud_message::hintMessage( "Headshot!!!" );
					score = maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) + int(targetDist);
					eAttacker thread maps\mp\gametypes\_rank::giveRankXP( "headshot", score );
					eAttacker.pers["score"] += score;
					eAttacker.score = self.pers["score"];
					eAttacker notify ( "update_playerscore_hud" );
				}
				if(isSniper(eAttacker) && level.teamBased == 1 && self.team != eAttacker.team)
				{
					eAttacker maps\mp\gametypes\_hud_message::hintMessage( "Headshot!!!" );
					score = maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) + int(targetDist);
					eAttacker thread maps\mp\gametypes\_rank::giveRankXP( "headshot", score );
					eAttacker.pers["score"] += score;
					eAttacker.score = self.pers["score"];
					eAttacker notify ( "update_playerscore_hud" );
				}
                    thread hitShellShock(stoppingCoef);
            }
            else
            {
                stoppingCoef = 0;
                stoppingCoef = (getDvarfloat( level.stoppingCoef[ sWeapon ] ))/(1+rangeMod*targetDist);
                if(stoppingCoef == 1)
                {
                    thread hitShellShock(stoppingCoef);
                }
                iDamage = iDamage/(1+rangeMod*targetDist);
            }
        }

	}
	
	
	if ( sMeansOfDeath == "MOD_MELEE" )
	{
		if (level.teamBased==1) {
			if (eAttacker.team != self.team) {
				iDamage=DoMelee(eAttacker,iDamage);
			}
		}
		else
		{
			iDamage=DoMelee(eAttacker,iDamage);
		}
		
	}
	if (sMeansOfDeath == "MOD_FALLING") {
		if (iDamage<=25 && self.health > iDamage) {
			self thread HealthRegen(iDamage);
		}
		
		else if(iDamage>=25 && self.health > iDamage)
		{
			
			self thread HealthRegen(25);
		}
		
	}
	if (sMeansOfDeath == "MOD_EXPLOSIVE" && self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_armorvest" )) {
		iDamage = iDamage * 0.25;
	}
	if (eAttacker !=self && isPlayer(eAttacker)) {
		eAttacker IPrintLn("Damage: "+ iDamage);
	}

	return int(iDamage);
}

DoMelee(eAttacker,iDamage)
{
	if (self fromBehind(eAttacker)) {
		eAttacker maps\mp\gametypes\_hud_message::hintMessage( "Knifed!" );
		score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) + 20;
		eAttacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", score );
		eAttacker.pers["score"] += score;
		eAttacker.score = self.pers["score"];
		eAttacker notify ( "update_playerscore_hud" );
		return iDamage;
	}
	else
	{
		iDamage = iDamage/4;
		return iDamage;
	}
}

fromBehind(eAttacker)
{
	attacker_vector=vectorscale(anglesToForward(eAttacker.angles),5);
	attacker_point = self.origin + attacker_vector;
	self_vector=vectorscale(anglesToForward(self.angles),5);
	self_point = self.origin + self_vector;
	pointDist = distance(attacker_point,self_point);
	if (pointDist <= sqrt(50)) {
		return true;
	}
	else
	{
		return false;
	}
}

HealthRegen(DamageTaken)
{
	wait(3);
	for (HealthRegened = 0; HealthRegened < DamageTaken; HealthRegened++) {
		if (!isalive(self)) {
			return false;
		}
		self.health +=1;
		wait(0.5);
	}
	return true;
}

hitShellShock(stoppingCoef)
{
     time = stoppingCoef * getDvarfloat( "scr_stoppingcoef" );   
     self shellShock( "frag_grenade_mp", time );
}

loadWeaponDamage()
{
	level.damage=[];
	level.weapon=[];
	level.class=[];
	
	level.weapon[ "rpg_mp" ]["damage"] = 1000;
	level.weapon[ "m16_acog_mp" ]["damage"] = 34.29;
	level.weapon[ "m16_gl_mp" ]["damage"] = 34.29;
	level.weapon[ "m16_mp" ]["damage"] = 34.29;
	level.weapon[ "m16_reflex_mp" ]["damage"] = 34.29;
	level.weapon[ "m16_silencer_mp" ]["damage"] = 26.67;

	level.weapon[ "ak47_acog_mp" ]["damage"] = 40;
	level.weapon[ "ak47_gl_mp" ]["damage"] = 40;
	level.weapon[ "ak47_mp" ]["damage"] = 40;
	level.weapon[ "ak47_reflex_mp" ]["damage"] = 40;
	level.weapon[ "ak47_silencer_mp" ]["damage"] = 40;

	level.weapon[ "m4_acog_mp" ]["damage"] = 32.00;
	level.weapon[ "m4_gl_mp" ]["damage"] = 32.00;
	level.weapon[ "m4_mp" ]["damage"] = 32.00;
	level.weapon[ "m4_reflex_mp" ]["damage"] = 32.00;
	level.weapon[ "m4_silencer_mp" ]["damage"] = 26.67;

	level.weapon[ "g3_acog_mp" ]["damage"] = 48.00;
	level.weapon[ "g3_gl_mp" ]["damage"] = 48.00;
	level.weapon[ "g3_mp" ]["damage"] = 48.00;
	level.weapon[ "g3_reflex_mp" ]["damage"] = 48.00;
	level.weapon[ "g3_silencer_mp" ]["damage"] = 48.00;

	level.weapon[ "g36c_acog_mp" ]["damage"] = 32.00;
	level.weapon[ "g36c_gl_mp" ]["damage"] = 32.00;
	level.weapon[ "g36c_mp" ]["damage"] = 32.00;
	level.weapon[ "g36c_reflex_mp" ]["damage"] = 32.00;
	level.weapon[ "g36c_silencer_mp" ]["damage"] = 26.67;

	level.weapon[ "m14_acog_mp" ]["damage"] = 68.57;
	level.weapon[ "m14_gl_mp" ]["damage"] = 68.57;
	level.weapon[ "m14_mp" ]["damage"] = 68.57;
	level.weapon[ "m14_reflex_mp" ]["damage"] = 68.57;
	level.weapon[ "m14_silencer_mp" ]["damage"] = 68.57;

	level.weapon[ "mp44_mp" ]["damage"] = 48.00;


	// Special Ops class weapons
	level.weapon[ "mp5_acog_mp" ]["damage"] = 30;
	level.weapon[ "mp5_mp" ]["damage"] = 30;
	level.weapon[ "mp5_reflex_mp" ]["damage"] = 30;
	level.weapon[ "mp5_silencer_mp" ]["damage"] = 30;

	level.weapon[ "skorpion_acog_mp" ]["damage"] = 25.26;
	level.weapon[ "skorpion_mp" ]["damage"] = 25.26;
	level.weapon[ "skorpion_reflex_mp" ]["damage"] = 25.26;
	level.weapon[ "skorpion_silencer_mp" ]["damage"] = 25.26;

	level.weapon[ "uzi_acog_mp" ]["damage"] = 26.67;
	level.weapon[ "uzi_mp" ]["damage"] = 26.67;
	level.weapon[ "uzi_reflex_mp" ]["damage"] = 26.67;
	level.weapon[ "uzi_silencer_mp" ]["damage"] = 26.67;

	level.weapon[ "ak74u_acog_mp" ]["damage"] = 32;
	level.weapon[ "ak74u_mp" ]["damage"] = 32;
	level.weapon[ "ak74u_reflex_mp" ]["damage"] = 32;
	level.weapon[ "ak74u_silencer_mp" ]["damage"] = 26.67;

	level.weapon[ "p90_acog_mp" ]["damage"] = 26.67;
	level.weapon[ "p90_mp" ]["damage"] = 26.67;
	level.weapon[ "p90_reflex_mp" ]["damage"] = 26.67;
	level.weapon[ "p90_silencer_mp" ]["damage"] = 26.67;


	// Demolition class weapons
	level.weapon[ "m1014_grip_mp" ]["damage"] = 30;
	level.weapon[ "m1014_mp" ]["damage"] = 30;
	level.weapon[ "m1014_reflex_mp" ]["damage"] = 30;

	level.weapon[ "winchester1200_grip_mp" ]["damage"] = 30;
	level.weapon[ "winchester1200_mp" ]["damage"] = 30;
	level.weapon[ "winchester1200_reflex_mp" ]["damage"] = 30;


	// Heavy gunner class weapons
	level.weapon[ "saw_acog_mp" ]["damage"] = 24.00;
	level.weapon[ "saw_grip_mp" ]["damage"] = 24.00;
	level.weapon[ "saw_mp" ]["damage"] = 24.00;
	level.weapon[ "saw_reflex_mp" ]["damage"] = 24.00;

	level.weapon[ "rpd_acog_mp" ]["damage"] = 32.00;
	level.weapon[ "rpd_grip_mp" ]["damage"] = 32.00;
	level.weapon[ "rpd_mp" ]["damage"] = 32.00;
	level.weapon[ "rpd_reflex_mp" ]["damage"] = 32.00;

	level.weapon[ "m60e4_acog_mp" ]["damage"] = 43.64;
	level.weapon[ "m60e4_grip_mp" ]["damage"] = 43.64;
	level.weapon[ "m60e4_mp" ]["damage"] = 43.64;
	level.weapon[ "m60e4_reflex_mp" ]["damage"] = 43.64;


	// Sniper class weapons
	level.weapon[ "dragunov_acog_mp" ]["damage"] = 68.57;
	level.weapon[ "dragunov_mp" ]["damage"] = 68.57;

	level.weapon[ "m40a3_acog_mp" ]["damage"] = 120.00;
	level.weapon[ "m40a3_mp" ]["damage"] = 120.00;

	level.weapon[ "barrett_acog_mp" ]["damage"] = 400;
	level.weapon[ "barrett_mp" ]["damage"] = 400;

	level.weapon[ "remington700_acog_mp" ]["damage"] = 120;
	level.weapon[ "remington700_mp" ]["damage"] = 120;

	level.weapon[ "m21_acog_mp" ]["damage"] = 68.57;
	level.weapon[ "m21_mp" ]["damage"] = 68.57;


	// Handguns
	level.weapon[ "beretta_mp" ]["damage"] = 40;
	level.weapon[ "beretta_silencer_mp" ]["damage"] = 40;

	level.weapon[ "colt45_mp" ]["damage"] = 53.33;
	level.weapon[ "colt45_silencer_mp" ]["damage"] = 53.33;

	level.weapon[ "usp_mp" ]["damage"] = 53.33;
	level.weapon[ "usp_silencer_mp" ]["damage"] = 53.33;

	level.weapon[ "deserteagle_mp" ]["damage"] = 60;
	level.weapon[ "deserteaglegold_mp" ]["damage"] = 60;
	

	return;
}


loadWdrMod()
{
     
	// Load all the weapons with their corresponding dvar controlling it
	level.wdr = [];

	// Assault class weapons
	level.wdr[ "m16_acog_mp" ] = "scr_wdr_m16";
	level.wdr[ "m16_gl_mp" ] = "scr_wdr_m16";
	level.wdr[ "m16_mp" ] = "scr_wdr_m16";
	level.wdr[ "m16_reflex_mp" ] = "scr_wdr_m16";
	level.wdr[ "m16_silencer_mp" ] = "scr_wdr_m16_silenced";

	level.wdr[ "ak47_acog_mp" ] = "scr_wdr_ak47";
	level.wdr[ "ak47_gl_mp" ] = "scr_wdr_ak47";
	level.wdr[ "ak47_mp" ] = "scr_wdr_ak47";
	level.wdr[ "ak47_reflex_mp" ] = "scr_wdr_ak47";
	level.wdr[ "ak47_silencer_mp" ] = "scr_wdr_ak47_silenced";

	level.wdr[ "m4_acog_mp" ] = "scr_wdr_m4";
	level.wdr[ "m4_gl_mp" ] = "scr_wdr_m4";
	level.wdr[ "m4_mp" ] = "scr_wdr_m4";
	level.wdr[ "m4_reflex_mp" ] = "scr_wdr_m4";
	level.wdr[ "m4_silencer_mp" ] = "scr_wdr_m4_silenced";

	level.wdr[ "g3_acog_mp" ] = "scr_wdr_g3";
	level.wdr[ "g3_gl_mp" ] = "scr_wdr_g3";
	level.wdr[ "g3_mp" ] = "scr_wdr_g3";
	level.wdr[ "g3_reflex_mp" ] = "scr_wdr_g3";
	level.wdr[ "g3_silencer_mp" ] = "scr_wdr_g3_silenced";

	level.wdr[ "g36c_acog_mp" ] = "scr_wdr_g36c";
	level.wdr[ "g36c_gl_mp" ] = "scr_wdr_g36c";
	level.wdr[ "g36c_mp" ] = "scr_wdr_g36c";
	level.wdr[ "g36c_reflex_mp" ] = "scr_wdr_g36c";
	level.wdr[ "g36c_silencer_mp" ] = "scr_wdr_g36c_silenced";

	level.wdr[ "m14_acog_mp" ] = "scr_wdr_m14";
	level.wdr[ "m14_gl_mp" ] = "scr_wdr_m14";
	level.wdr[ "m14_mp" ] = "scr_wdr_m14";
	level.wdr[ "m14_reflex_mp" ] = "scr_wdr_m14";
	level.wdr[ "m14_silencer_mp" ] = "scr_wdr_m14_silenced";

	level.wdr[ "mp44_mp" ] = "scr_wdr_mp44";


	// Special Ops class weapons
	level.wdr[ "mp5_acog_mp" ] = "scr_wdr_mp5";
	level.wdr[ "mp5_mp" ] = "scr_wdr_mp5";
	level.wdr[ "mp5_reflex_mp" ] = "scr_wdr_mp5";
	level.wdr[ "mp5_silencer_mp" ] = "scr_wdr_mp5_silenced";

	level.wdr[ "skorpion_acog_mp" ] = "scr_wdr_skorpion";
	level.wdr[ "skorpion_mp" ] = "scr_wdr_skorpion";
	level.wdr[ "skorpion_reflex_mp" ] = "scr_wdr_skorpion";
	level.wdr[ "skorpion_silencer_mp" ] = "scr_wdr_skorpion_silenced";

	level.wdr[ "uzi_acog_mp" ] = "scr_wdr_uzi";
	level.wdr[ "uzi_mp" ] = "scr_wdr_uzi";
	level.wdr[ "uzi_reflex_mp" ] = "scr_wdr_uzi";
	level.wdr[ "uzi_silencer_mp" ] = "scr_wdr_uzi_silenced";

	level.wdr[ "ak74u_acog_mp" ] = "scr_wdr_ak74u";
	level.wdr[ "ak74u_mp" ] = "scr_wdr_ak74u";
	level.wdr[ "ak74u_reflex_mp" ] = "scr_wdr_ak74u";
	level.wdr[ "ak74u_silencer_mp" ] = "scr_wdr_ak74u_silenced";

	level.wdr[ "p90_acog_mp" ] = "scr_wdr_p90";
	level.wdr[ "p90_mp" ] = "scr_wdr_p90";
	level.wdr[ "p90_reflex_mp" ] = "scr_wdr_p90";
	level.wdr[ "p90_silencer_mp" ] = "scr_wdr_p90_silenced";


	// Demolition class weapons
	level.wdr[ "m1014_grip_mp" ] = "scr_wdr_m1014";
	level.wdr[ "m1014_mp" ] = "scr_wdr_m1014";
	level.wdr[ "m1014_reflex_mp" ] = "scr_wdr_m1014";

	level.wdr[ "winchester1200_grip_mp" ] = "scr_wdr_winchester1200";
	level.wdr[ "winchester1200_mp" ] = "scr_wdr_winchester1200";
	level.wdr[ "winchester1200_reflex_mp" ] = "scr_wdr_winchester1200";


	// Heavy gunner class weapons
	level.wdr[ "saw_acog_mp" ] = "scr_wdr_saw";
	level.wdr[ "saw_grip_mp" ] = "scr_wdr_saw";
	level.wdr[ "saw_mp" ] = "scr_wdr_saw";
	level.wdr[ "saw_reflex_mp" ] = "scr_wdr_saw";

	level.wdr[ "rpd_acog_mp" ] = "scr_wdr_rpd";
	level.wdr[ "rpd_grip_mp" ] = "scr_wdr_rpd";
	level.wdr[ "rpd_mp" ] = "scr_wdr_rpd";
	level.wdr[ "rpd_reflex_mp" ] = "scr_wdr_rpd";

	level.wdr[ "m60e4_acog_mp" ] = "scr_wdr_m60e4";
	level.wdr[ "m60e4_grip_mp" ] = "scr_wdr_m60e4";
	level.wdr[ "m60e4_mp" ] = "scr_wdr_m60e4";
	level.wdr[ "m60e4_reflex_mp" ] = "scr_wdr_m60e4";


	// Sniper class weapons
	level.wdr[ "dragunov_acog_mp" ] = "scr_wdr_dragunov";
	level.wdr[ "dragunov_mp" ] = "scr_wdr_dragunov";

	level.wdr[ "m40a3_acog_mp" ] = "scr_wdr_m40a3";
	level.wdr[ "m40a3_mp" ] = "scr_wdr_m40a3";

	level.wdr[ "barrett_acog_mp" ] = "scr_wdr_barrett";
	level.wdr[ "barrett_mp" ] = "scr_wdr_barrett";

	level.wdr[ "remington700_acog_mp" ] = "scr_wdr_remington700";
	level.wdr[ "remington700_mp" ] = "scr_wdr_remington700";

	level.wdr[ "m21_acog_mp" ] = "scr_wdr_m21";
	level.wdr[ "m21_mp" ] = "scr_wdr_m21";


	// Handguns
	level.wdr[ "beretta_mp" ] = "scr_wdr_beretta";
	level.wdr[ "beretta_silencer_mp" ] = "scr_wdr_beretta_silenced";

	level.wdr[ "colt45_mp" ] = "scr_wdr_colt45";
	level.wdr[ "colt45_silencer_mp" ] = "scr_wdr_colt45_silenced";

	level.wdr[ "usp_mp" ] = "scr_wdr_usp";
	level.wdr[ "usp_silencer_mp" ] = "scr_wdr_usp_silenced";

	level.wdr[ "deserteagle_mp" ] = "scr_wdr_deserteagle";
	level.wdr[ "deserteaglegold_mp" ] = "scr_wdr_deserteagle";


	return;
}

loadPenetCoef()
{

// Load all the weapons with their corresponding dvar controlling it
level.penetCoef = [];

// Assault class weapons
level.penetCoef[ "m16_acog_mp" ] = "scr_pnt_m16";
level.penetCoef[ "m16_gl_mp" ] = "scr_pnt_m16";
level.penetCoef[ "m16_mp" ] = "scr_pnt_m16";
level.penetCoef[ "m16_reflex_mp" ] = "scr_pnt_m16";
level.penetCoef[ "m16_silencer_mp" ] = "scr_pnt_m16_silenced";

level.penetCoef[ "ak47_acog_mp" ] = "scr_pnt_ak47";
level.penetCoef[ "ak47_gl_mp" ] = "scr_pnt_ak47";
level.penetCoef[ "ak47_mp" ] = "scr_pnt_ak47";
level.penetCoef[ "ak47_reflex_mp" ] = "scr_pnt_ak47";
level.penetCoef[ "ak47_silencer_mp" ] = "scr_pnt_ak47_silenced";

level.penetCoef[ "m4_acog_mp" ] = "scr_pnt_m4";
level.penetCoef[ "m4_gl_mp" ] = "scr_pnt_m4";
level.penetCoef[ "m4_mp" ] = "scr_pnt_m4";
level.penetCoef[ "m4_reflex_mp" ] = "scr_pnt_m4";
level.penetCoef[ "m4_silencer_mp" ] = "scr_pnt_m4_silenced";

level.penetCoef[ "g3_acog_mp" ] = "scr_pnt_g3";
level.penetCoef[ "g3_gl_mp" ] = "scr_pnt_g3";
level.penetCoef[ "g3_mp" ] = "scr_pnt_g3";
level.penetCoef[ "g3_reflex_mp" ] = "scr_pnt_g3";
level.penetCoef[ "g3_silencer_mp" ] = "scr_pnt_g3_silenced";

level.penetCoef[ "g36c_acog_mp" ] = "scr_pnt_g36c";
level.penetCoef[ "g36c_gl_mp" ] = "scr_pnt_g36c";
level.penetCoef[ "g36c_mp" ] = "scr_pnt_g36c";
level.penetCoef[ "g36c_reflex_mp" ] = "scr_pnt_g36c";
level.penetCoef[ "g36c_silencer_mp" ] = "scr_pnt_g36c_silenced";

level.penetCoef[ "m14_acog_mp" ] = "scr_pnt_m14";
level.penetCoef[ "m14_gl_mp" ] = "scr_pnt_m14";
level.penetCoef[ "m14_mp" ] = "scr_pnt_m14";
level.penetCoef[ "m14_reflex_mp" ] = "scr_pnt_m14";
level.penetCoef[ "m14_silencer_mp" ] = "scr_pnt_m14_silenced";

level.penetCoef[ "mp44_mp" ] = "scr_pnt_mp44";


// Special Ops class weapons
level.penetCoef[ "mp5_acog_mp" ] = "scr_pnt_mp5";
level.penetCoef[ "mp5_mp" ] = "scr_pnt_mp5";
level.penetCoef[ "mp5_reflex_mp" ] = "scr_pnt_mp5";
level.penetCoef[ "mp5_silencer_mp" ] = "scr_pnt_mp5_silenced";

level.penetCoef[ "skorpion_acog_mp" ] = "scr_pnt_skorpion";
level.penetCoef[ "skorpion_mp" ] = "scr_pnt_skorpion";
level.penetCoef[ "skorpion_reflex_mp" ] = "scr_pnt_skorpion";
level.penetCoef[ "skorpion_silencer_mp" ] = "scr_pnt_skorpion_silenced";

level.penetCoef[ "uzi_acog_mp" ] = "scr_pnt_uzi";
level.penetCoef[ "uzi_mp" ] = "scr_pnt_uzi";
level.penetCoef[ "uzi_reflex_mp" ] = "scr_pnt_uzi";
level.penetCoef[ "uzi_silencer_mp" ] = "scr_pnt_uzi_silenced";

level.penetCoef[ "ak74u_acog_mp" ] = "scr_pnt_ak74u";
level.penetCoef[ "ak74u_mp" ] = "scr_pnt_ak74u";
level.penetCoef[ "ak74u_reflex_mp" ] = "scr_pnt_ak74u";
level.penetCoef[ "ak74u_silencer_mp" ] = "scr_pnt_ak74u_silenced";

level.penetCoef[ "p90_acog_mp" ] = "scr_pnt_p90";
level.penetCoef[ "p90_mp" ] = "scr_pnt_p90";
level.penetCoef[ "p90_reflex_mp" ] = "scr_pnt_p90";
level.penetCoef[ "p90_silencer_mp" ] = "scr_pnt_p90_silenced";


// Demolition class weapons
level.penetCoef[ "m1014_grip_mp" ] = "scr_pnt_m1014";
level.penetCoef[ "m1014_mp" ] = "scr_pnt_m1014";
level.penetCoef[ "m1014_reflex_mp" ] = "scr_pnt_m1014";

level.penetCoef[ "winchester1200_grip_mp" ] = "scr_pnt_winchester1200";
level.penetCoef[ "winchester1200_mp" ] = "scr_pnt_winchester1200";
level.penetCoef[ "winchester1200_reflex_mp" ] = "scr_pnt_winchester1200";


// Heavy gunner class weapons
level.penetCoef[ "saw_acog_mp" ] = "scr_pnt_saw";
level.penetCoef[ "saw_grip_mp" ] = "scr_pnt_saw";
level.penetCoef[ "saw_mp" ] = "scr_pnt_saw";
level.penetCoef[ "saw_reflex_mp" ] = "scr_pnt_saw";

level.penetCoef[ "rpd_acog_mp" ] = "scr_pnt_rpd";
level.penetCoef[ "rpd_grip_mp" ] = "scr_pnt_rpd";
level.penetCoef[ "rpd_mp" ] = "scr_pnt_rpd";
level.penetCoef[ "rpd_reflex_mp" ] = "scr_pnt_rpd";

level.penetCoef[ "m60e4_acog_mp" ] = "scr_pnt_m60e4";
level.penetCoef[ "m60e4_grip_mp" ] = "scr_pnt_m60e4";
level.penetCoef[ "m60e4_mp" ] = "scr_pnt_m60e4";
level.penetCoef[ "m60e4_reflex_mp" ] = "scr_pnt_m60e4";


// Sniper class weapons
level.penetCoef[ "dragunov_acog_mp" ] = "scr_pnt_dragunov";
level.penetCoef[ "dragunov_mp" ] = "scr_pnt_dragunov";

level.penetCoef[ "m40a3_acog_mp" ] = "scr_pnt_m40a3";
level.penetCoef[ "m40a3_mp" ] = "scr_pnt_m40a3";

level.penetCoef[ "barrett_acog_mp" ] = "scr_pnt_barrett";
level.penetCoef[ "barrett_mp" ] = "scr_pnt_barrett";

level.penetCoef[ "remington700_acog_mp" ] = "scr_pnt_remington700";
level.penetCoef[ "remington700_mp" ] = "scr_pnt_remington700";

level.penetCoef[ "m21_acog_mp" ] = "scr_pnt_m21";
level.penetCoef[ "m21_mp" ] = "scr_pnt_m21";


// Handguns
level.penetCoef[ "beretta_mp" ] = "scr_pnt_beretta";
level.penetCoef[ "beretta_silencer_mp" ] = "scr_pnt_beretta_silenced";

level.penetCoef[ "colt45_mp" ] = "scr_pnt_colt45";
level.penetCoef[ "colt45_silencer_mp" ] = "scr_pnt_colt45_silenced";

level.penetCoef[ "usp_mp" ] = "scr_pnt_usp";
level.penetCoef[ "usp_silencer_mp" ] = "scr_pnt_usp_silenced";

level.penetCoef[ "deserteagle_mp" ] = "scr_pnt_deserteagle";
level.penetCoef[ "deserteaglegold_mp" ] = "scr_pnt_deserteagle";


return;
}

loadStoppingCoef()
{

// Load all the weapons with their corresponding dvar controlling it
level.stoppingCoef = [];

// Assault class weapons
level.stoppingCoef[ "m16_acog_mp" ] = "scr_stp_m16";
level.stoppingCoef[ "m16_gl_mp" ] = "scr_stp_m16";
level.stoppingCoef[ "m16_mp" ] = "scr_stp_m16";
level.stoppingCoef[ "m16_reflex_mp" ] = "scr_stp_m16";
level.stoppingCoef[ "m16_silencer_mp" ] = "scr_stp_m16_silenced";

level.stoppingCoef[ "ak47_acog_mp" ] = "scr_stp_ak47";
level.stoppingCoef[ "ak47_gl_mp" ] = "scr_stp_ak47";
level.stoppingCoef[ "ak47_mp" ] = "scr_stp_ak47";
level.stoppingCoef[ "ak47_reflex_mp" ] = "scr_stp_ak47";
level.stoppingCoef[ "ak47_silencer_mp" ] = "scr_stp_ak47_silenced";

level.stoppingCoef[ "m4_acog_mp" ] = "scr_stp_m4";
level.stoppingCoef[ "m4_gl_mp" ] = "scr_stp_m4";
level.stoppingCoef[ "m4_mp" ] = "scr_stp_m4";
level.stoppingCoef[ "m4_reflex_mp" ] = "scr_stp_m4";
level.stoppingCoef[ "m4_silencer_mp" ] = "scr_stp_m4_silenced";

level.stoppingCoef[ "g3_acog_mp" ] = "scr_stp_g3";
level.stoppingCoef[ "g3_gl_mp" ] = "scr_stp_g3";
level.stoppingCoef[ "g3_mp" ] = "scr_stp_g3";
level.stoppingCoef[ "g3_reflex_mp" ] = "scr_stp_g3";
level.stoppingCoef[ "g3_silencer_mp" ] = "scr_stp_g3_silenced";

level.stoppingCoef[ "g36c_acog_mp" ] = "scr_stp_g36c";
level.stoppingCoef[ "g36c_gl_mp" ] = "scr_stp_g36c";
level.stoppingCoef[ "g36c_mp" ] = "scr_stp_g36c";
level.stoppingCoef[ "g36c_reflex_mp" ] = "scr_stp_g36c";
level.stoppingCoef[ "g36c_silencer_mp" ] = "scr_stp_g36c_silenced";

level.stoppingCoef[ "m14_acog_mp" ] = "scr_stp_m14";
level.stoppingCoef[ "m14_gl_mp" ] = "scr_stp_m14";
level.stoppingCoef[ "m14_mp" ] = "scr_stp_m14";
level.stoppingCoef[ "m14_reflex_mp" ] = "scr_stp_m14";
level.stoppingCoef[ "m14_silencer_mp" ] = "scr_stp_m14_silenced";

level.stoppingCoef[ "mp44_mp" ] = "scr_stp_mp44";


// Special Ops class weapons
level.stoppingCoef[ "mp5_acog_mp" ] = "scr_stp_mp5";
level.stoppingCoef[ "mp5_mp" ] = "scr_stp_mp5";
level.stoppingCoef[ "mp5_reflex_mp" ] = "scr_stp_mp5";
level.stoppingCoef[ "mp5_silencer_mp" ] = "scr_stp_mp5_silenced";

level.stoppingCoef[ "skorpion_acog_mp" ] = "scr_stp_skorpion";
level.stoppingCoef[ "skorpion_mp" ] = "scr_stp_skorpion";
level.stoppingCoef[ "skorpion_reflex_mp" ] = "scr_stp_skorpion";
level.stoppingCoef[ "skorpion_silencer_mp" ] = "scr_stp_skorpion_silenced";

level.stoppingCoef[ "uzi_acog_mp" ] = "scr_stp_uzi";
level.stoppingCoef[ "uzi_mp" ] = "scr_stp_uzi";
level.stoppingCoef[ "uzi_reflex_mp" ] = "scr_stp_uzi";
level.stoppingCoef[ "uzi_silencer_mp" ] = "scr_stp_uzi_silenced";

level.stoppingCoef[ "ak74u_acog_mp" ] = "scr_stp_ak74u";
level.stoppingCoef[ "ak74u_mp" ] = "scr_stp_ak74u";
level.stoppingCoef[ "ak74u_reflex_mp" ] = "scr_stp_ak74u";
level.stoppingCoef[ "ak74u_silencer_mp" ] = "scr_stp_ak74u_silenced";

level.stoppingCoef[ "p90_acog_mp" ] = "scr_stp_p90";
level.stoppingCoef[ "p90_mp" ] = "scr_stp_p90";
level.stoppingCoef[ "p90_reflex_mp" ] = "scr_stp_p90";
level.stoppingCoef[ "p90_silencer_mp" ] = "scr_stp_p90_silenced";


// Demolition class weapons
level.stoppingCoef[ "m1014_grip_mp" ] = "scr_stp_m1014";
level.stoppingCoef[ "m1014_mp" ] = "scr_stp_m1014";
level.stoppingCoef[ "m1014_reflex_mp" ] = "scr_stp_m1014";

level.stoppingCoef[ "winchester1200_grip_mp" ] = "scr_stp_winchester1200";
level.stoppingCoef[ "winchester1200_mp" ] = "scr_stp_winchester1200";
level.stoppingCoef[ "winchester1200_reflex_mp" ] = "scr_stp_winchester1200";


// Heavy gunner class weapons
level.stoppingCoef[ "saw_acog_mp" ] = "scr_stp_saw";
level.stoppingCoef[ "saw_grip_mp" ] = "scr_stp_saw";
level.stoppingCoef[ "saw_mp" ] = "scr_stp_saw";
level.stoppingCoef[ "saw_reflex_mp" ] = "scr_stp_saw";

level.stoppingCoef[ "rpd_acog_mp" ] = "scr_stp_saw";
level.stoppingCoef[ "rpd_grip_mp" ] = "scr_stp_saw";
level.stoppingCoef[ "rpd_mp" ] = "scr_stp_saw";
level.stoppingCoef[ "rpd_reflex_mp" ] = "scr_stp_saw";

level.stoppingCoef[ "m60e4_acog_mp" ] = "scr_stp_m60e4";
level.stoppingCoef[ "m60e4_grip_mp" ] = "scr_stp_m60e4";
level.stoppingCoef[ "m60e4_mp" ] = "scr_stp_m60e4";
level.stoppingCoef[ "m60e4_reflex_mp" ] = "scr_stp_m60e4";


// Sniper class weapons
level.stoppingCoef[ "dragunov_acog_mp" ] = "scr_stp_dragunov";
level.stoppingCoef[ "dragunov_mp" ] = "scr_stp_dragunov";

level.stoppingCoef[ "m40a3_acog_mp" ] = "scr_stp_m40a3";
level.stoppingCoef[ "m40a3_mp" ] = "scr_stp_m40a3";

level.stoppingCoef[ "barrett_acog_mp" ] = "scr_stp_barrett";
level.stoppingCoef[ "barrett_mp" ] = "scr_stp_barrett";

level.stoppingCoef[ "remington700_acog_mp" ] = "scr_stp_remington700";
level.stoppingCoef[ "remington700_mp" ] = "scr_stp_remington700";

level.stoppingCoef[ "m21_acog_mp" ] = "scr_stp_m21";
level.stoppingCoef[ "m21_mp" ] = "scr_stp_m21";


// Handguns
level.stoppingCoef[ "beretta_mp" ] = "scr_stp_beretta";
level.stoppingCoef[ "beretta_silencer_mp" ] = "scr_stp_beretta_silenced";

level.stoppingCoef[ "colt45_mp" ] = "scr_stp_colt45";
level.stoppingCoef[ "colt45_silencer_mp" ] = "scr_stp_colt45_silenced";

level.stoppingCoef[ "usp_mp" ] = "scr_wdr_usp";
level.stoppingCoef[ "usp_silencer_mp" ] = "scr_stp_usp_silenced";

level.stoppingCoef[ "deserteagle_mp" ] = "scr_stp_deserteagle";
level.stoppingCoef[ "deserteaglegold_mp" ] = "scr_stp_deserteagle";


return;
}

loadWeaponLength()
{

// Load all the weapons with their corresponding dvar controlling it
level.wl = [];

// Assault class weapons
level.wl[ "m16_acog_mp" ] = "scr_wl_m16";
level.wl[ "m16_gl_mp" ] = "scr_wl_m16";
level.wl[ "m16_mp" ] = "scr_wl_m16";
level.wl[ "m16_reflex_mp" ] = "scr_wl_m16";
level.wl[ "m16_silencer_mp" ] = "scr_wl_m16_silenced";

level.wl[ "ak47_acog_mp" ] = "scr_wl_ak47";
level.wl[ "ak47_gl_mp" ] = "scr_wl_ak47";
level.wl[ "ak47_mp" ] = "scr_wl_ak47";
level.wl[ "ak47_reflex_mp" ] = "scr_wl_ak47";
level.wl[ "ak47_silencer_mp" ] = "scr_wl_ak47_silenced";

level.wl[ "m4_acog_mp" ] = "scr_wl_m4";
level.wl[ "m4_gl_mp" ] = "scr_wl_m4";
level.wl[ "m4_mp" ] = "scr_wl_m4";
level.wl[ "m4_reflex_mp" ] = "scr_wl_m4";
level.wl[ "m4_silencer_mp" ] = "scr_wl_m4_silenced";

level.wl[ "g3_acog_mp" ] = "scr_wl_g3";
level.wl[ "g3_gl_mp" ] = "scr_wl_g3";
level.wl[ "g3_mp" ] = "scr_wl_g3";
level.wl[ "g3_reflex_mp" ] = "scr_wl_g3";
level.wl[ "g3_silencer_mp" ] = "scr_wl_g3_silenced";

level.wl[ "g36c_acog_mp" ] = "scr_wl_g36c";
level.wl[ "g36c_gl_mp" ] = "scr_wl_g36c";
level.wl[ "g36c_mp" ] = "scr_wl_g36c";
level.wl[ "g36c_reflex_mp" ] = "scr_wl_g36c";
level.wl[ "g36c_silencer_mp" ] = "scr_wl_g36c_silenced";

level.wl[ "m14_acog_mp" ] = "scr_wl_m14";
level.wl[ "m14_gl_mp" ] = "scr_wl_m14";
level.wl[ "m14_mp" ] = "scr_wl_m14";
level.wl[ "m14_reflex_mp" ] = "scr_wl_m14";
level.wl[ "m14_silencer_mp" ] = "scr_wl_m14_silenced";

level.wl[ "mp44_mp" ] = "scr_wl_mp44";


// Special Ops class weapons
level.wl[ "mp5_acog_mp" ] = "scr_wl_mp5";
level.wl[ "mp5_mp" ] = "scr_wl_mp5";
level.wl[ "mp5_reflex_mp" ] = "scr_wl_mp5";
level.wl[ "mp5_silencer_mp" ] = "scr_wl_mp5_silenced";

level.wl[ "skorpion_acog_mp" ] = "scr_wl_skorpion";
level.wl[ "skorpion_mp" ] = "scr_wl_skorpion";
level.wl[ "skorpion_reflex_mp" ] = "scr_wl_skorpion";
level.wl[ "skorpion_silencer_mp" ] = "scr_wl_skorpion_silenced";

level.wl[ "uzi_acog_mp" ] = "scr_wl_uzi";
level.wl[ "uzi_mp" ] = "scr_wl_uzi";
level.wl[ "uzi_reflex_mp" ] = "scr_wl_uzi";
level.wl[ "uzi_silencer_mp" ] = "scr_wl_uzi_silenced";

level.wl[ "ak74u_acog_mp" ] = "scr_wl_ak74u";
level.wl[ "ak74u_mp" ] = "scr_wl_ak74u";
level.wl[ "ak74u_reflex_mp" ] = "scr_wl_ak74u";
level.wl[ "ak74u_silencer_mp" ] = "scr_wl_ak74u_silenced";

level.wl[ "p90_acog_mp" ] = "scr_wl_p90";
level.wl[ "p90_mp" ] = "scr_wl_p90";
level.wl[ "p90_reflex_mp" ] = "scr_wl_p90";
level.wl[ "p90_silencer_mp" ] = "scr_wl_p90_silenced";


// Demolition class weapons
level.wl[ "m1014_grip_mp" ] = "scr_wl_m1014";
level.wl[ "m1014_mp" ] = "scr_wl_m1014";
level.wl[ "m1014_reflex_mp" ] = "scr_wl_m1014";

level.wl[ "winchester1200_grip_mp" ] = "scr_wl_winchester1200";
level.wl[ "winchester1200_mp" ] = "scr_wl_winchester1200";
level.wl[ "winchester1200_reflex_mp" ] = "scr_wl_winchester1200";


// Heavy gunner class weapons
level.wl[ "saw_acog_mp" ] = "scr_wl_saw";
level.wl[ "saw_grip_mp" ] = "scr_wl_saw";
level.wl[ "saw_mp" ] = "scr_wl_saw";
level.wl[ "saw_reflex_mp" ] = "scr_wl_saw";

level.wl[ "rpd_acog_mp" ] = "scr_wl_saw";
level.wl[ "rpd_grip_mp" ] = "scr_wl_saw";
level.wl[ "rpd_mp" ] = "scr_wl_saw";
level.wl[ "rpd_reflex_mp" ] = "scr_wl_saw";

level.wl[ "m60e4_acog_mp" ] = "scr_wl_m60e4";
level.wl[ "m60e4_grip_mp" ] = "scr_wl_m60e4";
level.wl[ "m60e4_mp" ] = "scr_wl_m60e4";
level.wl[ "m60e4_reflex_mp" ] = "scr_wl_m60e4";


// Sniper class weapons
level.wl[ "dragunov_acog_mp" ] = "scr_wl_dragunov";
level.wl[ "dragunov_mp" ] = "scr_wl_dragunov";

level.wl[ "m40a3_acog_mp" ] = "scr_wl_m40a3";
level.wl[ "m40a3_mp" ] = "scr_wl_m40a3";

level.wl[ "barrett_acog_mp" ] = "scr_wl_barrett";
level.wl[ "barrett_mp" ] = "scr_wl_barrett";

level.wl[ "remington700_acog_mp" ] = "scr_wl_remington700";
level.wl[ "remington700_mp" ] = "scr_wl_remington700";

level.wl[ "m21_acog_mp" ] = "scr_wl_m21";
level.wl[ "m21_mp" ] = "scr_wl_m21";


// Handguns
level.wl[ "beretta_mp" ] = "scr_wl_beretta";
level.wl[ "beretta_silencer_mp" ] = "scr_wl_beretta_silenced";

level.wl[ "colt45_mp" ] = "scr_wl_colt45";
level.wl[ "colt45_silencer_mp" ] = "scr_wl_colt45_silenced";

level.wl[ "usp_mp" ] = "scr_wdr_usp";
level.wl[ "usp_silencer_mp" ] = "scr_wl_usp_silenced";

level.wl[ "deserteagle_mp" ] = "scr_wl_deserteagle";
level.wl[ "deserteaglegold_mp" ] = "scr_wl_deserteagle";


return;
}

loadWeaponSpeed()
{

// Load all the weapons with their corresponding dvar controlling it
level.ws = [];

// Assault class weapons
level.ws[ "m16_acog_mp" ] = "scr_ws_m16_acog";
level.ws[ "ak47_acog_mp" ] = "scr_ws_ak47_acog";
level.ws[ "m4_acog_mp" ] = "scr_ws_m4_acog";
level.ws[ "g3_acog_mp" ] = "scr_ws_g3_acog";
level.ws[ "g36c_acog_mp" ] = "scr_ws_g36c_acog";
level.ws[ "m14_acog_mp" ] = "scr_ws_m14_acog";

// Special Ops class weapons
level.ws[ "mp5_acog_mp" ] = "scr_ws_mp5_acog";
level.ws[ "skorpion_acog_mp" ] = "scr_ws_skorpion_acog";
level.ws[ "uzi_acog_mp" ] = "scr_ws_uzi_acog";
level.ws[ "ak74u_acog_mp" ] = "scr_ws_ak74u_acog";
level.ws[ "p90_acog_mp" ] = "scr_ws_p90_acog";

// Heavy gunner class weapons
level.ws[ "saw_acog_mp" ] = "scr_ws_saw_acog";
level.ws[ "rpd_acog_mp" ] = "scr_ws_saw_acog";
level.ws[ "m60e4_acog_mp" ] = "scr_ws_m60e4_acog";

// Sniper class weapons
level.ws[ "dragunov_acog_mp" ] = "scr_ws_dragunov_acog";
level.ws[ "dragunov_mp" ] = "scr_ws_dragunov";

level.ws[ "m40a3_acog_mp" ] = "scr_ws_m40a3_acog";
level.ws[ "m40a3_mp" ] = "scr_ws_m40a3";

level.ws[ "barrett_acog_mp" ] = "scr_ws_barrett_acog";
level.ws[ "barrett_mp" ] = "scr_ws_barrett";

level.ws[ "remington700_acog_mp" ] = "scr_ws_remington700_acog";
level.ws[ "remington700_mp" ] = "scr_ws_remington700";

level.ws[ "m21_acog_mp" ] = "scr_ws_m21_acog";
level.ws[ "m21_mp" ] = "scr_ws_m21";

return;
}

loadWeaponZoomLevel()
{

// Load all the weapons with their corresponding dvar controlling it
level.wzl = [];

// Assault class weapons
level.wzl[ "m16_acog_mp" ] = "scr_wzl_m16_acog";
level.wzl[ "ak47_acog_mp" ] = "scr_wzl_ak47_acog";
level.wzl[ "m4_acog_mp" ] = "scr_wzl_m4_acog";
level.wzl[ "g3_acog_mp" ] = "scr_wzl_g3_acog";
level.wzl[ "g36c_acog_mp" ] = "scr_wzl_g36c_acog";
level.wzl[ "m14_acog_mp" ] = "scr_wzl_m14_acog";

// Special Ops class weapons
level.wzl[ "mp5_acog_mp" ] = "scr_wzl_mp5_acog";
level.wzl[ "skorpion_acog_mp" ] = "scr_wzl_skorpion_acog";
level.wzl[ "uzi_acog_mp" ] = "scr_wzl_uzi_acog";
level.wzl[ "ak74u_acog_mp" ] = "scr_wzl_ak74u_acog";
level.wzl[ "p90_acog_mp" ] = "scr_wzl_p90_acog";

// Heavy gunner class weapons
level.wzl[ "saw_acog_mp" ] = "scr_wzl_saw_acog";
level.wzl[ "rpd_acog_mp" ] = "scr_wzl_saw_acog";
level.wzl[ "m60e4_acog_mp" ] = "scr_wzl_m60e4_acog";

// Sniper class weapons
level.wzl[ "dragunov_acog_mp" ] = "scr_wzl_dragunov_acog";
level.wzl[ "dragunov_mp" ] = "scr_wzl_dragunov";

level.wzl[ "m40a3_acog_mp" ] = "scr_wzl_m40a3_acog";
level.wzl[ "m40a3_mp" ] = "scr_wzl_m40a3";

level.wzl[ "barrett_acog_mp" ] = "scr_wzl_barrett_acog";
level.wzl[ "barrett_mp" ] = "scr_wzl_barrett";

level.wzl[ "remington700_acog_mp" ] = "scr_wzl_remington700_acog";
level.wzl[ "remington700_mp" ] = "scr_wzl_remington700";

level.wzl[ "m21_acog_mp" ] = "scr_wzl_m21_acog";
level.wzl[ "m21_mp" ] = "scr_wzl_m21";

return;
}


AfterSpawn()
{
	self.maxhealth = self.health;
   if(!isdefined(self.bIsBot))
	{
//		self thread whoami();
		self thread  noBunny();
	}
    self thread  scopeRangeFinder();
    //self thread  ballisticCalc();
	if( getDvarfloat( "scr_xpboost" ) == 1 )
		{
			thread maps\mp\gametypes\_xpboost::init();
		}
	self thread bulletwatcher();
	self thread LaserSight();
	self thread SpawnProtection();
	self thread Hints();
	self thread initGui();
	if (level.teamBased==1) {
	self thread Medic();
	self thread MedicGUI();
	}
	self thread HealthGUI();
	if (getDvarfloat( "scr_test" ) == 1) {
		self thread test();
		
	}
	
}

Hints()
{
	level waittill("prematch_over");
	if (level.teamBased==1) {
		self IPrintLnBold("You can heal teammates by approaching them and holding Use Button");
		wait(1);
	}
	self IPrintLnBold("Approach an enemy from behind to score one-hit melee kill");
	
}


initGui()
{
if (!level.hardcoreMode) {
	
	
	//init of health bar background
	self.notifyMessage = newClientHudElem(self);
	self.notifyMessage.foreground = true;
	self.notifyMessage.hideWhenInMenu = true;
	self.notifyMessage.alignX = "center";
	self.notifyMessage.alignY = "middle";
	self.notifyMessage.horzAlign = "center";
	self.notifyMessage.vertAlign = "middle";
	self.notifyMessage.alpha = 0;
	self.notifyMessage.sort = 2;
	self.notifyMessage.color = (1,1,1);
	self.notifyMessage.x = 0;
	self.notifyMessage.y = 0;
	
if (level.teamBased==1) {
	
	if ( !isDefined( self.HealthIconFriendly ) )
	{
		//init of health icon
		self.HealthIconFriendly = newClientHudElem(self);
		self.HealthIconFriendly.foreground = true;
		self.HealthIconFriendly.hideWhenInMenu = true;
		self.HealthIconFriendly.alignX = "center";
		self.HealthIconFriendly.alignY = "middle";
		self.HealthIconFriendly.horzAlign = "center";
		self.HealthIconFriendly.vertAlign = "bottom";
		self.HealthIconFriendly setshader ( "hint_health", 30, 30 );
		self.HealthIconFriendly.alpha = 0;
		self.HealthIconFriendly.color = (1,1,0);
		self.HealthIconFriendly.x = 0;
		self.HealthIconFriendly.y = -80;
	}

}
	
	while (self.protected || !ismoving(self)) {
			wait(0.1);
		}

	

	if ( !isDefined( self.HealthIcon ) )
	{
		//init of health icon
		self.HealthIcon = newClientHudElem(self);
		self.HealthIcon.foreground = true;
		self.HealthIcon.hideWhenInMenu = true;
		self.HealthIcon.alignX = "center";
		self.HealthIcon.alignY = "middle";
		self.HealthIcon.horzAlign = "left";
		self.HealthIcon.vertAlign = "bottom";
		self.HealthIcon setshader ( "hint_health", 40, 40 );
		self.HealthIcon.alpha = 1;
		self.HealthIcon.color = (1,1,0);
		self.HealthIcon.x = 240;
		self.HealthIcon.y = -35;
	}
}
}


HealthGUI()
{
	self endon("disconnect");
	self endon( "game_ended" );
	if (!level.hardcoreMode) {
		while (self.protected || !ismoving(self)) {
			wait(0.1);
		}
		self.oldhealth = 0;
		while (isAlive(self)) {
				//Health watcher- health can't be larger then maxhealth
			if (self.health >= self.maxhealth) {
				self.health = self.maxhealth;
			}
			if (self.oldhealth != self.health) {
				healthBarLength = 96 * self.health/self.maxhealth;
				healthProcent = self.health/self.maxhealth*100;
				if (isDefined(self.HealthIcon)) {
					self.HealthIcon.alpha = 1;
					self.HealthIcon.color = (1,healthProcent/100,0);
				}

			}
				self.oldhealth = self.health;
				wait(0.1);
			}

		if ( isDefined( self.HealthIcon ) )
		{
			self.HealthIcon.alpha = 0;
		}
		
	}
}


Medic()
{
		maxhealth = self.maxhealth;
		healthToAdd = maxhealth/5;
		while(isAlive(self))
		{
			PlayerToHeal = self getPlayerToHeal();
			if (isDefined(PlayerToHeal) && PlayerToHeal.team == self.team && PlayerToHeal.health < maxhealth && self UseButtonPressed() && distance(self.origin,PlayerToHeal.origin)< 80)
			{
				if (isDefined(self) && isAlive(self)) {
					self disableWeapons();
				}
				//self maps\mp\gametypes\_hud_message::hintMessage( "Healing" );
				while(isDefined(self) && isDefined(PlayerToHeal) && isAlive(PlayerToHeal) && isAlive(self) && self UseButtonPressed() && distance(self.origin,PlayerToHeal.origin)< 60 && PlayerToHeal.health < maxhealth && PlayerToHeal != self && self islookingat(PlayerToHeal))
				{
					PlayerToHeal.health = PlayerToHeal.health + int(healthToAdd);
			
					self thread maps\mp\gametypes\_rank::giveRankXP( "assist", 1 );
					self.pers["score"] += 1;
					self.score = self.pers["score"];
					self notify ( "update_playerscore_hud" );
				
					if (PlayerToHeal.health >= maxhealth) {
						PlayerToHeal.health = maxhealth;
						break;
					}
					wait(0.4);
				}
				if (isDefined(self) && isAlive(self)) {
					self enableWeapons();
				}
			}
			wait(0.1);
		}
}

MedicGUI()
{
	self endon("disconnect");
	self endon( "game_ended" );
	if (level.teamBased == 1 && !level.hardcoreMode) {
		while (self.protected || !ismoving(self)) {
			wait(0.1);
		}

		while (isalive(self)) {
			friendlyOldHealth = 0;
			PlayerToHeal = getPlayerToHeal();
			while (isDefined(PlayerToHeal) && !PlayerToHeal.protected && !self.protected && PlayerToHeal.team == self.team) {
				
				if (self.HealthIconFriendly.alpha != 1) {
					self.HealthIconFriendly.alpha = 1;
				}
				
				
				if (friendlyOldHealth != PlayerToHeal.health) {
					
					healthBarLengthFriendly = 96 * PlayerToHeal.health/PlayerToHeal.maxhealth;
					healthProcentFriendly = PlayerToHeal.health/PlayerToHeal.maxhealth*100;
					
					if (isDefined(self.HealthIconFriendly)) {
						self.HealthIconFriendly.alpha = 1;
						self.HealthIconFriendly.color = (1,healthProcentFriendly/100,0);
					}
					
				}
				
				friendlyOldHealth = PlayerToHeal.health;
				PlayerToHeal = getPlayerToHeal();
				wait(0.1);
			}
			if (isDefined(self.HealthIconFriendly) && self.HealthIconFriendly.alpha != 0) {
				self.HealthIconFriendly.alpha = 0;
			}
			
			wait(0.1);
		}
		if (isDefined(self.HealthIconFriendly) && self.HealthIconFriendly.alpha != 0) {
			self.HealthIconFriendly.alpha = 0;
		}
		
	}
}

getPlayerToHeal()
{
	PlayerToHeal = isLookingAtEntity();
	return PlayerToHeal;
}

isLookingAtEntity()
{
	position = self getPlayerEyes();
	tracervector = vectorscale(anglesToForward( self.angles ), 200);
	endposition = position + tracervector;
	visualTracer = bullettrace(position,endposition,true,self);
	if (isDefined(visualTracer["entity"]) && isPlayer(visualTracer["entity"])) {
		return visualTracer["entity"];
	}
	else
	{
		return undefined;
	}
}

SpawnProtection()
{
	self endon("disconnect");
	self endon( "game_ended" );
	if ( isDefined( self.SpawnProtection ) )
	{
		self.SpawnProtection destroy();
	}
	spawnorigin = self.origin;
	timer = 0;
	oldhealth = self.health;
	
		if ( isDefined( self.SpawnProtection ) )
		{
			self.SpawnProtection destroy();
		}
		self.SpawnProtection = 10;
		self.SpawnProtection = newClientHudElem(self);
		self.SpawnProtection.alpha = 1;
		self.SpawnProtection.fontScale = 1.4;
		self.SpawnProtection.font = "objective";
		self.SpawnProtection.foreground = 1;
		self.SpawnProtection.archived = true;
		self.SpawnProtection.hideWhenInMenu = true;
		self.SpawnProtection.alignX = "center";
		self.SpawnProtection.alignY = "middle";
		self.SpawnProtection.horzAlign = "center";
		self.SpawnProtection.vertAlign = "bottom";
		self.SpawnProtection.x = 0;
		self.SpawnProtection.y = -85;
		self.oldProtected = false;
	while (isAlive(self) && timer <= 3 && distance (spawnorigin,self.origin) <=80) {
		self.health = 1000;
		self.protected = true;
		if (self.oldProtected != self.protected ) {
			self.SpawnProtection.color = (0,1,0);
			self.SpawnProtection  setText ("Spawn Protection") ;
		}
		
		timer +=0.1;
		wait 0.5;
	}
	self.protected = false;
	if ( isDefined( self.SpawnProtection ) )
	{
		self.SpawnProtection destroy();
	}
	self.health = oldhealth;
}


test()
{
	while(isAlive(self))
	{
		if (self UseButtonPressed())
		{
			self thread hitscanBullet(self GetPlayerAngles(),self getPlayerEyes());
		}
		wait(WeaponFireTime(self GetCurrentWeapon()));
	}
}

hitscanBullet(angles,startposition)
{
	peneteffect = loadfx("impacts/20mm_default_impact");
	timescale = 0.015;
	timer = 0;
	bulletSpeed = 10000;
	newangles = angles;
	destScale = 0;
	tracerlength = bulletSpeed * timescale;
	tracervector = vectorscale(anglesToForward( newangles ), tracerlength);
	oldorigin = startposition;
	while (true) {
		gravity = 385 * timer*timer;
		timer +=timescale;
		neworigin = oldorigin + tracervector - (0,0,gravity);
		if (!BulletTracePassed(oldorigin,neworigin,true,self)) {
			break;
		}
		playfx(peneteffect,oldorigin,anglestoforward(newangles));
		oldorigin = neworigin;
		wait(timescale);
	}
	hitTracer = BulletTrace(oldorigin,neworigin,true,undefined);
	
	playfx(peneteffect,hitTracer["position"],anglestoforward(VectorToangles(hitTracer["normal"])));
	
	
}

bulletSpawn(origin, angle, speed, owner, damage, penetration, model, effect, tracerprob, lifetime)
{
						
					    vect = vectorscale( anglestoforward( angle ), 50 );
						trace = origin + vect;						
						
						bullet = spawn( "script_model", trace, 3 );
						bullet setmodel( model );
						bullet Solid();
						muzzlevelocity = vectorscale( anglestoforward( angle ), speed );
						bullet MoveGravity( muzzlevelocity, lifetime );
						bullet.damage = damage;
						bullet.angles=angle;
						bullet.owner = owner;
						bullet.penetration = penetration;
						IPrintLn("bullet.origin --"+ bullet.origin);
						thread projControl(bullet);
						wait (lifetime);
						bullet delete();
						
						
}


bulletwatcher()
{
	player=self;
	while(isAlive(self))
	{
		self waittill("weapon_fired");
		bullet = GetEntArray( "grenade","classname" );
		for(i=0;i<bullet.size;i++)
		{
			if (!isDefined(bullet[i].owner)) {
				bullet[i].owner = getowner(bullet[i]);
			}
			
			if(isdefined(bullet[i]) && bullet[i].model=="projectile_tag" && isDefined(bullet[i].owner) &&  bullet[i].owner == self)
			{
				if(!isDefined(bullet[i].timeout))
				{
					if (isdefined(self))
					{
						if( self hasPerk("specialty_bulletpenetration") && ! maps\mp\gametypes\_weapons::isPistol(self GetCurrentWeapon()) || self GetCurrentWeapon()=="barrett_acog_mp" || self GetCurrentWeapon()=="barrett_mp")
						{
							bullet[i].penetration = 1;
						}
						else
						{
							bullet[i].penetration = 0;
						}
					}
					if(isDefined(self) && isDefined(level.weapon[ self getCurrentWeapon() ]["damage"]))
					{
						bullet[i].damage = level.weapon[ self getCurrentWeapon() ]["damage"];
					}
					bullet[i].pointoforigin = self.origin;
					bullet[i].weaponoforigin = self getCurrentWeapon();
					bullet[i].timeout = 1;
					thread projControl(bullet[i]);
					thread deleteProjectile(bullet[i], bullet[i].timeout);
				}
			}
		}
		wait(0.00001);
	}
}

projControl(entity)
{
	if (!isDefined(entity.owner)) {//double check for bullet owner
		entity.owner = getowner(entity);
	}
	finalBulletDamage=0;
	oldangles=entity.angles;
	prevorigin = entity.origin;
	TraceEndPosition=(0,0,0);
	TraceVector = vectorscale( anglestoforward( oldangles ), 40 ); //vector 40 inches forward
	while(1)
	{
		wait .015;
		if (isDefined(entity)){
			TraceEndPosition = entity.origin + TraceVector;
			PhysicsExplosionSphere( entity.origin, 10, 8, 1 );
			if(!BulletTracePassed(entity.origin, TraceEndPosition, true, undefined )){
				prevorigin = entity.origin;
				break;
			}
		}
	}
	//make tracer forward from projectile origin
	TracerBackOrigin = prevorigin;	//stopped projectile origin
	TracerBackAngles = oldangles;	//projectile angles
	VectorBack = vectorscale( anglestoforward( TracerBackAngles ), 40 ); //vector 2 inches forward
	BackTracer = TracerBackOrigin + VectorBack;
	TracerForward = BulletTrace( TracerBackOrigin, BackTracer, true, undefined );

	if (isDefined(TracerForward["entity"]) && TracerForward["entity"].classname == "script_vehicle") {
		if (isDefined(entity.weaponoforigin) && (entity.weaponoforigin == "barrett_mp" || entity.weaponoforigin == "barrett_acog_mp")) {//Barrett will damage heli
			self DoPenetration(entity,TracerForward, TracerBackAngles, 400);
		}
	}
	else
	{
		//if is defined penetration then do penetration calculation
		if(isdefined(entity.penetration) && entity.penetration==1)
		{
			if (entity.weaponoforigin != "rpg_mp") {
				self DoPenetration(entity,TracerForward, TracerBackAngles, 400);
			}
			
		
		}
		else
		{
			if (entity.weaponoforigin != "rpg_mp") {
				self DoPenetration(entity,TracerForward, TracerBackAngles, 80);
			}
			
		}
	
		if (isDefined(entity.weaponoforigin) && entity.weaponoforigin == "rpg_mp") {//RPG do damage through walls
			self ExplodeThroughWall(entity,TracerForward, TracerBackAngles);
		}
		if (isDefined(entity.owner.classname) && entity.owner.classname == "script_vehicle") {//Heli's gun will shoot through walls NOT WORKING
			self ExplodeThroughWall(entity,TracerForward, TracerBackAngles);
		}
	}
	while (isDefined(entity) && ismoving(entity)) {
		wait(0.01);
	}
	if(isDefined(entity)) {
		entity Delete();
	}
	
}

ExplodeThroughWall(entity,TracerForward, angles)
{
	explodeeffect = loadfx("explosions/grenadeexp_default");
	traceorg = TracerForward["position"];
	angle = angles;
	vect = vectorscale( anglestoforward( angle ), 40 );
	trace = traceorg + vect;
	//if hit position is player then do tracer behind player so there will be no double damage effect, if not - do normal penetration calculation
	if (isDefined(TracerForward["entity"])) { //Check for entity hit
		Btrace= BulletTrace( trace, traceorg, true, undefined );
		
	}
	else
	{
		Btrace= BulletTrace( trace, traceorg, false, undefined );
		playfx(explodeeffect,Btrace["position"],anglestoforward( angle ));
		//playfx(ricochet,Btrace["position"],anglestoforward( angle ));
	}
	RadiusDamage( Btrace["position"], 300, entity.damage, entity.damage/4, entity.owner);
}

DoPenetration(entity,TracerForward, angles, PenetrationDistance)
{
	peneteffect = loadfx("impacts/20mm_default_impact");
	ricochet = loadfx("tracers/ricochet");
	traceorg = TracerForward["position"];
	angle = angles;
	vect = vectorscale( anglestoforward( angle ), 40 );
	trace = traceorg + vect;
	//if hit position is player then do tracer behind player so there will be no double damage effect, if not - do normal penetration calculation
	if (isDefined(TracerForward["entity"])) { //Check for entity hit
		Btrace= BulletTrace( trace, traceorg, true, undefined );
		
	}
	else
	{
		Btrace= BulletTrace( trace, traceorg, false, undefined );
		playfx(peneteffect,Btrace["position"],anglestoforward( angle ));
		//playfx(ricochet,Btrace["position"],anglestoforward( angle ));
	}
	
	rangeMod = getDvarfloat( level.wdr[ entity.weaponoforigin ] );
	targetDist = distance(entity.origin, entity.owner getPlayerEyes())* 0.0254;
	entity.damage = entity.damage/(1+rangeMod*targetDist);
	//self IPrintLn(entity.damage);
	finalBulletDamage = entity.damage - distance(traceorg, Btrace["position"] );
	if (finalBulletDamage>=0)  {
		vectafter = vectorscale( anglestoforward( angle ), PenetrationDistance );
		traceafter = Btrace["position"] + vectafter;
		Btraceafter= BulletTrace( Btrace["position"], traceafter, true, undefined );
		if ( isDefined(Btraceafter["entity"])) {
			RadiusDamage( Btraceafter["entity"].origin, 40, finalBulletDamage, finalBulletDamage, entity.owner);
		}
		/*
		 else
		 {
		 playfx(peneteffect,Btraceafter["position"],anglestoforward(vectortoangles( Btraceafter[ "normal" ] )));
		 }
		 */
		
	}
}

getowner(bullet)
{
	vect = vectorscale( anglestoforward( bullet.angles ), 800 );
	trace = bullet.origin - vect;
	Btrace= BulletTrace( bullet.origin, trace, true, undefined );
	if (isDefined(Btrace["entity"]))
	{
		return Btrace["entity"];
	}
	else
	{
		return undefined;
	}
}

ismoving(entity)
{
	oldorigin=[];
	if (isDefined(entity)) {
		oldorigin=entity.origin;
	}
	
	wait(0.015);
	if (isDefined(entity)) {
		if(entity.origin==oldorigin)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
}


LaserSight()
{
	self setClientDvars("cg_laserRadius",0.2, "cg_laserRangePlayer", 100,"cg_laserRange", 100);
	while(isAlive(self))
	{
		CurrWeap = self GetCurrentWeapon();
		if( CurrWeap !="rpg_mp" && self hasPerk("specialty_bulletaccuracy") && !self playerADS())
		{
			self setClientDvars("cg_laserforceon",1, "cg_laserlight", 0, "cg_drawCrosshair", 1);
			
		}
		else
		{
			self setClientDvars("cg_laserforceon",0, "cg_laserlight", 0, "cg_drawCrosshair", 0);
		}
	wait(0.1);
	}
	self setClientDvars("cg_laserforceon",0, "cg_laserlight", 0);
}
laserDot()
{
	laserDot=loadfx("tracers/laserdot");
	while (isAlive(self)) {
		laserDotPosition = rangeFinder();
		playfx(laserDot,laserDotPosition["position"],vectortoangles( laserDotPosition[ "normal" ] ));
		wait(0.1);
	}
}
drawCrosshair()
{
	crossHair = newHudElem();
//	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.horzAlign = "fullscreen";
    crossHair.vertAlign = "fullscreen";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 0;
	crossHair.x = 0;
	crossHair.y = 0;
	crossHair setText("+");
	return crossHair;
}

getPlayerEyes()
{
    playerEyes = self.origin;
    switch ( self getStance() ) {
    case "prone":
        playerEyes += (0,0,11);
    break;
    case "crouch":
        playerEyes += (0,0,40);
    break;
    case "stand":
        playerEyes += (0,0,60);
    break;
}

return playerEyes;	
}
rangeFinder()
{

    maxdist = 5000000;

        wait(0.1);
        traceorg = self getPlayerEyes();
        angle = self getplayerangles();
        vect = vectorscale( anglestoforward( angle ), maxdist );
        trace = bullettrace( traceorg, traceorg + vect, 0, self );
        //target coordinates
        self.traceHitPosition = trace["position"];
		self.traceHitEntity = trace["entity"];
        Dist = int( distance(traceorg, trace["position"] ) )*0.0254;
        //Distance between player and "target"
        self.rangeFinder = Dist;
        return trace;
}

scopeRangeFinder()
{ 
    if ( isDefined( self.scopeRangeFinder ) )
    {
		self.scopeRangeFinder destroy();
    }    
    self.rangeFinder = 10;
    self.scopeRangeFinder = newClientHudElem(self);
    self.scopeRangeFinder.alpha = 0;
    self.scopeRangeFinder.fontScale = 1.4;
    self.scopeRangeFinder.color = (0,1,0);
    self.scopeRangeFinder.font = "objective";
    self.scopeRangeFinder.archived = true;
    self.scopeRangeFinder.hideWhenInMenu = false;
    self.scopeRangeFinder.alignX = "center";
    self.scopeRangeFinder.alignY = "top";
    self.scopeRangeFinder.horzAlign = "center";
    self.scopeRangeFinder.vertAlign = "top";
    self.scopeRangeFinder.x = 0;
    self.scopeRangeFinder.y = 50;
    while(isAlive(self))
    {
        wait(0.05);
        while((maps\mp\gametypes\_weapons::hasScope( self GetCurrentWeapon() )) && self playerADS() )
        {   
            wait(0.05);
            rangeFinder();
            self.scopeRangeFinder.alpha = 1;
            self.scopeRangeFinder setValue( int( self.rangeFinder) );
        }
        self.scopeRangeFinder.alpha = 0;
    }
    if ( isDefined( self.scopeRangeFinder ) )
    {
		self.scopeRangeFinder destroy();
    } 
}

ballisticCalc()
{
    if ( isDefined( self.ballisticCalc ) )
    {
		self.ballisticCalc destroy();
    }
    self.rangeFinder = 10;
    self.ballisticCalc = newClientHudElem(self);
    self.ballisticCalc.alpha = 0;
    self.ballisticCalc.fontScale = 1.4;
    self.ballisticCalc.color = (1,0,0);
    self.ballisticCalc.font = "objective";
    self.ballisticCalc.archived = true;
    self.ballisticCalc.hideWhenInMenu = false;
    self.ballisticCalc.alignX = "center";
    self.ballisticCalc.alignY = "middle";
    self.ballisticCalc.horzAlign = "center";
    self.ballisticCalc.vertAlign = "middle";
    self.ballisticCalc.x = 0;
    //self.ballisticCalc.y = 50; 
    while(isAlive(self))
    {
        if( (self AdsButtonPressed() ) && (self UseButtonPressed()) && (maps\mp\gametypes\_weapons::hasScope( self GetCurrentWeapon() )) )
        {
	    bulletSpeed = 0.0254*getDvarfloat( level.ws[ self getCurrentWeapon() ] ); 
            timeToTarget = self.rangeFinder/bulletSpeed;
            bulletdrop = getDvarFloat( "scr_ballcalccoef" )*9.8*timeToTarget*timeToTarget/getDvarfloat( level.wzl[ self getCurrentWeapon() ] );
            self.ballisticCalc.y = bulletdrop ;
            self.ballisticCalc  setText ("- -") ;
            wait(2);
            self.ballisticCalc.alpha = 1;
            while ((self AdsButtonPressed() ))
            {
            wait (0.1);
            }
            self.ballisticCalc.alpha = 0;
        }
        self.ballisticCalc.alpha = 0;
    wait(0.5);
    }
    if ( isDefined( self.ballisticCalc ) )
    {
		self.ballisticCalc destroy();
    } 

}

weaponInteraction(sWeapon)
{
    self endon("disconnect");
   self endon( "game_ended" );
    self.rangeFinder = 0;
    weaponLength = 1;
    weaponLength = getDvarfloat( level.wl[ sWeapon ] );
    self.weaponEnabled = 1;
    for(;;)
    {
       // weaponLength = getDvarfloat( level.wl[ sWeapon ] );
        wait (0.1);
        if( (self.rangeFinder <= weaponLength && self.weaponEnabled == 1) )
        {
            self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
            self.weaponEnabled = 0;
        }
        else if( (self.rangeFinder >= weaponLength && self.weaponEnabled == 0) )
        {
            self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
            self.weaponEnabled = 1;
        }
    }
}
noBunny()
{
    while(isAlive(self))
    {
        if( self UseButtonPressed() )
        {
            self AllowJump(false);
            while(self UseButtonPressed())
            {
                wait(0.1);
            }
            self AllowJump(true);
        }
        if(!( self isOnGround() ))
        {
            wait(0.15);
            if(!( self isOnGround() ))
            {
                self disableWeapons();
                while(!( self isOnGround()) )
                {
                    wait(0.1);
                }
                
                self enableWeapons();
            }
        }
        wait (0.1);
    }
    self enableWeapons();

}


whoami()
{
	Curr_weapon = self GetCurrentWeapon();
	if(isSubStr( Curr_weapon, "m16_" ) || isSubStr( Curr_weapon, "ak47_" ) || isSubStr( Curr_weapon, "m4_" ) || isSubStr( Curr_weapon, "g3_" ) || isSubStr( Curr_weapon, "g36c_" ) || isSubStr( Curr_weapon, "m14_" ) || isSubStr( Curr_weapon, "mp44_" ))
	{
		self.pers["class"]="assault";
	}
	if(isSubStr( Curr_weapon, "mp5_" ) || isSubStr( Curr_weapon, "skorpion_" ) || isSubStr( Curr_weapon, "uzi_" ) || isSubStr( Curr_weapon, "ak74u_" ) || isSubStr( Curr_weapon, "p90_" ))
	{
		self.pers["class"]="specops";
	}

	if(isSubStr( Curr_weapon, "saw_" ) || isSubStr( Curr_weapon, "rpd_" ) || isSubStr( Curr_weapon, "m60e4_" ))
	{
		self.pers["class"]="heavygunner";
	}

	if(isSubStr( Curr_weapon, "dragunov_" ) || isSubStr( Curr_weapon, "m40a3_" ) || isSubStr( Curr_weapon, "barrett_" ) || isSubStr( Curr_weapon, "remington700_" ) || isSubStr( Curr_weapon, "m21_" ))
	{
		self.pers["class"]="sniper";
	}

	if(isSubStr( Curr_weapon, "m1014_" ) || isSubStr( Curr_weapon, "winchester1200_" ))
	{
		self.pers["class"]="demolitions";
	}


	self skillPerClass();
	
}

isSniper(entity)
{
	Curr_weapon = entity GetCurrentWeapon();
	if(Curr_weapon=="dragunov_mp" || Curr_weapon=="dragunov_acog_mp" || Curr_weapon=="m40a3_mp" || Curr_weapon=="m40a3_acog_mp" ||Curr_weapon=="barrett_mp" || Curr_weapon=="barrett_acog_mp" || Curr_weapon=="remington700_mp" || Curr_weapon=="remington700_acog_mp" || Curr_weapon == "m21_mp" ||  Curr_weapon == "m21_acog_mp" )
	{
		return true;	
	}
	else
	{
		return false;
	}
}

isAssault(entity)
{
	if(entity.pers["class"]=="assault")
	{
		return true;	
	}
	else
	{
		return false;
	}
}

WhoNeedsMedic()
{
	while(isAlive(self))
	{
		players = getEntArray( "player", "classname" );
		for(p=0;p<players.size;p++)
      		{
				if(isdefined(players[p]) && isDefined(self.team) && isDefined(players[p].team) && self.team == players[p].team && players[p] != self && level.teamBased==1)
					{
						players[p] thread INeedAMedic(players[p]);
					}
				wait(0.1);
			}
			
		
		wait(0.1);
	}
}

INeedAMedic(entity)
{
	
	while(isAlive(entity))
	{
		Print3d( entity gettagorigin("head"), "HEALTH:"+ entity.health + "%", (0, 1, 0), 1, 0.5 );
		wait(0.02);
	}

}

callformedic()
{
	if ( !level.teambased )
		return;
	team=self.team;
	iconOrg = self.origin;
	
	assert(team == "allies" || team == "axis");
	
	if ( getDvar( "ui_hud_showdeathicons" ) == "0" )
		return;
	if ( level.hardcoreMode )
		return;
	
	if ( isdefined( self.lastDeathIcon ) )
		self.lastDeathIcon destroy();
	
	newdeathicon = newTeamHudElem( team );
	newdeathicon.x = iconOrg[0];
	newdeathicon.y = iconOrg[1];
	newdeathicon.z = iconOrg[2] + 54;
	newdeathicon.alpha = .61;
	newdeathicon.archived = true;
	newdeathicon setShader(game["entity_headicon_" + team], 10, 10);
	newdeathicon setwaypoint(true);
	newdeathicon destroy();
	self.lastDeathIcon = newdeathicon;

	return;
}

skillPerClass()
{

    switch ( self.pers["class"] )
	{
		case "assault":
			self thread WhoNeedsMedic();
			
			while(isAlive(self))
			{
				self.TargetPlayer=undefined;
				self.TargetPlayer = isLookingAtClosestPlayer();
				if ( level.teamBased )
				{
					if(isDefined(self.TargetPlayer) && self.TargetPlayer.health < self.maxhealth )
					{
						if( self UseButtonPressed() )
						{
							self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
							//Healing
							while(isAlive(self) && isAlive(self.TargetPlayer) && self UseButtonPressed() && self.TargetPlayer.health <= self.maxhealth && int( distance(self.origin, self.TargetPlayer.origin ) )*0.0254 <= 2 )
							{
								self.TargetPlayer.health += 10;
								self thread maps\mp\gametypes\_rank::giveRankXP( "assist", 1 );
								self.pers["score"] += 1;
								self.score = self.pers["score"];
								self notify ( "update_playerscore_hud" );
								if( self.TargetPlayer.health >= self.maxhealth )
								{
									self.TargetPlayer.health = self.maxhealth;
								}
								wait (1);
							}
							self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
						
						}
					}
					wait (0.1);
				}
			}
			break;
		case "specops":
			break;
		case "heavygunner":
			break;
		case "demolitions":
			break;
		case "sniper":
			while(isAlive(self))
			{	if(self playerADS() && self UseButtonPressed())
				{
					players = getEntArray( "player", "classname" );
					for(p=0;p<players.size;p++)
					{
						if(isdefined(players[p]) && isDefined(self.team) && isDefined(players[p].team) && self.team != players[p].team && self islookingat(players[p]) && bulletTracePassed( self getPlayerEyes(), players[p] getPlayerEyes(), false, self ) && isSniper(self) && level.teamBased)
						{
							self thread waitForReward(players[p]);
							players[p].spoted = 1;
							self thread enemySpoted(players[p]);
						}
					wait(0.1);

					}
				}
				wait(0.1);
			}
			break;
	}
}

waitForReward(enemy)
{
	if(!isdefined(enemy.spoted))
	{
		for(time=0;time<5;time+=0.02)
		{
			if(!isAlive(enemy))
			{
				self thread maps\mp\gametypes\_rank::giveRankXP( "assist", 2 );
				self.pers["score"] += 2;
				self.score = self.pers["score"];
				self notify ( "update_playerscore_hud" );
				return;
			}
			wait(0.02);
		}
		enemy.spoted = undefined;
	}
}
enemySpoted(enemy)
{
	players = getEntArray( "player", "classname" );
	for(p=0;p<players.size;p++)
	{
		if(isdefined(players[p]) && isDefined(self.team) && isDefined(players[p].team) && self.team == players[p].team && level.teamBased == 1)
		{
			players[p] thread showEnemy(enemy); 
		}
	wait(0.1);
	}
}

showEnemy(enemy)
{
	for(time=0;time<5;time+=0.02)
	{
		if(isAlive(enemy) && isdefined(enemy) && isAlive(self))
		{
			
			Print3d( enemy gettagorigin("head"), "ENEMY", (1, 0, 0), 1, 0.5 );
			wait(0.02);
		}
		else
		{
			break;
		}
	}
}

isLookingAtClosestPlayer(distance)
{
	TargetPlayer=undefined;
	players = getEntArray( "player", "classname" );
	for(p=0;p<players.size;p++)
      	{
		self.DistToPlayer= int( distance(self.origin, players[p].origin ) )*0.0254;
		if( self.DistToPlayer <= distance && self IsLookingAt( players[p] ))
		{
			TargetPlayer = players[p];
			break;
		}	
	}
	return TargetPlayer;
}

IsLookingAt( gameEntity )
{
        entityPos = gameEntity.origin;
	if(isPlayer(self))  
	{      
		playerPos = self getEye();
	}
	else
	{
		playerPos = self.origin;
	}

        entityPosAngles = vectorToAngles( entityPos - playerPos );
        entityPosForward = anglesToForward( entityPosAngles );
	
	if(isPlayer(self))  
	{      
		playerPosAngles = self getPlayerAngles();
	}
	else
	{
		playerPosAngles = self.angles;
	}
	
        playerPosForward = anglesToForward( playerPosAngles );

        newDot = vectorDot( entityPosForward, playerPosForward );

        if ( newDot < 0.72 ) {
                return false;
        } else {
                return true;
        }

}

levelcleanup()
{
    //endon("disconnect");
    level endon( "game_ended" );
    for(;;)
    {
        grenades = GetEntArray( "grenade","classname" );
            for(i=0;i<grenades.size;i++)
            {
            if(grenades[i].model=="projectile_tag")
            {
				if (!isDefined(grenades[i].owner)) {//double check for bullet owner
					grenades[i].owner = getowner(grenades[i]);
				}
                if(!isDefined(grenades[i].timeout))
                {
                    grenades[i].timeout=1;
                    thread deleteProjectile(grenades[i], grenades[i].timeout);
                }
            }
            }
        wait (0.001);
    }
}
deleteProjectile(entityname, timeout)
{
    wait(timeout);
    if(isdefined(entityname))
    {
        entityname Delete();
    }
}


getfxarraybyID( fxid )
{
	array = [];
	for( i = 0;i < level.createFXent.size;i ++ )
	{
		if( level.createFXent[ i ].v[ "fxid" ] == fxid )
			array[ array.size ] = level.createFXent[ i ];
	}
	return array;
}

