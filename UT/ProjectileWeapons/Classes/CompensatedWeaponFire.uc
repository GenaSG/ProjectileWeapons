class CompensatedWeaponFire extends InstantFire;

var float Speed;
var PlayerController LocalPlayer;
var float Ping, LastFireTime;
var int ShotCount;
var projectile Bullet;




function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;
	
    Instigator.MakeNoise(1.0);
	
    // the to-hit trace always starts right in front of the eye
    StartTrace = Instigator.Location + Instigator.EyePosition();
    Aim = AdjustAim(StartTrace, AimError);
	
	if ( Level.TimeSeconds - LastFireTime > Default.FireRate*2 ){
		Spread = Default.Spread;
		ShotCount=0;
	}
	else
	{
		ShotCount++;
		Spread = Spread*ShotCount;
		if (Spread > 5*Default.Spread) {
			Spread=5*Default.Spread;
		}
		
	}
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
	LastFireTime = Level.TimeSeconds;
}

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

defaultproperties
{
	Speed=20000
	ProjectileClass=class'CompensatedProjectile';
	
	
	AmmoClass=class'ClassicSniperAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeClassicSniper'
    DamageMin=60
    DamageMax=60
	ShakeOffsetMag=(X=-15.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=-4000.0,Y=0.0,Z=4000.0)
    ShakeOffsetTime=1.6
    ShakeRotMag=(X=-15.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=-4000.0,Y=0.0,Z=4000.0)
    ShakeRotTime=2

}
