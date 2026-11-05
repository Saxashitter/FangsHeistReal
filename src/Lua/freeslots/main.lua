local function dosetup(fileName)
	return FH:require("freeslots/"..fileName)
end

-- setup gametypes first
dosetup("gametypes/heist.lua")

-- setup objects
dosetup("objects/sign/main.lua")
dosetup("objects/escape ring/main.lua")
