util.AddNetworkString(Network.Id)

local function StartNotify(str, isLang, langArgs)
    net.Start(Network.Id)
    net.WriteInt(N_NOTIFY, Network.CmdBits)
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
        net.WriteInt(N_HOOK, Network.CmdBits)
        net.WriteString(name)
        net.WriteTable({...})
    net.Broadcast()
end

function Network:BroadcastSound(snd)
    net.Start(Network.Id)
        net.WriteInt(N_SOUND, Network.CmdBits)
        net.WriteString(snd)
    net.Broadcast()
end

function Network:BroadcastKillsound(snd)
    net.Start(Network.Id)
        net.WriteInt(N_KILLSOUND, Network.CmdBits)
        net.WriteString(snd)
    net.Broadcast()
end

function Network:SendAnim(ent, slot, seq)
    net.Start(Network.Id)
        net.WriteInt(N_PLAYANIM, Network.CmdBits)
        net.WriteEntity(ent)
        net.WriteUInt(slot, 3)
        net.WriteUInt(seq, 11)
    net.Broadcast()
end

local function ReceiveHandler(len, ply)
    local cmd = net.ReadInt(Network.CmdBits)
    dbg.print(cmd)

    if cmd == N_TAUNT then
        Game:TauntNetHandler(len, ply)
    elseif cmd == N_PROXYASK then
        Proxy:HandleResponse(ply, net.ReadBool())
    elseif cmd == N_ABILITY then
        Abilities:NetHandler(len, ply)
    end
end
net.Receive(Network.Id, ReceiveHandler)
