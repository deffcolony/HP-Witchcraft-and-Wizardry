--smooth = GetFloatParam("grad_str", 1) * 0.5
--speed = GetFloatParam("speed", 1)

function init()
	path = {}
	for i,v in ipairs(FindLocations()) do
		path[i] = GetLocationTransform(v)
	end

	for i = 1, 3 do
		local i = 1
		while i <= #path do
			table.insert(path, i+1, InterpTransform(path[i], path[i % #path + 1], 0.75))
			path[i] = InterpTransform(path[i], path[i % #path + 1], 0.25)
			i = i + 2
		end
	end

	--[[
	grads = {}
	for i=1, #path do
		local next = path[i % #path + 1].pos
		local prev = path[(i - 2) % #path + 1].pos
		grads[i] = VecScale(VecSub(next, prev), smooth)
	end

	t = 1
	prev_pos = spline(t)
	]]
end

function tick(dt)
	for i,v in ipairs(path) do
		DebugLine(v.pos, TransformToParentPoint(v, {0, 0, -1}), 1, 1, 1, 0.5)
		DebugCross(v.pos)
	end


	--[[
	local move_len = dt * speed
	t = t + 0.0005
	for i=1, 3 do
		local s1 = VecLength(VecSub(spline(t), prev_pos))
		local s0 = VecLength(VecSub(spline(t + 0.0001), prev_pos))
		
		t = t - (s1 - move_len) / (s0 - s1) * 0.0001
	end

	local new_pos = spline(t)
	
	local ft = math.floor(t)
	local r0 = path[(ft - 1) % #path + 1].rot
	local r1 = path[ft % #path + 1].rot

	SetCameraTransform(Transform(new_pos, QuatSlerp(r0, r1, t - ft)))

	prev_pos = new_pos
	]]
end

function InterpTransform(tform1, tform2, t)
	return Transform(VecLerp(tform1.pos, tform2.pos, t), QuatSlerp(tform1.rot, tform2.rot, t))	
end

function spline(t)
	local ft = math.floor(t)
	local i0 = (ft - 1) % #path + 1
	local i1 = ft % #path + 1
	t = t - ft
	return VecLerp(
		VecAdd(path[i0].pos, VecScale(grads[i0], t)), 
		VecAdd(path[i1].pos, VecScale(grads[i1], t - 1)), (3 - 2 * t) * t * t)
end