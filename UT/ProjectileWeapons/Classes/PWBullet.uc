class PWBullet extends Projectile;

var xEmitter Trail;
var byte Bounces;
var PWWeapon Actors_Gun;
var int DamageMin, DamageMax, MaxDamageRange, MinDamageRange;
var vector Start;
var sound ImpactSounds[6];
var() float HeadShotDamageMult,HeadShotHeight;
var() class<DamageType> DamageTypeHeadShot;
var bool bHeadShots;



simulated function Destroyed()
{
    if (Trail !=None) Trail.mRegen=False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
    local float r;
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

simulated function Timer()
{
	Super.Timer();
	
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local int Damage, DamageDiff,DistanceDiff,Distance;
	local vector LocationDiff;
	Distance=VSize(Start-Location);
	if (Other==self || Other==Instigator) {
		return;
	}
	
	
	if ( Other != None && (Other != Instigator) )
    {
        if ( !Other.bWorldGeometry )
        {
			
			if (Distance <= MaxDamageRange) {
				Damage=DamageMax;
			}
			else if ((Distance>MaxDamageRange) && (Distance<MinDamageRange) )
			{
				DamageDiff=DamageMax-DamageMin;
				DistanceDiff=MinDamageRange-MaxDamageRange;
				Damage=DamageMax-DamageDiff * (Distance-MaxDamageRange)/DistanceDiff;
				
			}
			else
			{
				Damage=DamageMin;
			}
			
			if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > HeadShotHeight * Other.CollisionHeight) && bHeadShots ){
				Damage*=HeadShotDamageMult;
				MyDamageType=DamageTypeHeadShot;
			}
		}
		
		//if (Other.Role<ROLE_Authority) {
		LocationDiff=Location-Other.Location;
		Actors_Gun.ServerTraceHit(Other,Start,LocationDiff,Normal(Velocity),Damage,MyDamageType);
		//}
		//Destroy();
        Destroy();
    }

}


simulated function SetOwnerWeapon(PWWeapon Gun)
{
	Actors_Gun=Gun;
	
}

simulated function Landed( Vector HitNormal )
{
	Destroy();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	local projectile Rico;
	local float VectorDot;
	VectorDot=Normal(Vector(Rotation)) dot HitNormal;
	Spawn(class'SniperWallHitEffect',,, Location, rotator(-1 * HitNormal));
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
	
	if ((Bounces > 0) && (VectorDot> 0.8))
    {
		Rico=Spawn(class'FlakChunk',,,Location,rotator(-1 * HitNormal));
		Rico.Damage=DamageMin*0.65;
        Rico.Velocity = 0.65 * (Velocity - 2.0*HitNormal*(VectorDot));
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
	HeadShotHeight=0.75
    Style=STY_Alpha
    ScaleGlow=1.0
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
	FluidSurfaceShootStrengthMod=1.f
    speed=2500.000000
    MaxSpeed=0
    Damage=13
    MomentumTransfer=1
    LifeSpan=2.7
	bHeadShots=true
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
