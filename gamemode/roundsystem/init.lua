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
    if #player.GetAll() >= 2 then
        return true
    end

    return false
end

function Round:WaitForPlayers()
    Round:SetRound(ROUND_WAITING)
    timer.Create("RoundWaitPlayers", 30, 0, function()
        if Round:CanStart() then
            Round:StartGame()
            timer.Remove("RoundWaitPlayers")
        else
            Network:NotifyAll("Waiting for players...")
        end
    end)
end

function Round:Startup()
    Round:WaitForPlayers()
end

hook.Add("Think", "RoundThink", function()
    if not Round:CanStart() and Round:GetRound() != ROUND_WAITING then
        return Round:WaitForPlayers()
    end

    if Round:GetRound() == ROUND_PLAYING then
        if CurTime() > Round:GetEndTime() then
            return Round:End("timeup")
        end

        
    end
end)

hook.Add("PlayerDeathThink", "DisableRespawn", function()
    return false
end)

hook.Add("PlayerDeath", "RoundPlayerDeath", function(ply)
    timer.Simple(5, function()
        if ply:Alive() then
            return
        end

        ply:StartSpectating()
    end)
end)

hook.Add("PlayerSpawn", "InitialSpawnButNotQuite", function(ply)
    if not ply:GetNWBool("HasSpawned")
        ply:SetTeam(TEAM_SPEC)
        ply:KillSilent()
        ply:SetNWBool("HasSpawned", true)
    end
end)
