function Game:TauntNetHandler(len, ply)
    if not ply:IsBoss() and not ply:IsProxy() then return end

    local profile = Game:GetProfileInfo()
    local taunts
    if ply:IsBoss() then
        taunts = profile.taunts
    elseif ply:IsProxy() then
        taunts = profile.proxy.taunts
    end
    if not istable(taunts) then return end

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
    if desired == "random" or not table.HasValue(taunts, desired) then
        snd = taunts[math.random(#taunts)]
    else
        snd = desired
    end
    dbg.print(snd)
    ply:EmitSound(snd, 90, 100, 1, CHAN_VOICE)
end
