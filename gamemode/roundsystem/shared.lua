Round = Round or {}

ROUND_INVALID = -1
ROUND_WAITING = 0
ROUND_PLAYING = 1
ROUND_POST    = 2

function Round:ToStr(enRound)
    return "wtf??"
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
