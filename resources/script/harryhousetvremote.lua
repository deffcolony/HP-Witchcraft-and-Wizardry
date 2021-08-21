--TV States:

--0: off
--1: on

function init()
	tv = FindShape("harryhousetv")
	tvBody = FindBody("harryhouset")
	
	tvPos = GetBodyTransform(tvBody).pos
	
	TV = FindShape("harryhousetv")
	
	TVscreen = FindScreen("harryhousetvscreen")
	
	tvOff = LoadSound("MOD/resources/snd/harryhousetvOff.ogg")
	tvLoop = LoadLoop("MOD/resources/snd/harryhousetvRun.ogg")
	tvStart = LoadSound("MOD/resources/snd/harryhousetvOn.ogg")
	
	SetInt("tvState", 0)
	

	played = false
end

function tick(dt)

	if GetPlayerInteractShape() == tv and InputPressed("interact") then
		if GetInt("tvState") == 0 then
			PlaySound(tvStart, tvPos, 0.15)
			SetInt("tvState", 1)
		elseif GetInt("tvState") > 0 then
			PlaySound(tvOff, tvPos, 0.15)
			SetInt("tvState", 0)
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

	
	if GetInt("tvState") == 0 then
		SetTag(tv, "interact", "Turn On")
		SetFloat("loadTime", 0)
	elseif GetInt("tvState") > 0 then
		SetTag(tv, "interact", "Turn Off")
		PlayLoop(tvLoop, tvPos, 0.15)
	end
end

--Another truly awful script by Murdoc.
