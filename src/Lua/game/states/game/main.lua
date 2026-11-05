--- @type fh_gamestate_t
local super = FH:require("classes/gamestate_t.lua")
local signFuncs = FH:require("freeslots/objects/sign/funcs.lua")
local vector = FH:require("libs/common/vector3.lua")

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
	game.ringLocations = {}

	return state
end

function state:MapLoad()
	-- setup objects here
	print("hi im saxa")

	local game = FH.game

	for thing in mapthings.iterate do
		local x = thing.x*FU
		local y = thing.y*FU
		local z = thing.z*FU + P_FloorzAtPos(thing.x*FU, thing.y*FU, ONFLOORZ, 32*FU)
		---@diagnostic disable-next-line: param-type-mismatch
		local angle = FixedAngle(thing.angle*FU)

		if thing.type == 501 then
			local sign = signFuncs.setupSign(nil, x, y, z)
			sign.angle = angle
			sign.inited = true
		end

		if thing.type == 1 then
			game.ringLocations[#game.ringLocations+1] = vector.new(x, y, z)
		end
	end
end

function state:ThinkFrame()
	local game = FH.game
	
	if game.escape and game.tics then
		game.tics = game.tics - 1
		
		if game.tics <= 0 then
			self:spawnEscapeRing()
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

function state:spawnEscapeRing()
	local game = FH.game
	local location = game.ringLocations[P_RandomRange(1, #game.ringLocations)]

	if location then
		print(location.y)
		P_SpawnMobj(location.x, location.y, location.z, MT_FH_ESCAPERING)
		print("Ring at "..tostring(location))
	end
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
