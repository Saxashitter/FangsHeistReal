--- @class fh_gamestate_game_t
local state = {}

function state:gameHUD(v, player, camera)
    print("ran?")
    local game = FH.game

    if not game.escape then
        return
    end

    v.drawString(160, 100, game.tics)
end

return state