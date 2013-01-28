class CSWF extends WeaponFire;

var class<DamageType> DamageType;
var int DamageMin, DamageMax;
var float TraceRange;
var float Momentum;


function float MaxRange()
{
    if (Instigator.Region.Zone.bDistanceFog)
        TraceRange = FClamp(Instigator.Region.Zone.DistanceFogEnd, 8000, default.TraceRange);
    else
    	TraceRange = default.TraceRange;

	return TraceRange;
}

function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;

    Instigator.MakeNoise(1.0);

    // the to-hit trace always starts right in front of the eye
    StartTrace = Instigator.Location + Instigator.EyePosition();
    Aim = AdjustAim(StartTrace, AimError);
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
}


event ModeDoFire()
{
	Super.ModeDoFire();
    // client
    if (Instigator.IsLocallyControlled())
    {
		ClientFire();
    }
    else // server
    {
//        ServerPlayFiring();
    }
}

function ClientFire()
{
	local vector Start;
	local CP CP;
	local Coords C;
	local rotator Dir;
	C=CSAR(Weapon).GetBoneCoords('tip');
	Start=C.Origin;
	Dir=CSAR(Weapon).GetBoneRotation( 'tip' );
	CP=Spawn(class'CP',Instigator.Controller,,Start,Dir);
	CP.SetOwnerWeapon(CSAR(Weapon));
	//StopFire(0);
	
}

function ShakeView()
{
    local PlayerController P;
	
    P = PlayerController(Instigator.Controller);
    if ( P != None )
        P.WeaponShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime,
						  ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
}

function DoTrace(Vector Start, Rotator Dir)
{

}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
}

defaultproperties
{
	Momentum=1
    TraceRange=10000
    NoAmmoSound=Sound'WeaponSounds.P1Reload5'
	bInstantHit=true
	ShakeOffsetMag=(X=0,Y=0,Z=0)
    ShakeOffsetRate=(X=0,Y=0,Z=0)
    ShakeOffsetTime=0
    ShakeRotMag=(X=0,Y=0,Z=0)
    ShakeRotRate=(X=0,Y=0,Z=0)
    ShakeRotTime=0
}
