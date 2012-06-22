class ONSPRVProj extends ONSPRV;

function TakeDamage(int Damage, Pawn instigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType)
{
	if (DamageType != class'DamTypeTankShell' && DamageType != class'DamTypeONSAVRiLRocket' )
	{
		Damage = 0;
	}
	Super.TakeDamage(Damage, instigatedBy, Hitlocation, Momentum, damageType);
}


defaultproperties
{
	PassengerWeapons(0)=(WeaponPawnClass=Class'ProjectileWeapons.ONSPRVSideGunPawnProj',WeaponBone="Dummy01")
//	PassengerWeapons(1)=(WeaponPawnClass=Class'ProjectileWeapons.ONSPRVRearGunPawnProj',WeaponBone="Dummy02")

}
