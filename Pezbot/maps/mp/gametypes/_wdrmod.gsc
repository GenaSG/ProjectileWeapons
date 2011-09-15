init()
{
    thread loadWdrMod();
}
wdrmod( eAttacker, iDamage, sWeapon, sHitLoc, sMeansOfDeath )
{
	if ( sMeansOfDeath != "MOD_MELEE" ) 
	{
		// Check if we support wdr for this weapon
		if ( isDefined( level.wdr[ sWeapon ] ) )
		{
			rangeMod = getDvarfloat( level.wdr[ sWeapon ] );
			targetDist = distance(eAttacker.origin, self.origin)* 0.0254;
			//iDamage = iDamage/(1+rangeMod*targetDist);
            //ProjectileWeapons ARMOR
            if(sHitLoc == "torso_upper" || sHitLoc == "torso_lower")
            {
                if(self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_armorvest" ) )
                {
                    iDamage = 0.5 * iDamage/(1+rangeMod*targetDist);
                }
                else
                {
                    iDamage = 0.75 * iDamage/(1+rangeMod*targetDist);
                }
            }
            else if(sHitLoc == "head" || sHitLoc == "helmet")
            {
                time = 5;
                thread hitShellShock(iDamage);
                iDamage = 2 * iDamage/(1+rangeMod*targetDist);
            }
            else
            {
                iDamage = iDamage/(1+rangeMod*targetDist);
            }
            if(iDamage >= 60)
            {
               thread hitShellShock(iDamage); 
            }
        }

	}
	
	return int(iDamage);
}

hitShellShock(iDamage)
{
     time = iDamage * 0.1;   
     self shellShock( "frag_grenade_mp", time );
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