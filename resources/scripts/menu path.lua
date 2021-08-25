function init()
	t = 0

	poses = {}
	for i,v in ipairs(FindLocations("path")) do
	 	poses[i] = GetLocationTransform(v).pos
	end

	visited = {}
end

function tick(dt)
	local yeet = {}
	for i,v in ipairs(poses) do
		yeet[i] = VecCopy(v)
	end

	while #yeet > 1 do
		yeet = bezier_set(yeet, t)
	end

	table.insert(visited, VecCopy(yeet[1]))

	for i=1, #visited-1 do
		DebugLine(visited[i], visited[i+1])
	end

	for i=1, #poses-1 do
		DebugLine(poses[i], poses[i+1])
	end

	t = t + dt
	t = (t < 1) and t or 1
	DebugWatch("t", t)
end

function bezier_set(points, t)
	for i=1, #points-1 do
		points[i] = VecLerp(points[i], points[i+1], t)
	end
	table.remove(points, #points)
	return points
end