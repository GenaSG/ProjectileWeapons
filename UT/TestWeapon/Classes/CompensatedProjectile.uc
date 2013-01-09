
class CompensatedProjectile extends Projectile;

var xEmitter Trail;
var byte Bounces;
var float DamageAtten;
var sound ImpactSounds[6];
var() float HeadShotDamageMult;
var() class<DamageType> DamageTypeHeadShot;
var SniperWallHitEffect S;
var vector StartSpeed;

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
	local Pawn HeadShotPawn;
	X = Normal(Velocity);
	if ( Other != None && (Other != Instigator) )
    {
        if ( !Other.bWorldGeometry )
        {
            if (Vehicle(Other) != None)
                HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);
			
            if (HeadShotPawn != None)
                HeadShotPawn.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer*X, DamageTypeHeadShot);
 			else if ( (Pawn(Other) != None) && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
                Other.TakeDamage(Damage * HeadShotDamageMult, Instigator, HitLocation, MomentumTransfer*X, DamageTypeHeadShot);
            else
                Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer*X, MyDamageType);
        }
		/*
        else
			HitLocation = HitLocation + 2.0 * HitNormal;
    }
    else
    {
        HitLocation = End;
        HitNormal = Normal(Start - End);
    }
	
    if ( (HitNormal != Vect(0,0,0)) && (HitScanBlockingVolume(Other) == None) )
    {
		S = Weapon.Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
		if ( S != None )
			S.FireStart = Start;
	}
	*/
/*
    if ( (FlakChunk(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
    {
        speed = VSize(Velocity);
        if ( speed > 200 )
        {
            if ( Role == ROLE_Authority )
			{
				if ( Instigator == None || Instigator.Controller == None )
					Other.SetDelayedDamageInstigatorController( InstigatorController );
				
                Other.TakeDamage( Max(5, Damage - DamageAtten*FMax(0,(default.LifeSpan - LifeSpan - 1))), Instigator, HitLocation,
								 (MomentumTransfer * Velocity/speed), MyDamageType );
			}
        }*/
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
/*
	if (VSize(Velocity) > VSize(StartSpeed/2)) {
		S = Spawn(class'SniperWallHitEffect',,, Location, rotator(-1 * HitNormal));
	}
*/
	Destroy();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	local projectile Rico;
	Velocity = Velocity*0.65;
	if (VSize(Velocity) > VSize(StartSpeed/2)) {
		S = Spawn(class'SniperWallHitEffect',,, Location, rotator(-1 * HitNormal));
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
	
	if (Bounces > 0)
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
    Style=STY_Alpha
    ScaleGlow=1.0
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
    MyDamageType=class'DamTypeFlakChunk'
	FluidSurfaceShootStrengthMod=1.f
    speed=2500.000000
    MaxSpeed=2700.000000
    Damage=13
    DamageAtten=5.0 // damage reduced per second from when the chunk was fired
    MomentumTransfer=10000
    LifeSpan=2.7
    bBounce=true
    Bounces=1
    NetPriority=2.500000
    AmbientGlow=254
    DrawScale=14.0
    CullDistance=+3000.0
	ImpactSounds(0)=sound'XEffects.Impact4Snd'
	ImpactSounds(1)=sound'XEffects.Impact6Snd'
	ImpactSounds(2)=sound'XEffects.Impact7Snd'
	ImpactSounds(3)=sound'XEffects.Impact3'
	ImpactSounds(4)=sound'XEffects.Impact1'
	ImpactSounds(5)=sound'XEffects.Impact2'
	}
