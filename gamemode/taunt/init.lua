function Game:TauntNetHandler(len, ply)
    if not ply:IsBoss() then return end

    local profile = Game:GetProfileInfo()
    if not istable(profile.taunts) then return end

    if ply.flLastTaunt then
        local rel = profile.taunt_cooldown or Evil.Cfg.TauntCooldown
        if CurTime() - ply.flLastTaunt < rel then
            return
        end
    end

    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep:GetMaxClip1() != 0 then
        if wep:Clip1() != wep:GetMaxClip1() then return end
    end

    ply.flLastTaunt = CurTime()
    
    local desired = net.ReadString()
    if desired == "random" or not table.HasValue(profile.taunts, desired) then
        snd = profile.taunts[math.random(#profile.taunts)]
    else
        snd = desired
    end
    print(snd)
    ply:EmitSound(snd, 90, 100, 1, CHAN_VOICE)
end
