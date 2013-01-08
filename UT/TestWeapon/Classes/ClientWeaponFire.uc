class ClientWeaponFire extends InstantFire;

var float Speed;
var PlayerController LocalPlayer;
var float Ping;
var array<GameInfo.PlayerResponseLine>  Players;
var projectile Bullet;

var() float HeadShotDamageMult;
var() class<DamageType> DamageTypeHeadShot;
var name FireAnims[3];


function PostBeginPlay()
{
	Super.PostBeginPlay();
}


event ModeDoFire()
{
	Super.ModeDoFire();
}

simulated function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X,Y,Z, End, HitLocation, HitNormal, ArcEnd;
    local Actor Other;
    local Pawn HeadShotPawn;
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
	
    X = Vector(Dir);
	Ping = Instigator.PlayerReplicationInfo.ping;
	if (Ping > 0) {
		TracerRange=Ping*Speed/1000;
	}
	else
	{
		TracerRange=1;
	}
	Start=Start + Instigator.Velocity*Ping/1000;
    End = Start + TracerRange * X;
    Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
    if ( Other != None && (Other != Instigator) )
    {
        if ( !Other.bWorldGeometry )
        {
            if (Vehicle(Other) != None)
                HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);
			
            if (HeadShotPawn != None)
                HeadShotPawn.TakeDamage(DamageMax * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
 			else if ( (Pawn(Other) != None) && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
                Other.TakeDamage(DamageMax * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
            else
                Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
        }
        else
			HitLocation = HitLocation + 2.0 * HitNormal;
    }
    else
    {
        HitLocation = End;
        HitNormal = Normal(Start - End);
    }
	SpawnProjectile(HitLocation,Dir);
}


function projectile SpawnProjectile(Vector Start, rotator Dir)
{
	local projectile B;
	B=Weapon.Spawn(ProjectileClass,Instigator.Controller,,Start,Dir);
	B.Velocity=Vector(Dir)*Speed;
	B.Damage=DamageMax;
	return B;
}

function projectile ServerSpawnProjectile(projectile B)
{
	local projectile P;
	Spawn(ProjectileClass,Instigator.Controller,,B.Location,B.Rotation);
	B.Destroy();
	return P;
}
defaultproperties
{
	Speed=20000
	ProjectileClass=class'ClientProjectile';
	
	
	AmmoClass=class'ClassicSniperAmmo'
    AmmoPerFire=1
    DamageType=class'DamTypeClassicSniper'
    DamageTypeHeadShot=class'DamTypeClassicHeadShot'
    DamageMin=60
    DamageMax=60
    FireSound=Sound'NewWeaponSounds.NewSniperShot'
    FireForce="NewSniperShot"  // jdf
    TraceRange=17000
    FireRate=1.33
	FireAnimRate=1.5
	
    FlashEmitterClass=class'XEffects.AssaultMuzFlash1st'
	
    BotRefireRate=0.4
    AimError=850
	WarnTargetPct=+0.5
	
    HeadShotDamageMult=2.0
	
    ShakeOffsetMag=(X=-15.0,Y=0.0,Z=10.0)
    ShakeOffsetRate=(X=-4000.0,Y=0.0,Z=4000.0)
    ShakeOffsetTime=1.6
    ShakeRotMag=(X=0.0,Y=0.0,Z=0.0)
    ShakeRotRate=(X=0.0,Y=0.0,Z=0.0)
    ShakeRotTime=2
	
    FireAnims(0)=Fire1
    FireAnims(1)=Fire2
    FireAnims(2)=Fire3
}
