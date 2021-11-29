function init()
	path = {}
	for i,v in ipairs(FindLocations()) do
		path[i] = GetLocationTransform(v)
	end

	for i=1,4 do
		path = SubdividePath(path)
	end

	lengths = {}
	for i,v in ipairs(path) do
		table.insert(lengths, VecLength(VecSub(path[i].pos, path[i % #path + 1].pos)))
	end
end

speed = GetFloatParam("speed", 1)
lenSinceLast = 0
idx = 1

function tick(dt)
	lenSinceLast = lenSinceLast + speed * dt
	if lenSinceLast >= lengths[idx] then -- move to the next segment
		lenSinceLast = lenSinceLast - lengths[idx]
		idx = idx % #path + 1
	end

	SetCameraTransform(InterpTransform(path[idx], path[idx % #path + 1], lenSinceLast / lengths[idx]))
end


function InterpTransform(tform1, tform2, t)
	return Transform(VecLerp(tform1.pos, tform2.pos, t), QuatSlerp(tform1.rot, tform2.rot, t))	
end


function SubdividePath(path)
	local newPath = {}
	for i,v in ipairs(path) do
		table.insert(newPath, InterpTransform(path[i], path[(i - 2) % #path + 1], 0.25))
		table.insert(newPath, InterpTransform(path[i], path[i % #path + 1], 0.25))
	end
	return newPath
end
