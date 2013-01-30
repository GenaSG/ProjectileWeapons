//=============================================================================
// Main PW Weapon class 
//=============================================================================
class PWWeapon extends Weapon
    config(user);
var() class<DamageType> DamageType;

replication
{
	reliable if (Role<ROLE_Authority)
		ServerTraceHit;
}

simulated function ServerTraceHit(actor Other,vector Start,vector Hit_Location,vector Hit_Normal,int Damage, class<DamageType> DamageType)
{
	local vector HitLocation,HitNormal,End;
	local actor Target;
	End=Hit_Location+Other.Location;
	Target=Trace(HitLocation, HitNormal, End, Start, true);
	if (Target==Other) {
		Other.TakeDamage(Damage, instigator,HitLocation,
						 (1000 * HitNormal), DamageType );
	}
	
	
}

defaultproperties
{
	DamageType=class'DamTypeClassicSniper'
}
