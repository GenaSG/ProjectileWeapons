class AssaultFireProj extends ProjectileFire config(user);

var config float SpreadCoef, VelocityCoef, DamageCoef;


simulated function PostBeginPlay()
{

    Super.PostBeginPlay();
	SpreadCoef=Class'ProjectileWeapons.InGameMenu'.static.GetWeaponSpread();
	VelocityCoef=Class'ProjectileWeapons.InGameMenu'.static.GetWeaponSpeed();
	DamageCoef=Class'ProjectileWeapons.InGameMenu'.static.GetWeaponDamage();
	Spread *= SpreadCoef;
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local AssaultRifleBullet p;
    
	if( ProjectileClass != None )
		p = Weapon.Spawn(Class'ProjectileWeapons.AssaultRifleBullet',,, Start, Dir);

	if( p == None )
		return None;
	p.Bounces=0;
	p.Damage *= DamageCoef;
	p.Velocity *= VelocityCoef;
	return p;
}


function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function FlashMuzzleFlash()
{
    local rotator r;
    r.Roll = Rand(65536);
    Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);
    Super.FlashMuzzleFlash();
}

defaultproperties
{
     ProjPerFire=1
     ProjSpawnOffset=(X=25.000000,Y=5.000000,Z=-6.000000)
     bPawnRapidFireAnim=True
     FireLoopAnim=
     FireEndAnim=
     FireSound=SoundGroup'WeaponSounds.AssaultRifle.AssaultRifleFire'
     FireForce="AssaultRifleFire"
     FireRate=0.160000
     AmmoClass=Class'XWeapons.AssaultAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=1.000000,Y=1.000000,Z=1.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'XEffects.AssaultMuzFlash1st'
     aimerror=800.000000
     ProjectileClass=Class'ProjectileWeapons.AssaultRifleBullet'
     Spread=200.000000
     SpreadStyle=SS_Random
}

