//=============================================================================
// Assault Rifle
//=============================================================================
class ARClient extends AssaultRifle
    config(user);
var float FireRate;

replication
{
	// functions called by server on client
    reliable if( Role==ROLE_Authority )
		ClientFire;
	
    // functions called by client on server
    reliable if( Role<ROLE_Authority )
         ServerFire;
}


simulated event ClientStartFire(int Mode)
{
    if ( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
        return;
    if (Role < ROLE_Authority)
    {
        if (StartFire(Mode))
        {
			ClientFire(Mode);
			//StartFire(Mode);
            //ServerStartFire(Mode);
        }
    }
    else
    {
        StartFire(Mode);
    }
}
simulated function Timer()
{
	Super.Timer();
		StopFire(0);
}

simulated function ClientFire(int Mode)
{
	local vector End, HitLocation, HitNormal, Start;
    local Actor Other;
	local Rotator Aim;
	local projectile B;
	Start = Instigator.Location + Instigator.EyePosition();
	Aim = Rotation;
	
	End = Start + 40000 * Vector(Aim);
	settimer(FireRate,false);
	B=Spawn(class'ClientProjectile',,,Start,Aim);
	/*
	Other = Trace(HitLocation, HitNormal, End, Start, true);
	if (Other.Role<ROLE_Authority) {
		Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
		ServerFire(Other,HitLocation,HitNormal);
	}
	*/
}
event ServerFire(Actor Target,vector HitLocation,vector Hitnormal)
{
	local vector End, HitLoc, HitNorm, Start;
	local Actor Other;
	Start = Instigator.Location + Instigator.EyePosition();
	Other = Trace(HitLoc, HitNorm,Target.Location, Start, true);
	if (Other==Target&& Other.Role==ROLE_Authority) {
		Target.TakeDamage(40, Instigator, HitLocation, HitNormal, class'DamTypeAssaultBullet');
		Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
	}

	
}


defaultproperties
{

    ItemName="Assault Rifle Client"
	FireRate=0.16
    FireModeClass(0)=ARClientFire
 
}
