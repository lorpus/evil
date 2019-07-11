AddCSLuaFile("sh_bosses.lua")
AddCSLuaFile("sh_games.lua")

function Game:SetBoss(pEnt)
    SetGlobal2Entity("EvilBoss", pEnt)
end

function Game:SetGametype(strGametype)
    SetGlobal2String("EvilGametype", strGametype)
end

function Game:SetProfile(strProfile)
    SetGlobal2String("EvilProfile", strProfile)
end

function Game:ResetPlayer(ply)
    ply:SetTeam(TEAM_SPEC)
    ply:StripWeapons()
    ply:SetWalkSpeed(Evil.Cfg.PlayerWalkspeed)
    ply:SetRunSpeed(Evil.Cfg.PlayerRunspeed)
    ply:SetJumpPower(Stamina.normaljump)
    ply:SetModelScale(1)
    ply:StopSpectating()
end

function Game:ResetPlayers()
    for _, ply in pairs(player.GetAll()) do
        Game:ResetPlayer(ply)
    end
end

function Game:SetupBoss(ply)
    local key
    if Evil._NEXTBOSS then
        key = Evil._NEXTBOSS
        Evil._NEXTBOSS = nil
    else
        key = table.Random(table.GetKeys(Evil.Bosses))
    end
    local info = Evil.Bosses[key]
    
    Game:SetProfile(key)
    Game:SetBoss(ply)
    
    ply:SetTeam(TEAM_BOSS)
    ply:SetModel(info.model)
    ply:SetRunSpeed(info.runspeed)
    ply:SetWalkSpeed(info.walkspeed)

    local hands = ply:GetHands()
    if info.hands_model and IsValid(hands) then
        hands:SetModel(info.hands_model)
    end

    if info.modelscale then
        ply:SetModelScale(info.modelscale)
    end

    if info.proximity_music then
        net.Start(Network.Id)
            net.WriteInt(N_BOSSMUSIC, Network.CmdBits)
            net.WriteString(info.proximity_music)
        net.Broadcast()
    end

    ply:Spawn()
    Network:Notify(ply, "You are the boss!")

    for _, v in pairs(info.weapons) do
        ply:Give(v)
    end

    timer.Simple(0.1, function()
        ply:Lock()
        timer.Simple(5, function()
            if IsValid(ply) then
                ply:UnLock()
            end
        end)
    end)
end

local lastChosenBoss
function Game:PickAndSetupBoss()
    local ply
    if IsValid(Evil._NEXTBOSSPLAYER) then
        ply = Evil._NEXTBOSSPLAYER
        Evil._NEXTBOSSPLAYER = nil
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

    timer.Simple(0.1, function()
        ply:Lock()
        timer.Simple(5, function()
            if IsValid(ply) then
                ply:UnLock()
            end
        end)
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
    dbg.print(victim, inflictor, attacker)
    for _, ply in pairs(player.GetAll()) do
        if ply:IsSpectating() and ply:GetObserverTarget() == victim then
            timer.Simple(1.5, function()
                if IsValid(ply) then
                    ply:CycleSpectatorTarget(1)
                end
            end)
        end
    end

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
        if IsValid(attacker:GetAttacker()) and not attacker:GetAttacker():IsBoss() and not attacker:GetAttacker():IsProxy() then
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
    
    if istable(info.killsounds) then
        Network:BroadcastKillsound(info.killsounds[math.random(#info.killsounds)])
    end
end)

hook.Add("PlayerSpawn", "MoveToSpawn", function(ply)
    if ply:IsSpecTeam() then return end
    
    local humans = Map.spawns.humans
    local boss = Map.spawns.boss
    local proxy = Map.spawns.proxy
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
    elseif ply:IsProxy() and boss then
        local spawns = proxy
        if not spawns then spawns = boss end
        local spawn = spawns[math.random(#spawns)]
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

function GM:CanPlayerSuicide(ply)
    Network:Notify(ply, "Sorry, you're stuck here")
    return false
end

function GM:IsSpawnpointSuitable(ply, spawnpointEnt, bMakeSuitable)
    return true
end

function GM:PlayerCanHearPlayersVoice(listener, speaker)
    local b = listener:EyePos():Distance(speaker:EyePos()) < (Evil.Cfg.VoiceDistance or 768)
	if (listener:Alive() and not listener:IsHuman()) and (speaker:Alive() and not speaker:IsHuman()) then
		return true, false
	elseif listener:Alive() and speaker:Alive() then
		return b, true
	elseif listener:Alive() != speaker:Alive() then
		return false, false
	elseif not listener:Alive() and not speaker:Alive() then
		return true, false
	end
end
