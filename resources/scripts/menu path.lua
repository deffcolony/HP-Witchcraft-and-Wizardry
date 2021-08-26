function init()
	t = 1

	path = {}
	for i,v in ipairs(FindLocations("path")) do
	 	path[i] = GetLocationTransform(v)
	end
end

function tick(dt)
	local i = math.floor(t)
	local x = t - i

	local p0 = path[(i - 2) % #path + 1]
	local p1 = path[(i - 1) % #path + 1]
	local p2 = path[i % #path + 1]
	local p3 = path[(i + 1) % #path + 1]

	local grad_1 = VecScale(VecSub(p2.pos, p0.pos), 0.5)
	local grad_2 = VecScale(VecSub(p3.pos, p1.pos), 0.5)

	SetCameraTransform(Transform(VecLerp(
		VecAdd(p1.pos, VecScale(grad_1, x)),
		VecAdd(p2.pos, VecScale(grad_2, x - 1)),
		x), QuatSlerp(p1.rot, p2.rot, x)))

	for i,v in ipairs(path) do
		DebugCross(v.pos)
	end

	t = t + dt
	DebugWatch("t", t)
end