API = API or {
    Bosses = {},
}

function API:ProcessBossProfile(info)
    local f = {}
    f.name = info.Name
    f.model = info.Model
    f.runspeed = info.RunSpeed
    f.walkspeed = info.WalkSpeed
    f.proximity_music = info.ProximityMusic
    f.chase_music = info.ChaseMusic
    f.weapons = info.Weapons
    f.killhook = info.OnKill and function(victim, boss) info.OnKill(boss, victim) end or nil
    f.jumpscare = info.Jumpscare and { mat = info.Jumpscare.Material, sound = info.Jumpscare.Sound, len = info.Jumpscare.Length } or nil
    f.taunts = info.Taunts
    f.tauntdisplay = info.TauntDisplay
    f.killsounds = info.KillSounds
    f.ability = info.Ability
    f.traits = info.Traits
    f.no_running_animation = info.DisableRunningAnimation
    f.modelscale = info.ModelScale
    f.round_music = info.RoundMusic
    f._Proxy = info.Proxy
    f._Precache = info.Precache -- to be handled when gm knows this boss should be used
    f._Lang = info.Lang
    f._WSID = info.WorkshopID

    f.Think = info.Think

    player_manager.AddValidModel(info.Name, info.Model)
    if info.HandsModel then
        player_manager.AddValidHands(info.Name, info.HandsModel, 0, "0000000")
    end

    f._Resources = {}
    local function res(lst, pre)
        if not lst then return end
        if istable(lst) then
            for _, v in pairs(lst) do
                if not file.Exists((pre or "") .. v, "THIRDPARTY") then continue end -- we don't want to add stock game content
                if pre then
                    table.insert(f._Resources, pre .. v)
                else
                    table.insert(f._Resources, v)
                end
            end
        elseif file.Exists((pre or "") .. lst, "THIRDPARTY") then
            table.insert(f._Resources, (pre or "") .. lst) 
        end 
    end

    res(f.model)
    res(f.proximity_music, "sound/")
    res(f.round_music)
    res(f.taunts, "sound/")
    res(f.killsounds, "sound/")
    res(info.ExtraResources)
    if f._Precache then res(f._Precache.Sounds, "sound/") res(f._Precache.Models) end
    if f.jumpscare then res(f.jumpscare.mat .. ".vmt", "materials/") res(f.jumpscare.sound, "sound/") end

    return f
end

function API:ProcessProxyProfile(info)
    local f = {}
    f.model = info.Model
    f.walkspeed = info.WalkSpeed
    f.runspeed = info.RunSpeed
    f.taunt_cooldown = info.TauntCooldown
    f.taunts = info.Taunts
    f.traits = info.Traits
    f.weapons = info.Weapons
    f.tauntdisplay = info.TauntDisplay
    f.start = info.OnStart
    f.finish = info.OnFinish
    f._Lang = info.Lang
    f._Precache = info.Precache
    return f
end

function API:RegisterBoss(profile, v)
    if istable(v._Lang) then
        for lang, data in pairs(v._Lang) do
            for k, v in pairs(data) do
                Lang:Add(lang, k, v)
            end
        end
    end

    local function ps(t)
        if istable(t) then
            for _, s in ipairs(t) do
                util.PrecacheSound(s)
            end
        end
    end

    util.PrecacheModel(v.model)

    ps(v.taunts)
    ps(v.killsounds)
    if v.jumpscare then util.PrecacheSound(v.jumpscare.sound) end
    if v.round_music then util.PrecacheSound(v.round_music) end
    if v.proximity_music then util.PrecacheSound(v.proximity_music) end
    if v.proxy then
        ps(v.taunts)
    end

    if v._Precache then
        if v._Precache.Models then
            for _, model in ipairs(v._Precache.Models) do
                util.PrecacheModel(model)
            end
        end
        ps(v._Precache.Sounds)
    end

    Evil.Bosses[profile] = v
    dbg.print("Successfully processed and registered boss " .. profile)
end

function API:LoadBoss(filename)
    local profile = filename:Split(".")[1]
    local success, func = xpcall(CompileFile, function(err)
        Evil.Log("ERROR loading boss " .. profile .. ": " .. err)
    end, "evil/bosses/" .. filename)
    local info
    if success and func then
        BOSS = {}
        BOSS.ID = profile
        xpcall(func, function(err)
            Evil.Log("ERROR loading boss " .. profile .. ": " .. err)
            BOSS = nil
        end)
        if not BOSS then return end
        info = BOSS
        BOSS = nil
    else
        Evil.Log("ERROR loading boss " .. profile)
        return
    end

    -- process it back into the form the gamemode wants since i cba to change 500 lines everywhere :DD
    API.Bosses[profile] = API:ProcessBossProfile(info)
    API.Bosses[profile]._Filename = "evil/bosses/" .. filename

    dbg.print("Loaded boss " .. profile .. " successfully")
end

function API:LoadProxy(filename)
    local profile = filename:Split(".")[1]
    local success, func = xpcall(CompileFile, function(err)
        Evil.Log("ERROR loading proxy " .. profile .. ": " .. err)
    end, "evil/proxies/" .. filename)
    local info
    if success and func then
        PROXY = {}
        PROXY.ID = profile
        xpcall(func, function(err)
            Evil.Log("ERROR loading proxy " .. profile .. ": " .. err)
            PROXY = nil
        end)
        if not PROXY then return end
        info = PROXY
        PROXY = nil
    else
        Evil.Log("ERROR loading proxy " .. profile)
        return
    end

    -- same as before
    local f = API:ProcessProxyProfile(info)
    f._Filename = "evil/proxies/" .. filename

    dbg.print("Loaded proxy " .. profile .. " successfully")

    local b = false
    for k, v in pairs(API.Bosses) do
        if v._Proxy == profile then
            v.proxy = f
            dbg.print("Proxy " .. profile .. " matched to " .. k)
            b = true
        end
    end

    if not b then
        dbg.print("Proxy " .. profile .. " is unused")
    end
end

function API:SharedLoad() -- for shit like abilities where size isnt a concern
    local f, _ = file.Find("evil/abilities/*.lua", "LUA")
    for _, filename in ipairs(f) do
        if SERVER then
            AddCSLuaFile("evil/abilities/" .. filename)
        end

        local name = filename:Split(".")[1]

        local success, func = xpcall(CompileFile, function(err)
            Evil.Log("ERROR loading ability " .. name .. ": " .. err)
        end, "evil/abilities/" .. filename)
        local info
        if success and func then
            ABILITY = {}
            ABILITY.ID = name
            xpcall(func, function(err)
                Evil.Log("ERROR loading ability " .. name .. ": " .. err)
                ABILITY = nil
            end)
            if not ABILITY then continue end
            info = ABILITY
            ABILITY = nil
        else
            Evil.Log("ERROR loading ability " .. name)
            continue
        end

        Abilities.Abilities[name] = {
            use = function(ply) if isfunction(info.OnUse) then info:OnUse(ply) end end
        }

        dbg.print("Successfully registered ability " .. name)
    end

    f, _ = file.Find("evil/traits/*.lua", "LUA")
    for _, filename in ipairs(f) do
        if SERVER then
            AddCSLuaFile("evil/traits/" .. filename)
        end

        local name = filename:Split(".")[1]
        local success, func = xpcall(CompileFile, function(err)
            Evil.Log("ERROR loading trait " .. name .. ": " .. err)
        end, "evil/traits/" .. filename)
        local info
        if success and func then
            TRAIT = {}
            TRAIT.ID = name
            xpcall(func, function(err)
                Evil.Log("ERROR loading trait " .. name .. ": " .. err)
                TRAIT = nil
            end)
            if not TRAIT then continue end
            info = TRAIT
            TRAIT = nil
        else
            Evil.Log("ERROR loading trait " .. name)
            continue
        end

        local t = {}
        if info.Apply then t.apply = function(ply) info:Apply(ply) end end
        if info.Remove then t.remove = function(ply) info:Remove(ply) end end
        if info.Think then t.think = function(ply) info:Think(ply) end end
        Traits.Traits[name] = t

        dbg.print("Successfully registered trait " .. name)
    end

    Evil.Loaded = true
    hook.Run("EvilLoaded")
end
