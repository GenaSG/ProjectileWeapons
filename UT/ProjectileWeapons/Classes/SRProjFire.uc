class SRProjFire extends CompensatedWeaponFire;

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


function DoTrace(Vector Start, Rotator Dir)
{
	Super.DoTrace(Start,Dir);
	Bullet.Damage=DamageMax;
	Bullet.MyDamageType=DamageType;
	Bullet.Velocity=Vector(Dir)*Speed;
}


simulated function PlayFiring()
{
	Weapon.PlayAnim(FireAnims[Rand(3)], FireAnimRate, TweenTime);
    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

defaultproperties
{
	Speed=40000
    AmmoClass=class'ClassicSniperAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeClassicSniper'
    DamageTypeHeadShot=class'DamTypeClassicHeadShot'
    DamageMin=60
    DamageMax=60
    FireSound=Sound'NewWeaponSounds.NewSniperShot'
    FireForce="NewSniperShot"  // jdf
    TraceRange=17000
    FireRate=0.6
	FireAnimRate=1.5
	Spread=0.002
	SpreadStyle=SS_Random
    FlashEmitterClass=class'XEffects.AssaultMuzFlash1st'

    BotRefireRate=0.4
    AimError=850
	WarnTargetPct=+0.5

    HeadShotDamageMult=2.0

    ShakeOffsetMag=(X=-15.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=-4000.0,Y=0.0,Z=4000.0)
    ShakeOffsetTime=1.6
    ShakeRotMag=(X=-15.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=-4000.0,Y=0.0,Z=4000.0)
    ShakeRotTime=2

    FireAnims(0)=Fire1
    FireAnims(1)=Fire2
    FireAnims(2)=Fire3
}

