//=============================================================================
// Assault Rifle
//=============================================================================
class PWAssaultRifle extends PWWeapon
config(user);


var transient float LastFOV,ADSZoomLevel;
var() bool zoomed;
var color ChargeColor;


simulated function ClientWeaponThrown()
{
    if( (Instigator != None) && (PlayerController(Instigator.Controller) != None) )
        PlayerController(Instigator.Controller).EndZoom();
    Super.ClientWeaponThrown();
}

simulated function IncrementFlashCount(int Mode)
{
	if ( Mode == 1 )
		return;
	Super.IncrementFlashCount(Mode);
}



simulated function BringUp(optional Weapon PrevWeapon)
{
    if ( PlayerController(Instigator.Controller) != None )
        LastFOV = PlayerController(Instigator.Controller).DesiredFOV;
    Super.BringUp(PrevWeapon);
}

simulated function bool PutDown()
{
    if( Instigator.Controller.IsA( 'PlayerController' ) )
        PlayerController(Instigator.Controller).EndZoom();
    if ( Super.PutDown() )
		return true;
	return false;
}

// AI Interface
function float SuggestAttackStyle()
{
    return -0.4;
}

function float SuggestDefenseStyle()
{
    return 0.2;
}

/* BestMode()
 choose between regular or alt-fire
 */
function byte BestMode()
{
	return 0;
}

function float GetAIRating()
{
	local Bot B;
	local float ZDiff, dist, Result;
	
	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;
	if ( B.IsShootingObjective() )
		return AIRating - 0.15;
	if ( B.Enemy == None )
	{
		if ( (B.Target != None) && VSize(B.Target.Location - B.Pawn.Location) > 8000 )
			return 0.78;
		return AIRating;
	}
	
	if ( B.Stopped() )
		result = AIRating + 0.1;
	else
		result = AIRating - 0.1;
	if ( Vehicle(B.Enemy) != None )
		result -= 0.2;
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff < -200 )
		result += 0.1;
	dist = VSize(B.Enemy.Location - Instigator.Location);
	if ( dist > 2000 )
	{
		if ( !B.EnemyVisible() )
			result = result - 0.15;
		return ( FMin(2.0,result + (dist - 2000) * 0.0002) );
	}
	if ( !B.EnemyVisible() )
		return AIRating - 0.1;
	
	return result;
}


function bool RecommendRangedAttack()
{
	local Bot B;
	
	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return true;
	
	return ( VSize(B.Enemy.Location - Instigator.Location) > 2000 * (1 + FRand()) );
}
// end AI Interface

simulated function bool WantsZoomFade()
{
	return true;
}

defaultproperties
{
    SelectAnimRate=+0.75
	BringUpTime=+0.6
	MinReloadPct=+0.5
    PutDownAnimRate=0.78
	PutDownTime=+0.58
	
	Description="Inexpensive and easily produced, the AR770 provides a lightweight 5.56mm combat solution that is most effective against unarmored foes. With low-to-moderate armor penetration capabilities, this rifle is best suited to a role as a light support weapon.|The optional M355 Grenade Launcher provides the punch that makes this weapon effective against heavily armored enemies.  Pick up a second assault rifle to double your fire power."
	HighDetailOverlay=Material'UT2004Weapons.WeaponSpecMap2'
    ItemName="Assault Rifle TEST"
    IconMaterial=Material'HudContent.Generic.HUD'
    IconCoords=(X1=420,Y1=180,X2=512,Y2=210)
	
    FireModeClass(0)=PWAssaultFire
    FireModeClass(1)=ADS
    InventoryGroup=2
	
    Mesh=mesh'NewWeapons2004.AssaultRifle'
    BobDamping=2.3
	PickupClass=class'PWAssaultRiflePickup'
    EffectOffset=(X=100,Y=28,Z=-19)
	
    DrawScale=0.8
    PlayerViewOffset=(X=4,Y=5.5,Z=-6)
	ADSPlayerViewOffset=(X=-13,Y=-9.65,Z=-2)
	ADSZoomLevel=10
    SmallViewOffset=(X=13,Y=12,Z=-10)
	
    PutDownAnim=PutDown
    IdleAnim=Idle
    SelectAnim=PickUp
    DisplayFOV=70
	
	ChargeColor=(R=255,G=255,B=255,A=255)
	
    AttachmentClass=class'AssaultAttachment'
    SelectSound=Sound'WeaponSounds.AssaultRifle.SwitchToAssaultRifle'
	zoomed=false
	SelectForce="SwitchToAssaultRifle"
	
    bSniping=false
	AIRating=+0.69
	CurrentRating=+0.69
	
    bDynamicLight=false
    LightType=LT_Steady
    LightEffect=LE_NonIncidence
    LightPeriod=3
    LightBrightness=255
    LightHue=30
    LightSaturation=170
    LightRadius=5
    HudColor=(r=185,g=170,b=255,a=255)
	CustomCrosshair=0
	CustomCrosshairTextureName="Crosshairs.Hud.Crosshair_Cross1"
	CustomCrosshairColor=(r=185,g=170,b=255,a=255)
	
	Priority=3
	
	CenteredOffsetY=0
	CenteredYaw=0
	GroupOffset=0
    CenteredRoll=0
	CullDistance=+5000.0
	}
/*
defaultproperties
{
	Description="Inexpensive and easily produced, the AR770 provides a lightweight 5.56mm combat solution that is most effective against unarmored foes. With low-to-moderate armor penetration capabilities, this rifle is best suited to a role as a light support weapon.|The optional M355 Grenade Launcher provides the punch that makes this weapon effective against heavily armored enemies.  Pick up a second assault rifle to double your fire power."
	HighDetailOverlay=Material'UT2004Weapons.WeaponSpecMap2'
    ItemName="Assault Rifle TEST"
    IconMaterial=Material'HudContent.Generic.HUD'
    IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
	
	bShowChargingBar=true
    bCanThrow=true
    FireModeClass(0)=CSAF
    FireModeClass(1)=AssaultGrenade
    InventoryGroup=2
    Mesh=mesh'NewWeapons2004.AssaultRifle'
    BobDamping=1.7
    PickupClass=class'AssaultRiflePickup'
    EffectOffset=(X=100.0,Y=25.0,Z=-10.0)
    PutDownAnim=PutDown
    DisplayFOV=70
    AttachmentClass=class'AssaultAttachment'
	
    DrawScale=0.8
    PlayerViewOffset=(X=4,Y=5.5,Z=-6)
    SmallViewOffset=(X=13,Y=12,Z=-10)
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
    SelectSound=Sound'WeaponSounds.AssaultRifle.SwitchToAssaultRifle'
	SelectForce="SwitchToAssaultRifle"
	
	AIRating=+0.4
    CurrentRating=0.4
	
    bDynamicLight=false
    LightType=LT_Pulse
    LightEffect=LE_NonIncidence
    LightPeriod=3
    LightBrightness=255
    LightHue=30
    LightSaturation=150
    LightRadius=4.0
	
	Priority=3
    HudColor=(r=255,g=128,b=192,a=255)
	CustomCrosshair=4
	CustomCrosshairTextureName="Crosshairs.Hud.Crosshair_Cross5"
	CustomCrosshairColor=(r=255,g=255,b=255,a=255)
	CustomCrosshairScale=+0.6667
	
    CenteredRoll=3000
    CenteredOffsetY=-5.0
    CenteredYaw=-1500
    OldDrawScale=1.0
    OldPlayerViewOffset=(X=-8,Y=5,Z=-6)
    OldSmallViewOffset=(X=4,Y=11,Z=-12)
    OldPlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)
	OldCenteredRoll=3000
	OldCenteredYaw=0
	OldCenteredOffsetY=+0.0
	OldMesh=mesh'Weapons.AssaultRifle_1st'
	OldPickup="WeaponStaticMesh.AssaultRiflePickup"
	}*/
