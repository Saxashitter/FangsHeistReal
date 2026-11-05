local funcs = {}

function funcs.spawnEscapeRing()
	-- TODO: actually do proper spawn stuff that's not shit placeholder
	for player in players.iterate do
		if not (player.mo and player.mo.valid) then continue end

		P_SpawnMobjFromMobj(player.mo, 0, 0, player.mo.height + 16*FU, MT_FH_ESCAPERING)
		return
	end
end
