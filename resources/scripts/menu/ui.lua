function init()
	levels = {
		{name = "Privet Drive", path = "MOD/privetdrive.xml"},
		--{name = "Bardar's Testing", path = "MOD/script_testing.xml"},
		--{name = "Some Other Map", path = "MOD/entrance.xml"}
		}
end

function draw()
	UiMakeInteractive()

	UiTranslate(350, 0)
	UiAlign("center")
	UiColor(1, 1, 1, 0.2)
	UiImageBox("MOD/resources/img/infobox.png", 400, 1080, 6, 6)

	-- Title
	UiTranslate(0, 200)
	UiColor(1, 1, 1)
	UiFont("bold.ttf", 50)
	UiText("Harry Potter", true)
	UiColor(0.9, 0.9, 0.9)
	UiFont("bold.ttf", 30)
	UiText("Witchcraft and Wizardry.", true)


	-- Buttons
	UiColor(1, 1, 1)
	UiFont("regular.ttf", 36)
	UiTranslate(0, 200)

	UiRect()
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
		scroll, done = UiSlider("MOD/resources/img/dot.png", "x", scroll or 0, 0, 400)
		move = inv_lerp(0, 400, scroll)
	UiPop()
	UiTranslate(UiCenter(), UiMiddle())

	UiTranslate(move * 200 * (#levels - 1), 0)
	UiWordWrap(175)

	UiFont("regular.ttf", 24)
	for i,v in ipairs(levels) do
		UiButtonImageBox("MOD/resources/img/box-outline-fill-6.png", 6, 6)
		if UiTextButton(v.name,  175, 175) then
			StartLevel("yes", v.path)
		end

		UiTranslate(200)
	end
end

-- Utility Functions:
function inv_lerp(a, b, v) return (v - a) / (a - b) end

function lerp(a, b, t) return a * (1 - t) + b * t end