state = GetBoolParam("lit", false)

function init()
	sounds = {}
	for i=1,3 do
		table.insert(sounds, LoadSound("MOD/resources/snd/light_switch"..i..".ogg"))
	end

	switches = FindShapes("lightswitch")
	for i,v in ipairs(switches) do
		SetTag(v, "interact")
	end

	lights = FindLights("")
	for i,v in ipairs(lights) do
		SetLightEnabled(v, state)
	end
end

function tick()
	-- detect if a switch is interacted with.
	if InputPressed("interact") then
		local interactShape = GetPlayerInteractShape()
		for i,v in ipairs(switches) do
			if interactShape == v then

				state = not state
				for i,v in ipairs(lights) do
					SetLightEnabled(v, state)
				end

				PlaySound(sounds[math.random(#sounds)], GetShapeWorldTransform(v).pos, 0.25)
				break
			end
		end
	end
end