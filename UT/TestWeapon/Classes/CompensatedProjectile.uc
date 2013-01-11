
class CompensatedProjectile extends Projectile;

var xEmitter Trail;
var byte Bounces;
var float DamageAtten,HeadShotHeight;
var sound ImpactSounds[6];
var() float HeadShotDamageMult;
var() class<DamageType> DamageTypeHeadShot;
var vector StartSpeed;
var bool bHeadShots;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function Destroyed()
{
    if (Trail !=None) Trail.mRegen=False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;
	StartSpeed=Velocity;
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'FlakTrail',self);
            Trail.Lifespan = Lifespan;
        }
		
    }
	SetPhysics(PHYS_Falling);
    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;
	
    r = FRand();
    if (r > 0.75)
        Bounces = 2;
    else if (r > 0.25)
        Bounces = 1;
    else
        Bounces = 0;
	
    SetRotation(RotRand());
	
    Super.PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local vector X;
	X = Normal(Velocity);
	if ( Other != None && (Other != Instigator) )
    {
        if ( !Other.bWorldGeometry )
        {

           	 if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > HeadShotHeight * Other.CollisionHeight) && bHeadShots )
                Other.TakeDamage(HeadShotDamageMult * damage, instigator,HitLocation,
                    (MomentumTransfer * Normal(Velocity)), DamageTypeHeadShot );
            else             
                Other.TakeDamage(damage, instigator,HitLocation,
                    (MomentumTransfer * Normal(Velocity)), MyDamageType );
        
		}
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
	Destroy();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	local projectile Rico;
	Velocity = Velocity*0.65;
	if (VSize(Velocity) > VSize(StartSpeed/2)) {
		Spawn(class'SniperWallHitEffect',,, Location, rotator(-1 * HitNormal));
	}
    if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }
	
	if (Bounces > 0 && (Velocity dot HitNormal) <0.5)
    {
		Rico=Spawn(class'FlakChunk',,,Location,rotator(-1 * HitNormal));
        Rico.Velocity = 0.65 * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
		Rico.SetPhysics(PHYS_Falling);
		Rico.LifeSpan=0.5;
		Destroy();
        return;
    }

	bBounce = true;
    if (Trail != None)
    {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
    }
		Destroy();
}


simulated function PhysicsVolumeChange( PhysicsVolume Volume )
{
    if (Volume.bWaterVolume)
    {
        if ( Trail != None )
            Trail.mRegen=False;
        Velocity *= 0.65;
    }
}

defaultproperties
{
	HeadShotDamageMult=2.0
	DamageTypeHeadShot=class'DamTypeClassicHeadShot'
	HeadShotHeight=0.62
    Style=STY_Alpha
    ScaleGlow=1.0
	bHeadShots=true
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
    MyDamageType=class'DamTypeFlakChunk'
	FluidSurfaceShootStrengthMod=1.f
    speed=2500.000000
    MaxSpeed=2700.000000
    Damage=13
    DamageAtten=5.0 // damage reduced per second from when the chunk was fired
    MomentumTransfer=1
    LifeSpan=2.7
    bBounce=true
    Bounces=1
    NetPriority=2.500000
    AmbientGlow=254
    DrawScale=1.0
    CullDistance=+3000.0
	ImpactSounds(0)=sound'XEffects.Impact4Snd'
	ImpactSounds(1)=sound'XEffects.Impact6Snd'
	ImpactSounds(2)=sound'XEffects.Impact7Snd'
	ImpactSounds(3)=sound'XEffects.Impact3'
	ImpactSounds(4)=sound'XEffects.Impact1'
	ImpactSounds(5)=sound'XEffects.Impact2'
	}
