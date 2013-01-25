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
			ClientTraceHit();
			//FireMode[0].ClientTraceHit(Location,Rotation);
            ServerStartFire(Mode);
        }
    }
    else
    {
        StartFire(Mode);
    }
}
simulated function ClientTraceHit()
{
	local vector Start,End,HitLocation,HitNormal;
	local actor Other;
	local ClientProjectile CP;
	Start=Location;
	End=Start+40000*vector(Rotation);
	Other=Trace(HitLocation, HitNormal, End, Start, true);
	CP=Spawn(class'ClientProjectile',Instigator.Controller,,Start,Rotation);
	CP.Test(self);
//	if (Other.Role<ROLE_Authority) {
		//Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-HitNormal));
//		ServerTraceHit(Other,Start,HitLocation,HitNormal);
//	}
}

simulated function ServerTraceHit(actor Other,vector Start,vector Hit_Location,vector Hit_Normal)
{
	local vector HitLocation,HitNormal;
	local actor Target;
	Other.TakeDamage(40, instigator,Hit_Location,
					 (-1000 * Hit_Normal), class'DamTypeClassicSniper' );
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
