local PATH = "freeslots/objects/escape ring/"

FH:require(PATH.."states/idle.lua")
local funcs = FH:require(PATH.."funcs.lua")

addHook("TouchSpecial", function(ring, toucher)
	if not (ring.valid or toucher.valid) then
		return true
	end

	local player = toucher.player
	local game = FH.game
	if not player then
		return true
	end

	player.heist.escaped = true
	toucher.alpha = 0
	toucher.momx = 0
	toucher.momy = 0
	toucher.momz = 0
	toucher.flags = $|MF_NOTHINK|MF_NOGRAVITY

	

	return true
end, MT_FH_ESCAPERING)
