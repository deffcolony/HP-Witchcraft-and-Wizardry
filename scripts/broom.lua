-- Flying broom script by Iaobardar.
-- Used for creating controlable brooms that hover and fly.
-- Initial code pretty much coppied from Iaobardar's helicopter tests.

#include "PID.lua"

function init()
	init_PID("p", 0.5, 0.01, 0)
	init_PID("r", 0.5, 0.01, 0)
	init_PID("f", 1, 0.1, 1000)

	broom = FindVehicle("broom")
	broom_body = GetVehicleBody(broom)
end

function update()
	if GetPlayerVehicle() == broom then
		local broom_t = GetBodyTransform(broom_body)
		local pitch, yaw, roll = GetQuatEuler(broom_t.rot)

		local pitch_target = (InputDown("up") and -30) or (InputDown("down") and 30) or 0
		local roll_target = (InputDown("right") and -30) or (InputDown("left") and 30) or 0

		roll = roll + PID("r", roll, roll_target)
		pitch = pitch + PID("p", pitch, pitch_target)

		SetBodyTransform(broom_body, Transform(broom_t.pos, QuatEuler(pitch, yaw, roll)))

		--local force = TransformToParentVec(broom_t, Vec(0, , 0))
		
		SetBodyVelocity(broom_body, VecAdd(GetBodyVelocity(broom_body), Vec(0, PID("f", broom_t.pos[2], 3), 0)))

		if InputDown("handbrake") then
			SetBodyVelocity(broom_body, VecAdd(GetBodyVelocity(broom_body), TransformToLocalVec(broom_t, Vec(0, 0, -0.1))))
		end
	end
end