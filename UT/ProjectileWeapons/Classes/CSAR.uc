//=============================================================================
// Assault Rifle
//=============================================================================
class CSAR extends AssaultRifle
    config(user);

replication
{
	reliable if (Role<ROLE_Authority)
		ServerTraceHit;
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
    ItemName="Assault Rifle TEST"
    FireModeClass(0)=CSAF

}
