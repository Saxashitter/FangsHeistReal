local S_FH_SIGN_GRABBED = freeslot("S_FH_SIGN_GRABBED")
local MT_FH_SIGN_GRABBED = freeslot("MT_FH_SIGN_GRABBED")

local PATH = "freeslots/objects/sign/"

states[S_FH_SIGN_GRABBED] = {
	sprite = SPR_SIGN,
	frame = 0,
	tics = 1,
    action = A_CapeChase,
	var1 = 48 * FRACUNIT,
	var2 = 0,
	nextstate = S_FH_SIGN_GRABBED
}

mobjinfo[MT_FH_SIGN_GRABBED] = {
	doomednum = -1,
	spawnstate = S_FH_SIGN_GRABBED,
	spawnhealth = 1000,
	seestate = S_PLAY_SIGN,
	seesound = sfx_lvpass,
	reactiontime = 8,
	attacksound = sfx_None,
	painstate = S_NULL, // custom logic is being made
	painchance = MT_SPARK,
	painsound = sfx_s3kb8,
	meleestate = S_NULL, // custom logic is being made
	missilestate = S_CLEARSIGN,
	deathstate = S_NULL, // custom logic is being made
	xdeathstate = S_NULL,
	deathsound = sfx_s3k64,
	speed = 8,
	radius = 36*FU,
	height = 32*FU,
	dispoffset = 1,
	mass = 16,
	damage = 0,
	activesound = sfx_None,
	flags = MF_NOCLIP | MF_NOCLIPHEIGHT | MF_NOGRAVITY | MF_NOBLOCKMAP,
	raisestate = S_NULL
}

return MT_FH_SIGN_GRABBED