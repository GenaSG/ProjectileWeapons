//=============================================================================
// Assault Rifle
//=============================================================================
class ARClient extends AssaultRifle
config(user);
replication
{
	reliable if (Role==ROLE_Authority)
		ClientTraceHit;
	reliable if (Role<ROLE_Authority)
		ServerTraceHit;
}

//// client only ////
simulated event ClientStartFire(int Mode)
{
    if ( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
        return;
    if (Role < ROLE_Authority)
    {
        if (StartFire(Mode))
		{
			StartFire(Mode);
            ServerStartFire(Mode);
        }
    }
    else
    {
		
        StartFire(Mode);
    }
}
/*
simulated function Timer()
{
	
}
*/
simulated function bool StartFire(int Mode)
{
    local int alt;
	
    if (!ReadyToFire(Mode))
        return false;
	
    if (Mode == 0)
        alt = 1;
    else
        alt = 0;
	
    FireMode[Mode].bIsFiring = true;
    FireMode[Mode].NextFireTime = Level.TimeSeconds + FireMode[Mode].PreFireTime;
	
    if (FireMode[alt].bModeExclusive)
    {
        // prevents rapidly alternating fire modes
        FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[alt].NextFireTime);
    }
	
    if (Instigator.IsLocallyControlled())
    {
        if (FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease)
        {
            FireMode[Mode].PlayPreFire();
        }
        FireMode[Mode].FireCount = 0;
    }
	ClientTraceHit();
    return true;
}

simulated function ClientTraceHit()
{
	local vector Start,End,HitLocation,HitNormal;
	local actor Other;
	local ClientProjectile CP;
	if (Level.TimeSeconds <FireMode[0].NextFireTime) {
		return;
	}
	Start=Location;
	End=Start+40000*vector(Rotation);
	Other=Trace(HitLocation, HitNormal, End, Start, true);
	CP=Spawn(class'ClientProjectile',Instigator.Controller,,Start,Rotation);
	CP.SetOwnerWeapon(self);
	//StopFire(0);
}

simulated function ServerTraceHit(actor Other,vector Start,vector Hit_Location,vector Hit_Normal)
{
	local vector HitLocation,HitNormal;
	local actor Target;
	Other.TakeDamage(100, instigator,Hit_Location,
					 (1000 * Hit_Normal), class'DamTypeClassicSniper' );
	/*
	Target=Trace(HitLocation, HitNormal, Other.Location, Start, true);
	if (Target.Role==ROLE_Authority) {
		Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-HitNormal));
	}
*/
	
}


defaultproperties
{
	
    ItemName="Assault Rifle Proj"
	
	
    FireModeClass(0)=ARClientFire
	
	}
