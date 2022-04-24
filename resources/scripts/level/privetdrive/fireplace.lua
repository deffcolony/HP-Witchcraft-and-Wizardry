function init()
	fireplace = FindShape("fireplace")
	
	trigger = FindTrigger("sfx")
	
	fire_start = LoadSound("MOD/resources/snd/harryhouse_fireplace_WOOSH_ON.ogg")
	fire_crackle = LoadLoop("MOD/resources/snd/harryhouse_fireplace_LOOP.ogg")
	
	loc_fire = FindLocation("firepos")
	firePos = GetLocationTransform(loc_fire).pos
	
	fireBurning = false
end

function tick(dt)
	if GetPlayerInteractShape() == fireplace and InputPressed("interact") then
		if not fireBurning then
			PlaySound(fire_start, firePos, 0.4)
			fireBurning = true
		else
			fireBurning = false
		end
	end
	
	if fireBurning then
		SetTag(fireplace, "interact", "Extinguish Fire")
		if IsPointInTrigger(trigger, GetPlayerTransform().pos) then
			PlayLoop(fire_crackle, firePos, 0.4)
		end
		smokeParticle()
		fireParticle()
	else
		SetTag(fireplace, "interact", "Light Fire")
	end
	
	--DebugCross(firePos)
end

function smokeParticle()
	ParticleType("smoke")
	ParticleTile(1)
	ParticleColor(0.3,0.3,0.3)
	ParticleRadius(0.07)
	ParticleAlpha(0.8)
	ParticleGravity(2)
	ParticleDrag(1)
	ParticleEmissive(0.66)
	ParticleRotation(0.25)
	ParticleStretch(0)
	ParticleSticky(0)
	ParticleCollide(0)
	SpawnParticle(firePos, Vec(0, 0.1, 0), 15)
end

function fireParticle()
	ParticleType("plain")
	ParticleTile(5)
	ParticleColor(0.9,0.6,0.2)
	ParticleRadius(0.2)
	ParticleAlpha(0.05)
	ParticleGravity(5)
	ParticleDrag(0)
	ParticleEmissive(0.33)
	ParticleRotation(0.25)
	ParticleStretch(0)
	ParticleSticky(0)
	ParticleCollide(0)
	SpawnParticle(firePos, Vec(0, 0.01, 0), 0.4)
	
	ParticleType("plain")
	ParticleTile(5)
	ParticleColor(1,0.3,0.2)
	ParticleRadius(0.2)
	ParticleAlpha(0.05)
	ParticleGravity(5)
	ParticleDrag(0)
	ParticleEmissive(0.33)
	ParticleRotation(0.25)
	ParticleStretch(0)
	ParticleSticky(0)
	ParticleCollide(0)
	SpawnParticle(firePos, Vec(0, 0.01, 0), 0.4)
end