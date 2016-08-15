PLUGIN = nil

function Initialize(Plugin)
	Plugin:SetName("MazeGenerator")
	Plugin:SetVersion(1)

	-- Hooks

	PLUGIN = Plugin -- NOTE: only needed if you want OnDisable() to use GetName() or something like that

	-- Use the InfoReg shared library to process the Info.lua file:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()
	RegisterPluginInfoConsoleCommands()

	cFile:CreateFolder("schematics")
	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function OnDisable()
	LOG(PLUGIN:GetName() .. " is shutting down...")
end

function handlePlayerGenerate(Split, Player)
	local usage = "Usage: " .. Split[1] .. " " .. Split[2] .. " <size> <name>"
	if (#Split ~= 4) then
		Player:SendMessageInfo(usage)
		return true
	end

	local position = Player:GetPosition() + Vector3d(1,0,1)
	local size = tonumber(Split[3])
	local name = Split[4]
	local world = Player:GetWorld()

	if(size == nil) then
		Player:SendMessageInfo(usage)
		return true
	end

	generateMaze(world, position, size, name)
	Player:SendMessage("Done!")
	return true
end

function handlePlayerSave(Split, Player)
	-- Logic missing
	return true
end
function NOTUSED(SPlit,Player)
	local usage = "Usage: " .. Split[1] .. " " .. Split[2] .. " <name>"
	if(#Split ~= 3) then
		Player:SendMessageInfo(usage)
		return true
	end

	local name = Split[3]
	local world = Player:GetWorld()
	local pos1 = Vector3i(0,0,0)
	local pos2 = Vector3i(10,10,10)
	local blockarea = cBlockArea():Read(world, pos1, pos2)

	blockarea:SaveToSchematicFile('schematics/' .. name)
	Player:SendMessage("Done!")
	return true
end

function handleConsoleGenerate(Split)
	local usage = "Usage: " .. Split[1] .. " " .. Split[2] .. " <x> <y> <z> <world> <size> <name>"
	if(#Split ~= 8) then
		LOGINFO(usage)
		return true
	end

	local x = tonumber(Split[3])
	local y = tonumber(Split[4])
	local z = tonumber(Split[5])
	local world = cRoot:Get():GetWorld(Split[6])
	local size = tonumber(Split[7])
	local name = Split[8]

	if(size == nil or x == nil or y == nil or z == nil or world == nil) then
		LOGINFO(usage)
		return true
	end

	local position = Vector3d(x,y,z)

	generateMaze(world, position, size, name)
	LOG("Done!")
	return true
end

function generateMaze(world, position, size, name)
	LOG("Generating...")
	local maze = Maze(size)
	maze.generate()

	LOG("Placing blocks...")
	local area = maze.getArea()
	area:Write(world, Vector3i(position))

--	LOG("Placing schematic...")
--	local schematic = cBlockArea():LoadFromSchematicFile('schematics/' .. name)
--	local size = Vector3d(schematic.GetSize())
--	schematic:Write(world, Vector3i(position + maze.getCenter() - size/2))
	
end
