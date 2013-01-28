class CP extends Projectile;

var xEmitter Trail;
var CSAR Actors_Gun;

simulated function Destroyed()
{
    if ( Trail !=None )
		Trail.mRegen=False;
	Super.Destroyed();
}

simulated function bool CanSplash()
{
	return (bReadyToSplash && (Level.NetMode != NM_Standalone));
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	local vector Dir,LinePos,LineDir, OldLocation;
/*
	if ( (Level.NetMode == NM_Client) && (Level.GetLocalPlayerController() == Owner) )
	{
		Destroy();
		return;
	}
*/
    if ( Level.NetMode != NM_DedicatedServer )
    {
        if ( !PhysicsVolume.bWaterVolume )
        {
            Trail = Spawn(class'FlakTrail',self);
            Trail.Lifespan = Lifespan;
        }
    }
    Velocity = Vector(Rotation) * (Speed);
    Super.PostNetBeginPlay();
	
 	// see if local player controller near bullet, but missed
	PC = Level.GetLocalPlayerController();
	if ( (PC != None) && (PC.Pawn != None) )
	{
		Dir = Normal(Velocity);
		LinePos = (Location + (Dir dot (PC.Pawn.Location - Location)) * Dir);
		LineDir = PC.Pawn.Location - LinePos;
		if ( VSize(LineDir) < 150 )
		{
			OldLocation = Location;
			SetLocation(LinePos);
			if ( FRand() < 0.5 )
				PlaySound(sound'Impact3Snd',,,,80);
			else
				PlaySound(sound'Impact7Snd',,,,80);
			SetLocation(OldLocation);
		}
	}
}

simulated function Touch(Actor Other)
{
	if (Other.Role<ROLE_Authority) {
		Actors_Gun.ServerTraceHit(Other,Location,Location,Normal(Velocity));
	}

}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
}

simulated function Landed( Vector HitNormal )
{
    Destroy();
}

simulated function SetOwnerWeapon(CSAR Gun)
{
	Actors_Gun=Gun;
	
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	
    Destroy();
}

defaultproperties
{
    Style=STY_Alpha
    ScaleGlow=1.0
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
    speed=20000.000000
    MaxSpeed=20000.000000
    LifeSpan=2.0
    NetPriority=2.500000
    DrawScale=5.0
	bReplicateInstigator=true
	bOwnerNoSee=true
	Physics=PHYS_Projectile
	bNetTemporary=false
	bReplicateMovement=true
	bAlwaysRelevant=true
	bTearOff=false
	}
