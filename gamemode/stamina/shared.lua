Stamina = Stamina or Evil.Cfg.Stamina

local function moving(ply, cmd)
    return  cmd:KeyDown(IN_FORWARD) or
            cmd:KeyDown(IN_BACK) or
            cmd:KeyDown(IN_MOVELEFT) or
            cmd:KeyDown(IN_MOVERIGHT)
end

hook.Add("StartCommand", "nazis", function(ply, cmd)
    local flStamina = ply:GetNW2Float("stamina")
    local flOldStamina = flStamina

    if not ply.flLastSpeed then
        ply.flLastSpeed = 0
        return
    end

    local bShouldCheck = hook.Run("ShouldCheckStamina", ply)

    if bShouldCheck == false then
        return
    end

    if not ply:Alive() then return end

    local staminaScale = hook.Run("PlayerStaminaScale", ply)
    if staminaScale == nil then staminaScale = 1 end
    //dbg.print(ply, staminaScale)

    if cmd:KeyDown(IN_JUMP) and not ply:KeyDownLast(IN_JUMP) and ply:OnGround() and flStamina > 0 then
        flStamina = flStamina - Stamina.jumplosestamina * staminaScale
        ply.flLastSpeed = CurTime()
    end

    if cmd:KeyDown(IN_SPEED) and moving(ply, cmd) then
        if flStamina > 0 then
            flStamina = flStamina - Stamina.loserate * staminaScale
        end

        ply.flLastSpeed = CurTime()
    elseif not ply:KeyDown(IN_SPEED) and flStamina <= Stamina.maxstamina then
        if ply.flLastSpeed then
            if CurTime() - ply.flLastSpeed > Evil.Cfg.Stamina.gainwait then
                flStamina = flStamina + Stamina.gainrate * staminaScale
            end
        end
    end

    if flStamina <= 0 and not ply:GetNW2Bool("NoForceSpeeds") then
        local walkspeed = Stamina.walkspeed
        if ply:IsBoss() then
            walkspeed = Game:GetProfileInfo().walkspeed
        elseif ply:IsProxy() then
            walkspeed = Game:GetProfileInfo().proxy.walkspeed
        end
        local hkws = hook.Run("StaminaWalkspeed", ply, walkspeed)
        if hkws != nil then walkspeed = hkws end
        local hkjp = hook.Run("StaminaJumpPower", ply, false, Stamina.staminajump)
        if hkjp == nil then hkjp = Stamina.staminajump end
        ply:SetRunSpeed(walkspeed)
        ply:SetJumpPower(hkjp)
    elseif not ply:GetNW2Bool("NoForceSpeeds") then
        local runspeed = Stamina.runspeed
        if ply:IsBoss() then
            runspeed = Game:GetProfileInfo().runspeed
        elseif ply:IsProxy() then
            runspeed = Game:GetProfileInfo().proxy.runspeed
        end
        local hkrs = hook.Run("StaminaRunspeed", ply, runspeed)
        if hkrs != nil then runspeed = hkrs end
        local hkjp = hook.Run("StaminaJumpPower", ply, true, Stamina.normaljump)
        if hkjp == nil then hkjp = Stamina.normaljump end
        ply:SetRunSpeed(runspeed)
        ply:SetJumpPower(hkjp)
    end

    if flStamina != flOldStamina and SERVER then
        ply:SetNW2Float("stamina", flStamina)
    end
end)

/*hook.Add("PlayerTick", "zooop", function(ply, mv)
    if not CLIENT then return end // frick u prediction !!1

    if bit.band(mv:GetButtons(), IN_SPEED) != 0 then
        if ply:GetNWInt("stamina") <= 0 then
            mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_SPEED)))
        end
    end
end)*/
