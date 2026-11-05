--- @type fh_gamestate_t
local super = FH:require("classes/gamestate_t.lua")
local heist_t = FH:require("classes/heist_t.lua")
local vector = FH:require("libs/common/vector3.lua")

--- @class fh_gamestate_game_t
local state = {}

--- @class mobj_t
--- dude lj update ur api
--- @field alpha fixed_t

local signFuncs = FH:require("freeslots/objects/sign/funcs.lua")

--- @param player player_t
function state:PlayerPreThink(player)
    if player.heist.escaped then
        player.cmd.buttons = 0
        player.cmd.sidemove = 0
        player.cmd.forwardmove = 0

        if not player.mo then
            return
        end

        player.mo.momx = 0
        player.mo.momy = 0
        player.mo.momz = 0
    end
end

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