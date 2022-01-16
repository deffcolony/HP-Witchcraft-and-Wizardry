function init()
	hinge = FindJoint( "hinge" )
	slider = FindJoint( "slider" )
	sound_location = GetLocationTransform( FindLocation( "soundlocation" ) ).pos
	sound_close = LoadSound( "MOD/resources/snd/atticstairlock.ogg" )
	sound_open = LoadSound( "MOD/resources/snd/atticstairopen.ogg" )
	clicked = true
end

function tick()
	local hinge_movement = GetJointMovement( hinge )
	if hinge_movement > -10 then
		SetJointMotorTarget( hinge, 0, 10, 750 )
	else
		SetJointMotor( hinge, 0, 0 )
	end

	if clicked and hinge_movement < -0.25 then
		PlaySound( sound_open, sound_location, 0.4 )
		clicked = false
	elseif not clicked and hinge_movement > -0.15 then
		PlaySound( sound_close, sound_location, 0.4 )
		clicked = true
	end

	local slider_movement = GetJointMovement( slider )
	local max_movement = math.max( 0, (-10 - hinge_movement) / 27 )
	SetJointMotor( slider, math.max( slider_movement - max_movement, 0 ) * 10, slider_movement > max_movement and 1000 or 0 )
end
