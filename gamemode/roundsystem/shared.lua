Round = Round or {}

ROUND_INVALID = -1
ROUND_WAITING = 0
ROUND_PLAYING = 1

TEAM_BOSS   = 2
TEAM_HUMAN  = 3
TEAM_SPEC   = 4

team.SetUp(TEAM_BOSS,  "Boss",  Color(255, 63,  63),  false)
team.SetUp(TEAM_HUMAN, "Human", Color(63,  153, 255), false)
team.SetUp(TEAM_SPEC,  "Boss",  Color(130, 130, 130), false)

function Round:ToStr(enRound)
    return {
        [ROUND_INVALID] = "invalid",
        [ROUND_WAITING] = "waiting",
        [ROUND_PLAYING] = "playing"
    }[enRound]
end

// absolute
function Round:GetEndTime()
    return GetGlobalFloat("RoundEndTime")
end

function Round:GetRound()
    return GetGlobalInt("CurrentRound", -1)
end

function Round:GetRoundString()
    return self:ToStr(self:GetRound())
end

function Round:Initialize()
    if SERVER then
        Round:WaitForPlayers()
    end
end
