class ONSHoverTankProj extends ONSHoverTank;

function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType)
{
	if (DamageType == class'DamTypeHoverBikePlasma')
	{
		Damage *= 0.80;
	}
	if (DamageType != class'DamTypeTankShell' && DamageType != class'DamTypeONSAVRiLRocket' )
	{
		Damage = 0;
	}
	Super.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
}


defaultproperties
{
	PassengerWeapons(0)=(WeaponPawnClass=Class'ProjectileWeapons.ONSTankSecondaryTurretPawnProj',WeaponBone="MachineGunTurret")
}
