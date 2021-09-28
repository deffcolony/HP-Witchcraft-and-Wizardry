function init()
	harryValue = true
	hallwayValue = true
	bathroomValue = true
	parentValue = true
	dudleyValue = true
	
	
	--|First Floor Buttons
		btn_harryRoom = FindShape("btn_harryRoom")
		btn_bathroom = FindShape("btn_bathroom")
		btn_parentsRoom = FindShape("btn_parentsRoom")
		btn_dudleyRoom = FindShape("btn_dudleyRoom")
		btn_hallway = FindShape("btn_hallway")
	--|
		SetTag(btn_harryRoom, "interact", "")
		SetTag(btn_bathroom, "interact", "")
		SetTag(btn_parentsRoom, "interact", "")
		SetTag(btn_dudleyRoom, "interact", "")
		SetTag(btn_hallway, "interact", "")
	
	--|First Floor Lights
		light_harry = FindLights("harry", true)
		light_hallway = FindLights("hallway", true)
		light_bathroom = FindLights("bathroom", true)
		light_parentRoom = FindLights("parentRoom", true)
		light_dudley = FindLights("dudley", true)
	--|
	
	
end

function tick(dt)
	--First Floor
		if GetPlayerInteractShape() == btn_hallway and InputPressed("interact") then
			if hallwayValue == true then
				hallwayValue = false
			else
				hallwayValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_harryRoom and InputPressed("interact") then
			if harryValue == true then
				harryValue = false
			else
				harryValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_bathroom and InputPressed("interact") then
			if bathroomValue == true then
				bathroomValue = false
			else
				bathroomValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_parentsRoom and InputPressed("interact") then
			if parentValue == true then
				parentValue = false
			else
				parentValue = true
			end
		end
		
		if GetPlayerInteractShape() == btn_dudleyRoom and InputPressed("interact") then
			if dudleyValue == true then
				dudleyValue = false
			else
				dudleyValue = true
			end
		end
		
		for i=1,#light_harry do
			SetLightEnabled(light_harry[i], harryValue)
		end
		for i=1,#light_hallway do
			SetLightEnabled(light_hallway[i], hallwayValue)
		end
		for i=1,#light_bathroom do
			SetLightEnabled(light_bathroom[i], bathroomValue)
		end
		for i=1,#light_parentRoom do
			SetLightEnabled(light_parentRoom[i], parentValue)
		end
		for i=1,#light_dudley do
			SetLightEnabled(light_dudley[i], dudleyValue)
		end
end