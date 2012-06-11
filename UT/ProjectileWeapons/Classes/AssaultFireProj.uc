class AssaultFireProj extends ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

defaultproperties
{
     ProjPerFire=1
     ProjSpawnOffset=(X=25.000000,Y=5.000000,Z=-6.000000)
     FireEndAnim=
     FireAnimRate=0.950000
     FireSound=SoundGroup'WeaponSounds.AssaultRifle.AssaultRifleFire'
     FireForce="AssaultRifleFire"
     FireRate=0.100000
     AmmoClass=Class'XWeapons.AssaultAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'TestRifle.AssaultRifleBullet'
     BotRefireRate=0.700000
     FlashEmitterClass=Class'XEffects.AssaultMuzFlash1st'
     Spread=200.000000
     SpreadStyle=SS_Random
}

