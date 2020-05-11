local lastIdleSound = 0
local nextIdleTime = 0
hook.Add("Think", "EvilPlayIdleSounds", function()
    local boss = Game:GetBoss()
    local profile = Game:GetProfileInfo()

    if not Round:IsPlaying() or not IsValid(boss) or not profile then return end

    if SysTime() - lastIdleSound > nextIdleTime then
        lastIdleSound = SysTime()
        nextIdleTime = math.random(15, 20)

        local idlesounds = profile.idlesounds
        if not idlesounds then return end
        local snd = idlesounds[math.random(#idlesounds)]
        boss:EmitSound(snd, 120)
    end
end)
