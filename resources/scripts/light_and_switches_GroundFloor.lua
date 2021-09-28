function init()
	kitchenValue = true
	garageValue = true
	porchValue = true
	entranceValue = true
	livingRoomValue = true
	
	--|Ground Floor Buttons
		btn_kitchen = FindShape("btn_kitchen")
		btn_kitchen2 = FindShape("btn_kitchen2")
		btn_garage = FindShape("btn_garage")
		btn_porch = FindShape("btn_porch")
		btn_entrance = FindShape("btn_entrance")
		btn_entrance2 = FindShape("btn_entrance2")
		btn_livingRoom = FindShape("btn_livingRoom")
	--|
		SetTag(btn_kitchen, "interact", "")
		SetTag(btn_kitchen2, "interact", "")
		SetTag(btn_garage, "interact", "")
		SetTag(btn_porch, "interact", "")
		SetTag(btn_entrance, "interact", "")
		SetTag(btn_entrance2, "interact", "")
		SetTag(btn_livingRoom, "interact", "")
	
	--|Ground Floor Lights
		light_kitchen = FindLights("kitchen", true)
		light_livingRoom = FindLights("livingRoom", true)
		light_porch = FindLights("porch", true)
		light_entrance = FindLights("entrance", true)
		light_garage = FindLights("garage", true)
	--|
	
	
end

function tick(dt)
	--Ground Floor
		if GetPlayerInteractShape() == btn_kitchen and InputPressed("interact") then
			if kitchenValue == true then
				kitchenValue = false
			else
				kitchenValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_kitchen2 and InputPressed("interact") then
			if kitchenValue == true then
				kitchenValue = false
			else
				kitchenValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_garage and InputPressed("interact") then
			if garageValue == true then
				garageValue = false
			else
				garageValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_porch and InputPressed("interact") then
			if porchValue == true then
				porchValue = false
			else
				porchValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_entrance and InputPressed("interact") then
			if entranceValue == true then
				entranceValue = false
			else
				entranceValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_entrance2 and InputPressed("interact") then
			if entranceValue == true then
				entranceValue = false
			else
				entranceValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_livingRoom and InputPressed("interact") then
			if livingRoomValue == true then
				livingRoomValue = false
			else
				livingRoomValue = true
			end
		end
		
		for i=1,#light_kitchen do
			SetLightEnabled(light_kitchen[i], kitchenValue)
		end
		for i=1,#light_livingRoom do
			SetLightEnabled(light_livingRoom[i], livingRoomValue)
		end
		for i=1,#light_entrance do
			SetLightEnabled(light_entrance[i], entranceValue)
		end
		for i=1,#light_garage do
			SetLightEnabled(light_garage[i], garageValue)
		end
		for i=1,#light_porch do
			SetLightEnabled(light_porch[i], porchValue)
		end
end