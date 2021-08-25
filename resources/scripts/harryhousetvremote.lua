--TV States:

--0: off
--1: on

function init()
	tv = FindShape("harryhousetv")
	tvBody = FindBody("harryhousetv")
	light = FindLight("harryhousetvspeaker")
	
	TVscreen = FindScreen("harryhousetvscreen")
	

	playing = false
end

function tick(dt)
	local tvPos = GetShapeWorldTransform(tv).pos
	
	if GetPlayerInteractShape() == tv and InputPressed("interact") then
		if not playing then
			playing = true
		else
			playing = false
		end
		if IsScreenEnabled(TVscreen) == false then
			SetScreenEnabled(TVscreen, true)
		elseif IsScreenEnabled(TVscreen) == true then
			SetScreenEnabled(TVscreen, false)
		end
	end
	if GetPlayerInteractShape() == monitor and InputPressed("interact") then
		if GetPlayerScreen() ~= TVscreen then 
			SetPlayerScreen(TVscreen)
		end
	end
	if GetPlayerScreen() == TVscreen then
		RemoveTag(monitor, "interact")
	else
		SetTag(monitor, "interact", "WATCH")
	end

	
	if not playing then
		SetTag(tv, "interact", "Turn On")
		SetFloat("loadTime", 0)
	else
		SetTag(tv, "interact", "Turn Off")
	end
	
	if IsShapeBroken(tv) then
		RemoveTag(tv, "interact")
	end
	
	SetLightEnabled(light, playing)
end

--Another truly awful script by Murdoc.
