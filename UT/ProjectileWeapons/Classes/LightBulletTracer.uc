class LightBulletTracer extends Emitter;


defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_PointLife
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=80.000000
         UseCrossedSheets=True
         PointLifeTime=0.0800000
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=100,G=200,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=200,R=255))
         Opacity=0.500000
         MaxParticles=1
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Weapons.TrailBlur'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=500.000000,Max=500.000000)
     End Object

	Emitters(0)=TrailEmitter'ProjectileWeapons.LightBulletTracer.TrailEmitter0'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
     bDirectional=True
}
