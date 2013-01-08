//=============================================================================
// Assault Rifle
//=============================================================================
class AssaultRifleTest extends AssaultRifle
    config(user);

simulated event ClientStartFire(int Mode)
{
	Super.ClientStartFire(Mode);
	
}

defaultproperties
{

    ItemName="Assault Rifle TEST"


    FireModeClass(0)=AssaultFireTest

}
