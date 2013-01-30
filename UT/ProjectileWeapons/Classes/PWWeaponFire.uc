class PWWeaponFire extends WeaponFire;

var class<DamageType> DamageType,DamageTypeHeadShot;
var int DamageMin, DamageMax, MaxDamageRange, MinDamageRange, Speed;
var float TraceRange;
var float Momentum;


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
	
	local Coords C;
	local rotator Dir;
	if (!AllowFire())
        return;
	C=PWWeapon(Weapon).GetBoneCoords('tip');
	Start=C.Origin;
	Start=Weapon.GetEffectStart();
	if (Bot(Instigator.Controller)!=none) {
		Dir = rotator(vector(AdjustAim(Start, AimError)));
	}
	else
	{
		
		Dir=PWWeapon(Weapon).GetBoneRotation( 'tip' );
	}
	
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
	CP.SetOwnerWeapon(CSAR(Weapon));
}


defaultproperties
{
	DamageTypeHeadShot=class'DamTypeClassicHeadShot'
    DamageType=class'DamTypeAssaultBullet
	DamageMin=5
	DamageMax=40
	Spread=100
	MaxDamageRange=500
	MinDamageRange=2000
	Speed=20000
	Momentum=1
    TraceRange=10000
    NoAmmoSound=Sound'WeaponSounds.P1Reload5'
	bInstantHit=true
}
