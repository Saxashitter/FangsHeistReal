local PATH = "freeslots/objects/escape ring/"

FH:require(PATH.."states/idle.lua")
local funcs = FH:require(PATH.."funcs.lua")

addHook("TouchSpecial", function(ring, toucher)
	if not (ring.valid or toucher.valid) then
		return true
	end

	local player = toucher.player
	if not player then
		return true
	end

	player.heist.escaped = true
	return true
end, MT_FH_ESCAPERING)
