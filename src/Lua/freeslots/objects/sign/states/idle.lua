local S_FH_SIGN_IDLE = freeslot("S_FH_SIGN_IDLE")
local S_FH_SIGN_TOSSED = freeslot("S_FH_SIGN_TOSSED")
local MT_FH_SIGN_IDLE = freeslot("MT_FH_SIGN_IDLE")

local PATH = "freeslots/objects/sign/"

--- turns the board of the signpost
--- var1 is the speed in which it does (fracunits)
--- does not carry momentum
--- @param var1 fixed_t
local function A_TurnSignpostBoard(sign, var1, var2)
	local board = sign.tracer

	if not board
	or not board.valid then
		return
	end

	local angle = FixedAngle(AngleFixed(sign.angle) + var1)
	board.angle = angle
end

states[S_FH_SIGN_IDLE] = {
	sprite = SPR_SIGN,
	frame = 0,
	tics = 1,
	nextstate = S_FH_SIGN_IDLE
}

states[S_FH_SIGN_TOSSED] = {
	sprite = SPR_SIGN,
	frame = 0,
	tics = 10,
	nextstate = S_FH_SIGN_IDLE
}

mobjinfo[MT_FH_SIGN_IDLE] = {
	doomednum = -1,
	spawnstate = S_FH_SIGN_IDLE,
	spawnhealth = 1000,
	seestate = S_PLAY_SIGN,
	seesound = sfx_lvpass,
	reactiontime = 8,
	attacksound = sfx_None,
	painstate = S_NULL, // custom logic is being made
	painchance = MT_SPARK,
	painsound = sfx_s3kb8,
	meleestate = S_FH_SIGN_TOSSED, // custom logic is being made
	missilestate = S_CLEARSIGN,
	deathstate = S_NULL, // custom logic is being made
	xdeathstate = S_NULL,
	deathsound = sfx_s3k64,
	speed = 8,
	radius = 36*FU,
	height = 32*FU,
	dispoffset = 0,
	mass = 16,
	damage = 0,
	activesound = sfx_None,
	flags = MF_SPECIAL,
	raisestate = S_NULL
}

return MT_FH_SIGN_IDLE