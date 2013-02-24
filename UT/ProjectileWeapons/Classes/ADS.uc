class ADS extends WeaponFire;

var bool bADS,bADSZoom,bADSZoomed;
var float ADSInTime,ADSOutTime,ZoomLevel;

event ModeDoFire()
{
	if (!PWWeapon(Weapon).bADS) {
		SetTimer(ADSInTime,false);
	}
	else
	{
		SetTimer(ADSOutTime,false);
	}
}

simulated function Timer()
{
	if (!PWWeapon(Weapon).bADS) {
		ADSOn();
	}
	else
	{
		ADSOff();
	}
}

simulated function ADSOn()
{	
		PlayerController(Instigator.Controller).SetWeaponHand("Center");
		if (bADSZoom && !bADSZoomed) {
			PlayerController(Instigator.Controller).SetFOV(ZoomLevel);
			bADSZoomed=true;
		}
		PWWeapon(Weapon).bADS=true;
	
}


simulated function ADSOff()
{
		PlayerController(Instigator.Controller).SetWeaponHand("Right");
		if (bADSZoom && bADSZoomed) {
			PlayerController(Instigator.Controller).ResetFOV();
			bADSZoomed=false;
		}
		PWWeapon(Weapon).bADS=false;
}


defaultproperties
{
	bADS=false
	bADSZoom=true
	bADSZoomed=false
	ADSInTime=0.1
	ADSOutTime=0.1
    FireAnim=Idle
	ZoomLevel=20
}
