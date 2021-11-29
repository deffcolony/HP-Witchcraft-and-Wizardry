state = GetBoolParam("lit", false)
prev_state = state

function init()
	sounds = {}
	for i=1,3 do
		table.insert(sounds, LoadSound("MOD/resources/snd/light_switch"..i..".ogg"))
	end

	switches = FindShapes("lightswitch")
	lights = FindLights("")

	for i,v in ipairs(switches) do
		SetTag(v, "interact")
	end

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
				PlaySound(sounds[math.random(#sounds)], GetShapeWorldTransform(v).pos, 0.25)
				break
			end
		end
	end

	if state ~= prev_state then
		for i,v in ipairs(lights) do
			SetLightEnabled(v, state)
		end
		prev_state = state
	end
end