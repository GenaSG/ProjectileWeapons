class SniperAttachmentProj extends xWeaponAttachment;


var xEmitter            mMuzFlash3rd;
var float SmokeOffsetZ;

simulated function Destroyed()
{
    if (mMuzFlash3rd != None)
        mMuzFlash3rd.Destroy();
    Super.Destroyed();
}

simulated function Vector GetTipLocation()
{
    return Location -  vector(Rotation) * 100;
}

defaultproperties
{
     SmokeOffsetZ=10.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=170
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     Mesh=SkeletalMesh'NewWeapons2004.Sniper3rd'
     RelativeLocation=(X=-30.000000,Z=4.000000)
     RelativeRotation=(Pitch=32768)
     DrawScale=0.160000
}
