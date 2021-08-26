--TV States:

--0: off
--1: on

function init()
	tv2 = FindShape("harryhousetv2")
	tvBody2 = FindBody("harryhousetv2")
	light = FindLight("harryhousetvspeaker2")
	
	TVscreen2 = FindScreen("harryhousetvscreen2")
	

	playing = false
end

function tick(dt)
	local tv2Pos = GetShapeWorldTransform(tv2).pos
	
	if GetPlayerInteractShape() == tv2 and InputPressed("interact") then
		if not playing then
			playing = true
		else
			playing = false
		end
		if IsScreenEnabled(TVscreen2) == false then
			SetScreenEnabled(TVscreen2, true)
		elseif IsScreenEnabled(TVscreen2) == true then
			SetScreenEnabled(TVscreen2, false)
		end
	end
	if GetPlayerInteractShape() == monitor and InputPressed("interact") then
		if GetPlayerScreen() ~= TVscreen2 then 
			SetPlayerScreen(TVscreen2)
		end
	end
	if GetPlayerScreen() == TVscreen2 then
		RemoveTag(monitor, "interact")
	else
		SetTag(monitor, "interact", "WATCH")
	end

	
	if not playing then
		SetTag(tv2, "interact", "Turn On")
		SetFloat("loadTime", 0)
	else
		SetTag(tv2, "interact", "Turn Off")
	end
	
	if IsShapeBroken(tv2) then
		RemoveTag(tv2, "interact")
	end
	
	SetLightEnabled(light, playing)
end

--Another truly awful script by Murdoc.
