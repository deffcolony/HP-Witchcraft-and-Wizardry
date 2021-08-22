--TV States:

--0: off
--1: on

function init()
	minitv = FindShape("harryhouseminitv")
	minitvBody = FindBody("harryhouseminitv")
	
	minitvPos = GetBodyTransform(minitvBody).pos
	
	miniTV = FindShape("harryhouseminitv")
	
	miniTVscreen = FindScreen("harryhouseminitvscreen")
	
	minitvOff = LoadSound("MOD/resources/snd/harryhouseminitvOff.ogg")
	minitvLoop = LoadLoop("MOD/resources/snd/harryhouseminitvRun.ogg")
	minitvStart = LoadSound("MOD/resources/snd/harryhouseminitvOn.ogg")
	
	SetInt("minitvState", 0)
	

	played = false
end

function tick(dt)

	if GetPlayerInteractShape() == minitv and InputPressed("interact") then
		if GetInt("minitvState") == 0 then
			PlaySound(minitvStart, minitvPos, 0.15)
			SetInt("minitvState", 1)
		elseif GetInt("minitvState") > 0 then
			PlaySound(minitvOff, minitvPos, 0.15)
			SetInt("minitvState", 0)
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

	
	if GetInt("minitvState") == 0 then
		SetTag(minitv, "interact", "Turn On")
		SetFloat("loadTime", 0)
	elseif GetInt("minitvState") > 0 then
		SetTag(minitv, "interact", "Turn Off")
		PlayLoop(minitvLoop, minitvPos, 0.15)
	end
end

--Another truly awful script by Murdoc.
