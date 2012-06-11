class MutProjectileWeapons extends Mutator
    config(user);
 
//=============================================================================
function string GetInventoryClassOverride(string InventoryClassName)
{
	if (InventoryClassName == "XWeapons.AssaultRifle")
		InventoryClassName = "TestRifle.AssaultRifleProj";
//	if (InventoryClassName == "XWeapons.SniperRifle")
//		InventoryClassName = "TestRifle.SniperRifleProj";
 
	return Super.GetInventoryClassOverride(InventoryClassName);
}
 
//=============================================================================
defaultproperties
{
     GroupName="Projectile based assault rifle"
     FriendlyName="Projectile based assault rifle"
     Description="Projectile based assault rifle"
}
