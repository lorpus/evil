hook.Add("KeyPress", "EvilTaunt", function(ply, key)
    if not ply:IsBoss() then return end
    if key != IN_RELOAD then return end

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
    local sound = profile.taunts[math.random(#profile.taunts)]
    ply:EmitSound(sound, 105, 100, 1, CHAN_VOICE)
end)
