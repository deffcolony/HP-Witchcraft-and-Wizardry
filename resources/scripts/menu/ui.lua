#include "../../../ui/TGUI_ui_library.lua"
#include "../../../ui/TGUI_manager.lua"

function init()
	globalWindowOpacity = 1;tgui_ui_assets = "MOD/ui/TGUI_resources"
	-- uic_debug_buttontextWidth = true;
	levels = {
		{name = "Privet Drive", path = "MOD/privetdrive.xml"},
		-- {name = "Bardar's Testing", path = "MOD/script_testing.xml"},
		-- {name = "Some Other Map", path = "MOD/entrance.xml"}
		}

	activeWindows = {};
end

isNewGame_sandbox_open = false;
menuButtons = {h = 0}

function draw()
	
	-- UiPop()

	UiMute(1)

	playMenuMusic()

	UiMakeInteractive()
	UiPush()
		UiColor(1,1,1,1)
		UiTranslate(UiCenter(),UiHeight())
		UiAlign('center bottom')
		uic_text("UI is in placeholder phase", 32, 24)
	UiPop()
	UiPush()
		UiTranslate(UiWidth() - 70, UiMiddle())
		UiAlign("left middle")

		uic_CreateGameMenu_Buttons_list(menuButtons, 300, {
			-- {
			-- 	text = "Campaign",
			-- },
			{
				text = "Sandbox",
				action = function()
					-- isNewGame_sandbox_open = true;
					table.insert(activeWindows, {
						firstFrame = true,
						startMiddle  = true,
						allowResize = false,
						pos = { x=0, y=0 },
						size = { w = 370, h = 300 },
						title = "NEW SANDBOX GAME",
						content = function( window )
							for i,v in ipairs(levels) do
								uic_button_func(0, v.name, UiWidth(), 32, false, false, function()
									StartLevel("yes", v.path)
								end)	
								UiTranslate(0,34)
							end
						end
					})
					-- DebugPrint('new sandbox game')
					-- draw = level_select()
				end
			},
			{
				text = "Quit",
				action = function()
					Menu()
				end
			},
			-- {
			-- 	text = "Button Test",
			-- },
			-- {
			-- 	text = "Button Test",
			-- },
			-- {
			-- 	text = "Button Test",
			-- },
			-- {
			-- 	text = "Button Test",
			-- },
		}, false, {textAlgin = "right", buttonHeight = 36, fontSize = 36})
	UiPop()
	initDrawTGUI(activeWindows)

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

function playMenuMusic()
	PlayMusic('MOD/resources/snd/music/MysteriousNightMasterBlend.ogg')
end

-- Utility Functions:
function inv_lerp(a, b, v) return (v - a) / (a - b) end

function lerp(a, b, t) return a * (1 - t) + b * t end