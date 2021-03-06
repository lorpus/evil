local color_black = Color(0, 0, 0)
local color_red   = Color(125, 0, 0)

function Evil:AddTextChat(str)
    chat.AddText(color_black, "[", color_red, "Evil", color_black, "]", color_white, ": ", str)
end

local killsoundAllowed = true
local function ReceiveHandler(iLen, ply)
    local cmd = net.ReadInt(Network.CmdBits)
    dbg.print(cmd)
    if cmd == N_NOTIFY then
        local str = net.ReadString()
        local isLang = net.ReadBool()
        local hasArgs = net.ReadBool()
        local isRaw = net.ReadBool()
        local butStillDoTheLang = net.ReadBool()
        if isRaw then
            local tab = net.ReadTable()
            if butStillDoTheLang then
                for k, v in ipairs(tab) do
                    if isstring(v) and v:StartWith("#") then
                        tab[k] = Lang:Get(v)
                    end
                end
            end
            return chat.AddText(unpack(tab))
        end
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
    elseif cmd == N_SOUND then
        local snd = net.ReadString()
        dbg.print(snd)
        surface.PlaySound(snd)
    elseif cmd == N_KILLSOUND then
        local snd = net.ReadString()
        if killsoundAllowed then
            sound.PlayFile("sound/" .. snd, "", function(chan, errId, errName)
                if IsValid(chan) then
                    chan:Play()
                    killsoundAllowed = false
                    timer.Simple(chan:GetLength(), function()
                        killsoundAllowed = true
                    end)
                end
            end)
        end
    elseif cmd == N_PROXYASK then
        Proxy:ShowPrompt()
    elseif cmd == N_PLAYANIM then
        local ent = net.ReadEntity()
        local slot = net.ReadUInt(3)
        local seq = net.ReadUInt(11)
        if IsValid(ent) then
            ent:AddVCDSequenceToGestureSlot(slot, seq, 0, true)
        else
            dbg.print("N_PLAYANIM sent now-invalid entity")
        end
    elseif cmd == N_BOSSMUSIC then
        Game:StartBossProximityMusic(net.ReadString())
    elseif cmd == N_MAPVOTE then
        MapVote:ShowVoteUI(net.ReadTable())
    elseif cmd == N_CONTENT then
        Evil:CLAPINetHandler()
    end
end
net.Receive(Network.Id, ReceiveHandler)

function Network:RequestTaunt(taunt)
    net.Start(Network.Id)
        net.WriteInt(N_TAUNT, Network.CmdBits)
        net.WriteString(taunt)
    net.SendToServer()
end
