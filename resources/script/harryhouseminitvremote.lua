--TV States:

--0: off
--1: on

function init()
	minitv = FindShape("harryhouseminitv")
	minitvBody = FindBody("harryhouseminitv")
	light = FindLight("harryhouseminitvspeaker")
	
	miniTVscreen = FindScreen("harryhouseminitvscreen")
	

	playing = false
end

function tick(dt)
	local minitvPos = GetShapeWorldTransform(minitv).pos
	
	if GetPlayerInteractShape() == minitv and InputPressed("interact") then
		if not playing then
			playing = true
		else
			playing = false
		end
		if IsScreenEnabled(miniTVscreen) == false then
			SetScreenEnabled(miniTVscreen, true)
		elseif IsScreenEnabled(miniTVscreen) == true then
			SetScreenEnabled(miniTVscreen, false)
		end
	end
	if GetPlayerInteractShape() == monitor and InputPressed("interact") then
		if GetPlayerScreen() ~= miniTVscreen then 
			SetPlayerScreen(miniTVscreen)
		end
	end
	if GetPlayerScreen() == miniTVscreen then
		RemoveTag(monitor, "interact")
	else
		SetTag(monitor, "interact", "WATCH")
	end

	
	if not playing then
		SetTag(minitv, "interact", "Turn On")
		SetFloat("loadTime", 0)
	else
		SetTag(minitv, "interact", "Turn Off")
	end
	
	if IsShapeBroken(minitv) then
		RemoveTag(minitv, "interact")
	end
	
	SetLightEnabled(light, playing)
end

--Another truly awful script by Murdoc.
