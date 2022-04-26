function init()
	timer = 1.5
end

function tick(dt)
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
end