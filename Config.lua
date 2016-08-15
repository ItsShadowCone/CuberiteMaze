-- Definitely do not touch. Function definition for a Block to provide easier config writing

function Block(block, variant)
	return {Block = block, Variant = variant}
end

-- Do not touch END, the rest do please touch

config = {}

config.height = 10 -- Defines the output height of each generated maze
config.scale = 2 -- How wide each corridor and wall should be
config.parts = 3 -- In how many parts should the maze be split, see walls and floors definition below (Note: the actual number of segments is N x N where N is this setting)

config.walls = {} -- Finisher definitions. 3 Parts mean up to 9 different segments. If not all 9 are present, multiple segments are filled with number 0. However, if 9 are present, 0 is never used (it's just the fallback)
config.walls[0] = {	Block(80,0),	Block(174,0)} -- By default this generates Snow (ID: 80, Variant: 0) and Packed Ice (ID: 174, Variant: 0) in most segments. Add custom Block(ID, VARIANT) statements according to your need
config.walls[1] = {	Block(5,5),	Block(162,1),	Block(191,0)}
config.walls[2] = {	Block(139,0),	Block(98,0),	Block(98,2),	Block(98,3)}
config.walls[3] = {	Block(24,0),	Block(24,1),	Block(24,2)}
config.walls[4] = {	Block(17,3),	Block(5,4), 	Block(190,0),	Block(18,3)}
config.walls[5] = {	Block(112,0),	Block(113,0),	Block(153,0)}
config.walls[6] = {	Block(155,0),	Block(155,1),	Block(155,2)}
	
config.floors = {} -- Same applies as above list. NOTE: always define the same amount of floor values as wall values
config.floors[0] = {	Block(9,0),	Block(79,0)}
config.floors[1] = {	Block(161,1)}
config.floors[2] = {	Block(1,6)}
config.floors[3] = {	Block(12,0)}
config.floors[4] = {	Block(3,1),	Block(13,0),	Block(48,0)}
config.floors[5] = {	Block(87,0),	Block(154,0)}
config.floors[6] = {	Block(168,0)}

-- Probably do not touch these values, they control the block values for AIR (what is where players should walk in) and BARRIER (to provide a ceiling)
config.air = Block(0,0)
config.barrier = Block(166,0)
