util.AddNetworkString(Network.Id)

local function StartNotify(str, isLang, langArgs)
    net.Start(Network.Id)
    net.WriteInt(N_NOTIFY, 4)
    net.WriteString(str)
    net.WriteBool(isLang)
    net.WriteBool(langArgs != nil)
    if langArgs then
        net.WriteTable(langArgs)
    end
end

function Network:Notify(ply, str, isLang, langArgs)
    StartNotify(str, isLang, langArgs)
    net.Send(ply)
end

function Network:NotifyAll(str, isLang, langArgs)
    StartNotify(str, isLang, langArgs)
    net.Broadcast()
end

function Network:SendHook(name, ...)
    net.Start(Network.Id)
        net.WriteInt(N_HOOK, 4)
        net.WriteString(name)
        net.WriteTable({...})
    net.Broadcast()
end

function Network:BroadcastSound(snd)
    net.Start(Network.Id)
        net.WriteInt(N_SOUND, 4)
        net.WriteString(snd)
    net.Broadcast()
end

function Network:BroadcastKillsound(snd)
    net.Start(Network.Id)
        net.WriteInt(N_KILLSOUND, 4)
        net.WriteString(snd)
    net.Broadcast()
end

local function ReceiveHandler(len, ply)
    local cmd = net.ReadInt(4)
    dbg.print(cmd)

    if cmd == N_TAUNT then
        Game:TauntNetHandler(len, ply)
    elseif cmd == N_PROXYASK then
        Proxy:HandleResponse(ply, net.ReadBool())
    end
end
net.Receive(Network.Id, ReceiveHandler)
