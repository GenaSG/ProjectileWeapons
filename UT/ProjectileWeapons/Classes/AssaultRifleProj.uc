class AssaultRifleProj extends AssaultRifle;
 
//=============================================================================

var transient float LastFOV;
var() bool zoomed;
var color ChargeColor;

simulated function float ChargeBar()
{
	return 0 ;
}


simulated event RenderOverlays( Canvas Canvas )
{
	local float CX,CY,Scale;
	local float chargeBar;
	local float barOrgX, barOrgY;
	local float barSizeX, barSizeY;

	if ( PlayerController(Instigator.Controller) == None )
	{
        Super.RenderOverlays(Canvas);
		zoomed=false;
		return;
	}

    if ( LastFOV > PlayerController(Instigator.Controller).DesiredFOV )
    {
        PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomIn', SLOT_Misc,,,,,false);
    }
    else if ( LastFOV < PlayerController(Instigator.Controller).DesiredFOV )
    {
        PlaySound(Sound'WeaponSounds.LightningGun.LightningZoomOut', SLOT_Misc,,,,,false);
    }
    LastFOV = PlayerController(Instigator.Controller).DesiredFOV;

    if ( PlayerController(Instigator.Controller).DesiredFOV == PlayerController(Instigator.Controller).DefaultFOV )
	{
        Super.RenderOverlays(Canvas);
		zoomed=false;
	}
	else
    {
		if ( FireMode[0].NextFireTime <= Level.TimeSeconds )
		{
			chargeBar = 1.0;
		}
		else
		{
			chargeBar = 1.0 - ((FireMode[0].NextFireTime-Level.TimeSeconds) / FireMode[0].FireRate);
		}

		CX = Canvas.ClipX/2;
		CY = Canvas.ClipY/2;
		Scale = Canvas.ClipX/1024;

		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetDrawColor(0,0,0);

		// Draw the crosshair
		Canvas.SetPos(CX-169*Scale,CY-155*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 164,35, 169,310);
		Canvas.SetPos(CX,CY-155*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 332,345, -169,-310);

		// Draw Cornerbars
		Canvas.SetPos(160*Scale,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 0 , 0, 111, 111);

		Canvas.SetPos(Canvas.ClipX-271*Scale,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 0, -111, 111);

		Canvas.SetPos(160*Scale,Canvas.ClipY-271*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale, 0 , 111, 111, -111);

		Canvas.SetPos(Canvas.ClipX-271*Scale,Canvas.ClipY-271*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 111, -111, -111);


		// Draw the 4 corners
		Canvas.SetPos(0,0);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0, 274, 159, -158);

		Canvas.SetPos(Canvas.ClipX-160*Scale,0);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159,274, -159, -158);

		Canvas.SetPos(0,Canvas.ClipY-160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0,116, 159, 158);

		Canvas.SetPos(Canvas.ClipX-160*Scale,Canvas.ClipY-160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159, 116, -159, 158);

		// Draw the Horz Borders
		Canvas.SetPos(160*Scale,0);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 512, 32, -160);

		Canvas.SetPos(160*Scale,Canvas.ClipY-160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 352, 32, 160);

		// Draw the Vert Borders
		Canvas.SetPos(0,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 0,308, 160,32);

		Canvas.SetPos(Canvas.ClipX-160*Scale,160*Scale);
		Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 160,308, -160,32);

		// Draw the Charging meter
		Canvas.DrawColor = ChargeColor;
        Canvas.DrawColor.A = 255;

		if(chargeBar <1)
		    Canvas.DrawColor.R = 255*chargeBar;
		else
        {
            Canvas.DrawColor.R = 0;
		    Canvas.DrawColor.B = 0;
        }

		if(chargeBar == 1)
		    Canvas.DrawColor.G = 255;
		else
		    Canvas.DrawColor.G = 0;

		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetPos( barOrgX, barOrgY );
		Canvas.DrawTile(Texture'Engine.WhiteTexture',barSizeX,barSizeY*chargeBar, 0.0, 0.0,Texture'Engine.WhiteTexture'.USize,Texture'Engine.WhiteTexture'.VSize*chargeBar);
		zoomed = true;
	}
}

simulated function ClientStartFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = true;
        if( Instigator.Controller.IsA( 'PlayerController' ) )
            PlayerController(Instigator.Controller).ToggleZoom();
    }
    else
    {
        Super.ClientStartFire(mode);
    }
}

simulated function ClientStopFire(int mode)
{
    if (mode == 1)
    {
        FireMode[mode].bIsFiring = false;
        if( PlayerController(Instigator.Controller) != None )
            PlayerController(Instigator.Controller).StopZoom();
    }
    else
    {
        Super.ClientStopFire(mode);
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    if ( PlayerController(Instigator.Controller) != None )
        LastFOV = PlayerController(Instigator.Controller).DesiredFOV;
    Super.BringUp(PrevWeapon);
}

defaultproperties
{
	FireModeClass(0)=Class'ProjectileWeapons.AssaultFireProj'
	FireModeClass(1)=Class'XWeapons.SniperZoom'
	PickupClass=Class'XWeapons.AssaultRiflePickup'
	AttachmentClass=Class'XWeapons.AssaultAttachment'
//	InventoryGroup=3
}
