
freeslot(
	"S_FH_ESCAPERING",
	"MT_FH_ESCAPERING"
)

states[S_FH_ESCAPERING] = {
	sprite = SPR_RING,
	frame = A,
	tics = -1
}

mobjinfo[MT_FH_ESCAPERING] = {
	doomednum = -1,
	spawnstate = S_FH_ESCAPERING,
	radius = 32*FU,
	height = 32*FU,
	flags = MF_SPECIAL|MF_NOGRAVITY
}
