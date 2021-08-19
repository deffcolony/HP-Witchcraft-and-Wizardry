function init()
	fireplace = FindShape("fireplace", true)
	SetTag(fireplace, "interact")
	
	fire_start = LoadSound("MOD/resources/snd/harryhouse_fireplace_WOOSH_ON.ogg")
	fire_crackle = LoadLoop("MOD/resources/snd/harryhouse_fireplace_LOOP.ogg")
	
	sndPos = GetShapeWorldTransform(fireplace)
	
	fireBurning = false
end

function tick(dt)
	if GetPlayerInteractShape() == fireplace and InputPressed("interact") then
		if not fireBurning then
			PlaySound(fire_start, sndPos.pos, 0.5)
			fireBurning = true
		else
			fireBurning = false
		end
	end
	
	if fireBurning then
		PlayLoop(fire_crackle, sndPos.pos, 0.5)
	end
end