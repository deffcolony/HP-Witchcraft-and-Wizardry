
function init()
	TimeToWait = 10 -- 10 Seconds

	StairsTrigger = FindTrigger("stairs_trigger")
	SecretSound = LoadSound("MOD/resources/snd/dudleyrunsonstair.ogg", 1)
	SoundPos = GetLocationTransform(FindLocation("sound_pos")).pos
	EffectPos = GetLocationTransform(FindLocation("effect_pos")).pos
	DoorJoint = FindJoint("harry_door_joint0", true)
end

function tick()
	if not SecretFound and IsPointInTrigger(StairsTrigger, GetPlayerCameraTransform().pos) and GetJointMovement(DoorJoint) < 3 then
		if not SecretTime then
			SecretTime = GetTime() + TimeToWait
		elseif SecretTime < GetTime() then
			SecretFound = true
			PlaySound(SecretSound, SoundPos, 2)
			EffectTime = GetTime()
		end
	else
		SecretTime = nil
	end
	if EffectTime then
		if not Effect1 and EffectTime <= GetTime() - 5 then
			Effect1 = true
		elseif EffectTime <= GetTime() - 6.3 then
			EffectTime = nil
		else
			return
		end
		for i = 1, 50 do
			ParticleType("plain")
			ParticleTile(0)
			ParticleColor(0.7,0.7,0.7)
			ParticleRadius(0.1, 0.15)
			ParticleAlpha(1, 0)
			ParticleGravity(-2)
			ParticleDrag(1)
			ParticleRotation(math.random() - 0.5)
			local y = math.random()-0.5
			SpawnParticle(VecAdd(EffectPos, Vec(y, y/2, math.random()-0.5)), Vec(0,0,0), 2)
		end
	end
end