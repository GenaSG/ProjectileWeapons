class ARClientFire extends ClientWeaponFire;

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
/*
 event ModeDoFire()
 {
 if ( Level.TimeSeconds - LastFireTime > Default.FireRate*2 )
 Spread = Default.Spread;
 else
 {
 Spread = Spread+0.4*Default.Spread;
 if (Spread > 3*Default.Spread) {
 Spread=3*Default.Spread;
 }
 }
 LastFireTime = Level.TimeSeconds;
 Super.ModeDoFire();
 }
 */
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

simulated function DoTrace(Vector Start, Rotator Dir)
{
	Super.DoTrace(Start,Dir);
	//Bullet.Damage=DamageMax;
	//Bullet.MyDamageType=DamageType;
}

function StartBerserk()
{
    DamageMin = default.DamageMin * 1.33;
    DamageMax = default.DamageMax * 1.33;
}

function StopBerserk()
{
    DamageMin = default.DamageMin;
    DamageMax = default.DamageMax;
}

function StartSuperBerserk()
{
    FireRate = default.FireRate * 1.5/Level.GRI.WeaponBerserk;
    FireAnimRate = default.FireAnimRate * 0.667 * Level.GRI.WeaponBerserk;
    DamageMin = default.DamageMin * 1.5;
    DamageMax = default.DamageMax * 1.5;
    if (AssaultRifle(Weapon) != None && AssaultRifle(Weapon).bDualMode)
    	FireRate *= 0.55;
}

defaultproperties
{
    AmmoClass=class'AssaultAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeAssaultBullet'
    DamageMin=20
    DamageMax=20
    bPawnRapidFireAnim=true
    Momentum=0.0
	
    FireAnim=Fire
    FireEndAnim=None
    FireLoopAnim=None
    FireAnimRate=1.0
	
    FlashEmitterClass=class'XEffects.AssaultMuzFlash1st'
	
    FireSound=Sound'WeaponSounds.AssaultRifle.AssaultRifleFire'
    FireForce="AssaultRifleFire"   // jdf
	
	Spread=0.02
    SpreadStyle=SS_Line
    PreFireTime=0.0
    FireRate=0.1
    bModeExclusive=true
	
    BotRefireRate=0.99
    AimError=800
	
    ShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2
	}
