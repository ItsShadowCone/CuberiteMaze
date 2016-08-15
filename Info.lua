g_PluginInfo =
{
	Name = "MazeGenerator",
	Date = "2016-08-14",
	Description = "This plugin generates random maze's using Kruskal's algorithm with randomly weighted edges",

	-- The following members will be documented in greater detail later:
	AdditionalInfo = {
		{
			Title = "Warning",
			Contents = "As of rounding errors or slight inaccuracies in the code the actual maze size may be different than requested and the actual segment's size may be different"
		},
		{
			Title = "Another warning",
			Contents = "The plugin overwrites blocks without undo cache and without checking limitations for the player executing it. Be careful whom you give the permission to use it as it may enable really big grief (/maze generate 1000000 for example will make the server lag really hard, maybe until killed by the OOM killer and may overwrite really really many blocks in one go)"
		},
		{
			Title = "One last warning",
			Contents = "Forgot at the moment what to enter here :) but there was something"
		},
		{
			Title = "Kruskal's algorithm",
			Contents = "This maze generator uses Kruskal's algorithm to generate a minimum spanning tree of a graph with weighted edges and in this case the edges are randomly weighted. This means, in short, a sqare grid of lots of dots is generated and a randomly sorted list of each edges (one edge connects two nodes direcly next to each other). Now, the plugin checks for each edge if it would generate cycles in the tree, otherwise merge the tree with the edge. For details, see Wikipedia (https://en.wikipedia.org/wiki/Kruskal%27s_algorithm)"
		}
	},
	Commands = {
		["/maze"] = {
			Subcommands = {
				generate = {
					HelpString = "Generate a maze at your coordinates with the given size and the given name as saved earlier with /maze save",
					Permission = "maze.generate",
					Alias = "g",
					Handler = handlePlayerGenerate,
					ParameterCombinations = {
						{
							Params = "size name",
							Help = "Generates the maze with the given size and the given name for the center of the maze"
						}
					}
				},
				save = {
					HelpString = "Saves your current WorldEdit selection for use in maze generation",
					Permission = "maze.save",
					Alias = "s",
					Handler = handlePlayerSave,
					ParameterCombinations = {
						{
							Params = "name",
							Help = "Saves the current selection with the specified name"
						}
					}
				}
			}
		}
	},
	ConsoleCommands = {
		maze = {
			Subcommands = {
				generate = {
					HelpString = "Generate a maze at given coordinates with the given size and the given name as saved earlier with /maze save",
					Alias = "g",
					Handler = handleConsoleGenerate,
					ParameterCombinations = {
						{
							Params = "x y z world size name",
							Help = "Generates the maze in the given world at the given coordinates with the given size and the given name for the center of the maze"
						}
					}
				}
			}
		}
	},
	Permissions = {
		["maze.generate"] = {
			Description = "Allows the player to generate mazes and through that to overwrite any blocks",
			RecommendedGroups = "admins"
		},
		["maze.save"] = {
			Description = "Allows the player to save the center for a maze and through that affect future maze generations",
			RecommendedGroups = "admins"
		}
	},
}

