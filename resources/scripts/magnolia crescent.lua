function init()
	timer = 1.5
end

function tick(dt)
	playerpos = GetPlayerPos()

	trig = FindTrigger("trig", true)
	
	if IsPointInTrigger(trig, playerpos) then
		timer = timer - dt	
	
		light = FindLight("light", true)
	
		lamp = FindShape("lamp", true)

		if timer <= 1 then
			table = {0, 10, 30}
			rand = table[math.random(1, #table)]
			SetLightIntensity(light, rand)
			SetShapeEmissiveScale(lamp, rand)
		end

		if timer <= 0 then
			timer = timer + 1.5
		end
		
		round = FindJoint("round", true)
		seesaw = FindJoint("seesaw", true)
		SetJointMotor(round, 0.1)
		SetJointMotor(seesaw, 0.2)
		
		swing = FindBody("swing", true)
		SetBodyAngularVelocity(swing, 0.3)
		
	else
		SetJointMotor(round,0)
		SetJointMotor(seesaw,0)
	end
end