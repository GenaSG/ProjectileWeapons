class PWWeaponFire extends WeaponFire;

var class<DamageType> DamageType,DamageTypeHeadShot;
var int DamageMin, DamageMax, MaxDamageRange, MinDamageRange, Speed, WeaponHipMaxAngle,WeaponADSMaxAngle, RecoilMult,BulletToss;
var float Momentum;
var rotator OldRotation;
var vector BulletSpawnOffset, ADSBulletSpawnOffset;


event ModeDoFire()
{
	
	if (!AllowFire())
        return;
	
    if (MaxHoldTime > 0.0)
        HoldTime = FMin(HoldTime, MaxHoldTime);
	
    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
        DoFireEffect();
		HoldTime = 0;	// if bot decides to stop firing, HoldTime must be reset first
        if ( (Instigator == None) || (Instigator.Controller == None) )
			return;
		
        if ( AIController(Instigator.Controller) != None )
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);
		
        Instigator.DeactivateSpawnProtection();
    }
	
    // client
    if (Instigator.IsLocallyControlled())
    {
		ClientFire();
        ShakeView();
        FlashMuzzleFlash();
        StartMuzzleSmoke();
    }
    else // server
    {
        ServerPlayFiring();
    }
	
    Weapon.IncrementFlashCount(ThisModeNum);
	
    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
            NextFireTime += MaxHoldTime + FireRate;
        else
            NextFireTime = Level.TimeSeconds + FireRate;
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }
	
    Load = AmmoPerFire;
    HoldTime = 0;
	
    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != None)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

function ClientFire()
{
	/*
	 TODO Tie start location to barrel of the weapon 
	 */
	local vector Start;
	local rotator Dir;
	if (!AllowFire())
        return;
	if (PWWeapon(Weapon).bADS) {
		Start=Instigator.Location + Instigator.EyePosition();
		Start.Z=PWWeapon(Weapon).Location.Z;
	}
	else {
		Start=PWWeapon(Weapon).Location;
	}
	Dir=AdjustAim(Start, AimError) + Weapon.PlayerViewPivot;
	Dir=Rotator(vector(Dir) + VRand()*Spread/325);
	Dir.Pitch+=BulletToss;
	SpawnBullet(Start, Dir);
	FireAnimRate=default.FireAnimRate+default.FireAnimRate*FRand();
	PlayFiring();
//	if (Bot(Instigator.Controller)==none) {
	PlayRecoil();
//	}
	
}

simulated function PlayRecoil()
{
//	if (!PWWeapon(Weapon).bADS && Weapon.PlayerViewPivot.Pitch <=WeaponMaxAngle) {
		if (FRand() >= 0.5 ) {
			Weapon.PlayerViewPivot.Pitch+=DamageMax*RecoilMult;
		}
		else
		{
			Weapon.PlayerViewPivot.Pitch-=DamageMax*RecoilMult;
		}
		if (FRand() < 0.5 ) {
			Weapon.PlayerViewPivot.Yaw+=DamageMax*RecoilMult;
		}
		else
		{
			Weapon.PlayerViewPivot.Yaw-=DamageMax*RecoilMult;
		}
		
//	}

}


function SpawnBullet(Vector Start, Rotator Dir)
{
	local PWBullet CP;
	CP=Spawn(class'PWBullet',Instigator.Controller,,Start,Dir);
	CP.Start=Start;
	CP.DamageMax=DamageMax;
	CP.DamageMin=DamageMin;
	CP.MaxDamageRange=MaxDamageRange;
	CP.MinDamageRange=MinDamageRange;
	CP.DamageTypeHeadShot=DamageTypeHeadShot;
	CP.MyDamageType=DamageType;
	CP.Velocity=Vector(Dir) * (Speed);
	CP.SetOwnerWeapon(PWWeapon(Weapon));
}
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.01,true);
}


simulated function Timer()
{
	Super.Timer();
	FreeAim();
	
}

simulated function FreeAim()
{
	local rotator NewRotation, CurrentRotation;
	local int WeaponAngles;
	CurrentRotation=Weapon.Rotation;
	NewRotation=CurrentRotation-OldRotation;
	//Zero Crossing compensation
	if (CurrentRotation.Pitch>=32768 && OldRotation.Pitch<=32768) {
		NewRotation.Pitch=-1*((65536-CurrentRotation.Pitch) + OldRotation.Pitch);
	}
	if (CurrentRotation.Pitch<=32768 && OldRotation.Pitch>=32768) {
		NewRotation.Pitch=((65536-OldRotation.Pitch) + CurrentRotation.Pitch);
	}
	//
	if (!PWWeapon(Weapon).bADS) {
		WeaponAngles=WeaponHipMaxAngle;
		}
	else
	{
		WeaponAngles=WeaponADSMaxAngle;
	}
	Weapon.PlayerViewPivot+=NewRotation;
	//Weapon Pivot Angles Shouldn't be bigger then Max Allowed angles
	if (Weapon.PlayerViewPivot.Pitch >= WeaponAngles) {
		Weapon.PlayerViewPivot.Pitch=WeaponAngles;
	}
	if (Weapon.PlayerViewPivot.Pitch <= -WeaponAngles) {
		Weapon.PlayerViewPivot.Pitch=-WeaponAngles;
	}
	if (Weapon.PlayerViewPivot.Yaw >= WeaponAngles) {
		Weapon.PlayerViewPivot.Yaw=WeaponAngles;
	}
	if (Weapon.PlayerViewPivot.Yaw <= -WeaponAngles) {
		Weapon.PlayerViewPivot.Yaw=-WeaponAngles;
	}
	
	OldRotation=Weapon.Rotation;
}

defaultproperties
{
	DamageTypeHeadShot=class'DamTypeClassicHeadShot'
    DamageType=class'DamTypeAssaultBullet'
	BulletSpawnOffset=(X=0,Y=0,Z=0)
	ADSBulletSpawnOffset=(X=0,Y=0,Z=0)
	WeaponHipMaxAngle=500
	WeaponADSMaxAngle=50
	RecoilMult=5
	AimError=0
	DamageMin=5
	DamageMax=40
	BulletToss=200
	Spread=1
	MaxDamageRange=500
	MinDamageRange=2000
	Speed=20000
	Momentum=1
    NoAmmoSound=Sound'WeaponSounds.P1Reload5'
	bInstantHit=true
}
