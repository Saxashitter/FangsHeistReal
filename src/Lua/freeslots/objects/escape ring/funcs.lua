local funcs = {}

function funcs.spawnEscapeRing()
	-- TODO: actually do proper spawn stuff that's not shit placeholder
	for thing in mapthings.iterate do
		if thing.type == 1 then
			P_SpawnMobj(thing.x*FU, thing.y*FU, thing.z*FU + 64*FU + P_FloorzAtPos(thing.x*FU, thing.y*FU, ONFLOORZ, 32*FU), MT_FH_ESCAPERING)
		end
	end
end

return funcs
