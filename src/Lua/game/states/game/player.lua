--- @type fh_gamestate_t
local super = FH:require("classes/gamestate_t.lua")
local heist_t = FH:require("classes/heist_t.lua")

--- @class fh_gamestate_game_t
local state = {}

local signFuncs = FH:require("freeslots/objects/sign/funcs.lua")

--- @param player player_t
function state:PlayerThink(player)
	if not player.mo then
		return
	end

	if player.cmd.buttons & BT_TOSSFLAG and player.heist.sign then
		signFuncs.dropSign(player)
	end
end

function state:SignGrabbed(player, sign)
    local game = FH.game

    if not game.escape then
        self:startEscape()
    end
end

return state