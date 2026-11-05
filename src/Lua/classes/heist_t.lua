--- @class heist_t
--- goes on top of the player to store gametype-related data
local heist_t = {}
registerMetatable(heist_t)

--- if the player has the sign, this is a mobj. otherwise nuh uh
--- @type mobj_t|nil
heist_t.sign = nil

--- if the player has escaped
--- @type boolean
heist_t.escaped = false

--- players pressed buttons but not resetted
--- @type number
heist_t.buttons = 0

--- players last pressed buttons but not resetted
--- @type number
heist_t.lastbuttons = 0

--- players pressed sidemove but not resetted
--- @type number
heist_t.sidemove = 0

--- players last pressed sidemove but not resetted
--- @type number
heist_t.lastsidemove = 0

--- players pressed forwardmove but not resetted
--- @type number
heist_t.forwardmove = 0

--- players last pressed forwardmove but not resetted
--- @type number
heist_t.lastforwardmove = 0

--- //////////////////
--- // PLAYER SETUP //
--- //////////////////

--- @class player_t
--- fang's heist related data
--- @field heist heist_t

local player_t = userdataMetatable("player_t")
if player_t then
	local __index = player_t.__index
	player_t.__index = function(self, key)
		if key == "heist" then
			if not FH.players[#self] then
				FH.players[#self] = setmetatable({}, heist_t)
			end
		
			return FH.players[#self]
		end

		return __index(self, key)
	end
end

addHook("PlayerQuit", function(player)
	local game = FH.game
	if game.state then
		game.state:PlayerQuit(player)
	end

	FH.players[#player] = nil
end)

addHook("PlayerJoin", function(node)
	local game = FH.game
	if game.state then
		game.state:PlayerJoin(node)
	end
	FH.players[node] = setmetatable({}, heist_t)
end)

return heist_t
