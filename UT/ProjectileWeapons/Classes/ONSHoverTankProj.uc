class ONSHoverTankProj extends ONSHoverTank;

function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType)
{
	if (DamageType != class'DamTypeTankShell' && DamageType != class'DamTypeONSAVRiLRocket' && DamageType != class'DamTypeAttackCraftMissle')
	{
		Damage = 0;
	}
	Super.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
}


defaultproperties
{
	PassengerWeapons(0)=(WeaponPawnClass=Class'ProjectileWeapons.ONSTankSecondaryTurretPawnProj',WeaponBone="MachineGunTurret")
}
