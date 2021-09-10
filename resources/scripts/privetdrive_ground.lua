file = GetString("file", "testground.png", "script png")
heightScale = GetInt("scale", 64)
tileSize = GetInt("tilesize", 128)

function init()
	matRock = CreateMaterial("rock", 0.3, 0.3, 0.3)
	matDirt = CreateMaterial("dirt", 0.45, 0.33, 0.30, 1, 0, 0.1)
	matGrass1 = CreateMaterial("unphysical", 0.32, 0.42, 0.30, 1, 0, 0.2)
	matGrass2 = CreateMaterial("unphysical", 0.32, 0.46, 0.28, 1, 0, 0.2)
	matTarmac = CreateMaterial("masonry", 0.45, 0.42, 0.40, 1, 0, 0.4)
	matTarmacTrack = CreateMaterial("masonry", 0.2, 0.2, 0.2, 1, 0, 0.3)
	matTarmacLine = CreateMaterial("masonry", 0.6, 0.6, 0.6, 1, 0, 0.6)
	
	LoadImage(file)
	
	w,h = GetImageSize()

	local maxSize = tileSize
	
	local y0 = 0
	while y0 < h do
		local y1 = y0 + maxSize
		if y1 > h then y1 = h end

		local x0 = 0
		while x0 < w do
			local x1 = x0 + maxSize
			if x1 > w then x1 = w end
			Vox(x0, 0, y0)
			Heightmap(x0, y0, x1, y1, heightScale, hollow==0)
			x0 = x1
		end
		y0 = y1
	end
end

