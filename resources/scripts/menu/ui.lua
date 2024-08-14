#include "../../../ui/TGUI_ui_library.lua"
#include "../../../ui/HPTDui_manager.lua"

function init()
	globalWindowOpacity = 1;tgui_ui_assets = "MOD/ui/TGUI_resources"
	-- uic_debug_buttontextWidth = true;
	levels = {
		{name = "Privet Drive", path = "MOD/privetdrive.xml", locked = false},
		-- {name = "Bardar's Testing", path = "MOD/script_testing.xml", locked = true},
		{name = "Entrance gate Hogwarts", path = "MOD/entrance.xml"},
		{name = "Kings Cross Station", path = "MOD/kings_cross.xml"},
		{name = "Little Whinging", path = "MOD/Little Whinging.xml"},
	}

	ALL_WINDOWS_OPEN = {};
end

isNewGame_sandbox_open = false;
menuButtons = {h = 0}

function draw(dt)
	
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
			-- {
			-- 	text = "More Actions test",
			-- },
			{
				text = "Sandbox",
				action = function()
					-- isNewGame_sandbox_open = true;
					table.insert(ALL_WINDOWS_OPEN, {
						firstFrame = true,
						startMiddle  = true,
						allowResize = false,
						pos = { x=0, y=0 },
						-- size = { w = 370, h = 300 },
						title = "NEW SANDBOX GAME",
						content = function( window )
							UiAlign('center top')
							UiTranslate(UiCenter(), 0)
							for i,v in ipairs(levels) do
								if v.locked then
									UiPush()
										UiAlign('right top');
										UiTranslate(-UiCenter()+750*1.5-12)
										uic_text("( locked icon )", 48, 24);
									UiPop()

									UiColor(0.3,0.3,0.3,1)
								else
									UiColor(1,1,1,1)
								end
								uic_button_func({}, dt, v.name, 750, 48, false, "", function()
									if not v.locked then
										StartLevel("yes", v.path)
									end
								end, 0, {
									fontSize = 28,
								})	
								UiTranslate(0,46)
							end
						end
					})
					-- DebugPrint('new sandbox game')
					-- draw = level_select()
				end
			},
			-- {
			-- 	text = "Credits",
			-- 	action = function()
			-- 		table.insert(activeWindows, {
			-- 			firstFrame = true,
			-- 			startMiddle  = true,
			-- 			allowResize = false,
			-- 			pos = { x=0, y=0 },
			-- 			-- size = { w = 370, h = 300 },
			-- 			title = "Credits",
			-- 			content = function()

			-- 			end
			-- 		});
			-- 	end
			-- },
			{
				text = "News",
				action = function()
					table.insert(ALL_WINDOWS_OPEN, {
						firstFrame = true,
						startMiddle  = true,
						allowResize = false,
						pos = { x=0, y=0 },
						newsSCrollingContainer = {
						},
						-- size = { w = 370, h = 300 },
						title = "News",
						content = function(window)
							function updateHeaderName(name) 
								UiAlign('left top')
								UiTranslate(0, 0)
								uic_text(name, 50, 42);
								UiTranslate(0,50);
							end
							function updateItem(type ,value) 
								if type == "text" then
									UiAlign('left top')
									UiTranslate(0,0)
									uic_text(value, 24, 24)
								elseif type == "image" then
									UiAlign('left top')
									UiTranslate(0,0)
									UiImage(value)
									-- uic_image(text, 24, 24)
								end
							end
							function imageIcon(icon) 
								if icon == "wand" then UiImageBox('./icons/magic-wand.png', 24, 24) elseif icon == "wizard" then UiImageBox('./icons/man-mage.png', 24, 24) end
							end
							function UINewslistingManager(listOfNews)
								for i,v in ipairs(listOfNews) do
									UiPush()
										if v.icon == nil then else
											imageIcon(v.icon) UiTranslate(26,0);
										end
										updateItem(v.type, v.value)
									UiPop()	
									UiTranslate(0,24)
								end
							end

							uic_scroll_Container(window.newsSCrollingContainer, UiWidth(), UiHeight(), true, 1000, 0, function()
								updateHeaderName("Update 0.1.1 - Unfinished maps")
								uic_text("UPDATE", 24, 24, {font=tgui_ui_assets.."/Fonts/TAHOMABD.TTF"})
								UiTranslate(0,24)
								UINewslistingManager({
									{icon = "wand",type = "text",value = "FIXED - Buttons are now visible in the sandbox menu."},
									{icon = "wand",type = "text",value = "FIXED - Map exposure is now correct."},
									{icon = "wizard",type = "text",value = "ADDED - Unfinished maps are now listed."},
									{icon = "wizard",type = "text",value = "ADDED - Trains are now in the Kings Cross station."},
								})
								UiTranslate(0,24)
								updateHeaderName("Update 0.1.0 - map")
								uic_text("MAP UPDATE", 24, 24, {font=tgui_ui_assets.."/Fonts/TAHOMABD.TTF"})
								UiTranslate(0,24)
								UINewslistingManager({
									{icon = "wizard",type = "text",value = "ADDED - Shower head water stream."},
									{icon = "wizard",type = "text",value = "ADDED - Shower on/off."},
									{icon = "wizard",type = "text",value = "ADDED - Bathroom steam when shower is on."},
									{icon = "wizard",type = "text",value = "ADDED - The sink can now turn on and off."},
									{icon = "wizard",type = "text",value = "ADDED - The sink emits water particles."},
									{icon = "wizard",type = "text",value = "ADDED - The sink's volume fades based on distance."},
									{icon = "wizard",type = "text",value = "ADDED - Toilet can be flushed."},
									{icon = "wizard",type = "text",value = "CHANCED - Map is now darker."},
								})
								UiTranslate(0,24)
								uic_text("BUG FIXES", 24, 24, {font=tgui_ui_assets.."/Fonts/TAHOMABD.TTF"})
								UiTranslate(0,24)
								UINewslistingManager({
									{icon = "wand",type = "text",value = "FIXED - UI Button."},
									{icon = "wand",type = "text",value = "FIXED - Smoke from the fireplace coming inside the house"},
									{icon = "wand",type = "text",value = "FIXED - the tvs in harry's house. They now display the correct image and the tv upstairs won't play automatically anymore"},
									{icon = "wand",type = "text",value = "FIXED - Bathroom shower steam dimensions."},
								})
								UiTranslate(0,24)
							end)

							-- UiPush()
							-- 	imageIcon("wizard") UiTranslate(26,0);
							-- 	updateItem("text", "ADDED - Shower head water stream.")
							-- UiPop()	
							-- UiTranslate(0,24)
							-- UiPush()
							-- 	imageIcon("wizard") UiTranslate(26,0);
							-- 	updateItem("text", "ADDED - Shower on/off.")
							-- UiPop()	
							-- UiTranslate(0,24)
							-- UiPush()
							-- 	imageIcon("wizard") UiTranslate(26,0);
							-- 	updateItem("text", "ADDED - Bathroom steam when shower is on.")
							-- UiPop()	

							--[[
								MAP UPDATE
								🧙‍♂️ ADDED – Shower head water stream
								🧙‍♂️ ADDED – Shower on/off.
								🧙‍♂️ ADDED – Bathroom steam when shower is on.
								🧙‍♂️ ADDED – The sink can now turn on and off.
								🧙‍♂️ ADDED – The sink emits water particles.
								🧙‍♂️ ADDED – The sink's volume fades based on distance.
								🧙‍♂️ ADDED – Toilet can be flushed

								BUG FIXES
								🪄 FIXED – UI Button
								🪄 FIXED – Smoke from the fireplace coming inside the house
								🪄 FIXED – the tvs in harry's house. They now display the correct image and the tv upstairs won't play automatically anymore.
								🪄 FIXED – Bathroom shower steam dimensions. 
							]]

							-- UiTranslate(0,24)
							-- UiPush()
							-- 	imageIcon("wand") UiTranslate(26,0);
							-- 	updateItem("text", "REMOVED - nothing")
							-- UiPop()	
							-- UiTranslate(0,24)
							-- uic_text("No news available", 24, 22)
						end
					});
				end
			},
			{
				text = "Settings",
				action = function()
					table.insert(ALL_WINDOWS_OPEN, {
						firstFrame = true,
						startMiddle  = true,
						allowResize = false,
						pos = { x=0, y=0 },
						newsSCrollingContainer = {
						},
						-- size = { w = 370, h = 300 },
						title = "Settings",
						content = function(window)
							local checkboxPadding = 24;
							UiPush()
								UiPush()
									uic_checkbox("Enable Music", "savegame.mod.HPTD.settings.enableSound", 200);
									UiTranslate(0, checkboxPadding);
									uic_checkbox("Enable Sound Effects", "savegame.mod.HPTD.settings.enableSoundEffects", 200);
									UiTranslate(0, checkboxPadding);
									uic_checkbox("Enable Voice", "savegame.mod.HPTD.settings.enableVoice", 200);
									UiTranslate(0, checkboxPadding);
									uic_checkbox("Enable Developer Tools", "savegame.mod.HPTD.settings.enableDeveloperTools", 200);
								UiPop()
							UiPop()
						end
					})
				end
			},
			{
				text = "Credits",
				action = function()
					table.insert(ALL_WINDOWS_OPEN, {
						firstFrame = true,
						startMiddle  = true,
						allowResize = false,
						pos = { x=0, y=0 },
						newsSCrollingContainer = {
						},
						-- size = { w = 370, h = 300 },
						title = "Credits",
						content = function(window)
							UiPush()
								UiPush()
									local t = uic_text("Created by", 32, 32);
									UiTranslate(0, t.height);
									uic_text("Deffcolony", 28, 28);

								UiPop()
							UiPop()
						end
					})
				end
			},
			{
				text = "Quit",
				action = function()
					Menu()
				end
			},
		}, false, {textAlgin = "right", buttonHeight = 36, fontSize = 36, centerButtons = true})
	UiPop()
	initDrawHPRD_UI(ALL_WINDOWS_OPEN)

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