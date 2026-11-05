-- states
FH.states = {
	pregame = FH:require("game/states/pregame/main.lua"),
	game = FH:require("game/states/game/main.lua"),
	intermission = FH:require("game/states/intermission/main.lua"),
	map_vote = FH:require("game/states/map_vote/main.lua")
}

--- @param gamestate fh_gamestate_t
--- @param call_exit boolean|nil
local function set_state(gamestate, call_exit)
	if call_exit == nil then call_exit = true end

	local game = FH.game
	local state = game.state

	-- if state and call_exit then
	-- 	state:exit()
	-- end

	game.state = gamestate:new()
end

-- functions
function FH:isGametype()
	---@diagnostic disable-next-line: undefined-global
	return gametype == GT_FH_HEIST
end

function FH:initGametype()
	FH.players = {} -- globally reset player data from last round
	set_state(FH.states.game)
end

function FH:loadGametype()
	-- FH.states.game:load()
end

-- hooks
addHook("MapChange", function(...)
	FH:initGametype()
	-- FH:dispatchStateHook("MapChange", ...)
end)

addHook("MapLoad", function(...)
	FH:loadGametype()
	-- FH:dispatchStateHook("MapLoad", ...)
end)