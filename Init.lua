PLUGIN = nil

mazes = {}

function Initialize(Plugin)
	Plugin:SetName("MazeGenerator")
	Plugin:SetVersion(1)

	-- Hooks

	PLUGIN = Plugin -- NOTE: only needed if you want OnDisable() to use GetName() or something like that

	-- Use the InfoReg shared library to process the Info.lua file:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()
	RegisterPluginInfoConsoleCommands()
	cPluginManager:AddHook(cPluginManager.HOOK_TICK, onTick);

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
function NOTUSED(Split,Player)
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
	local index = #mazes + 1
	LOG("Generating...")

	mazes[index] = {}
	mazes[index].maze = Maze(size)
	mazes[index].world = world
	mazes[index].position = position
	mazes[index].size = size
	mazes[index].name = name
	mazes[index].co = coroutine.create(function() 
		mazes[index].maze.generate()
	end)
	coroutine.resume(mazes[index].co)
end

function onTick(timeDelta)
	for index,maze in pairs(mazes) do
		LOG('Resuming ... ' .. index)
		coroutine.resume(mazes[index].co)
		if(coroutine.status(mazes[index].co) ~= 'suspended') then
			LOG("Finishing...")
			mazes[index].maze.finish()

			LOG("Placing blocks...")
			local area = mazes[index].maze.getArea()
			area:Write(mazes[index].world, Vector3i(mazes[index].position))

		--	LOG("Placing schematic...")
		--	local schematic = cBlockArea():LoadFromSchematicFile('schematics/' .. mazes[index].name)
		--	local size = Vector3d(schematic.GetSize())
		--	schematic:Write(mazes[index].world, Vector3i(mazes[index].position + mazes[index].maze.getCenter() - mazes[index].size/2))

			mazes[index] = nil
		end
	end
end
