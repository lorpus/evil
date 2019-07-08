function Proxy:ProxiesAllowed()
    local percent = Game:GetPercentHumansAlive()
    local count = #player.GetAll()

    // return count > 5 and percent < 0.7
    return Round:IsPlaying()
end

function Proxy:AskToBeProxy(ply)
    net.Start(Network.Id)
        net.WriteInt(N_PROXYASK, 4)
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

    Game:ResetPlayer(ply)
    
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
    Network:SendHook("ProxyFinish")
end

function Proxy:HandleResponse(ply, bAccept)
    dbg.print(ply, bAccept)
    if bAccept and ply.bProxyBeingAsked then
        Proxy:Setup(ply)
    end
end

timer.Create("ProxyAsk", Evil.Cfg.ProxyAskInterval, 0, function()
    if not Proxy:ProxiesAllowed() then return end
    local profile = Game:GetProfileInfo()
    if not profile or not profile.proxy then return end

    for k, v in RandomPairs(Game:GetDead()) do
        if k > 3 then return end
        Proxy:AskToBeProxy(v)
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
