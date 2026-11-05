--- @type fh_gamestate_t
local super = FH:require("classes/gamestate_t.lua")
local signFuncs = FH:require("freeslots/objects/sign/funcs.lua")

--- @class fh_gamestate_game_t : fh_gamestate_t
local state = super:extend("GameState")
state.__index = state
registerMetatable(state)

print("initalized")

function state:new()
	local state = super.new(state)
	local game = FH.game

	print("initalized")

	game.tics = 10 * TICRATE
	game.escape = false

	return state
end

function state:MapLoad()
	-- setup objects here
	print("hi im saxa")

	for thing in mapthings.iterate do
		if thing.type ~= 501 then continue end -- not the sign

		print("sign found")
		local x = thing.x*FU
		local y = thing.y*FU
		local z = R_PointInSubsector(x, y).sector.floorheight + thing.z*FU
		---@diagnostic disable-next-line: param-type-mismatch
		local angle = FixedAngle(thing.angle*FU)

		-- local sign = P_SpawnMobj(x, y, z, MT_FH_SIGN_IDLE)
		local sign = signFuncs.setupSign(nil, x, y, z)
		sign.angle = angle
		sign.inited = true
	end
end

function state:ThinkFrame()
	local game = FH.game
	
	if game.escape then
		game.tics = game.tics - 1
		
		if game.tics <= 0 then
			G_ExitLevel()
		end
	end
end

local position = 0
function state:PostThinkFrame()
	position = S_GetMusicPosition()
end

-- TODO: allow for other songs to be played
function state:MusicChange(old, new, mflags, looping, _, prefadems, fadeinms)
	local game = FH.game

	if not game.escape then
		return
	end

	-- if old:upper() ~= "FH_ESC" then
	-- 	return
	-- end

	return "FH_ESC", mflags, true, position, 0, 0
end

function state:startEscape()
	local game = FH.game

	S_ChangeMusic("FH_ESC", true)
	game.escape = true
end

COM_AddCommand("escape_start", function()
	local game = FH.game

	if not game.state then return end
	if game.state.name ~= "GameState" then return end

	game.state:startEscape()
end)

state:implement(
	FH:require("game/states/game/player.lua"),
	FH:require("game/states/game/hud.lua")
)

return state