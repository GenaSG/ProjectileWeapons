class SniperRifleBullet extends BallisticBullet;


defaultproperties
{
     Bounces=1
	BounceFactor=0.75
	RebounceSpeed=0.065
     DamageAtten=5.000000
     ImpactSounds(0)=Sound'XEffects.Impact4Snd'
     ImpactSounds(1)=Sound'XEffects.Impact6Snd'
     ImpactSounds(2)=Sound'XEffects.Impact7Snd'
     ImpactSounds(3)=Sound'XEffects.Impact3'
     ImpactSounds(4)=Sound'XEffects.Impact1'
     ImpactSounds(5)=Sound'XEffects.Impact2'
     Speed=60000.000000
     MaxSpeed=80000.000000
     Damage=60.000000
     MomentumTransfer=10000.000000
     DrawType=DT_StaticMesh
     CullDistance=3000.000000
     LifeSpan=2.700000
     DrawScale=14.000000
     AmbientGlow=254
     Style=STY_Alpha
     bBounce=True
	HeadShotDamageFactor=2.000000
     HeadDamageType=Class'UTClassic.DamTypeClassicHeadshot'
     MyDamageType=Class'UTClassic.DamTypeClassicSniper'
	HeadShotHeight=0.7
	bExplode=False
	HitEffectClass=Class'XEffects.SmallExplosion'
	ExplosionDecal=Class'XEffects.BulletDecal'
}
