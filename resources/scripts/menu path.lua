grad_stren = GetFloatParam("gradientStrength", 1) * 0.5
speed = GetFloatParam("speed", 1)

function init()
	time = 1

	path = {}
	for i,v in ipairs(FindLocations()) do
	 	path[i] = GetLocationTransform(v)
	end
	grads = {}
	for i=1, #path do
		local next = path[i % #path + 1].pos
		local prev = path[(i - 2) % #path + 1].pos
		grads[i] = VecScale(VecSub(next, prev), grad_stren)
	end
end

function tick(dt)
	local i = math.floor(time)
	local x = time - i
	time = time + dt * speed

	local i0 = (i - 1) % #path + 1
	local i1 = i % #path + 1
	local p0 = path[i0]
	local p1 = path[i1]

	local interp_pos = VecLerp(
		VecAdd(p0.pos, VecScale(grads[i0], x)), 
		VecAdd(p1.pos, VecScale(grads[i1], x - 1)), x)

	SetCameraTransform(Transform(interp_pos, QuatSlerp(p0.rot, p1.rot, x)))
end