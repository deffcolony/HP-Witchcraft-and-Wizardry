function init()
	fireplace = FindShape("fireplace", true)
	SetTag(fireplace, "interact")
	
	trigger = FindTrigger("sfx", true)
	
	fire_start = LoadSound("MOD/resources/snd/harryhouse_fireplace_WOOSH_ON.ogg")
	fire_crackle = LoadLoop("MOD/resources/snd/harryhouse_fireplace_LOOP.ogg")
	
	firePos = VecAdd(GetShapeWorldTransform(fireplace).pos, Vec(0.9, 0, -0.6))
	
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
		if IsPointInTrigger(trigger, GetPlayerTransform().pos) then
			PlayLoop(fire_crackle, firePos, 0.4)
		end
		smokeParticle()
		fireParticle()
	end
	
	--DebugCross(firePos)
end

function smokeParticle()
	ParticleType("smoke")
	ParticleTile(1)
	ParticleColor(0.5,0.5,0.5)
	ParticleRadius(0.1)
	ParticleAlpha(0.2)
	ParticleGravity(2)
	ParticleDrag(0)
	ParticleEmissive(0.66)
	ParticleRotation(0.25)
	ParticleStretch(0)
	ParticleSticky(0)
	ParticleCollide(0.5)
	SpawnParticle(firePos, 1, 3)
end

function fireParticle()
	ParticleType("smoke")
	ParticleTile(1)
	ParticleColor(0.9,0.6,0.2)
	ParticleRadius(0.05)
	ParticleAlpha(0.66)
	ParticleGravity(2)
	ParticleDrag(0)
	ParticleEmissive(0.66)
	ParticleRotation(0.25)
	ParticleStretch(0)
	ParticleSticky(0)
	ParticleCollide(0.5)
	SpawnParticle(firePos, 1, 3)
	
	ParticleType("smoke")
	ParticleTile(1)
	ParticleColor(1,0.3,0.2)
	ParticleRadius(0.05)
	ParticleAlpha(0.66)
	ParticleGravity(2)
	ParticleDrag(0)
	ParticleEmissive(0.66)
	ParticleRotation(0.25)
	ParticleStretch(0)
	ParticleSticky(0)
	ParticleCollide(0.5)
	SpawnParticle(firePos, 1, 3)
end