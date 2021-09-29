function init()
	levels = {
		{name = "Privet Drive", path = "MOD/privetdrive.xml"}, 
		{name = "Bardar's Testing", path = "MOD/script_testing.xml"}, 
		{name = "Some Other Map", path = "MOD/entrance.xml"}}
	scroll = 0
end

function draw()
	--UiMakeInteractive()
	UiTranslate(350, 0)
	UiAlign("center")
	UiWordWrap(400)

	UiColor(1, 1, 1, 0.2)
	UiImageBox("MOD/resources/img/infobox.png", 400, 1080, 6, 6)

	UiTranslate(0, 200)
	UiColor(1, 1, 1)
	UiFont("bold.ttf", 50)
	UiText("TITLE/IMAGE")

	UiFont("regular.ttf", 36)
	UiTranslate(0, 200)
	if UiTextButton("Level Select") then
		draw = level_select
	end

	UiTranslate(0, 200)
	if UiTextButton("Exit") then
		Menu()
	end
end

function level_select()
	UiMakeInteractive()
	UiTranslate(UiCenter(), UiMiddle())
	UiAlign("center middle")

	UiImageBox("MOD/resources/img/box-outline-fill-6.png", 800, 500, 6, 6)
	UiWindow(800, 500, true)
	UiPush()
		UiTranslate(UiCenter()-200, UiHeight()-25)
		UiAlign("left middle")
		scroll, done = UiSlider("MOD/resources/img/dot.png", "x", scroll, 0, 400)
		move = inv_lerp(0, 400, scroll)
	UiPop()
	UiTranslate(UiCenter(), UiMiddle())

	UiTranslate(move * 200 * (#levels - 1), 0)
	UiWordWrap(175)
	
	UiFont("regular.ttf", 24)
	for i,v in ipairs(levels) do
		UiImageBox("MOD/resources/img/box-outline-fill-6.png", 175, 175, 6, 6)
		if UiTextButton(v.name) then
			StartLevel("yes", v.path)
		end
		
		UiTranslate(200)
	end
end

-- Utility Functions:
function inv_lerp(a, b, v) return (v - a) / (a - b) end

function lerp(a, b, t) return a * (1 - t) + b * t end