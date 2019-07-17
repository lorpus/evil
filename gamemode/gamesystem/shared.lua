Game = Game or {}

include("sh_games.lua")
include("sh_bosses.lua")

// separate logic from round

TEAM_BOSS   = 2
TEAM_HUMAN  = 3
TEAM_SPEC   = 4
TEAM_PROXY  = 5

team.SetUp(TEAM_BOSS,  "Boss",  Color(190, 63,  63),  false)
team.SetUp(TEAM_HUMAN, "Human", Color(63,  113, 170), false)
team.SetUp(TEAM_SPEC,  "Boss",  Color(130, 130, 130), false)
team.SetUp(TEAM_PROXY, "Proxy", Color(190, 63, 63),   false)

function Game:GetBoss()
    return GetGlobal2Entity("EvilBoss")
end

function Game:GetProfile()
    return GetGlobal2String("EvilProfile")
end

function Game:GetProfileInfo()
    return Evil.Bosses[GetGlobal2String("EvilProfile")]
end

function Game:GetGametype()
    return GetGlobal2String("EvilGametype")
end

function Game:GetGametypeInfo()
    return Game.Gametypes[Game:GetGametype()] 
end

function Game:GetHumans()
    local ret = {}

    for _, ply in pairs(player.GetAll()) do
        if ply:Alive() and ply:Team() == TEAM_HUMAN then
            table.insert(ret, ply)
        end
    end

    return ret
end

function Game:GetDead()
    local ret = {}
    
    for _, ply in pairs(player.GetAll()) do
        if not ply:Alive() then
            table.insert(ret, ply)
        end
    end

    return ret
end

function Game:GetPercentHumansAlive() // what % are humans that are alive
    local count = #player.GetAll()
    local percent = 0
    for k, ply in pairs(Game:GetHumans()) do
        if ply:Alive() then
            percent = percent + (1 / count)
        end
    end

    return percent
end

function Game:CanESP(viewer, viewed)
    if viewer == viewed then return false end

    local d = true
    if not viewed:IsHuman() or not viewed:Alive() then
        d = false
    elseif not viewer:IsBoss() then
        d = false
    elseif viewer:IsBoss() and viewed:GetNW2Bool("EvilForceESP") then
        d = true
    elseif Game:GetGametype() == "pages" then
        local taken = GetGlobal2Int("PagesCollected")
        local total = GetGlobal2Int("PagesTotal")
        if taken / total < 0.7 then d = false end
    else
        d = false
    end 

    local hk = hook.Run("CanSeePlayerESP", viewer, viewed)
    if hk != nil then
        return hk
    end

    return d
end

hook.Add("ShouldCollide", "EvilPlayerNoCollide", function(e1, e2)
    if e1:IsPlayer() and e2:IsPlayer() then
        return e1:Team() != e2:Team()
    end
end)

hook.Add("ShouldCheckStamina", "EviCheckStamina", function(ply)
    if ply:IsBoss() then
        local info = Game:GetProfileInfo()
        if info and info.stamina then
            return true
        else
            return false
        end
    elseif ply:IsProxy() then
        local info = Game:GetProfileInfo()
        if info and info.proxy and info.proxy.stamina then
            return true
        else
            return false
        end
    end
end)

hook.Add("Think", "ProcessGametypeThink", function()
    if Round:IsPlaying() then
        local info = Game:GetGametypeInfo()
        if info and isfunction(info.think) then
            info.think()
        end
    end
end)

hook.Add("Think", "EvilBossThink", function()
    if Round:IsPlaying() then
        local info = Game:GetProfileInfo()
        if info and isfunction(info.think) then
            info.think()
        end
    end
end)

hook.Add("EntityEmitSound", "memefootsteps", function(data)
    if not IsValid(data.Entity) or not data.Entity:IsPlayer() then return end
    if not data.SoundName:find("footsteps") then return end

    if CLIENT and LocalPlayer():IsBoss() then
        return
    else
        if CLIENT and data.Entity:IsBoss() then
            return false
        elseif data.Entity:Crouching() then
            data.Volume = data.Volume * 0.5
            return true
        end
    end
end)
