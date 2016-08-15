FLOOR = Block(1000000,0)
WALL = Block(1000001,0)

function Maze(outputsize)
	local mazesize = (outputsize - 1) / (2 * config.scale)
	local blocksize = mazesize * 2 + 1;
	local blockarea = cBlockArea()
	blockarea:Create(outputsize, config.height, outputsize)
	local edges = {}
	local forest = {}
	local tree = {}

	local generate = function()
		-- Initialize edges and the forest
		for x=1,mazesize do
			for y=1,mazesize do
				local function down()
					if(x > (mazesize-1)) then
						return nil
					end
					return {A = {x,y}, B = {x+1,y}}
				end

				local function right()
					if(y > (mazesize-1)) then
						return nil
					end
					return {A = {x,y}, B = {x,y+1}}
				end

				local function insert(edge)
					if(edge ~= nil) then
						table.insert(edges, edge)
					end
				end

				insert(down())
				insert(right())

				table.insert(forest, { {x,y} })
			end
		end
		shuffleTable(edges)

		-- Generate the unified minimum spanning tree
		for index,edge in pairs(edges) do
			local function getForestIndex(node)
				local ret = -1;
				for index,tree in pairs(forest) do
					for thisIndex,thisNode in pairs(tree) do
						if(thisNode[1] == node[1] and thisNode[2] == node[2]) then
							ret = index
						end
					end
				end
				return ret
			end

			local indexA = getForestIndex(edge["A"])
			local indexB = getForestIndex(edge["B"])
			if(indexA > -1 and indexB > -1 and indexA ~= indexB) then
				table.insert(tree, edge)

				-- Union edge.A, edge.B
				local treeA = forest[indexA]
				local treeB = forest[indexB]
				for index,node in pairs(treeB) do
					table.insert(treeA, node)
				end
				forest[indexA] = treeA
				table.remove(forest, indexB)
			end
		end

		-- Transform the Tree into blocks (a cBlockArea)
		finish()
	end

	function finish()
		local blocks = {}
		-- Initialize blocks variable with Barrier at top and FLOOR/WALL placeholders
		for x=1,blocksize do
			blocks[x] = {}
			for y=1,config.height do
				blocks[x][y] = {}
				for z=1,blocksize do
					local block = nil
					if(y == 1) then
						block = FLOOR
					elseif(y == config.height) then
						block = config.barrier
					else
						block = WALL
					end
					blocks[x][y][z] = block
				end
			end
		end

		-- Fill corridors with AIR
		for index,edge in pairs(tree) do
			local edgeX = edge.A[1] + edge.B[1]
			local edgeZ = edge.A[2] + edge.B[2]
			local AX = edge.A[1] * 2
			local AZ = edge.A[2] * 2
			local BX = edge.B[1] * 2
			local BZ = edge.B[2] * 2

			for y=2,config.height-1 do
				blocks[edgeX][y][edgeZ] = config.air
				blocks[AX][y][AZ] = config.air
				blocks[BX][y][BZ] = config.air
			end
		end

		-- Scale to config size
		local newBlocks = {}
		for x=1,outputsize do
			newBlocks[x] = {}
			for y=1,config.height do
				newBlocks[x][y] = {}
				for z=1,outputsize do
					local thisX = math.ceil(x/config.scale)
					local thisZ = math.ceil(z/config.scale)
					newBlocks[x][y][z] = blocks[thisX][y][thisZ]
				end
			end
		end
		blocks = newBlocks

		-- Convert WALL/FLOOR placeholders to actual blocks and put into blockarea
		local FACTOR = math.ceil(outputsize/config.parts)
		for x=1,outputsize do
			for y=1,config.height do
				for z=1,outputsize do
					if(blocks[x][y][z] == WALL or blocks[x][y][z] == FLOOR) then
	                                        local xPart = math.floor(x / FACTOR) + 1 -- originally 0-based, +1 to have it 1-based for convinience
	                                        local zPart = math.floor(z / FACTOR) + 1
						local part = xPart + (zPart-1)*config.parts
						local floors = config.floors
						local walls = config.walls
						local addressedSegments = #config.walls

						if(addressedSegments < config.parts^2) then
							for x=1,config.parts^2-addressedSegments do
								table.insert(floors, floors[0])
								table.insert(walls, walls[0])
							end
						end

						local wallorfloor = nil
						if(blocks[x][y][z] == WALL) then
							wallorfloor = walls[part]
						elseif(blocks[x][y][z] == FLOOR) then
							wallorfloor = floors[part]
						end
						blocks[x][y][z] = wallorfloor[math.random(1, #wallorfloor)]
					end

					local block = blocks[x][y][z]
					blockarea:SetRelBlockTypeMeta(x-1,y-1,z-1, block.Block, block.Variant)
				end
			end
		end
	end

	local getCenter = function()
		return Vector3d(outputsize/2, 0, outputsize/2)
	end

	local getArea = function()
		return blockarea
	end

	return {
		generate = generate,
		getCenter = getCenter,
		getArea = getArea
	}
end
