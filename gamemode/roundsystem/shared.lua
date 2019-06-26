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
    return GetGlobal2Float("RoundEndTime")
end

function Round:GetRound()
    return GetGlobal2Int("CurrentRound", -1)
end

function Round:GetRoundString()
    return self:ToStr(self:GetRound())
end

function Round:IsWaiting()
    return Round:GetRound() == ROUND_WAITING
end

function Round:IsPlaying()
    return Round:GetRound() == ROUND_PLAYING
end

function Round:IsPost()
    return Round:GetRound() == ROUND_POST
end

function Round:GetRoundCount() // number of times there has been ROUND_PLAYING
    return GetGlobal2Int("RoundCount")
end

function Round:Initialize()
    if SERVER then
        Round:WaitForPlayers()
    end
end
