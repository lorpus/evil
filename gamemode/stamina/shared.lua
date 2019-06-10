Stamina = Stamina or Evil.Cfg.Stamina

local function moving(ply, cmd)
    return  cmd:KeyDown(IN_FORWARD) or
            cmd:KeyDown(IN_BACK) or
            cmd:KeyDown(IN_MOVELEFT) or
            cmd:KeyDown(IN_MOVERIGHT)
end

hook.Add("StartCommand", "nazis", function(ply, cmd)
    local flStamina = ply:GetNWFloat("stamina")
    local flOldStamina = flStamina

    if not ply.flLastSpeed then
        ply.flLastSpeed = 0
        return
    end

    local bShouldCheck = hook.Run("ShouldCheckStamina", ply)

    if bShouldCheck == false then
        return
    end

    if cmd:KeyDown(IN_JUMP) and not ply:KeyDownLast(IN_JUMP) and ply:OnGround() and flStamina > 0 then
        flStamina = flStamina - Stamina.jumplosestamina
    end

    if cmd:KeyDown(IN_SPEED) and moving(ply, cmd) then
        if flStamina > 0 then
            flStamina = flStamina - Stamina.loserate
        end
        ply.flLastSpeed = CurTime()
    elseif not ply:KeyDown(IN_SPEED) and flStamina <= Stamina.maxstamina then
        if ply.flLastSpeed then
            if CurTime() - ply.flLastSpeed > 5 then
                flStamina = flStamina + Stamina.gainrate
            end
        end
    end

    if flStamina <= 0 then
        ply:SetRunSpeed(Stamina.walkspeed)
        ply:SetJumpPower(Stamina.staminajump)
    else
        ply:SetRunSpeed(Stamina.runspeed)
        ply:SetJumpPower(Stamina.normaljump)
    end

    if flStamina != flOldStamina and SERVER then
        ply:SetNWFloat("stamina", flStamina)
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
