function init()
	body = FindBody("body")
	speed = 1

	roll = 0

	sensitivity = 10

	flying = false

	lerpedVel = Vec(0, 0, 0)

	cameralock = true

	inVehicle = false
end

function tick ()
	vehicle = FindVehicle("vehicle")

	if GetPlayerVehicle() == vehicle and GetVehicleHealth(vehicle) ~= 0 then
		inVehicle = true
		local trans = GetBodyTransform(body)
		local fwd = TransformToParentVec(trans, Vec(0, 0, -1))

		if InputDown("uparrow") then
			fwd[2] = Lerp(fwd[2], fwd[2] + 2, 0.1)
		elseif InputDown("downarrow") then
			fwd[2] = Lerp(fwd[2], fwd[2] - 2, 0.1)
		end

		--DebugCross(VecAdd(trans.pos, VecScale(fwd, speed)))

		local angVel = GetBodyAngularVelocity(body)	

		speed = Clamp(speed, 0, 20)
		GetInput()

		if flying then
			mx, my = InputValue("mousedx"), InputValue("mousedy")

			local newQuat = QuatRotateQuat(QuatCopy(trans.rot), QuatEuler(-my/sensitivity, -mx/sensitivity, roll*5))

			local finalTrans = Transform(VecCopy(trans.pos), QuatCopy(newQuat))

			--DebugWatch("trans", finalTrans)
			if cameralock then
				SetBodyTransform(body, finalTrans)
			end
			
			SetBodyAngularVelocity(body, Vec(0, 0, 0))		
			SetBodyVelocity(body, VecScale(fwd, speed))
		end
		
	else
		inVehicle = false
	end
end

function GetInput ()
	if InputDown("up") then
		speed = speed + 0.1
	elseif InputDown("down") then
		speed = speed - 0.1
	end

	if InputPressed("shift") then
		flying = not flying
	end

	if InputDown("left") then
		roll = 1/sensitivity
	elseif InputDown("right") then
		roll = -1/sensitivity
	else
		roll = 0
	end

	if InputDown("alt") then
		cameralock = false
	else
		cameralock = true
	end
end

function Clamp (x, min, max)
	local output = 0
	if x < min then
		output = min
	elseif x > max then
		output = max
	else
		output = x
	end

	return output
end

function Lerp (value, target, t)
	output = (1 - t) * value + t * target
	return output
end

function draw ()
	if inVehicle then
		w = UiWidth()
		h = UiHeight()
		UiColor(0, 0, 0, 0.5)
		UiAlign("left top")
		UiTranslate(w - w/8 - 10, h - h/4)
		UiImageBox("MOD/resources/img/infobox.png", w/8, h/8, 5, 5)
		UiColor(1, 1, 1)
		UiFont("bold.ttf", 24)
		UiText("CONTROLS")
		UiFont("regular.ttf", 20)
		UiTranslate(0, h/48)
		UiText("SHIFT - Toggle flight mode")
		UiTranslate(0, h/48)
		UiText("Mouse + A/D - Rotate")
		UiTranslate(0, h/48)
		UiText("Alt - Free look")
		UiTranslate(0, h/48)
		UiText("W/S - If-flight speed adjustment")
	end
end