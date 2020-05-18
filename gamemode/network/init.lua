util.AddNetworkString(Network.Id)

local function FilterToTable(filter)
    local targets = {}
    if isfunction(filter) then
        for _, ply in pairs(player.GetAll()) do
            if filter(ply) then
                table.insert(targets, ply)
            end
        end
    elseif istable(filter) then
        targets = filter
    elseif isentity(filter) and filter:IsPlayer() then
        targets = { filter }
    end
    return targets
end

local function StartNotify(str, isLang, langArgs, raw)
    net.Start(Network.Id)
    net.WriteInt(N_NOTIFY, Network.CmdBits)
    net.WriteString(str)
    net.WriteBool(isLang)
    net.WriteBool(langArgs != nil)
    net.WriteBool(false)
    net.WriteBool(raw)
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

local function StartPrintChat(args, dontExpandLang)
    net.Start(Network.Id)
    net.WriteInt(N_NOTIFY, Network.CmdBits)
    net.WriteString("")
    net.WriteBool(false)
    net.WriteBool(false)
    net.WriteBool(true)
    net.WriteBool(not dontExpandLang)
    net.WriteTable(args)
end

function Network:PrintChat(ply, args, dontExpandLang)
    StartPrintChat(args, dontExpandLang)
    net.Send(ply)
end

function Network:PrintChatAll(args, dontExpandLang)
    StartPrintChat(args, dontExpandLang)
    net.Broadcast()
end

function Network:SendHookFiltered(filter, name, ...)
    local targets = FilterToTable(filter)

    net.Start(Network.Id)
        net.WriteInt(N_HOOK, Network.CmdBits)
        net.WriteString(name)
        net.WriteTable({...})
    net.Send(targets)
end

function Network:SendHook(name, ...)
    net.Start(Network.Id)
        net.WriteInt(N_HOOK, Network.CmdBits)
        net.WriteString(name)
        net.WriteTable({...})
    net.Broadcast()
end

function Network:PlaySoundFiltered(filter, snd)
    local targets = FilterToTable(filter)

    net.Start(Network.Id)
        net.WriteInt(N_SOUND, Network.CmdBits)
        net.WriteString(snd)
    net.Send(targets)
end

function Network:PlaySound(ply, snd)
    net.Start(Network.Id)
        net.WriteInt(N_SOUND, Network.CmdBits)
        net.WriteString(snd)
    net.Send(ply)
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
        Proxy:HandleResponse(ply, net.ReadInt(3))
    elseif cmd == N_ABILITY then
        Abilities:NetHandler(len, ply)
    elseif cmd == N_MAPVOTE then
        MapVote:NetHandler(len, ply)
    elseif cmd == N_CONTENT then
        Evil:SVAPINetHandler(len, ply)
    end
end
net.Receive(Network.Id, ReceiveHandler)
