local state = setmetatable({}, FH:require("classes/gamestate_t.lua"))
state.__index = state
registerMetatable(state)

return state