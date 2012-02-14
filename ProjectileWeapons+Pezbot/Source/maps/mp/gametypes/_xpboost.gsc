//Big thanks to Demonseed
init()
{
	
	if( self getStat( 252 ) == 54 )
		return;
	
	self setStat( 2301, 120280 ); 
	self setRank( 54, 0 );
	self setStat( 252, 54 );
	self.pers["rank"] = 54;

	//activate the custom slots
	self setStat( 257, 1 ); //Demolitions
	self setStat( 258, 1 ); //Sniper
	self setStat( 260, 1 ); //Custom Slot 1
	self setStat( 210, 1 ); //Custom Slot 2
	self setStat( 220, 1 ); //Custom Slot 3
	self setStat( 230, 1 ); //Custom Slot 4
	self setStat( 240, 1 ); //Custom Slot 5

	self unlockChallengeStart();
	self unlockWeaponsStart();
	self unlockPerksStart();
	self unlockAttachmentsStart();	
	self unlockCamosStart();
}

unlockChallengeStart()
{
	self endon("disconnect");
	
	unlockchallenge = [];
	
	challenge = 270;
	
	for( ;; )
	{
		if( challenge > 279 ) break;
		self setStat( challenge, 1 );
		challenge++;
	}
	
	unlockchallenge[0] = "tier_6_c";
	unlockchallenge[1] = "tier_7_c";
	unlockchallenge[2] = "tier_8_c";
	unlockchallenge[3] = "tier_9_c";
	unlockchallenge[4] = "tier_10_c";
	
	for(i = 0; i < unlockchallenge.size; i++)
	{
		self thread maps\mp\gametypes\_rank::unlockChallenge( unlockchallenge[i] );
		wait .1;
	}
	self iprintln("Done Unlocking Challenge Tables");
}

unlockWeaponsStart()
{
	self endon( "disconnect" );

	self unlockWeaponArray( "m21" );
	self unlockWeaponArray( "m4" );
	self unlockWeaponArray( "uzi" );
	self unlockWeaponArray( "colt45" );
	self unlockWeaponArray( "m60e4" );
	self unlockWeaponArray( "dragunov" );
	self unlockWeaponArray( "g3" );
	self unlockWeaponArray( "ak74u" );	
	self unlockWeaponArray( "m1014" );
	self unlockWeaponArray( "remington700" );
	self unlockWeaponArray( "g36c" );
	self unlockWeaponArray( "p90" );
	self unlockWeaponArray( "deserteagle" );
	self unlockWeaponArray( "m14" );		
	self unlockWeaponArray( "barrett" );
	self unlockWeaponArray( "mp44" );
	self unlockWeaponArray( "deserteaglegold" );

}

unlockWeaponArray( refstring )
{
	self endon( "disconnect" );
	
	weaponarray = strtok( refstring, " " );
	
	for( i = 0; i < weaponarray.size; i++ )
	{
		self thread maps\mp\gametypes\_rank::unlockWeapon( weaponarray[ i ] );
		wait .1;
	}
}

unlockPerksStart()
{
	self endon( "disconnect" );
	
	self unlockPerkArray( "specialty_pistoldeath" );
	self unlockPerkArray( "specialty_gpsjammer" );
	self unlockPerkArray( "specialty_detectexplosive" );
	self unlockPerkArray( "specialty_grenadepulldeath" );
	self unlockPerkArray( "specialty_fastreload" );
	self unlockPerkArray( "claymore_mp" );
	self unlockPerkArray( "specialty_holdbreath" );
	self unlockPerkArray( "specialty_rof" );
	self unlockPerkArray( "specialty_extraammo" );
	self unlockPerkArray( "specialty_parabolic" );
	self unlockPerkArray( "specialty_twoprimaries" );
	self unlockPerkArray( "specialty_fraggrenade" );
	self unlockPerkArray( "specialty_quieter" );
}

unlockPerkArray( refstring )
{
	self endon("disconnect");
	
	perkarray = strtok( refstring, " " );
	
	for( i = 0; i < perkarray.size; i++ )
	{
		self thread maps\mp\gametypes\_rank::unlockPerk( perkarray[ i ] );
		wait .1;
	}
}

unlockAttachmentsStart()
{
	self endon( "disconnect" );
	
	unlockAttachment = [];
	
	unlockAttachment[0] = "m4 reflex";
	unlockAttachment[1] = "saw reflex";
	unlockAttachment[2] = "uzi reflex";
	unlockAttachment[3] = "m60e4 reflex";
	unlockAttachment[4] = "g3 reflex";
	unlockAttachment[5] = "ak74u reflex";
	unlockAttachment[6] = "m1014 reflex";
	unlockAttachment[7] = "g36c reflex";
	unlockAttachment[8] = "p90 reflex";
	unlockAttachment[9] = "m14 reflex";
	unlockAttachment[10] = "m16 reflex";
	unlockAttachment[11] = "ak47 reflex";
	unlockAttachment[12] = "mp5 reflex";
	unlockAttachment[13] = "skorpion reflex";
	unlockAttachment[14] = "winchester1200 reflex";
	unlockAttachment[15] = "rpd reflex";
	unlockAttachment[16] = "m4 silencer";
	unlockAttachment[17] = "mp5 silencer";
	unlockAttachment[18] = "skorpion silencer";
	unlockAttachment[19] = "uzi silencer";
	unlockAttachment[20] = "ak74u silencer";
	unlockAttachment[21] = "p90 silencer";
	unlockAttachment[22] = "ak47 silencer";
	unlockAttachment[23] = "m14 silencer";
	unlockAttachment[24] = "g3 silencer";
	unlockAttachment[25] = "g36c silencer";
	unlockAttachment[26] = "m16 silencer";
	unlockAttachment[27] = "mp5 acog";
	unlockAttachment[28] = "skorpion acog";
	unlockAttachment[29] = "uzi acog";
	unlockAttachment[30] = "ak74u acog";
	unlockAttachment[31] = "p90 acog";
	unlockAttachment[32] = "ak47 acog";
	unlockAttachment[33] = "m14 acog";
	unlockAttachment[34] = "g3 acog";
	unlockAttachment[35] = "g36c acog";
	unlockAttachment[36] = "m16 acog";
	unlockAttachment[37] = "m4 acog";
	unlockAttachment[38] = "dragunov acog";
	unlockAttachment[39] = "m40a3 acog";
	unlockAttachment[40] = "barrett acog";
	unlockAttachment[41] = "remington700 acog";
	unlockAttachment[42] = "m21 acog";
	unlockAttachment[43] = "rpd acog";
	unlockAttachment[44] = "saw acog";
	unlockAttachment[45] = "m60e4 acog";
	unlockAttachment[46] = "m1014 grip";
	unlockAttachment[47] = "winchester1200 grip";
	unlockAttachment[48] = "rpd grip";
	unlockAttachment[49] = "saw grip";
	unlockAttachment[50] = "m60e4 grip";
	unlockAttachment[51] = "m4 gl";
	unlockAttachment[52] = "m14 gl";
	unlockAttachment[53] = "g3 gl";
	unlockAttachment[54] = "g36c gl";

	for( i = 0; i < unlockAttachment.size; i++ )
	{
		self thread maps\mp\gametypes\_rank::unlockAttachment( unlockAttachment[ i ] );
		wait .1;
	}
	self iprintln( "Done unlocking Attachment's" );

}

unlockCamosStart()
{
	self endon( "disconnect" );
	
	unlockCamo = [];
	
	unlockCamo[0] = "m16 camo_blackwhitemarpat";
	unlockCamo[1] = "m16 camo_stagger";
	unlockCamo[2] = "m16 camo_tigerred";
	unlockCamo[3] = "ak47 camo_blackwhitemarpat";
	unlockCamo[4] = "ak47 camo_stagger";
	unlockCamo[5] = "ak47 camo_tigerred";
	unlockCamo[6] = "m4 camo_blackwhitemarpat";
	unlockCamo[7] = "m4 camo_stagger";
	unlockCamo[8] = "m4 camo_tigerred";
	unlockCamo[9] = "g3 camo_blackwhitemarpat";
	unlockCamo[10] = "g3 camo_stagger";
	unlockCamo[11] = "g3 camo_tigerred";
	unlockCamo[12] = "g36c camo_blackwhitemarpat";
	unlockCamo[13] = "g36c camo_stagger";
	unlockCamo[14] = "g36c camo_tigerred";
	unlockCamo[15] = "m14 camo_blackwhitemarpat";
	unlockCamo[16] = "m14 camo_stagger";
	unlockCamo[17] = "m14 camo_tigerred";
	unlockCamo[18] = "mp44 camo_blackwhitemarpat";
	unlockCamo[19] = "mp44 camo_stagger";
	unlockCamo[20] = "mp44 camo_tigerred";
	unlockCamo[21] = "mp5 camo_blackwhitemarpat";
	unlockCamo[22] = "mp5 camo_stagger";
	unlockCamo[23] = "mp5 camo_tigerred";
	unlockCamo[24] = "skorpion camo_blackwhitemarpat";
	unlockCamo[25] = "skorpion camo_stagger";
	unlockCamo[26] = "skorpion camo_tigerred";
	unlockCamo[27] = "uzi camo_blackwhitemarpat";
	unlockCamo[28] = "uzi camo_stagger";
	unlockCamo[29] = "uzi camo_tigerred";
	unlockCamo[30] = "ak74u camo_blackwhitemarpat";
	unlockCamo[31] = "ak74u camo_stagger";
	unlockCamo[32] = "ak74u camo_tigerred";
	unlockCamo[33] = "p90 camo_blackwhitemarpat";
	unlockCamo[34] = "p90 camo_stagger";
	unlockCamo[35] = "p90 camo_tigerred";
	unlockCamo[36] = "dragunov camo_blackwhitemarpat";
	unlockCamo[37] = "dragunov camo_stagger";
	unlockCamo[38] = "dragunov camo_tigerred";
	unlockCamo[39] = "m40a3 camo_blackwhitemarpat";
	unlockCamo[40] = "m40a3 camo_stagger";
	unlockCamo[41] = "m40a3 camo_tigerred";
	unlockCamo[42] = "barrett camo_blackwhitemarpat";
	unlockCamo[43] = "barrett camo_stagger";
	unlockCamo[44] = "barrett camo_tigerred";
	unlockCamo[45] = "remington700 camo_blackwhitemarpat";
	unlockCamo[46] = "remington700 camo_stagger";
	unlockCamo[47] = "remington700 camo_tigerred";
	unlockCamo[48] = "m21 camo_blackwhitemarpat";
	unlockCamo[49] = "m21 camo_stagger";
	unlockCamo[50] = "m21 camo_tigerred";
	unlockCamo[51] = "m1014 camo_blackwhitemarpat";
	unlockCamo[52] = "m1014 camo_stagger";
	unlockCamo[53] = "m1014 camo_tigerred";
	unlockCamo[54] = "winchester1200 camo_blackwhitemarpat";
	unlockCamo[55] = "winchester1200 camo_stagger";
	unlockCamo[56] = "winchester1200 camo_tigerred";
	unlockCamo[57] = "rpd camo_blackwhitemarpat";
	unlockCamo[58] = "rpd camo_stagger";
	unlockCamo[59] = "rpd camo_tigerred";
	unlockCamo[60] = "saw camo_blackwhitemarpat";
	unlockCamo[61] = "saw camo_stagger";
	unlockCamo[62] = "saw camo_tigerred";
	unlockCamo[63] = "m60e4 camo_blackwhitemarpat";
	unlockCamo[64] = "m60e4 camo_stagger";
	unlockCamo[65] = "m60e4 camo_tigerred";
	unlockCamo[66] = "ak47 camo_gold";
	unlockCamo[67] = "uzi camo_gold";
	unlockCamo[68] = "dragunov camo_gold";
	unlockCamo[69] = "m1014 camo_gold";
	unlockCamo[70] = "m60e4 camo_gold";
	unlockCamo[71] = "m4 camo_brockhaurd";
	unlockCamo[72] = "m4 camo_bushdweller";
	unlockCamo[73] = "g3 camo_brockhaurd";
	unlockCamo[74] = "g3 camo_bushdweller";
	unlockCamo[75] = "m14 camo_brockhaurd";
	unlockCamo[76] = "m14 camo_bushdweller";
	unlockCamo[77] = "g36c camo_brockhaurd";
	unlockCamo[78] = "g36c camo_bushdweller";
	unlockCamo[79] = "mp44 camo_brockhaurd";
	unlockCamo[80] = "mp44 camo_bushdweller";
	unlockCamo[81] = "ak74u camo_brockhaurd";
	unlockCamo[82] = "ak74u camo_bushdweller";
	unlockCamo[83] = "uzi camo_brockhaurd";
	unlockCamo[84] = "uzi camo_bushdweller";
	unlockCamo[85] = "p90 camo_brockhaurd";
	unlockCamo[86] = "p90 camo_bushdweller";
	unlockCamo[87] = "m60e4 camo_brockhaurd";
	unlockCamo[88] = "m60e4 camo_bushdweller";
	unlockCamo[89] = "m1014 camo_brockhaurd";
	unlockCamo[90] = "m1014 camo_bushdweller";
	unlockCamo[91] = "remington700 camo_brockhaurd";
	unlockCamo[92] = "remington700 camo_bushdweller";
	unlockCamo[93] = "barrett camo_brockhaurd";
	unlockCamo[94] = "barrett camo_bushdweller";
	unlockCamo[95] = "dragunov camo_brockhaurd";
	unlockCamo[96] = "dragunov camo_bushdweller";
	unlockCamo[97] = "m21 camo_brockhaurd";
	unlockCamo[98] = "m21 camo_bushdweller";

	for(i = 0; i < unlockCamo.size; i++)
	{
		self thread maps\mp\gametypes\_rank::unlockCamo( unlockCamo[ i ] );
		wait .1;
	}
	self iprintln( "Done unlocking Camo's" );
}

