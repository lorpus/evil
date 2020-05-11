Music = Music or {
    Library = {
        "sound/evil/music/bentandbroken.mp3",
        "sound/evil/music/paratropic_apartments_fx_demo.mp3",
        "sound/evil/music/paratropic_interrogation.mp3",
        "sound/evil/music/paratropic_the_diner.mp3",
        "sound/evil/music/unknownplanet.mp3",
        "sound/evil/music/smogcemetery.mp3",
    },

    StartLibrary = {
        "sound/evil/music/feedmebilly.mp3",
    },
}

function Music:PlayStartMusic()
    if Music.DontPlayStartMusic then return end

    local pick = Music.StartLibrary[math.random(#Music.StartLibrary)]
    local hkval = hook.Run("EvilChooseStartMusic")
    if hkval != nil then pick = hkval end
    sound.PlayFile(pick, "", function(chan, errId, errName)
        if not IsValid(chan) then
            return dbg.print("start " .. pick .. " failed")
        end
        
        chan:SetVolume(0.3)
        chan:Play()
        Music.StartChannel = chan
    end)
end

hook.Add("StartSRCycle", "EvilKillStartMusic", function()
    Music.DontPlayStartMusic = true
    if IsValid(Music.StartChannel) then
        Music.StartChannel:Stop()
        Music.StartChannel = nil
    end
end)

hook.Add("RemoveSR", "EvilKillStartMusic", function()
    Music.DontPlayStartMusic = false
end)

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
            if not IsValid(Music.CurrentChannel) then return end
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
    return profile and profile.round_music // i fail to understand how this fuckwad can still be nil after THREE SECONDS
end)

hook.Add("RoundSet", "EvilHandleMusic", function(round)
    if round == ROUND_PLAYING then
        timer.Simple(3, function() // cuz global shit doesnt broadcast fast enough i dont get it :DD
            Music:PlayStartMusic()
            timer.Simple(11, function()
                Music:StartRandom()
            end)
        end)
    else
        Music:Kill()
    end
end)
