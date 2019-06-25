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
        ply:SetJumpPower(Stamina.normaljump)
        ply:StopSpectating()
    end
end

function Game:SetupBoss(ply)
    local key = table.Random(table.GetKeys(Evil.Bosses))
    local info = Evil.Bosses[key]
    
    Game:SetProfile(key)
    Game:SetBoss(ply)
    
    ply:SetTeam(TEAM_BOSS)
    ply:SetModel(info.model)
    ply:SetRunSpeed(info.runspeed)
    ply:SetWalkSpeed(info.walkspeed)
    ply:Spawn()
    Network:Notify(ply, "You are the boss!")

    for _, v in pairs(info.weapons) do
        ply:Give(v)
    end

    ply:Lock()
    timer.Simple(5, function()
        if IsValid(ply) then
            ply:UnLock()
        end
    end)
end

local lastChosenBoss
function Game:PickAndSetupBoss()
    local ply
    if IsValid(Evil._NEXTBOSS) then
        ply = Evil._NEXTBOSS
        Evil._NEXTBOSS = nil
    else
        local pool = player.GetAll()
        if IsValid(lastChosenBoss) then
            table.RemoveByValue(pool, lastChosenBoss)
        end
        ply = table.Random(pool)
        lastChosenBoss = ply
    end

    Game:SetupBoss(ply)
end

function Game:SetupHuman(ply)
    ply:SetTeam(TEAM_HUMAN)
    ply:SetDefaultModel()
    ply:Spawn()

    ply:Lock()
    timer.Simple(5, function()
        if IsValid(ply) then
            ply:UnLock()
        end
    end)
end

function Game:StartGametype(strGametype)
    local info = Game.Gametypes[strGametype]

    if info.start then
        info.start()
    end
end

function Game:PickAndStartGameType()
    local keys = {}
    
    for k, v in RandomPairs(Game.Gametypes) do
        if v.playable then
            if v.playable() then
                table.insert(keys, k)
            end
        else
            table.insert(keys, k)
        end
    end

    if #keys == 0 then
        return Evil:Lock("playable gametype configuration is broke")
    end

    local key = table.Random(keys)

    Game:SetGametype(key)
    Game:StartGametype(key)
end

hook.Add("PlayerShouldTakeDamage", "EvilNoBossDamage", function(ply, attacker)
    if ply:IsBoss() then
        return false
    end
end)

hook.Add("DoPlayerDeath", "EvilHandlePlayerDeath", function(victim, inflictor, attacker)
    print(victim, inflictor, attacker)
    if not victim:IsBoss() then // game's over anyways
        if not Round:IsWaiting() then
            local round = Round:GetRoundCount()
            timer.Simple(4, function()
                if round == Round:GetRoundCount() and IsValid(victim) then
                    victim:StartSpectating()
                end
            end)
        end
    end

    if type(attacker) == "CTakeDamageInfo" then
        if IsValid(attacker:GetAttacker()) and not attacker:GetAttacker():IsBoss() then
            return
        elseif not IsValid(attacker:GetAttacker()) then
            return
        end
    else
        return
    end

    Jumpscare:SendScare(victim)

    Network:SendHook("EvilPlayerKilled", victim)
    local info = Game:GetProfileInfo()
    if info.killhook then
        info.killhook(victim)
    end
end)

hook.Add("PlayerSpawn", "MoveToSpawn", function(ply)
    if ply:IsSpecTeam() then return end
    
    local humans = Map.spawns.humans
    local boss = Map.spawns.boss
    if ply:IsHuman() and humans then
        local spawn = humans[math.random(#humans)]
        ply:SetPos(spawn.pos)
        if spawn.ang then
            ply:SetEyeAngles(spawn.ang)
        end
    elseif ply:IsBoss() and boss then
        local spawn = boss[math.random(#boss)]
        ply:SetPos(spawn.pos)
        if spawn.ang then
            ply:SetEyeAngles(spawn.ang)
        end
    else
        Evil:Lock("spawns are misconfigured")
    end
end)

hook.Add("PlayerDeathSound", "EvilRemoveDeathSound", function()
    return false
end)

/*
hook.Add("EntityTakeDamage", "InstaDabOnPlyers", function(ent, info)
    if not ent:IsPlayer() then return end
    local attacker = info:GetAttacker()
    if not IsValid(attacker) or not attacker:IsPlayer() or not attacker:IsBoss() then return end

    // todo: make it so the info isnt overwritten with :Kill()'s info'

    // something to make this optional
    ent:Kill()
end)*/

function GM:IsSpawnpointSuitable(ply, spawnpointEnt, bMakeSuitable)
    return true
end
