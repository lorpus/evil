function Proxy:ProxiesAllowed()
    return Round:IsPlaying()
end

function Proxy:AskToBeProxy(ply)
    if ply.bProxyBeingAsked then return end
    net.Start(Network.Id)
        net.WriteInt(N_PROXYASK, Network.CmdBits)
    net.Send(ply)
    ply.bProxyBeingAsked = true
    timer.Simple(15, function()
        if not IsValid(ply) then return end
        ply.bProxyBeingAsked = nil
    end)
end

function Proxy:Setup(ply)
    local profile = Game:GetProfileInfo()
    if not profile or not profile.proxy then
        return Evil:Lock("profile mismatch between query and setup")
    end

    local wasKilled = ply:GetNW2Bool("EvilKilled")
    Game:ResetPlayer(ply)
    ply:SetNW2Bool("EvilKilled", wasKilled) // reset

    ply:SetTeam(TEAM_PROXY)
    ply:SetModel(profile.proxy.model)
    ply:SetRunSpeed(profile.proxy.runspeed)
    ply:SetWalkSpeed(profile.proxy.runspeed)

    if istable(profile.proxy.weapons) then
        for _, weapon in pairs(profile.proxy.weapons) do
            ply:Give(weapon)
        end
    end

    if isfunction(profile.proxy.start) then
        profile.proxy.start(ply)
    end

    if profile.proxy.ability then
        Abilities:SetPlayerAbility(ply, profile.proxy.ability)
    end

    Network:SendHook("ProxyStart", ply)

    ply:Spawn()
end

function Proxy:Cleanup(ply)
    local profile = Game:GetProfileInfo()
    if not profile or not profile.proxy then
        return Evil:Lock("profile mismatch between setup and cleanup")
    end

    if isfunction(profile.proxy.finish) then
        profile.proxy.finish(ply)
    end
    Network:SendHook("ProxyFinish", ply)
end

function Proxy:HandleResponse(ply, accept)
    dbg.print(ply, accept)
    if accept == 1 and ply.bProxyBeingAsked then
        Proxy:Setup(ply)
    elseif accept == -1 then
        ply.bDontAskForProxy = true
    end
    ply.bProxyBeingAsked = nil
end

timer.Create("ProxyAsk", Evil.Cfg.ProxyAskInterval, 0, function()
    if not Proxy:ProxiesAllowed() then return end
    local profile = Game:GetProfileInfo()
    if not profile or not profile.proxy then return end

    local i = 0
    for _, v in RandomPairs(Game:GetDead()) do
        i = i + 1
        if i > 2 then return end
        if not v.bDontAskForProxy then
            Proxy:AskToBeProxy(v)
        end
    end
end)

hook.Add("RoundSet", "ProxyRoundSet", function(round)
    if round != ROUND_PLAYING then
        for _, ply in pairs(player.GetAll()) do
            ply.bProxyBeingAsked = nil
            if ply:IsProxy() then
                Proxy:Cleanup(ply)
            end
        end
    end
end)

hook.Add("PlayerDeath", "ProxyHandlePlayerDeath", function(ply, inflictor, attacker)
    if ply:IsProxy() then
        Proxy:Cleanup(ply)
    end
end)
