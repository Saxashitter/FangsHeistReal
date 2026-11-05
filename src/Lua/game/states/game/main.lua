--- @type fh_gamestate_t
local super = FH:require("classes/gamestate_t.lua")
local signFuncs = FH:require("freeslots/objects/sign/funcs.lua")
local heist_t = FH:require("classes/heist_t.lua") --[[ @as heist_t ]]

--- @class fh_gamestate_game_t : fh_gamestate_t
local state = setmetatable({}, super)
state.__index = state
registerMetatable(state)

print("initalized")

function state:new()
	local self = super.new(state)
	local game = FH.game

	print("initalized")

	game.tics = (2 * TICRATE) * 60
	game.escape = false

	return self
end

function state:MapLoad()
	-- this isnt ran in the state thingy, this is global
	local game = FH.game

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
	print("Frames are thinking")
	for player in players.iterate do
		if player.cmd.buttons & BT_TOSSFLAG and player.heist.sign then
			signFuncs.dropSign(player)
		end
	end
end

return state