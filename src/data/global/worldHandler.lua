local global = ...
local wh = {
	game,
	ra,
	biome,
	posY,
	lastStreetPosX = 0,
	lastBarrierPosX = {},
	lastObjectPosX = {},
	lastCalculatedX = 0,
	lastGapX = 0,
	lastGapY = 0,
}

--===== local functions =====--
local function print(...)
	if global.conf.debug.whDebug then
		global.debug(...)
	end
end

local function initBiomes()
	for i, b in pairs(global.biome) do
		if type(b) == "table" then
			b.maxStreetChance, b.maxBarrierChance, b.maxFuelContainerChance = 0, 0, 0
			for i, o in pairs(b.streets) do
				b.maxStreetChance = b.maxStreetChance + o.chance
			end
			for i, o in pairs(b.barriers) do
				b.maxBarrierChance = b.maxBarrierChance + o.chance
			end
			for i, o in pairs(b.fuelContainers) do
				b.maxFuelContainerChance = b.maxFuelContainerChance + o.chance
			end
		end
	end
end

local function pickObject(maxChance, objects)
	local rng = math.random(maxChance)
	local objectCount = 0
	local go = {}
	
	for i, o in pairs(objects) do
		objectCount = objectCount + o.chance
		if objectCount >= rng then
			return o
		end
	end
end

local function checkBlockedLines(line, gap, posX, lines)
	local lx = 0
	for l, x in pairs(lines) do
		if l ~= line then
			lx = x
		end
	end
	if lx + gap <= posX then
		return true
	else
		return false
	end
end

local function placeStreet(toX)
	while wh.lastStreetPosX < toX do
		print("[WH]: Adding street: X: " .. tostring(wh.lastStreetPosX))
		local go = wh.ra:addGO(pickObject(wh.biome.maxStreetChance, wh.biome.streets).name, {
			posX = wh.lastStreetPosX, 
			posY = wh.posY, 
			layer = 2,
			name = "Street",
		})
		wh.lastStreetPosX = wh.lastStreetPosX + go.ngeAttributes.sizeX
	end
end

local function placeBarrier(fromX, toX)
	local posX = fromX
	
	while posX < toX do
		for i, lbp in pairs(wh.lastObjectPosX) do
			if 
				lbp < posX and 
				math.random(wh.biome.barrierChance) == wh.biome.barrierChance and
				checkBlockedLines(i, wh.biome.barrierGaps, posX, wh.lastBarrierPosX)
			then
				print("[WH]: Adding barrier: X: " .. tostring(posX) .. " Y: " .. tostring(wh.posY + (i -1) * wh.game.streetWidth))
				local barrier = pickObject(wh.biome.maxBarrierChance, wh.biome.barriers)
				local object = wh.ra:addGO(barrier.name, {
					posX = posX,
					posY = wh.posY + (i -1) * wh.game.streetWidth, 
					layer = 3,
					defaultParticleContainer = wh.game.pcDefaultParticleContainer,
					name = "Barrier",
				})
				
				wh.lastObjectPosX[i] = posX + object.ngeAttributes.sizeX
				wh.lastBarrierPosX[i] = posX + object.ngeAttributes.sizeX
			end
		end
		posX = posX +1
	end
end

local function placeFuelContainer(fromX, toX)
	local posX = fromX
	
	while posX < toX do
		for i, lbp in pairs(wh.lastObjectPosX) do
			if 
				lbp < posX and 
				math.random(wh.biome.fuelContainerChance) == wh.biome.fuelContainerChance 
			then
				print("[WH]: Adding fuelContainer: X: " .. tostring(posX) .. " Y: " .. tostring(wh.posY + (i -1) * wh.game.streetWidth))
				local fuelContainer = pickObject(wh.biome.maxFuelContainerChance, wh.biome.fuelContainers)
				local object = wh.ra:addGO(fuelContainer.name, {
					posX = posX,
					posY = wh.posY + (i -1) * wh.game.streetWidth, 
					layer = 3,
					defaultParticleContainer = wh.game.pcDefaultParticleContainer,
					name = "FuelContainer",
				})
				
				wh.lastObjectPosX[i] = posX + object.ngeAttributes.sizeX
			end
		end
		posX = posX +1
	end
end

local function generateWorld(fromX, toX)	
	toX = toX +3
	placeStreet(toX)
	placeBarrier(fromX, toX)
	placeFuelContainer(fromX, toX)
	
	wh.lastCalculatedX = toX
end

--===== global functions =====--
function wh.start(game, y, biome)
	initBiomes()
	
	wh.game = game
	wh.ra = game.raMain
	wh.posY = y
	local fromX, toX = wh.ra:getFOV()
	
	for i = 1, game.lines do
		wh.lastBarrierPosX[i] = 0
		wh.lastObjectPosX[i] = 0
	end
	
	wh.biome = global.biome[biome]
	
	generateWorld(fromX +20, toX)
	
end

function wh.update()
	local fromX, toX = wh.ra:getFOV()
	generateWorld(wh.lastCalculatedX, toX)
end

function wh.stop()
	
end

return wh