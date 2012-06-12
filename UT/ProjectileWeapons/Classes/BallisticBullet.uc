class BallisticBullet extends Projectile;


var xEmitter Trail;
var byte Bounces;
var float DamageAtten, BounceFactor, RebounceSpeed, HeadShotHeight, HeadShotDamageFactor;
var sound ImpactSounds[6];
var class<xEmitter> HitEffectClass;
var class<xEmitter> TrailEffect;
var class<DamageType> HeadDamageType;
var bool bExplode, bHeadShots;

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

    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(TrailEffect,self);
            Trail.Lifespan = Lifespan;
        }
            
    }

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();
    if (r > BounceFactor)
        Bounces = 1;
    else
        Bounces = 0;

    SetRotation(RotRand());

    Super.PostBeginPlay();
	SetPhysics(PHYS_Falling);
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    if ( (FlakChunk(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
    {
        speed = VSize(Velocity);
        if ( speed > 200 )
        {
            if ( Role == ROLE_Authority )
        	{
           	 if ( Other.IsA('Pawn') && (HitLocation.Z - Other.Location.Z > HeadShotHeight * Other.CollisionHeight) && bHeadShots )
                Other.TakeDamage(HeadShotDamageFactor * damage, instigator,HitLocation,
                    (MomentumTransfer * Normal(Velocity)), HeadDamageType );
            else             
                Other.TakeDamage(damage, instigator,HitLocation,
                    (MomentumTransfer * Normal(Velocity)), MyDamageType );
        	}
        }
	HitOrExplode(Location,Normal(HitLocation-Other.Location));
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
    SetPhysics(PHYS_None);
	Destroy();
}

simulated function HitWall( vector HitNormal, actor Wall )
{
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


	HitOrExplode(Location,HitNormal);
	
    SetPhysics(PHYS_Falling);
	if (Bounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(6)]);

        Velocity = RebounceSpeed * (Velocity - 2.0*HitNormal*(Velocity dot HitNormal));
        Bounces = Bounces - 1;
        return;
    }
	bBounce = false;
    if (Trail != None) 
    {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
    }
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

function BlowUp(vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	MakeNoise(1.0);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController PC;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	Spawn(class'NewExplosionA',,,HitLocation + HitNormal*20,rotator(HitNormal));
    	PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 5000 )
	        Spawn(class'ExplosionCrap',,, HitLocation + HitNormal*20, rotator(HitNormal));
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
    }

	BlowUp(HitLocation);
	Destroy();
}

simulated function HitOrExplode(vector HitLocation, vector HitNormal)
{
	if (bExplode)
	{
		Explode(Location,HitNormal);
	}
	else
	{
		Spawn(HitEffectClass,,, Location, Rotator(HitNormal));	
		if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
			Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	}
}

defaultproperties
{
	Bounces=1
	HeadDamageType=Class'XWeapons.DamTypeSniperHeadShot'
	HeadShotDamageFactor=2.0
	HeadShotHeight=0.62
	bExplode=False
	bHeadShots=True
	HitEffectClass=Class'XEffects.WallSparks'
	ExplosionDecal=Class'XEffects.BulletDecal'
	TrailEffect=class'FlakTrail'
	BounceFactor=0.75
	RebounceSpeed=0.065
	DamageAtten=5.000000
	ImpactSounds(0)=Sound'XEffects.Impact4Snd'
	ImpactSounds(1)=Sound'XEffects.Impact6Snd'
	ImpactSounds(2)=Sound'XEffects.Impact7Snd'
	ImpactSounds(3)=Sound'XEffects.Impact3'
	ImpactSounds(4)=Sound'XEffects.Impact1'
	ImpactSounds(5)=Sound'XEffects.Impact2'
	Speed=30000.000000
	MaxSpeed=50000.000000
	Damage=30.000000
	DamageRadius=200
	MomentumTransfer=10000.000000
	MyDamageType=Class'XWeapons.DamTypeFlakChunk'
	DrawType=DT_StaticMesh
	CullDistance=3000.000000
	LifeSpan=2.700000
	DrawScale=14.000000
	AmbientGlow=254
	Style=STY_Alpha
	bBounce=True
}
