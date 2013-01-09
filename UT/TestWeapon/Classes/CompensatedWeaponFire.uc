class CompensatedWeaponFire extends InstantFire;

var float Speed;
var PlayerController LocalPlayer;
var float Ping;
var projectile Bullet;



function PostBeginPlay()
{
	Super.PostBeginPlay();
}


event ModeDoFire()
{
	Super.ModeDoFire();
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
	local int TracerRange;
	
    Weapon.GetViewAxes(X, Y, Z);
    if ( Weapon.WeaponCentered() )
        ArcEnd = (Instigator.Location +
				  Weapon.EffectOffset.X * X +
				  1.5 * Weapon.EffectOffset.Z * Z);
	else
        ArcEnd = (Instigator.Location +
				  Instigator.CalcDrawOffset(Weapon) +
				  Weapon.EffectOffset.X * X +
				  Weapon.Hand * Weapon.EffectOffset.Y * Y +
				  Weapon.EffectOffset.Z * Z);
	

	Ping = Instigator.PlayerReplicationInfo.ping;
	if (Ping > 0) {
		TracerRange=Ping*Speed/1000;
		X = Vector(Dir+Instigator.RotationRate*Ping);
	}
	else
	{
		TracerRange=1;
	}
	X = Vector(Dir);
	Start=Start + Instigator.Velocity*Ping/1000;
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
