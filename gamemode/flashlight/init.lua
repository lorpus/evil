function FizzlePlayerFlashlight(ply) // move this in some table eventually
    ply:SetNW2Bool("flashlight", false)
    ply:EmitSound("weapons/physcannon/superphys_small_zap1.wav", 125)

    ply.FlashlightBlocked = true
    timer.Simple(5, function()
        if not IsValid(ply) then return end
        ply.FlashlightBlocked = false
    end)
end

hook.Add("StartCommand", "EvilFlashlight", function(ply, cmd)
    if cmd:GetImpulse() != 100 then return end
    if not Round:IsPlaying() or not ply:Alive() then return end
    local isGhost = ply:IsGhost()
    if not ply:IsHuman() and not isGhost then return end
    if not ply:GetNW2Bool("CanUseEvilFlashlight") then return end

    local toggle = not ply:GetNW2Bool("flashlight")
    if not isGhost then
        ply:EmitSound("items/flashlight1.wav", 125)
    end
    if not ply.FlashlightBlocked then
        ply:SetNW2Bool("flashlight", toggle)

        if isGhost then return end

        if ply.Toggles == nil then ply.Toggles = 0 end
        ply.Toggles = ply.Toggles + 1
        timer.Simple(3, function()
            if not IsValid(ply) then return end
            ply.Toggles = ply.Toggles - 1
        end)

        if ply.Toggles >= 12 then
            FizzlePlayerFlashlight(ply)
        end
    end
end)

hook.Add("Think", "EvilFlashlightFizzle", function()
    for _, ply in pairs(player.GetAll()) do
        if not ply:IsGhost() and ply:GetNW2Bool("flashlight") then
            if eutil.Percent(Evil.Cfg.Flashlight.FizzleChance) then
                FizzlePlayerFlashlight(ply)
            end
        end
    end
end)

hook.Add("PlayerSpawn", "EvilFlashlightEnable", function(ply)
    ply:SetNW2Bool("flashlight", false)
    if ply:IsHuman() or ply:IsGhost() then
        ply:SetNW2Bool("CanUseEvilFlashlight", true)
    else
        ply:SetNW2Bool("CanUseEvilFlashlight", false)
    end
end)
