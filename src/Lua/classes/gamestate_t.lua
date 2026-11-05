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

function gamestate_t:extend()
	local newState = setmetatable({}, self)
	newState.__index = newState
	registerMetatable(newState)

	return newState
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

function FH:dispatchStateHook(hookName, ...)
	local state = self.game.state
	if not state then
		return
	end

	return state[hookName](state, ...)
end

local function registerStateHook(hookName, ...)
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

return gamestate_t