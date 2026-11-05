local funcs = {}

local PATH = "freeslots/objects/sign/"
local idle = FH:require(PATH.."states/idle.lua")
local grabbed = FH:require(PATH.."states/grabbed.lua")

--- @class mobj_t
--- (FOR THE SIGN) stores original position of where the mobj was stored before pickup, and the lerp value
--- @field orig table
--- (FOR THE SIGN) this should only be true once the sign is completely initalized. TouchSpecial runs upon spawn and can cause the sign to be grabbed before it is fully initalized, this prevents that
--- @field inited boolean

--- initalizes sign at coordinates, spawns the overlay and sets up the player to be able to grab it
--- if coordinates arent supplied then it uses sign
--- call when the sign gets initalized through MapLoad
--- @param sign mobj_t|nil
--- @param x? fixed_t
--- @param y? fixed_t
--- @param z? fixed_t
function funcs.setupSign(sign, x, y, z)
	if not sign then
		sign = P_SpawnMobj(x, y, z, idle)

		if not sign.valid then
			return
		end
	end

	local board = P_SpawnMobjFromMobj(sign, 0, 0, 0, MT_OVERLAY);
	if not board.valid then
		return
	end
		
	sign.tracer = board
	board.angle = sign.angle
	board.target = sign
	board.state = S_SIGNBOARD
	board.movedir = ANGLE_90
	
	
	if not sign.target then
		A_SignPlayer(sign, -3, 0)
	else
		A_SignPlayer(sign, -1, 0)
	end

	board.dispoffset = sign.dispoffset + 10
	
	return sign
end

--- makes player grab the sign, transferring the overlay and applying nerfs and whatnot
--- this will also start the escape sequence in gamemodes that support it
--- @param sign mobj_t
--- @param pmo mobj_t
function funcs.grabSign(sign, pmo)
	local game = FH.game
	local grabbed_mobj = P_SpawnMobjFromMobj(sign, 0, 0, 0, grabbed)

	grabbed_mobj.target = pmo
	grabbed_mobj.orig = {
		x = sign.x,
		y = sign.y,
		z = sign.z,
		lerp = 0
	}

	pmo.player.heist.sign = grabbed_mobj
	funcs.setupSign(grabbed_mobj)

	if FH.game.state and FH.game.state.SignGrabbed then
		FH.game.state:SignGrabbed(pmo.player, grabbed_mobj)
	end

	-- play sounds, start escape, remove flags etc

	-- TouchSpecial handles the removal of the old sign
	-- btw the reason why we dont just make this sign use a state is because something new player mobjs spawn after the sign which can cause the sign to have delayed movement over the player

	return grabbed_mobj
end

--- makes the player let go of the sign
--- @param player player_t
function funcs.dropSign(player)
	local sign = player.heist.sign

	if not sign
	or not sign.valid then
		return
	end

	player.heist.sign = nil

	local idle_mobj = funcs.setupSign(nil, sign.x, sign.y, sign.z)

	if not idle_mobj then
		return
	end

	P_SetObjectMomZ(idle_mobj, 8*FU)
	P_InstaThrust(idle_mobj, player.mo.angle, 12*idle_mobj.scale)
	idle_mobj.state = S_FH_SIGN_TOSSED
	idle_mobj.target = player.mo
	idle_mobj.inited = true

	if sign.tracer then
		P_RemoveMobj(sign.tracer)
	end
	P_RemoveMobj(sign)

	return sign
end

return funcs