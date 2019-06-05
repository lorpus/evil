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
            print("nigga")
            timer.Remove("RoundWaitPlayers")
        else
            Network:NotifyAll("Waiting for players...")
        end
    end)
end

function Round:Startup()
    Round:WaitForPlayers()
end

function Round:StartGame()
    Round:SetRound(ROUND_PLAYING)
    Round:SetEndTime(CurTime() + 300)
    game.CleanUpMap()

    Game:PickAndSetupBoss()
    Game:PickAndStartGameType()

    for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_BOSS then continue end

        Game:SetupHuman(v)
    end
end

function Round:End(strReason)
    Round:SetRound(ROUND_POST)
    dbg.print("Round:End()", strReason)
    
    if strReason == "bosswin" then
        Network:NotifyAll("The boss has won!")
    elseif strReason == "bossdead" then
        Network:NotifyAll("The boss has mysteriously died!")
    elseif strReason == "timeup" then
        Network:NotifyAll("The boss has won!")
        for _, ply in pairs(eutil.GetLivingPlayers(TEAM_HUMAN)) do
            ply:Kill()
        end
    end

    timer.Simple(5, function()
        Round:StartGame()
    end)
end

hook.Add("Think", "RoundThink", function()
    if not Round:CanStart() and Round:GetRound() != ROUND_WAITING then
        return Round:WaitForPlayers()
    end

    if Round:GetRound() == ROUND_PLAYING then
        if CurTime() > Round:GetEndTime() then
            return Round:End("timeup")
        end

        if #eutil.GetLivingPlayers(TEAM_HUMAN) == 0 then
            Round:End("bosswin")
        elseif #eutil.GetLivingPlayers(TEAM_BOSS) == 0 then
            Round:End("bossdead")
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

        // ply:StartSpectating()
    end)
end)

hook.Add("PlayerSpawn", "InitialSpawnButNotQuite", function(ply)
    if not ply:GetNWBool("HasSpawned") then
        ply:SetTeam(TEAM_SPEC)
        ply:KillSilent()
        ply:SetNWBool("HasSpawned", true)
        // ply:StartSpectating()
    end
end)