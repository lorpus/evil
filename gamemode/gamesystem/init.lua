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
    ply:SetNW2Bool("EvilKilled", false)
    ply:SetNW2Bool("HasBible", false)
    ply:SetNW2Bool("EvilNightVision", false)
    ply:SetNW2Bool("NoForceSpeeds", false)
    ply:SetNW2String("ClassName", "")
    ply:SetViewOffset(Vector(0, 0, 64))
    ply:SetViewOffsetDucked(Vector(0, 0, 28))
    Game:RemoveGhost(ply)
    Abilities:StripPlayerAbilities(ply)
    Classes:ClearPlayerClass(ply)
    Traits:ClearTraits(ply)
    ply:StopSpectating()
    ply.bDontAskForProxy = false
end

function Game:ResetPlayers()
    for _, ply in pairs(player.GetAll()) do
        Game:ResetPlayer(ply)
    end
end

function Game:SetupBoss(ply)
    local info = Game:GetProfileInfo()
    ply:SetTeam(TEAM_BOSS)
    ply:SetModel(info.model)
    ply:SetRunSpeed(info.runspeed)
    ply:SetWalkSpeed(info.walkspeed)
    ply:SetNW2Float("AbilityCharge", 0.5)

    local hands = ply:GetHands()
    if info.hands_model and IsValid(hands) then
        hands:SetModel(info.hands_model)
    end

    if info.proximity_music then
        timer.Simple(1, function()
            net.Start(Network.Id)
                net.WriteInt(N_BOSSMUSIC, Network.CmdBits)
                net.WriteString(info.proximity_music)
            net.Broadcast()
        end)
    end

    ply:Spawn()
    /*Network:Notify(ply, "#YouAreBoss", true)
    Network:Notify(ply, "#HowToTaunt", true)
    Network:Notify(ply, "#HowToAttack", true)*/

    if istable(info.weapons) then
        for _, v in pairs(info.weapons) do
            ply:Give(v)
        end
    end

    if info.ability then
        Abilities:SetPlayerAbility(ply, info.ability)
    end

    if istable(info.traits) then
        for _, v in pairs(info.traits) do
            Traits:AddTrait(ply, v)
        end
    end

    timer.Simple(0.1, function()
        ply:Lock()
        timer.Simple(5, function()
            if IsValid(ply) then
                ply:UnLock()
            end
        end)
    end)

    if isfunction(info.start) then
        info.start(ply)
    end

    hook.Run("EvilPostBossSetup", Game:GetProfile(), ply)
    Network:SendHook("EvilPostBossSetup", Game:GetProfile(), ply)
end

local lastChosenBoss
function Game:PreSetup()
    // boss

    local ply
    if IsValid(Evil._NEXTBOSSPLAYER) then
        ply = Evil._NEXTBOSSPLAYER
        Evil._NEXTBOSSPLAYER.evilPurchasedBoss = nil
        Evil._NEXTBOSSPLAYER = nil
    else
        local pool = player.GetAll()
        if IsValid(lastChosenBoss) then
            table.RemoveByValue(pool, lastChosenBoss)
        end
        ply = table.Random(pool)
    end

    lastChosenBoss = ply
    Game:SetBoss(ply)
    ply:SetTeam(TEAM_BOSS)

    local key
    if Evil._NEXTBOSS then
        key = Evil._NEXTBOSS
        Evil._NEXTBOSS = nil
    else
        key = table.Random(table.GetKeys(Evil.Bosses))
    end

    Game:SetProfile(key)

    // generic
    for k, v in pairs(player.GetAll()) do
        if Game:GetBoss() == v then continue end

        v:SetTeam(TEAM_HUMAN)
    end

    // gt

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

    return ply, key
end

function Game:SetupHuman(ply, nolock)
    ply:SetTeam(TEAM_HUMAN)
    ply:SetDefaultModel()
    ply:Spawn()

    Classes:HandlePlayer(ply)

    if nolock then return end

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

    Network:SendHook("RunGTFunc", strGametype, "start")
end

function Game:SetGhost(ply)
    local wasKilled = ply:GetNW2Bool("EvilKilled")
    Game:ResetPlayer(ply)
    ply:SetNW2Bool("EvilGhost", true)
    ply:SetNW2Bool("EvilKilled", wasKilled) // reset
    ply:SetRenderMode(RENDERMODE_TRANSALPHA)
    ply:SetColor(Color(255, 255, 255, 120))
    ply:DrawShadow(false)
    ply:Spawn()
end

function Game:RemoveGhost(ply)
    ply:SetNW2Bool("EvilGhost", false)
    ply:SetRenderMode(0)
    ply:SetColor(color_white)
    ply:DrawShadow(true)
    ply:KillSilent()
    ply:StartSpectating()
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

    local gt = Game:GetGametypeInfo()
    if isfunction(gt.deathlogic) then
        gt.deathlogic(victim, inflictor, attacker)
    else
        if not victim:IsBoss() then
            if not Round:IsWaiting() then
                victim:SetTeam(TEAM_SPEC)
                local round = Round:GetRoundCount()
                timer.Simple(4, function()
                    if round == Round:GetRoundCount() and IsValid(victim) and not victim:Alive() then
                        victim:StartSpectating()
                    end
                end)
            end
        end
    end

    if type(attacker) == "CTakeDamageInfo" then
        if IsValid(attacker:GetAttacker()) and attacker:GetAttacker():IsPlayer() and not attacker:GetAttacker():IsBoss() and not attacker:GetAttacker():IsProxy() then
            return
        elseif not IsValid(attacker:GetAttacker()) then
            return
        elseif not attacker:GetAttacker():IsPlayer() then
            return
        end
    else
        return
    end

    victim:SetNW2Bool("EvilKilled", true)
    Jumpscare:SendScare(victim)
    if attacker:GetAttacker():IsProxy() then
        hook.Run("EvilPlayerKilled", victim, TEAM_PROXY, attacker:GetAttacker())
        Network:SendHook("EvilPlayerKilled", victim, TEAM_PROXY, attacker:GetAttacker())
    else
        hook.Run("EvilPlayerKilled", victim, TEAM_BOSS, attacker:GetAttacker())
        Network:SendHook("EvilPlayerKilled", victim, TEAM_BOSS, attacker:GetAttacker())
    end
    local info = Game:GetProfileInfo()
    if info.killhook then
        info.killhook(victim)
    end

    if istable(info.killsounds) then
        Network:BroadcastKillsound(info.killsounds[math.random(#info.killsounds)])
    end
end)

hook.Add("PlayerSpawn", "MoveToSpawn", function(ply)
    timer.Simple(0, function()
        if ply:IsSpecTeam() and not ply:IsGhost() then return end
        
        local humans = Map.spawns.humans
        local boss = Map.spawns.boss
        local proxy = Map.spawns.proxy
        if (ply:IsHuman() or ply:IsGhost()) and humans then
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
        end
    end)
end)

hook.Add("PlayerDeathSound", "EvilRemoveDeathSound", function()
    return false
end)

local function SpawnBlockers()
    if not istable(Map.blockers) then return end
    for _, block in pairs(Map.blockers) do
        local mins = Vector(block.mins)
        local maxs = Vector(block.maxs)
        OrderVectors(mins, maxs)
        local blocker = ents.Create("evil_blockmove")
        // local center = (mins + maxs) / 2
        blocker:SetPos(mins)
        blocker:SetMins(Vector())
        blocker:SetMaxs(maxs - mins)
        blocker:Spawn()
    end
end
hook.Add("InitPostEntity", "SpawnBlockers", SpawnBlockers)
hook.Add("PostCleanupMap", "SpawnBlockers", SpawnBlockers)

function GM:PlayerSay(ply, text, isTeam)
    local tab = {}
    if not ply:Alive() then
        table.insert(tab, Color(255, 0, 0))
        table.insert(tab, "*DEAD* ")
    end
    local col = team.GetColor(ply:Team())
    table.insert(tab, col)
    table.insert(tab, ply:EvilName())
    table.insert(tab, color_white)
    table.insert(tab, ": ")
    table.insert(tab, text)

    hook.Run("ChangePlayerText", ply, text, tab)

    local receivers = { ply }
    for _, v in ipairs(player.GetAll()) do
        local r = hook.Run("PlayerCanSeePlayersChat", text, isTeam, v, ply)
        if r == nil then
            table.insert(receivers, v)
        elseif r != nil and r == true then
            table.insert(receivers, v)
        elseif r != nil and r == false then
            // no
        elseif r then
            table.insert(receivers, v)
        end
    end

    net.Start(Network.Id)
        net.WriteInt(N_NOTIFY, Network.CmdBits)
        net.WriteString("")
        net.WriteBool(false)
        net.WriteBool(false)
        net.WriteBool(true)
        net.WriteBool(false)
        net.WriteTable(tab)
    net.Send(receivers)

    return ""
end

function GM:CanPlayerSuicide(ply)
    Network:Notify(ply, "Sorry, you're stuck here")
    return false
end

function GM:IsSpawnpointSuitable(ply, spawnpointEnt, bMakeSuitable)
    return true
end

function GM:PlayerCanHearPlayersVoice(listener, speaker)
    local b = listener:EyePos():Distance(speaker:EyePos()) < (Evil.Cfg.VoiceDistance or 768)
    if (listener:IsBoss() or listener:IsProxy()) and (speaker:IsBoss() or speaker:IsProxy()) then // baddy <-> baddy
        return true, false
    elseif (listener:Alive() and not listener:IsGhost()) and (speaker:Alive() and not speaker:IsGhost()) then // human <-> human
        return b, true
    elseif (listener:Alive() and not listener:IsGhost()) and (not speaker:Alive() or speaker:IsGhost()) then // living cant hear dead
        return false, false
    elseif (not listener:Alive() or listener:IsGhost()) then // dead people hear all
        return true, false
    end
end

function GM:PlayerCanSeePlayersChat(text, isTeam, receiver, sender)
    if not Round:IsPlaying() then return true end
    if receiver:Alive() and (not sender:Alive() or sender:IsGhost()) then // living cant hear dead
        return false
    end

    return true
end

function GM:SetupPlayerVisibility(viewer, viewent)
    for _, ply in pairs(player.GetAll()) do
        local cansee = Game:CanESP(viewer, ply)
        if cansee then
            AddOriginToPVS(ply:GetPos())
        end
    end

    local boss = Game:GetBoss()
    if IsValid(boss) then
        if SR.ActiveRounds["hax"] then
            AddOriginToPVS(boss:GetPos())
        end
    end

    if viewer:GetNW2String("EvilClass") == "kleiner" then
        local page = ents.FindByClass("evil_page")[1]
        if IsValid(page) then
            AddOriginToPVS(page:GetPos())
        end
    end
end

function GM:PlayerUse(ply, ent)
    if ply:IsGhost() then return false end
end

hook.Add("GetFallDamage", "EvilNoFallDamage", function(ply, spd)
    if ply:IsGhost() or ply:IsBoss() then
        return 0
    end
end)
