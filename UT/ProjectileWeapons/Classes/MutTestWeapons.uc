class MutTestWeapons extends Mutator
    config(user);
/* 
var float SpreadCoef;
var float WeaponsVars[3];

//=============================================================================
function string GetInventoryClassOverride(string InventoryClassName)
{
	if (InventoryClassName == "XWeapons.AssaultRifle")
		InventoryClassName = "ProjectileWeapons.AssaultRifleProj";
	return Super.GetInventoryClassOverride(InventoryClassName);
}

function PostBeginPlay()
{
	local ONSVehicleFactory Factory;

	//Replace old vehicles with new ones
	if ( Level.Game.IsA('ONSOnslaughtGame') )
	{
		foreach AllActors( class 'ONSVehicleFactory', Factory )
		{
			if ( Factory.VehicleClass == Class'Onslaught.ONSHoverBike' )
			{
				Factory.VehicleClass = Class'ProjectileWeapons.ONSHoverBikeProj';
			}
			else if ( Factory.VehicleClass == Class'Onslaught.ONSAttackCraft' )
			{
				Factory.VehicleClass = Class'ProjectileWeapons.ONSAttackCraftProj';
			}
			else if ( Factory.VehicleClass == Class'Onslaught.ONSHoverTank' )
			{
				Factory.VehicleClass = Class'ProjectileWeapons.ONSHoverTankProj';
			}
			else if ( Factory.VehicleClass == Class'Onslaught.ONSPRV' )
			{
				Factory.VehicleClass = Class'ProjectileWeapons.ONSPRVProj';
			}
		}
	}

	Super.PostBeginPlay();
}


*/
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{

    local xPickupBase B;
    local Pickup P;
	if (Other.Class != class'ShieldPack') {
		B = xPickupBase(Other);
		if ( B != none )
			B.bHidden = true;
		
		P = Pickup(Other);
		if ( P != none )
			P.Destroy();
	}




    return true;
}
function ModifyPlayer(Pawn Other)
{

    local xPawn x;   
	local Weapon m_wTemp;
 
    x = xPawn(Other);
 
    Other.GiveWeapon("ProjectileWeapons.ARProj");
    Other.GiveWeapon("ProjectileWeapons.SRProj");
  //  Other.GiveWeapon("TEstWeapons.APR");
	
	m_wTemp = Weapon(Other.FindInventoryType(class'ARProj'));
    m_wTemp.MaxOutAmmo();
 
	x.SelectedItem.Inventory = x.Inventory.SelectNext();
	
    m_wTemp = Weapon(Other.FindInventoryType(class'SRProj'));
    m_wTemp.MaxOutAmmo();
	
	Other.Inventory.SelectNext();
	
	m_wTemp = Weapon(Other.FindInventoryType(class'AssaultRifle'));
	m_wTemp.bHidden = true;
    m_wTemp.Destroy();

	if ( Level.Game.IsA('ONSOnslaughtGame') )
	{
		Other.GiveWeapon("Onslaught.ONSAVRiL");
		m_wTemp = Weapon(Other.FindInventoryType(class'Onslaught.ONSAVRiL'));
		m_wTemp.MaxOutAmmo(); 
	}

    Super.ModifyPlayer(Other);
}


//=============================================================================
defaultproperties
{
     GroupName="Projectile Based Weapons"
     FriendlyName="Projectile Based Weapons"
     Description="Projectile Based Weapons"
}
