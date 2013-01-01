class ClientWeaponFire extends WeaponFire;

function PlayFiring()
{
	local vector Start;
	local rotator Dir, Aim;
	local projectile Bullet;
	local vector BoneLocation;
	Super.PlayFiring();
	Aim = AdjustAim(Start, AimError);
	BoneLocation = Weapon.GetEffectStart();
	Start = Instigator.Location + Instigator.EyePosition();
	Dir = rotator(vector(Aim) + VRand()*FRand()*Spread);
	Bullet=Weapon.Spawn(ProjectileClass,Instigator.Controller,,BoneLocation,Dir);
}

defaultproperties
{
	ProjectileClass=class'FlakChunk';
}
