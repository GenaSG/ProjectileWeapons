class MutProjectileWeapons extends Mutator
    config(user);
 
//=============================================================================
function string GetInventoryClassOverride(string InventoryClassName)
{
	if (InventoryClassName == "XWeapons.AssaultRifle")
//		InventoryClassName = "ProjectileWeapons.AssaultRifleProj";
//	if (InventoryClassName == "XWeapons.ClassicSniperRifle")
		InventoryClassName = "ProjectileWeapons.SniperRifleProj";
 
	return Super.GetInventoryClassOverride(InventoryClassName);
}

//=============================================================================
function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
    local int i;
    local WeaponLocker L;
 
    bSuperRelevant = 0;
 
    if ( xWeaponBase(Other) != None )
    {
        if ( string( xWeaponBase(Other).WeaponType ) ~= "XWeapons.ClassicSniperRifle" )
        {
            xWeaponBase(Other).WeaponType = class'ProjectileWeapons.SniperRifleProj';
            return false;
        }
    }
//    else if ( WeaponPickup(Other) != None )
//    {
//        if ( string(Other.Class) ~= "XWeapons.MinigunPickup" )
//        {
//            ReplaceWith( Other, "MinigunHEPickup" );
//            return false;
//        }
 //   }
    else if ( WeaponLocker(Other) != None )
    {
        L = WeaponLocker(Other);
 
        for (i = 0; i < L.Weapons.Length; i++)
        {
            if ( string( L.Weapons[i].WeaponClass ) ~= "XWeapons.ClassicSniperRifle" )
                L.Weapons[i].WeaponClass = class'ProjectileWeapons.SniperRifleProj';
        }
    }
 
    return true;
}
 
//=============================================================================
defaultproperties
{
     GroupName="Projectile based assault rifle"
     FriendlyName="Projectile based assault rifle"
     Description="Projectile based assault rifle"
}
