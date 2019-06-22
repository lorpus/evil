include("shared.lua")

local color_black = Color(0, 0, 0)
local color_red   = Color(125, 0, 0)

function Evil:AddTextChat(str)
    chat.AddText(color_black, "[", color_red, "Evil", color_black, "]", color_white, ": ", str)
end
