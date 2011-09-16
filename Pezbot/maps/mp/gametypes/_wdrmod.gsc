init()
{
    thread loadWdrMod();
    thread loadPenetCoef();
    thread loadStoppingCoef();
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
                    penetCoef = 1;
                    penetCoef = getDvarfloat( level.penetCoef[ sWeapon ] );
                    stoppingCoef = 0;
                    stoppingCoef = getDvarfloat( level.stoppingCoef[ sWeapon ] );
                    if(stoppingCoef == 1)
                    {
                        thread hitShellShock(iDamage);
                    }
                    iDamage = 0.5 * penetCoef * iDamage/(1+rangeMod*targetDist);
                }
                else
                {
                    penetCoef = 1;
                    penetCoef = getDvarfloat( level.penetCoef[ sWeapon ] );
                    stoppingCoef = 0;
                    stoppingCoef = getDvarfloat( level.stoppingCoef[ sWeapon ] );
                    if(stoppingCoef == 1)
                    {
                        thread hitShellShock(iDamage);
                    }
                    iDamage = 0.75 * penetCoef * iDamage/(1+rangeMod*targetDist);
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
                stoppingCoef = 0;
                stoppingCoef = getDvarfloat( level.stoppingCoef[ sWeapon ] );
                if(stoppingCoef == 1)
                {
                    thread hitShellShock(iDamage);
                }
                iDamage = iDamage/(1+rangeMod*targetDist);
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