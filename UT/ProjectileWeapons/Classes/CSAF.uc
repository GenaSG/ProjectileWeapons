class CSAF extends CSWF;

var float LastFireTime;
var float ClickTime;

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

event ModeDoFire()
{
	if ( Level.TimeSeconds - LastFireTime > 0.5 )
		Spread = Default.Spread;
	else
		Spread = FMin(Spread+0.02,0.12);
	LastFireTime = Level.TimeSeconds;
	Super.ModeDoFire();
}

simulated function bool AllowFire()
{
    if (Super.AllowFire())
        return true;
    else
    {
        if ( (PlayerController(Instigator.Controller) != None) && (Level.TimeSeconds > ClickTime) )
        {
            Instigator.PlaySound(Sound'WeaponSounds.P1Reload5');
			ClickTime = Level.TimeSeconds + 0.25;
		}
        return false;
    }
}

function StartBerserk()
{

}

function StopBerserk()
{

}

function StartSuperBerserk()
{
}

defaultproperties
{
    AmmoClass=class'AssaultAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeAssaultBullet'
    DamageMin=7
    DamageMax=7
    bPawnRapidFireAnim=true
    Momentum=10.0

    FireAnim=None
    FireEndAnim=None
    FireLoopAnim=None
    FireAnimRate=2

    FlashEmitterClass=class'XEffects.AssaultMuzFlash1st'

    FireSound=Sound'WeaponSounds.AssaultRifle.AssaultRifleFire'
    FireForce="AssaultRifleFire"   // jdf

	Spread=0.020
    SpreadStyle=SS_Random
    PreFireTime=0.0
    FireRate=0.16
    bModeExclusive=true

    BotRefireRate=0.99
    AimError=800


}
