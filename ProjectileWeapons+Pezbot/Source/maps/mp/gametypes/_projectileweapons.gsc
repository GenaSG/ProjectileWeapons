#include common_scripts\utility;
init()
{
	PreCacheModel( "projectile_tag" );
	thread maps\mp\_createfx::add_effect("tracer", "tracers/smoke_geotrail_rifle");
	level.ping=getDvarint("sv_avrgping");
	if (level.ping==0) {
		setDvar( "sv_avrgping", "30" );
		level.ping=30;
	}
	level.weapon["m4"]["bulletSpeed"]=30000;
	level.weapon["m4"]["damage"]=30;
}

beginFire()
{
	//self iprintln("ping");
	ping=level.ping;
	weapon="m4";
	playerAngles=self getPlayerAngles();
	angles=playerAngles;
	origin=self maps\mp\gametypes\_wdrmod::getPlayerEyes();
	start=origin;// + playerVelocity*ping/2000;

	
	//Spawning "Bullet"
	
//	TracerEffect = loadfx("tracers/smoke_geotrail_rifle");
	bullet = SpawnStruct();
	bullet.speed=level.weapon["m4"]["bulletSpeed"];
	bullet.angles=angles;
	VectorDist=bullet.speed * 0.01;
	vectorForward=vectorscale( anglesToForward( bullet.angles ), VectorDist);
	gravityVector=vectorscale( anglesToUp( bullet.angles ), 1);
	PenetrationVector=vectorscale( anglesToForward( bullet.angles ), 1);
	bullet.hits=0;
	bullet.maxhits=3;
	bullet.start=start;
	bullet.done=false;
	bullet.maxDistance=10000;
	
	//First trace for Ping compensation
	traceDist=bullet.speed*ping/2000;
	tracevector=vectorscale( anglesToForward( angles ), traceDist);
	end=start+tracevector-(gravityVector*385*(ping/2000)*(ping/2000));
	
	trace=bullettrace(start,end,true,self);
	
	
	if (isDefined(trace["fraction"]) && trace["fraction"] !=1 && bullet.hits <= bullet.maxhits) {
		bullet.start=trace["position"]+PenetrationVector;
		bullet.hits=bullet.hits+1;
		if (isDefined(trace["entity"])) {
			DoDamage(trace["entity"],bullet);
		}
		else
		{
			PlayHit(trace);
		}
		if (isDefined(bullet) && bullet.hits==bullet.maxhits) {
			bullet.done=true;
		}
	}
	else
	{
		bullet.start=end;
	}

	//Starting Ballistic bullet
	
	maxI=int(bullet.maxDistance/VectorDist);
	for (i=0; i<maxI; i++) {
		self thread DoTrace(Bullet,i,vectorForward,PenetrationVector,gravityVector);
		
	}
	
}

DoTrace(bullet,i,vectorForward,PenetrationVector,gravityVector)
{
	delay = 0.05+i/100;
	wait(delay);
	if (isDefined(bullet) && isDefined(bullet.start) && bullet.done==false) {
		Trace=bullettrace(bullet.start,bullet.start+vectorForward,true,undefined);
		if (isDefined(Trace["fraction"]) && Trace["fraction"] !=1 && bullet.hits <= bullet.maxhits) {
			bullet.start=Trace["position"]+PenetrationVector-(gravityVector*385*(i/100)*(i/100));
			bullet.hits=bullet.hits+1;
			//self iprintln("hit registered " + i+ "fraction "+Trace["fraction"]);
			if (isDefined(Trace["entity"])) {
				DoDamage(Trace["entity"],bullet);
			}
			else
			{
				PlayHit(Trace);
			}
			if (isDefined(bullet) && bullet.hits==bullet.maxhits) {
			//	self iprintln("bullet deleted " + i);
				bullet.done=true;
			}
		}
		else
		{
			//self iprintln("NO hit registered " + i);
			bullet.start=bullet.start+vectorForward - (gravityVector*385*(i/100)*(i/100));
		}

	}
	}

PlayHit(Trace)
{
	peneteffect = loadfx("impacts/20mm_default_impact");
		playfx(peneteffect,Trace["position"],anglestoforward(VectorToangles(Trace["normal"])));
}

DoDamage(entity,bullet)
{
	self iprintln("Victim origin "+ entity.origin);
}
