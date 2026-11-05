--- @class fh_gamestate_t
local gamestate_t = {}
gamestate_t.__index = gamestate_t

local hooks = {
	"NetVars",
	"MapChange",
	"MapLoad",
	"PlayerJoin",
	"PreThinkFrame",
	"ThinkFrame",
	"PostThinkFrame",
	"JumpSpecial",
	"AbilitySpecial",
	"SpinSpecial",
	"JumpSpinSpecial",
	"BotTiccmd",
	"PlayerMsg",
	"PlayerSpawn",
	"ShieldSpawn",
	"ShieldSpecial",
	"PlayerCanDamage",
	"PlayerQuit",
	"IntermissionThinker",
	"TeamSwitch",
	"ViewpointSwitch",
	"SeenPlayer",
	"PlayerThink",
	"GameQuit",
	"PlayerCmd",
	"MusicChange",
	"PlayerHeight",
	"PlayerCanEnterSpinGaps",
	"AddonLoaded",
	"KeyDown",
	"KeyUp"
}

local mobjHooks = {
	"ShouldDamage",
	"MobjDamage",
	"MobjDeath",
	"BossDeath",
	"MobjRemoved",
	"BotRespawn",
	"HurtMsg"
}

local stringHooks = {
	"ShouldJingleContinue"
}

local hudHooks = {
	"game",
	"scores",
	"title",
	"titlecard",
	"intermission",
	"continue",
	"playersetup"
}

function gamestate_t:new()
	return setmetatable({}, self)
end

--- @param name string
function gamestate_t:extend(name)
	local newState = setmetatable({name = name}, self)
	newState.__index = newState
	registerMetatable(newState)

	return newState
end

--- implement functions into the state
--- does not override previous code in functions
function gamestate_t:implement(...)
	for _, funcs in ipairs({...}) do
		for key, value in pairs(funcs) do
			if type(value) == "function" then
				local oldFunc = self[key]
				self[key] = function(self, ...)
					if oldFunc then
						oldFunc(self, ...)
					end

					return value(self, ...)
				end
			else
				self[key] = value
			end
		end
	end
end

for _, hookName in ipairs(hooks) do
	gamestate_t[hookName] = function() end
end

for _, hookName in ipairs(mobjHooks) do
	gamestate_t[hookName] = function() end
end

for _, hookName in ipairs(stringHooks) do
	gamestate_t[hookName] = function() end
end

for _, hookName in ipairs(hudHooks) do
	gamestate_t[hookName.."HUD"] = function() end
end

-- custom hooks to work shit out

function gamestate_t:PlayerDamage(player, inflictor, source, damage, flags) end
function gamestate_t:PlayerDeath(player, inflictor, source, damage, flags) end
function gamestate_t:PlayerPreThink(player) end
function gamestate_t:PlayerThinkFrame(player) end
function gamestate_t:PlayerPostThink(player) end
function gamestate_t:PlayerMobjThink(player) end
function gamestate_t:SignGrabbed(player, sign) end

local noHooks = {
	["PreThinkFrame"] = true,
	["ThinkFrame"] = true,
	["PostThinkFrame"] = true,
	["PlayerQuit"] = true,
	["PlayerJoin"] = true
}

function FH:dispatchStateHook(hookName, ...)
	local state = self.game.state
	if not state then
		return
	end

	return state[hookName](state, ...)
end

local function registerStateHook(hookName, ...)
	if noHooks[hookName] then return end

	addHook(hookName, function(...)
		return FH:dispatchStateHook(hookName, ...)
	end, ...)
end

for _, hookName in ipairs(hooks) do
	registerStateHook(hookName)
end

for _, hookName in ipairs(mobjHooks) do
	registerStateHook(hookName)
end

for _, hookName in ipairs(stringHooks) do
	registerStateHook(hookName)
end

-- manually add for bullshit
for _, hookName in ipairs(hudHooks) do
	---@diagnostic disable-next-line: param-type-mismatch
	addHook("HUD", function(...)
		local state = FH.game.state

		if not state then
			return
		end

		return state[hookName.."HUD"](state, ...)
	end, hookName)
end

-- thinkframe, prethinkframe, and postthinkframe get their own manual hooks here so we can call PlayerThinkFrame and whatever
addHook("PreThinkFrame", function()
	local game = FH.game
	local state = game.state

	if not game.state then return end

	game.state:PreThinkFrame()
	for player in players.iterate do
		game.state:PlayerPreThink(player)
	end
end)
addHook("ThinkFrame", function()
	local game = FH.game
	local state = game.state

	if not game.state then return end

	game.state:ThinkFrame()
	for player in players.iterate do
		game.state:PlayerThinkFrame(player)
	end
end)
addHook("PostThinkFrame", function()
	local game = FH.game
	local state = game.state

	if not game.state then return end

	game.state:PostThinkFrame()
	for player in players.iterate do
		game.state:PlayerPostThink(player)
	end
end)

return gamestate_t