G_AddGametype{
    name = "Heist",
    identifier = "fh_heist",
    typeoflevel = TOL_COOP, -- freeslot("TOL_ESCAPE"),
	---@diagnostic disable-next-line: undefined-global
	rules = GTR_SPAWNENEMIES|GTR_NOTITLECARD|GTR_SPECTATORS,
	---@diagnostic disable-next-line: undefined-global
    intermissiontype = int_none,
    headercolor = 103,
    description = "hi so wip"
}