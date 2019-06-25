local color_black = Color(0, 0, 0)
local color_red   = Color(125, 0, 0)

function Evil:AddTextChat(str)
    chat.AddText(color_black, "[", color_red, "Evil", color_black, "]", color_white, ": ", str)
end

local function ReceiveHandler(iLen, ply)
    local cmd = net.ReadInt(4)
    dbg.print(cmd)
    if cmd == N_NOTIFY then
        local str = net.ReadString()
        local isLang = net.ReadBool()
        local hasArgs = net.ReadBool()
        if isLang then
            if hasArgs then
                local args = net.ReadTable()
                str = Lang:Format(str, args)
            else
                str = Lang:Get(str)
            end
        end
        Evil:AddTextChat(str)
    elseif cmd == N_HOOK then
        local event = net.ReadString()
        local args = net.ReadTable()

        hook.Run(event, unpack(args))
    elseif cmd == N_JUMPSCARE then
        Jumpscare:NetReceive()
    end
end
net.Receive(Network.Id, ReceiveHandler)
