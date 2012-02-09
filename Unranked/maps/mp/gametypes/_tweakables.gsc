#include maps\mp\_utility;

getTweakableDVarValue( category, name )
{
	switch( category )
	{
		case "rule":
			dVar = level.rules[name].dVar;
			break;
		case "game":
			dVar = level.gameTweaks[name].dVar;
			break;
		case "team":
			dVar = level.teamTweaks[name].dVar;
			break;
		case "player":
			dVar = level.playerTweaks[name].dVar;
			break;
		case "class":
			dVar = level.classTweaks[name].dVar;
			break;
		case "weapon":
			dVar = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			dVar = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			dVar = level.hudTweaks[name].dVar;
			break;
		default:
			dVar = undefined;
			break;
	}
	
	assert( isDefined( dVar ) );
	
	value = getDvarInt( dVar );
	
	return value;
}


getTweakableDVar( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].dVar;
			break;
		case "game":
			value = level.gameTweaks[name].dVar;
			break;
		case "team":
			value = level.teamTweaks[name].dVar;
			break;
		case "player":
			value = level.playerTweaks[name].dVar;
			break;
		case "class":
			value = level.classTweaks[name].dVar;
			break;
		case "weapon":
			value = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			value = level.hudTweaks[name].dVar;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


getTweakableValue( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].value;
			break;
		case "game":
			value = level.gameTweaks[name].value;
			break;
		case "team":
			value = level.teamTweaks[name].value;
			break;
		case "player":
			value = level.playerTweaks[name].value;
			break;
		case "class":
			value = level.classTweaks[name].value;
			break;
		case "weapon":
			value = level.weaponTweaks[name].value;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].value;
			break;
		case "hud":
			value = level.hudTweaks[name].value;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


getTweakableLastValue( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].lastValue;
			break;
		case "game":
			value = level.gameTweaks[name].lastValue;
			break;
		case "team":
			value = level.teamTweaks[name].lastValue;
			break;
		case "player":
			value = level.playerTweaks[name].lastValue;
			break;
		case "class":
			value = level.classTweaks[name].lastValue;
			break;
		case "weapon":
			value = level.weaponTweaks[name].lastValue;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].lastValue;
			break;
		case "hud":
			value = level.hudTweaks[name].lastValue;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


setTweakableValue( category, name, value )
{
	switch( category )
	{
		case "rule":
			dVar = level.rules[name].dVar;
			break;
		case "game":
			dVar = level.gameTweaks[name].dVar;
			break;
		case "team":
			dVar = level.teamTweaks[name].dVar;
			break;
		case "player":
			dVar = level.playerTweaks[name].dVar;
			break;
		case "class":
			dVar = level.classTweaks[name].dVar;
			break;
		case "weapon":
			dVar = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			dVar = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			dVar = level.hudTweaks[name].dVar;
			break;
		default:
			dVar = undefined;
			break;
	}
	
	setDvar( dVar, value );
}


setTweakableLastValue( category, name, value )
{
	switch( category )
	{
		case "rule":
			level.rules[name].lastValue = value;
			break;
		case "game":
			level.gameTweaks[name].lastValue = value;
			break;
		case "team":
			level.teamTweaks[name].lastValue = value;
			break;
		case "player":
			level.playerTweaks[name].lastValue = value;
			break;
		case "class":
			level.classTweaks[name].lastValue = value;
			break;
		case "weapon":
			level.weaponTweaks[name].lastValue = value;
			break;
		case "hardpoint":
			level.hardpointTweaks[name].lastValue = value;
			break;
		case "hud":
			level.hudTweaks[name].lastValue = value;
			break;
		default:
			break;
	}
}


registerTweakable( category, name, dvar, value )
{
	if ( isString( value ) )
	{
		if( getDvar( dvar ) == "" )
			setDvar( dvar, value );
		else
			value = getDvar( dvar );
	}
	else
	{
		if( getDvar( dvar ) == "" )
			setDvar( dvar, value );
		else
			value = getDvarInt( dvar );
	}

	switch( category )
	{
		case "rule":
			if ( !isDefined( level.rules[name] ) )
				level.rules[name] = spawnStruct();				
			level.rules[name].value = value;
			level.rules[name].lastValue = value;
			level.rules[name].dVar = dvar;
			break;
		case "game":
			if ( !isDefined( level.gameTweaks[name] ) )
				level.gameTweaks[name] = spawnStruct();
			level.gameTweaks[name].value = value;
			level.gameTweaks[name].lastValue = value;			
			level.gameTweaks[name].dVar = dvar;
			break;
		case "team":
			if ( !isDefined( level.teamTweaks[name] ) )
				level.teamTweaks[name] = spawnStruct();
			level.teamTweaks[name].value = value;
			level.teamTweaks[name].lastValue = value;			
			level.teamTweaks[name].dVar = dvar;
			break;
		case "player":
			if ( !isDefined( level.playerTweaks[name] ) )
				level.playerTweaks[name] = spawnStruct();
			level.playerTweaks[name].value = value;
			level.playerTweaks[name].lastValue = value;			
			level.playerTweaks[name].dVar = dvar;
			break;
		case "class":
			if ( !isDefined( level.classTweaks[name] ) )
				level.classTweaks[name] = spawnStruct();
			level.classTweaks[name].value = value;
			level.classTweaks[name].lastValue = value;			
			level.classTweaks[name].dVar = dvar;
			break;
		case "weapon":
			if ( !isDefined( level.weaponTweaks[name] ) )
				level.weaponTweaks[name] = spawnStruct();
			level.weaponTweaks[name].value = value;
			level.weaponTweaks[name].lastValue = value;			
			level.weaponTweaks[name].dVar = dvar;
			break;
		case "hardpoint":
			if ( !isDefined( level.hardpointTweaks[name] ) )
				level.hardpointTweaks[name] = spawnStruct();
			level.hardpointTweaks[name].value = value;
			level.hardpointTweaks[name].lastValue = value;			
			level.hardpointTweaks[name].dVar = dvar;
			break;
		case "hud":
			if ( !isDefined( level.hudTweaks[name] ) )
				level.hudTweaks[name] = spawnStruct();
			level.hudTweaks[name].value = value;
			level.hudTweaks[name].lastValue = value;			
			level.hudTweaks[name].dVar = dvar;
			break;
	}
}


init()
{
	level.clientTweakables = [];
	level.tweakablesInitialized = true;

	level.rules = [];
	level.gameTweaks = [];
	level.teamTweaks = [];
	level.playerTweaks = [];
	level.classTweaks = [];
	level.weaponTweaks = [];
	level.hardpointTweaks = [];
	level.hudTweaks = [];
	// commented out tweaks have not yet been implemented
	
	registerTweakable( "game", 			"playerwaittime", 		"scr_game_playerwaittime", 			15 ); //*
	registerTweakable( "game", 			"matchstarttime", 		"scr_game_matchstarttime", 			5 ); //*
	registerTweakable( "game", 			"onlyheadshots", 		"scr_game_onlyheadshots", 			0 ); //*
	registerTweakable( "game", 			"allowkillcam", 		"scr_game_allowkillcam", 			0 ); //*
	registerTweakable( "game", 			"spectatetype", 		"scr_game_spectatetype", 			2 ); //*

	registerTweakable( "game", 			"deathpointloss", 		"scr_game_deathpointloss", 			0 ); //*
	registerTweakable( "game", 			"suicidepointloss", 	"scr_game_suicidepointloss", 		0 ); //*
	registerTweakable( "team", 			"teamkillpointloss", 	"scr_team_teamkillpointloss", 		0 ); //*
	
//	registerTweakable( "team", 			"respawntime", 			"scr_team_respawntime", 			0 );
	registerTweakable( "team", 			"fftype", 				"scr_team_fftype", 					0 ); 
	registerTweakable( "team", 			"teamkillspawndelay", 	"scr_team_teamkillspawndelay", 		0 );
	
//	registerTweakable( "player", 		"respawndelay", 		"scr_player_respawndelay", 			0 ); //*
	registerTweakable( "player", 		"maxhealth", 			"scr_player_maxhealth", 			100 ); //*
	registerTweakable( "player", 		"healthregentime", 		"scr_player_healthregentime", 		5 ); //*
	registerTweakable( "player", 		"forcerespawn", 		"scr_player_forcerespawn", 			1 ); //*

	registerTweakable( "weapon", 	"allowfrag", 		"scr_weapon_allowfrags", 1 );
	registerTweakable( "weapon", 	"allowsmoke", 		"scr_weapon_allowsmoke", 1 );
	registerTweakable( "weapon", 	"allowflash", 		"scr_weapon_allowflash", 1 );
	registerTweakable( "weapon", 	"allowc4", 			"scr_weapon_allowc4", 1 );
	registerTweakable( "weapon", 	"allowclaymores", 	"scr_weapon_allowclaymores", 1 );
	registerTweakable( "weapon", 	"allowrpgs", 		"scr_weapon_allowrpgs", 1 );
	registerTweakable( "weapon", 	"allowmines", 		"scr_weapon_allowmines", 1 );

	registerTweakable( "hardpoint", "allowartillery", 	"scr_hardpoint_allowartillery", 1 );
	registerTweakable( "hardpoint", "allowuav", 		"scr_hardpoint_allowuav", 1 );
	registerTweakable( "hardpoint", "allowsupply", 		"scr_hardpoint_allowsupply", 1 );
	registerTweakable( "hardpoint", "allowhelicopter", 	"scr_hardpoint_allowhelicopter", 1 );
    
	registerTweakable( "hud", 		"showobjicons", 	"ui_hud_showobjicons", 						1 ); //*
	setClientTweakable( "hud", 		"showobjicons" );

	level thread updateUITweakables();
}


setClientTweakable( category, name )
{
	level.clientTweakables[level.clientTweakables.size] = name;
}



updateUITweakables()
{
	for ( ;; )
	{
		for ( index = 0; index < level.clientTweakables.size; index++ )
		{
			clientTweakable = level.clientTweakables[index];
			curValue = getTweakableDVarValue( "hud", clientTweakable );
			lastValue = getTweakableLastValue( "hud", clientTweakable );
			
			if ( curValue != lastValue )
			{
				updateServerDvar( getTweakableDvar( "hud", clientTweakable ), curValue );
				setTweakableLastValue( "hud", clientTweakable, curValue );
			}
		}
			
		wait ( 1.0 );
	}
}


updateServerDvar( dvar, value )
{
	makeDVarServerInfo( dvar, value );
}

wdrModTweaks()
{
	// Assault class weapons
	setDvar( "scr_wdr_m16", 0.00182 );
	setDvar( "scr_wdr_m16_silenced", 0.00182 );
	
	setDvar( "scr_wdr_ak47", 0.00250 );
	setDvar( "scr_wdr_ak47_silenced", 0.00250 );
	
	setDvar( "scr_wdr_m4", 0.00200 );
	setDvar( "scr_wdr_m4_silenced", 0.00200 );
	
	setDvar( "scr_wdr_g3", 0.00200 );
	setDvar( "scr_wdr_g3_silenced", 0.00200 );
	
	setDvar( "scr_wdr_g36c", 0.00200 );
	setDvar( "scr_wdr_g36c_silenced", 0.00200 );
	
	setDvar( "scr_wdr_m14", 0.00200 );
	setDvar( "scr_wdr_m14_silenced", 0.00200 );
	
	setDvar( "scr_wdr_mp44", 0.00333 );
	
	// Special Ops class weapons
	setDvar( "scr_wdr_mp5", 0.00500 );
	setDvar( "scr_wdr_mp5_silenced", 0.00500 );
	
	setDvar( "scr_wdr_skorpion", 0.01000 );
	setDvar( "scr_wdr_skorpion_silenced", 0.01000 );
	
	setDvar( "scr_wdr_uzi", 0.01000 );
	setDvar( "scr_wdr_uzi_silenced", 0.01000 );
	
	setDvar( "scr_wdr_ak74u", 0.00200 );
	setDvar( "scr_wdr_ak74u_silenced", 0.00200 );
	
	setDvar( "scr_wdr_p90", 0.00500 );
	setDvar( "scr_wdr_p90_silenced", 0.00500 );
	
	// Demolition class weapons
	//setDvar( "scr_wdr_m1014", 0.00500 );
	//setDvar( "scr_wdr_winchester1200", 0.00500 );
	
	// Heavy gunner class weapons
	setDvar( "scr_wdr_saw", 0.00110 );
	setDvar( "scr_wdr_rpd", 0.00100 );
	setDvar( "scr_wdr_m60e4", 0.00091 );
	
	// Sniper class weapons
	setDvar( "scr_wdr_dragunov", 0.00125 );
	
	setDvar( "scr_wdr_m40a3", 0.00109 );
	
	setDvar( "scr_wdr_barrett", 0.00056 );
	
	setDvar( "scr_wdr_remington700", 0.00083 );
	
	setDvar( "scr_wdr_m21", 0.00125 );
	
	// Handguns
	setDvar( "scr_wdr_beretta", 0.02000 );
	setDvar( "scr_wdr_beretta_silenced", 0.02000 );
	
	setDvar( "scr_wdr_colt45", 0.03333 );
	setDvar( "scr_wdr_colt45_silenced", 0.03333 );
	
	setDvar( "scr_wdr_usp", 0.03333 );
	setDvar( "scr_wdr_usp_silenced", 0.03333 );
	
	setDvar( "scr_wdr_deserteagle", 0.02000 );
	
}

PenetCoefModTweaks()
{
// Assault class weapons
setDvar( "scr_pnt_m16", 1.3 );
setDvar( "scr_pnt_m16_silenced", 1.3 );

setDvar( "scr_pnt_ak47", 1.3 );
setDvar( "scr_pnt_ak47_silenced", 1.3 );

setDvar( "scr_pnt_m4", 1.3 );
setDvar( "scr_pnt_m4_silenced", 1.3 );

setDvar( "scr_pnt_g3", 1.3 );
setDvar( "scr_pnt_g3_silenced", 1.3 );

setDvar( "scr_pnt_g36c", 1.3 );
setDvar( "scr_pnt_g36c_silenced", 1.3 );

setDvar( "scr_pnt_m14", 1.3 );
setDvar( "scr_pnt_m14_silenced", 1.3 );

setDvar( "scr_pnt_mp44", 1.3 );

// Special Ops class weapons
setDvar( "scr_pnt_mp5", 1 );
setDvar( "scr_pnt_mp5_silenced", 1 );

setDvar( "scr_pnt_skorpion", 1 );
setDvar( "scr_pnt_skorpion_silenced", 1 );

setDvar( "scr_pnt_uzi", 1 );
setDvar( "scr_pnt_uzi_silenced", 1 );

setDvar( "scr_pnt_ak74u", 1.3 );
setDvar( "scr_pnt_ak74u_silenced", 1.3 );

setDvar( "scr_pnt_p90", 1.3 );
setDvar( "scr_pnt_p90_silenced", 1.3 );

// Demolition class weapons
//setDvar( "scr_pnt_m1014", 1 );
//setDvar( "scr_pnt_winchester1200", 1 );

// Heavy gunner class weapons
setDvar( "scr_pnt_saw", 1.3 );
setDvar( "scr_pnt_rpd", 1.3 );
setDvar( "scr_pnt_m60e4", 1.3 );

// Sniper class weapons
setDvar( "scr_pnt_dragunov", 1.3 );

setDvar( "scr_pnt_m40a3", 1.3 );

setDvar( "scr_pnt_barrett", 1.3 );

setDvar( "scr_pnt_remington700", 1.3 );

setDvar( "scr_pnt_m21", 1.3 );

// Handguns
setDvar( "scr_pnt_beretta", 1 );
setDvar( "scr_pnt_beretta_silenced", 1 );

setDvar( "scr_pnt_colt45", 1 );
setDvar( "scr_pnt_colt45_silenced", 1 );

setDvar( "scr_pnt_usp", 1 );
setDvar( "scr_pnt_usp_silenced", 1 );

setDvar( "scr_pnt_deserteagle", 1 );

}

StoppingCoefModTweaks()
{
// Assault class weapons
setDvar( "scr_stp_m16", 0 );
setDvar( "scr_stp_m16_silenced", 0 );

setDvar( "scr_stp_ak47", 1 );
setDvar( "scr_stp_ak47_silenced", 1 );

setDvar( "scr_stp_m4", 0 );
setDvar( "scr_stp_m4_silenced", 0 );

setDvar( "scr_stp_g3", 1 );
setDvar( "scr_stp_g3_silenced", 1 );

setDvar( "scr_stp_g36c", 0 );
setDvar( "scr_stp_g36c_silenced", 0 );

setDvar( "scr_stp_m14", 1 );
setDvar( "scr_stp_m14_silenced", 1 );

setDvar( "scr_stp_mp44", 1 );

// Special Ops class weapons
setDvar( "scr_stp_mp5", 1 );
setDvar( "scr_stp_mp5_silenced", 1 );

setDvar( "scr_stp_skorpion", 1 );
setDvar( "scr_stp_skorpion_silenced", 1 );

setDvar( "scr_stp_uzi", 1 );
setDvar( "scr_stp_uzi_silenced", 1 );

setDvar( "scr_stp_ak74u", 0 );
setDvar( "scr_stp_ak74u_silenced", 0 );

setDvar( "scr_stp_p90", 0 );
setDvar( "scr_stp_p90_silenced", 0 );

// Demolition class weapons
//setDvar( "scr_stp_m1014", 1 );
//setDvar( "scr_stp_winchester1200", 1 );

// Heavy gunner class weapons
setDvar( "scr_stp_saw", 1 );
setDvar( "scr_stp_rpd", 1 );
setDvar( "scr_stp_m60e4", 1 );

// Sniper class weapons
setDvar( "scr_stp_dragunov", 1 );

setDvar( "scr_stp_m40a3", 1 );

setDvar( "scr_stp_barrett", 1 );

setDvar( "scr_stp_remington700", 1 );

setDvar( "scr_stp_m21", 1 );

// Handguns
setDvar( "scr_stp_beretta", 1 );
setDvar( "scr_stp_beretta_silenced", 1 );

setDvar( "scr_stp_colt45", 1 );
setDvar( "scr_stp_colt45_silenced", 1 );

setDvar( "scr_stp_usp", 0.03333 );
setDvar( "scr_stp_usp_silenced", 1 );

setDvar( "scr_stp_deserteagle", 1 );

}

weaponLengthModTweaks()
{
// Assault class weapons
setDvar( "scr_wl_m16", 1 );
setDvar( "scr_wl_m16_silenced", 1 );

setDvar( "scr_wl_ak47", 1 );
setDvar( "scr_wl_ak47_silenced", 1 );

setDvar( "scr_wl_m4", 1 );
setDvar( "scr_wl_m4_silenced", 1 );

setDvar( "scr_wl_g3", 1 );
setDvar( "scr_wl_g3_silenced", 1 );

setDvar( "scr_wl_g36c", 1 );
setDvar( "scr_wl_g36c_silenced", 1 );

setDvar( "scr_wl_m14", 1 );
setDvar( "scr_wl_m14_silenced", 1 );

setDvar( "scr_wl_mp44", 1 );

// Special Ops class weapons
setDvar( "scr_wl_mp5", 1 );
setDvar( "scr_wl_mp5_silenced", 1 );

setDvar( "scr_wl_skorpion", 1 );
setDvar( "scr_wl_skorpion_silenced", 1 );

setDvar( "scr_wl_uzi", 1 );
setDvar( "scr_wl_uzi_silenced", 1 );

setDvar( "scr_wl_ak74u", 1 );
setDvar( "scr_wl_ak74u_silenced", 1 );

setDvar( "scr_wl_p90", 1 );
setDvar( "scr_wl_p90_silenced", 1 );

// Demolition class weapons
//setDvar( "scr_wl_m1014", 1 );
//setDvar( "scr_wl_winchester1200", 1 );

// Heavy gunner class weapons
setDvar( "scr_wl_saw", 1 );
setDvar( "scr_wl_rpd", 1 );
setDvar( "scr_wl_m60e4", 1 );

// Sniper class weapons
setDvar( "scr_wl_dragunov", 1 );

setDvar( "scr_wl_m40a3", 1 );

setDvar( "scr_wl_barrett", 1 );

setDvar( "scr_wl_remington700", 1 );

setDvar( "scr_wl_m21", 1 );

// Handguns
setDvar( "scr_wl_beretta", 1 );
setDvar( "scr_wl_beretta_silenced", 1 );

setDvar( "scr_wl_colt45", 1 );
setDvar( "scr_wl_colt45_silenced", 1 );

setDvar( "scr_wl_usp", 0.03333 );
setDvar( "scr_wl_usp_silenced", 1 );

setDvar( "scr_wl_deserteagle", 1 );

}

weaponSpeedModTweaks()
{
// Assault class weapons
setDvar( "scr_ws_m16_acog", 37323 );

setDvar( "scr_ws_ak47_acog", 30079 );

setDvar( "scr_ws_m4_acog", 34803 );

setDvar( "scr_ws_g3_acog", 31496 );

setDvar( "scr_ws_g36c_acog", 33465 );

setDvar( "scr_ws_m14_acog", 33465 );


// Special Ops class weapons
setDvar( "scr_ws_mp5_acog", 15748 );

setDvar( "scr_ws_skorpion_acog", 12589 );

setDvar( "scr_ws_uzi_acog", 15748 );

setDvar( "scr_ws_ak74u_acog", 30079 );

setDvar( "scr_ws_p90_acog", 28150 );

// Heavy gunner class weapons
setDvar( "scr_ws_saw_acog", 36024 );
setDvar( "scr_ws_rpd_acog", 28937 );
setDvar( "scr_ws_m60e4_acog", 33585 );

// Sniper class weapons
setDvar( "scr_ws_dragunov", 32677 );
setDvar( "scr_ws_dragunov_acog", 32677 );

setDvar( "scr_ws_m40a3", 35433 );
setDvar( "scr_ws_m40a3_acog", 33585 );

setDvar( "scr_ws_barrett", 34724 );
setDvar( "scr_ws_barrett_acog", 34724 );

setDvar( "scr_ws_remington700", 35433 );
setDvar( "scr_ws_remington700_acog", 35433 );

setDvar( "scr_ws_m21", 33465 );
setDvar( "scr_ws_m21_acog", 33465 );


}

weaponZoomModTweaks()
{
// Assault class weapons
setDvar( "scr_wzl_m16_acog", 30 );

setDvar( "scr_wzl_ak47_acog", 30 );

setDvar( "scr_wzl_m4_acog", 43 );

setDvar( "scr_wzl_g3_acog", 30 );

setDvar( "scr_wzl_g36c_acog", 43 );

setDvar( "scr_wzl_m14_acog", 30 );

// Special Ops class weapons
setDvar( "scr_wzl_mp5_acog", 43 );

setDvar( "scr_wzl_skorpion_acog", 43 );

setDvar( "scr_wzl_uzi_acog", 43 );

setDvar( "scr_wzl_ak74u_acog", 43 );

setDvar( "scr_wzl_p90_acog", 43 );

// Heavy gunner class weapons
setDvar( "scr_wzl_saw_acog", 30 );
setDvar( "scr_wzl_rpd_acog", 30 );
setDvar( "scr_wzl_m60e4_acog", 30 );

// Sniper class weapons
setDvar( "scr_wzl_dragunov", 10 );
setDvar( "scr_wzl_dragunov_acog", 30 );

setDvar( "scr_wzl_m40a3", 10 );
setDvar( "scr_wzl_m40a3_acog", 30 );

setDvar( "scr_wzl_barrett", 10 );
setDvar( "scr_wzl_barrett_acog", 30 );

setDvar( "scr_wzl_remington700", 10 );
setDvar( "scr_wzl_remington700_acog", 30 );

setDvar( "scr_wzl_m21", 10 );
setDvar( "scr_wzl_m21_acog", 30 );


}
