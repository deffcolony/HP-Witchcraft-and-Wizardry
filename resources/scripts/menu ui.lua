function draw()
	UiMakeInteractive()

	UiAlign("center")

	UiTranslate(350, 0)
	UiColor(0, 0, 0, 0.2)
	UiRect(480, 1080)

	UiFont("Bold.ttf", 48)
	UiColor(1, 1, 1)

	UiTranslate(0, 200)
	if UiTextButton("other menu") then
		draw = other_menu
	end

	--UiImageBox("MOD/resources/img/popup_menu_bg.png", 100, 800, 64, 64)
end

function other_menu()

end