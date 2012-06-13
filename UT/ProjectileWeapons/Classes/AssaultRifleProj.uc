class AssaultRifleProj extends AssaultRifle;
 
//=============================================================================


simulated function float ChargeBar()
{
	return 0 ;
}

defaultproperties
{
	FireModeClass(0)=Class'ProjectileWeapons.AssaultFireProj'
	FireModeClass(1)=Class'ProjectileWeapons.AssaultAltFireProj'
	PickupClass=Class'XWeapons.AssaultRiflePickup'
	AttachmentClass=Class'XWeapons.AssaultAttachment'
//	InventoryGroup=3
}
