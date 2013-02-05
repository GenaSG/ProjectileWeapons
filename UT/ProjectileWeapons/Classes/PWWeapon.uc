//=============================================================================
// Main PW Weapon class 
//=============================================================================
class PWWeapon extends Weapon
    abstract;
var() class<DamageType> DamageType;
var bool bADS,bADSZoom,bADSZoomed;
var(FirstPerson) vector ADSPlayerViewOffset;
var int	CenteredPitch;
var float ZoomLevel;
var ADS ADS;

replication
{
	reliable if (Role<ROLE_Authority)
		ServerTraceHit;
}
simulated function PostBeginPlay()
{	
	Super.PostBeginPlay();
	PlayerController(Instigator.Controller).SetWeaponHand("Right");
}

simulated event RenderOverlays( Canvas Canvas )
{
    local int m;
	local vector NewScale3D;
	local rotator CenteredRotation;
	local name AnimSeq;
	local float frame,rate;
	
    if (Instigator == None)
        return;
	
	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;
	
    if ((Hand < -1.0) || (Hand > 1.0))
        return;
	
    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }
	
	if ( (OldMesh != None) && (bUseOldWeaponMesh != (OldMesh == Mesh)) )
	{
		GetAnimParams(0,AnimSeq,frame,rate);
		bInitOldMesh = true;
		if ( bUseOldWeaponMesh )
			LinkMesh(OldMesh);
		else
			LinkMesh(Default.Mesh);
		PlayAnim(AnimSeq,rate,0.0);
	}
	
    if ( (Hand != RenderedHand) || bInitOldMesh )
    {
		newScale3D = Default.DrawScale3D;
		if ( Hand != 0 )
			newScale3D.Y *= Hand;
		SetDrawScale3D(newScale3D);
		SetDrawScale(Default.DrawScale);
		CenteredRoll = Default.CenteredRoll;
		CenteredYaw = Default.CenteredYaw;
		CenteredOffsetY = Default.CenteredOffsetY;
		PlayerViewPivot = Default.PlayerViewPivot;
		SmallViewOffset = Default.SmallViewOffset;
		if ( SmallViewOffset == vect(0,0,0) )
			SmallViewOffset = Default.PlayerviewOffset;
		bInitOldMesh = false;
		if ( Default.SmallEffectOffset == vect(0,0,0) )
			SmallEffectOffset = EffectOffset + Default.PlayerViewOffset - SmallViewOffset;
		else
			SmallEffectOffset = Default.SmallEffectOffset;
		if ( Mesh == OldMesh )
		{
			SmallEffectOffset = EffectOffset + OldPlayerViewOffset - OldSmallViewOffset;
			PlayerViewPivot = OldPlayerViewPivot;
			SmallViewOffset = OldSmallViewOffset;
			if ( Hand != 0 )
			{
				PlayerViewPivot.Roll *= Hand;
				PlayerViewPivot.Yaw *= Hand;
			}
			CenteredRoll = OldCenteredRoll;
			CenteredYaw = OldCenteredYaw;
			CenteredOffsetY = OldCenteredOffsetY;
			SetDrawScale(OldDrawScale);
		}
		else if ( Hand == 0 )
		{
			PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll;
			PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw;
		}
		else
		{
			PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll * Hand;
			PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw * Hand;
		}
		RenderedHand = Hand;
	}
	if ( class'PlayerController'.Default.bSmallWeapons )
		PlayerViewOffset = SmallViewOffset;
	else if ( Mesh == OldMesh )
		PlayerViewOffset = OldPlayerViewOffset;
	else
		PlayerViewOffset = Default.PlayerViewOffset;
	if ( Hand == 0 )
		PlayerViewOffset = default.ADSPlayerViewOffset;
	
    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    if ( Hand == 0 )
    {
		CenteredRotation = Instigator.GetViewRotation();
		CenteredRotation.Yaw += CenteredYaw;
		CenteredRotation.Roll = CenteredRoll;
		CenteredRotation.Pitch += CenteredPitch;
	    SetRotation(CenteredRotation);

    }
    else
	    SetRotation( Instigator.GetViewRotation() );
	
	PreDrawFPWeapon();	// Laurent -- Hook to override things before render (like rotation if using a staticmesh)
	
    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
	//if ( Hand == 0 )
	//	PlayerViewOffset.Y = 0;
	
}
/*
simulated function ClientStartFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = true;
        if( Instigator.Controller.IsA( 'PlayerController' ) )
			ADS.ADSOn();
    }
    else
    {
        Super.ClientStartFire(mode);
    }
}
 */
/*
simulated function ADSOn()
{	
	if (!bADS) {
		PlayerController(Instigator.Controller).SetWeaponHand("Center");
		if (bADSZoom && !bADSZoomed) {
			PlayerController(Instigator.Controller).SetFOV(ZoomLevel);
			bADSZoomed=true;
		}
		bADS=true;
	}
	else
		return;
	
}


simulated function ADSOff()
{
	
	if (bADS) {
		PlayerController(Instigator.Controller).SetWeaponHand("Right");
		if (bADSZoom && bADSZoomed) {
			PlayerController(Instigator.Controller).ResetFOV();
			bADSZoomed=false;
		}
		bADS=false;
	}
	else
		return;
	
}
*/
/*
simulated function ClientStopFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = false;
        if( PlayerController(Instigator.Controller) != None )
			ADS.StopADS();
    }
    else
    {
        Super.ClientStopFire(mode);
    }
}
*/

simulated function ServerTraceHit(actor Other,vector Start,vector Hit_Location,vector Hit_Normal,int Damage, class<DamageType> DamageType)
{
	local vector HitLocation,HitNormal,End;
	local actor Target;
	End=Hit_Location+Other.Location;
	Target=Trace(HitLocation, HitNormal, End, Start, true);
	if (Target==Other) {
		Target.TakeDamage(Damage, instigator,HitLocation,
						 (Damage * HitNormal), DamageType );
	}
	
	
}

defaultproperties
{
	DamageType=class'DamTypeClassicSniper'
	ADSPlayerViewOffset=(X=-13,Y=-9.75,Z=-2)
	CenteredPitch=0
	ZoomLevel=40
}
