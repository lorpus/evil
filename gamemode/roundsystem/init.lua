function Round:SetRound(enRound)
    SetGlobal2Int("CurrentRound", enRound)
    hook.Run("RoundSet", enRound)
    Network:SendHook("RoundSet", enRound)
end

function Round:SetEndTime(endtime)
    SetGlobal2Float("RoundEndTime", endtime)
end

function Round:AddTime(time)
    SetGlobal2Float("RoundEndTime", GetGlobal2Float("RoundEndTime") + time)
end

function Round:CanStart()
    return #player.GetAll() >= 2
end

function Round:WaitForPlayers()
    Round:SetRound(ROUND_WAITING)

    timer.Create("RoundWaitPlayers", 30, 0, function()
        if Round:CanStart() then
            Round:StartGame()
            timer.Remove("RoundWaitPlayers")
        else
            Network:NotifyAll("#Round_WaitingForPlayers", true)
        end
    end)
end

function Round:Startup()
    Round:WaitForPlayers()
end

function Round:StartGame()
    Round:SetEndTime(CurTime() + 300)

    Game:ResetPlayers()

    local ply, gametype = Game:PreSetup()

    timer.Simple(1, function()
        Game:SetupBoss(ply)
        Game:StartGametype(gametype)

        for k, v in pairs(player.GetAll()) do
            if Game:GetBoss() == v then continue end

            Game:SetupHuman(v)
        end

        SetGlobal2Int("EvilStartingPlayers", #Game:GetHumans())
        SetGlobal2Int("RoundCount", GetGlobal2Int("RoundCount") + 1)
        Round:SetRound(ROUND_PLAYING)
    end)
end

function Round:End(strReason, format)
    if not Round:IsPlaying() then
        return false
    end

    local key = Game:GetGametype()
    local info = Game.Gametypes[key]
    if info.finish then
        info.finish()
        Network:SendHook("RunGTFunc", key, "finish")
    end

    Round:SetRound(ROUND_POST)
    dbg.print("Round:End()", strReason)
    
    if strReason then
        Network:NotifyAll(strReason, strReason:StartWith("#"), format)
    else
        Network:NotifyAll("#Round_EndUnknown", true, format)
    end

    timer.Simple(10, function()
        for _, ply in pairs(player.GetAll()) do
            ply:KillSilent()
            ply:SetTeam(TEAM_SPEC)
        end
    end)

    timer.Simple(25, function()
        game.CleanUpMap()
    end)

    timer.Simple(26, function()
        Round:StartGame()
    end)

    return true
end

hook.Add("Think", "RoundThink", function()
    if not Round:CanStart() and not Round:IsWaiting() then
        for _, ply in pairs(player.GetAll()) do
            ply:SetTeam(TEAM_SPEC)
            ply:KillSilent()
        end

        return Round:WaitForPlayers()
    end

    if Round:IsPlaying() then
        local gt = Game:GetGametypeInfo()
        if gt and isfunction(gt.endlogic) then
            return gt.endlogic()
        end

        if CurTime() > Round:GetEndTime() then
            Round:End("#Round_EndTimeUp")
            for _, ply in pairs(player.GetAll()) do
                if ply:IsHuman() then
                    ply:SetNWBool("EvilKilled", true)
                    ply:Kill()
                end
            end
        end

        if #Game:GetHumans() == 0 then
            Round:End("#Round_EndBossWin")
        elseif not IsValid(Game:GetBoss()) or not Game:GetBoss():Alive() then
            Round:End("#Round_EndBossDie")
        end
    end
end)

hook.Add("PlayerDeathThink", "DisableRespawn", function()
    return false
end)

hook.Add("PlayerSpawn", "InitialSpawnButNotQuite", function(ply)
    if not ply:GetNW2Bool("HasSpawned") then
        ply:SetTeam(TEAM_SPEC)
        ply:KillSilent()
        ply:SetNW2Bool("HasSpawned", true)
        ply:SetCustomCollisionCheck(true)
        
        if Round:IsPlaying() then
            timer.Simple(5, function() // weird
                if IsValid(ply) then
                    ply:StartSpectating()
                end
            end)
        end
    end
end)
