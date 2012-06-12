class SniperFireProj extends ProjectileFire;

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'dummy01');
}

function FlashMuzzleFlash()
{
    local rotator r;

    r.Yaw = 16384;
    Weapon.SetBoneRotation('dummy01', r, 0, 1.f);
    Super.FlashMuzzleFlash();
}

defaultproperties
{
     ProjPerFire=1
     ProjectileClass=Class'ProjectileWeapons.SniperRifleBullet'
     Spread=0.000000
     SpreadStyle=SS_Random
     FireAnimRate=1.500000
     FireSound=Sound'NewWeaponSounds.NewSniperShot'
     FireForce="NewSniperShot"
     FireRate=1.330000
     AmmoClass=Class'UTClassic.ClassicSniperAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-15.000000,Z=10.000000)
     ShakeOffsetRate=(X=-4000.000000,Z=4000.000000)
     ShakeOffsetTime=1.600000
     BotRefireRate=0.400000
     WarnTargetPct=0.500000
     FlashEmitterClass=Class'XEffects.AssaultMuzFlash1st'
     aimerror=850.000000
}

