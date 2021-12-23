function init()
	TVs = FindScreens("tv", true)

	enabled = IsScreenEnabled(GetScreenShape(tv_screen))

	SetTag(tv_shape, "interact")
end

function tick()

end