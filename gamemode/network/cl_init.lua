local color_black = Color(0, 0, 0)
local color_red   = Color(125, 0, 0)

local function ReceiveHandler(iLen, ply)
    local cmd = net.ReadInt(4)
    if cmd == N_NOTIFY then
        local str = net.ReadString()
        chat.AddText(color_black, "[", color_red, "Evil", color_black, "]", color_white, ": ", str)
    end
end
net.Receive(Network.Id, ReceiveHandler)
