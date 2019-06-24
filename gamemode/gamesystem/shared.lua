Game = Game or {}

include("sh_games.lua")
include("sh_bosses.lua")

// separate logic from round

TEAM_BOSS   = 2
TEAM_HUMAN  = 3
TEAM_SPEC   = 4

team.SetUp(TEAM_BOSS,  "Boss",  Color(190, 63,  63),  false)
team.SetUp(TEAM_HUMAN, "Human", Color(63,  113, 170), false)
team.SetUp(TEAM_SPEC,  "Boss",  Color(130, 130, 130), false)

function Game:GetBoss()
    return GetGlobalEntity("EvilBoss")
end

function Game:GetProfile()
    return GetGlobalString("EvilProfile")
end

function Game:GetProfileInfo()
    return Evil.Bosses[GetGlobalString("EvilProfile")]
end

function Game:GetGametype()
    return GetGlobalString("EvilGametype")
end

function Game:GetGametypeInfo()
    return Game.Gametypes[Game:GetGametype()] 
end

function Game:CanESP()
    if Game:GetGametype() == "pages" then
        local taken = GetGlobalInt("PagesCollected")
        local total = 8 // change
        if taken / total < 0.7 then return false end
    else
        return false
    end

    return true
end

hook.Add("ShouldCheckStamina", "nobossstamina", function(ply)
    if ply:Team() == TEAM_BOSS then
        return false
    end
end)

hook.Add("Think", "ProcessGametypeThink", function()
    if Round:IsPlaying() then
        local info = Game:GetGametypeInfo()
        if info.think then
            info.think()
        end
    end
end)
