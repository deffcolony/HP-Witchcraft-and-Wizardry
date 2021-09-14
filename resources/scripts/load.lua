menu_levels = {"MOD/script_testing.xml", "MOD/privetdrive.xml"}

function tick()
	StartLevel("yeehaw", menu_levels[math.random(#menu_levels)], "menu")
end