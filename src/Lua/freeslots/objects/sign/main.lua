local PATH = "freeslots/objects/sign/"

local idle = FH:require(PATH.."states/idle.lua")
local grabbed = FH:require(PATH.."states/grabbed.lua")
local funcs = FH:require(PATH.."funcs.lua")

-- required so we dont fuck it up
addHook("TouchSpecial", function(mo, toucher)
    if not mo.valid or not toucher.valid then
        return true
    end

    if toucher.player == nil then
        return true
    end
    if mo.state == S_FH_SIGN_TOSSED and mo.target == toucher then
        return true
    end
    if not mo.inited then -- we need this so when we toss the sign it doesnt instantly get grabbed upon spawn
        return true
    end

    funcs.grabSign(mo, toucher)
end, MT_FH_SIGN_IDLE)