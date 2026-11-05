--- The global table where all mod-related functions and data is kept.
local FH = {
	--- Where the game-related variables live. Synched with NetVars
	game = {},
	--- Where player metatable data is stored.
	players = {}
}
local files = {}

--- Run a lua file within the mod. Unlike dofile, this only runs scripts once and saves the return value.
--- @param fileName string The name of the file
--- @return any
function FH:require(fileName)
	if not files[fileName] then
		files[fileName] = dofile(fileName)
	end
	
	return files[fileName]
end

addHook("NetVars", function(network)
	FH.game = network($)
end)

rawset(_G, "FH", FH)