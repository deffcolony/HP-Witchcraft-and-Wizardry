function init()
	timer = 1.5
	timer2 = 0
	epress = 0

	
end

function tick(dt)
	playerpos = GetPlayerPos()

	trig = FindTrigger("trig", true)

	swing=FindJoint("swing",true)
	SetJointMotor(swing, 0.5)
	
	

	if IsPointInTrigger(trig, playerpos) then
		if InputPressed ("e") then
			epress = epress + 1
		end
	end
	
	if epress >= 1 then
		timer = timer - dt	
		timer2 = timer2 + dt
			
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
	end
	
	if timer2 >= 3 then
		SetLightIntensity(light, 0)
		SetShapeEmissiveScale(lamp, 0)
	end
	
	if timer2>= 4 then
		light2=FindLight("light2",true)
		lamp2=FindShape("lamp2",true)
		SetLightIntensity(light2, 0)
		SetShapeEmissiveScale(lamp2, 0)
	end
	
	if timer2>= 5 then
		light3=FindLight("light3",true)
		lamp3=FindShape("lamp3",true)
		SetLightIntensity(light3, 0)
		SetShapeEmissiveScale(lamp3, 0)
	end
	
	if timer2>= 6 then
		light4=FindLight("light4",true)
		lamp4=FindShape("lamp4",true)
		SetLightIntensity(light4, 0)
		SetShapeEmissiveScale(lamp4, 0)
	end
	
	if timer2>= 8 then
		round = FindJoint("round", true)
		
		SetJointMotor(round, 0.2)
	else
		SetJointMotor(round,0)
	end
	
	if timer2>= 9 then
		seesaw = FindJoint("seesaw", true)
	
		SetJointMotor(seesaw, 0.3)
		
	else
		SetJointMotor(seesaw,0)	
	end
	
	if timer2 == 10.1 then
		Spawn("MOD/resources/prefab/knightbus.xml", Transform(Vec(0, 0, 0)))	
	end
end

function draw()
	if epress >= 1 then
		return
	end

	if IsPointInTrigger(trig, playerpos) then
		UiFont("MOD/resources/harry potter.ttf",70)
		UiColor(1,1,1,0.6)
		UiTextShadow(0, 0, 0, 1, 4)
		UiTranslate(UiCenter(), 600)
		UiAlign("center")
		UiText("Press E to summon The Knight Bus")	
	end
end