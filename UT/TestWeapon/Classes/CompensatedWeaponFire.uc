class CompensatedWeaponFire extends InstantFire;

var float Speed;
var PlayerController LocalPlayer;
var float Ping;
var projectile Bullet;



simulated function DoTrace(Vector Start, Rotator Dir)
{
    local vector X,End, HitLocation, HitNormal;
    local Actor Other;
	local int TracerRange;

	Ping = Instigator.PlayerReplicationInfo.ping;
	if (Ping > 0) {
		TracerRange=Ping*Speed/2000;
		X = Vector(Dir+Instigator.RotationRate*Ping/2000);
	}
	else
	{
		X = Vector(Dir);
		TracerRange=1;
	}
	Start=Start + Instigator.Velocity*Ping/2000;
    End = Start + TracerRange * X;
    Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

	if (Other==None) {
		HitLocation = End;
        HitNormal = Normal(Start - End);
	}
	Bullet=SpawnProjectile(HitLocation,Dir);
	Bullet.Velocity=Vector(Dir)*Speed;
	Bullet.Damage=DamageMax;

}


function projectile SpawnProjectile(Vector Start, rotator Dir)
{
	local projectile B;
	B=Weapon.Spawn(ProjectileClass,Instigator.Controller,,Start,Dir);
	return B;
}

defaultproperties
{
	Speed=20000
	ProjectileClass=class'CompensatedProjectile';
	
	
	AmmoClass=class'ClassicSniperAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeClassicSniper'
    DamageMin=60
    DamageMax=60

}
