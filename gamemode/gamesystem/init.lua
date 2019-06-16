AddCSLuaFile("sh_bosses.lua")
AddCSLuaFile("sh_games.lua")

function Game:SetBoss(pEnt)
    SetGlobalEntity("EvilBoss", pEnt)
end

function Game:SetGametype(strGametype)
    SetGlobalString("EvilGametype", strGametype)
end

function Game:SetProfile(strProfile)
    SetGlobalString("EvilProfile", strProfile)
end

function Game:ResetPlayers()
    for _, ply in pairs(player.GetAll()) do
        ply:SetTeam(TEAM_SPEC)
        ply:StripWeapons()
        ply:SetWalkSpeed(Evil.Cfg.PlayerWalkspeed)
        ply:SetRunSpeed(Evil.Cfg.PlayerRunspeed)
    end
end

function Game:SetupBoss(pEnt)
    local key = table.Random(table.GetKeys(Evil.Bosses))
    local info = Evil.Bosses[key]
    
    Game:SetProfile(key)
    Game:SetBoss(pEnt)
    
    pEnt:SetTeam(TEAM_BOSS)
    pEnt:SetModel(info.model)
    pEnt:SetRunSpeed(info.runspeed)
    pEnt:SetWalkSpeed(info.walkspeed)
    pEnt:Spawn()

    for _, v in pairs(info.weapons) do
        pEnt:Give(v)
    end

    pEnt:Lock()
    timer.Simple(5, function()
        pEnt:UnLock()
    end)
end

function Game:PickAndSetupBoss()
    local ply
    if IsValid(Evil._NEXTBOSS) then
        ply = Evil._NEXTBOSS
        Evil._NEXTBOSS = nil
    else
        ply = table.Random(player.GetAll())
    end

    Game:SetupBoss(ply)
end

function Game:SetupHuman(pEnt)
    pEnt:SetTeam(TEAM_HUMAN)
    pEnt:SetDefaultModel()
    pEnt:Spawn()

    pEnt:Lock()
    timer.Simple(5, function()
        pEnt:UnLock()
    end)
end

function Game:StartGametype(strGametype)
    local info = Game.Gametypes[strGametype]

    if info.start then
        info.start()
    end
end

function Game:PickAndStartGameType()
    local key = table.Random(table.GetKeys(Game.Gametypes))

    Game:SetGametype(key)
    Game:StartGametype(key)
end

hook.Add("DoPlayerDeath", "EvilPlayerKilledHook", function(victim, inflictor, attacker)
    dbg.print(victim, attacker)
    if type(attacker) == "CTakeDamageInfo" then
        if IsValid(attacker:GetAttacker()) and not attacker:GetAttacker():IsBoss() then
            return
        elseif not IsValid(attacker:GetAttacker()) then
            return
        end
    else
        return
    end

    Network:SendHook("EvilPlayerKilled", victim)
    local info = Game:GetProfileInfo()
    if info.killhook then
        info.killhook(victim)
    end
end)

hook.Add("KeyPress", "bossattack", function(ply, key)
    if ply:Team() == TEAM_BOSS then
        if key == IN_ATTACK2 then
            ply.mouse2down = true
        end 
    end
end)

hook.Add("KeyRelease", "bossattack", function(ply, key)
    if ply:Team() == TEAM_BOSS then
        if key == IN_ATTACK2 then
            ply.mouse2down = false
        end
    end
end)

hook.Add("Think", "bossattack", function()
    /*local boss = Game:GetBoss()
    if IsValid(boss) then
        if boss.mouse2down then
            boss.pentup = boss.pentup + 1
        else
            local x = boss.pentup
            boss.pentup = 0
            if x > 50 then
                boss:SetVelocity(boss:GetAimVector() * x * 10)
            end
        end
    end*/
end)
