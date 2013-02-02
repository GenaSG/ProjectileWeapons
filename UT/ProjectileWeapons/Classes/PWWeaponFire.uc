class PWWeaponFire extends WeaponFire;

var class<DamageType> DamageType,DamageTypeHeadShot;
var int DamageMin, DamageMax, MaxDamageRange, MinDamageRange, Speed, WeaponMaxAngle;
var float TraceRange;
var float Momentum;
var rotator OldRotation;


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
	local vector Start;
	
	local rotator Dir;
	if (!AllowFire())
        return;
	Start=Weapon.Location;
//	if (Bot(Instigator.Controller)!=none) {
//		Dir = rotator(vector(AdjustAim(Start, AimError)));
//	}
//	else
//	{
		
		//Dir=PWWeapon(Weapon).GetBoneRotation( 'tip' );
		Dir=AdjustAim(Start, AimError) + Weapon.PlayerViewPivot;
//		Dir=PWWeapon(Weapon).Rotation + Weapon.PlayerViewPivot;
//	}
	Dir=Rotator(vector(Dir) + VRand()*Spread/325);
	SpawnBullet(Start, Dir);
	FireAnimRate=default.FireAnimRate+default.FireAnimRate*FRand();
	PlayFiring();
	
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
	if (!PWWeapon(Weapon).bADS) {
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
		Weapon.PlayerViewPivot+=NewRotation;
		//Weapon Pivot Angles Shouldn't be bigger then Max Allowed angles
		if (Weapon.PlayerViewPivot.Pitch >= WeaponMaxAngle) {
			Weapon.PlayerViewPivot.Pitch=WeaponMaxAngle;
		}
		if (Weapon.PlayerViewPivot.Pitch <= -WeaponMaxAngle) {
			Weapon.PlayerViewPivot.Pitch=-WeaponMaxAngle;
		}
		if (Weapon.PlayerViewPivot.Yaw >= WeaponMaxAngle) {
			Weapon.PlayerViewPivot.Yaw=WeaponMaxAngle;
		}
		if (Weapon.PlayerViewPivot.Yaw <= -WeaponMaxAngle) {
			Weapon.PlayerViewPivot.Yaw=-WeaponMaxAngle;
		}
	}
	OldRotation=Weapon.Rotation;
}

defaultproperties
{
	DamageTypeHeadShot=class'DamTypeClassicHeadShot'
    DamageType=class'DamTypeAssaultBullet'
	WeaponMaxAngle=500
	DamageMin=5
	DamageMax=40
	Spread=1
	MaxDamageRange=500
	MinDamageRange=2000
	Speed=20000
	Momentum=1
    TraceRange=10000
    NoAmmoSound=Sound'WeaponSounds.P1Reload5'
	bInstantHit=true
}
