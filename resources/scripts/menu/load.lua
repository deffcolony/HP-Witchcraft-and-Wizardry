menu_levels = {"MOD/privetdrive.xml"}

function tick()
	StartLevel("Harry Potter", menu_levels[math.random(#menu_levels)], "menu")
end