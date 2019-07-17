Music = Music or {
    Library = {
        "sound/evil/music/bentandbroken.mp3",
        "sound/evil/music/decay.mp3",
        "sound/evil/music/unknownplanet.mp3",
        "sound/evil/music/smogcemetery.mp3",
    }
}

function Music:StartRandom()
    local pick = Music.Library[math.random(#Music.Library)]
    local hkval = hook.Run("EvilChooseMusic")
    if hkval != nil then pick = hkval end
    dbg.print(pick)
    sound.PlayFile(pick, "", function(chan, errId, errName)
        if not IsValid(chan) then
            return dbg.print(pick .. " failed")
        end

        chan:SetVolume(0.5)
        chan:EnableLooping(true)
        Music.CurrentChannel = chan
    end)
end

function Music:Kill()
    if not IsValid(Music.CurrentChannel) then return end

    local v = Music.CurrentChannel:GetVolume()
    for i = 1, v * 1000 do
        timer.Simple(i / 100, function()
            Music.CurrentChannel:SetVolume(v - i / 1000)
        end)
    end

    timer.Simple(5, function()
        Music.CurrentChannel:Stop()
        Music.CurrentChannel = nil
    end)
end

hook.Add("EvilChooseMusic", "EvilBossCustomMusic", function()
    local profile = Game:GetProfileInfo()
    return profile.round_music // nil otherwise :goodthink:
end)

hook.Add("RoundSet", "EvilHandleMusic", function(round)
    if round == ROUND_PLAYING then
        timer.Simple(1, function() // cuz global shit doesnt broadcast fast enough i dont get it :DD
            Music:StartRandom()
        end)
    else
        Music:Kill()
    end
end)
