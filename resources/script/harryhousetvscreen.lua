function init()
	count = 26
	current = 1
	t = 0
end

function draw()
	UiTranslate(UiCenter(), UiMiddle())
	UiAlign("center middle")
	local a = current
	local b = math.mod(current+2, count)
	t = t + GetTimeStep()
	if t > 0 then
		UiImage("MOD/resources/pics/img"..(b+1)..".png")
	end
	if t > 0.05 then
		t = 0
		current = b
	end
end
