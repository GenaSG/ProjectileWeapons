class ClientWeaponFire extends InstantFire;

var float Speed;
var PlayerController LocalPlayer;
var float Ping;
var projectile Bullet;

/*
replication
{
	
	reliable if (Weapon.Role==ROLE_Authority)
		ClientFire;
	
	reliable if (Weapon.Role<ROLE_Authority)
		ServerFire;

}
 */
/*
function PostBeginPlay()
{
	ClientFire();
}
*/
/*
event ModeDoFire()
{
	Super.ModeDoFire();
	ClientFire();
}
 */
/*
function DoFireEffect()
{
	ClientFire();

}

function PlayFiring()
{
	super.PlayFiring();
	ClientFire();
}
*/
/*
simulated function ClientFire()
{
	local vector End, HitLocation, HitNormal, Start;
    local Actor Other;
	local Rotator Aim;
	Start = Instigator.Location + Instigator.EyePosition();
	Aim = AdjustAim(Start, AimError);
	
	End = Start + 40000 * Vector(Aim);
	Other = Trace(HitLocation, HitNormal, End, Start, true);
	if (Other.Role<ROLE_Authority) {
		Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
		ServerFire(Other);
	}
	//ServerFire(Other,HitLocation,HitNormal);
}
 */
/*
event ServerFire(Actor Target)
{
	local vector End, HitLocation, HitNormal, Start;
	local Actor Other;
//	if (Weapon.Role==ROLE_Authority) {
		Start = Instigator.Location + Instigator.EyePosition();
		Other = Trace(HitLocation, HitNormal, Target.Location, Start, true);
		Other.TakeDamage(40, Instigator, HitLocation, HitNormal, class'DamTypeAssaultBullet');
		Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
//	}

	
}
 */
simulated function DoTrace(Vector Start, Rotator Dir)
{
	
}

/*
simulated function DoTrace(Vector Start, Rotator Dir)
{
    local vector X,End, HitLocation, HitNormal;
    local Actor Other;
	local int TracerRange;

	Ping = Instigator.PlayerReplicationInfo.ping;
	if (Ping > 0) {
		TracerRange=Ping*Speed/2000;
	//	X = Vector(Dir+Instigator.RotationRate*Ping/2000);
	}
	else
	{
	//	X = Vector(Dir);
		TracerRange=1;
	}
	X = Vector(Dir);
	//Start=Start + Instigator.Velocity*Ping/2000;
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
*/
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
