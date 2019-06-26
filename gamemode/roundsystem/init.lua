function Round:SetRound(enRound)
    SetGlobalInt("CurrentRound", enRound)
end

function Round:SetEndTime(endtime)
    SetGlobalFloat("RoundEndTime", endtime)
end

function Round:AddTime(time)
    SetGlobalFloat("RoundEndTime", GetGlobalFloat("RoundEndTime") + time)
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
    game.CleanUpMap()

    Game:ResetPlayers()

    Game:PickAndSetupBoss()
    Game:PickAndStartGameType()

    for k, v in pairs(player.GetAll()) do
        if Game:GetBoss() == v then continue end

        Game:SetupHuman(v)
    end

    SetGlobalInt("RoundCount", GetGlobalInt("RoundCount") + 1)
    Round:SetRound(ROUND_PLAYING)
end

function Round:End(strReason)
    if not Round:IsPlaying() then
        return false
    end

    local info = Game:GetGametypeInfo()
    if info.finish then
        info.finish()
    end

    Round:SetRound(ROUND_POST)
    dbg.print("Round:End()", strReason)
    
    if strReason then
        Network:NotifyAll(strReason, strReason:StartWith("#")) // not the best but ur retarded if u use a # as first char and u dont want lang
    else
        Network:NotifyAll("#Round_EndUnknown")
    end

    timer.Simple(5, function()
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
        if CurTime() > Round:GetEndTime() then
            return Round:End("#Round_EndTimeUp")
        end

        if #eutil.GetLivingPlayers(TEAM_HUMAN) == 0 then
            Round:End("#Round_EndBossWin")
        elseif #eutil.GetLivingPlayers(TEAM_BOSS) == 0 then
            Round:End("#Round_EndBossDie")
        end
    end
end)

hook.Add("PlayerDeathThink", "DisableRespawn", function()
    return false
end)

hook.Add("PlayerSpawn", "InitialSpawnButNotQuite", function(ply)
    if not ply:GetNWBool("HasSpawned") then
        ply:SetTeam(TEAM_SPEC)
        ply:KillSilent()
        ply:SetNWBool("HasSpawned", true)
        
        if Round:IsPlaying() then
            timer.Simple(5, function() // weird
                if IsValid(ply) then
                    ply:StartSpectating()
                end
            end)
        end
    end
end)
