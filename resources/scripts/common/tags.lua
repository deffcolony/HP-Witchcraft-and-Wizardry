

function tick()
	if InputPressed( "interact" ) then
		local shape = GetPlayerInteractShape()
		if HasTag( shape, "onInteract" ) then
			runEvent( shape, GetTagValue( shape, "onInteract" ), "onInteract" )
		end
	end
end

do
	local command_cache = {}
	function runEvent( shape, commands_s, event )
		local data = command_cache[commands_s]
		if not data then
			data = {}
			for stmt in commands_s:gmatch( "[^;]+" ) do
				local action, params_s = stmt:match( "^([^(]+)%(?([^)]*)" )
				local params = {}
				for param in params_s:gmatch( "[^,]+" ) do
					params[#params + 1] = tonumber( param ) or param
				end
				data[#data + 1] = { action = action, params = params }
			end
			command_cache[commands_s] = data
		end
		local caller = { caller = shape, event = event }
		for _, cmd in ipairs( data ) do
			runCommand( caller, cmd.action, cmd.params )
		end
	end
end

local INIT = {}
function init()
	for k, v in pairs(INIT) do
		v()
	end
end
local COMMAND = {}
function runCommand( caller, command, params )
	local handler = COMMAND[command]
	if handler then
		handler( caller, unpack( params ) )
	end
end

function INIT.light()
	local lights = FindLights("light", true)
	for i = 1, #lights do
		local val = GetTagValue(lights[i], "light")
		if val == "off" or val == "false" then
			SetLightEnabled(lights[i], false)
		end
	end
end

function COMMAND:togglelight(target)
	local lights = FindLights(target, true)
	for i = 1, #lights do
		SetLightEnabled(lights[i], not IsLightActive(lights[i]))
	end
end

function INIT.sound()
	sounds = {}
	sounds.lightswitch = LoadSound("MOD/resources/snd/light_switch0.ogg")
end

function COMMAND:sound(sound, volume)
	PlaySound(sounds[sound], GetShapeWorldTransform(self.caller).pos, volume or 1)
end
