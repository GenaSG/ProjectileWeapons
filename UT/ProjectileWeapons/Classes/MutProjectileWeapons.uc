class MutProjectileWeapons extends Mutator
    config(user);
 
//=============================================================================
function string GetInventoryClassOverride(string InventoryClassName)
{
	if (InventoryClassName == "XWeapons.AssaultRifle")
		InventoryClassName = "ProjectileWeapons.AssaultRifleProj";
	return Super.GetInventoryClassOverride(InventoryClassName);
}


function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    local xPickupBase B;
    local Pickup P;
 
    B = xPickupBase(Other);
    if ( B != none )
        B.bHidden = true;
 
    P = Pickup(Other);
    if ( P != none )
        P.Destroy();
 
    return true;
}

function ModifyPlayer(Pawn Other)
{
    local xPawn x;   
	local Weapon m_wTemp;
 
    x = xPawn(Other);
 
    Other.GiveWeapon("ProjectileWeapons.AssaultRifleProj");
    Other.GiveWeapon("ProjectileWeapons.SniperRifleProj");
	m_wTemp = Weapon(Other.FindInventoryType(class'AssaultRifleProj'));
    m_wTemp.MaxOutAmmo();       // in UT2004, instead use:  m_wTemp.MaxOutAmmo();
 
    m_wTemp = Weapon(Other.FindInventoryType(class'SniperRifleProj'));
    m_wTemp.MaxOutAmmo();       // in UT2004, instead use:  m_wTemp.MaxOutAmmo();
 
    Super.ModifyPlayer(Other);
}


//=============================================================================
defaultproperties
{
     GroupName="Projectile based rifles"
     FriendlyName="Projectile based rifles"
     Description="Projectile based rifles"
}
