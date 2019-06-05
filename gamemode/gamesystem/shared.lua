Game = Game or {}

include("sh_games.lua")
include("sh_bosses.lua")

// separate logic from round

TEAM_BOSS   = 2
TEAM_HUMAN  = 3
TEAM_SPEC   = 4

team.SetUp(TEAM_BOSS,  "Boss",  Color(255, 63,  63),  false)
team.SetUp(TEAM_HUMAN, "Human", Color(63,  153, 255), false)
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