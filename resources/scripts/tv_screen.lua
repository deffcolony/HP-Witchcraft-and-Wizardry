--tv_channel = GetIntParam("channel", 1)
function tick()
	DebugPrint("tick works")
end

function draw()
	tv_screen = UiGetScreen()
	tv_shape = GetScreenShape(tv_screen)

	enabled = IsScreenEnabled(tv_screen)

	SetTag(tv_shape, "interact")
	DebugWatch("screen", tv_screen)
	DebugWatch("shape", tv_shape)

	DebugWatch("interact", GetPlayerInteractShape())
	if InputPressed("interact") and GetPlayerInteractShape() == tv_shape then
		DebugPrint("yes")
		SetScreenEnabled(tv_screen, not enabled)
	end

	UiTranslate(UiCenter(), UiMiddle())
	UiAlign("center middle")
	UiImage("MOD/resources/img/tv/gameshow.png")
end