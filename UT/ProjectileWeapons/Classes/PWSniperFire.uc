class PWSniperFire extends PWWeaponFire;

var() float HeadShotDamageMult;
var() class<DamageType> DamageTypeHeadShot;
var name FireAnims[3];

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



function PlayFiring()
{
	Weapon.PlayAnim(FireAnims[Rand(3)], FireAnimRate, TweenTime);
    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

defaultproperties
{
    AmmoClass=class'ClassicSniperAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeClassicSniper'
    DamageTypeHeadShot=class'DamTypeClassicHeadShot'
    DamageMin=120
    DamageMax=120
	BulletToss=100
	Spread=1
	MaxDamageRange=500
	MinDamageRange=2000
	Speed=40000
	Momentum=1
	WeaponHipMaxAngle=500
	WeaponADSMaxAngle=0
	
	
	
	
    FireSound=Sound'NewWeaponSounds.NewSniperShot'
    FireForce="NewSniperShot"  // jdf
    FireRate=1.33
	FireAnimRate=1.5

    FlashEmitterClass=class'XEffects.AssaultMuzFlash1st'

    BotRefireRate=0.4
    AimError=850
	WarnTargetPct=+0.5

    HeadShotDamageMult=2.0

    ShakeOffsetMag=(X=-15.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=-4000.0,Y=0.0,Z=4000.0)
    ShakeOffsetTime=1.6
    ShakeRotMag=(X=0.0,Y=0.0,Z=0.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=0.0)
    ShakeRotTime=2

    FireAnims(0)=Fire1
    FireAnims(1)=Fire2
    FireAnims(2)=Fire3
}

