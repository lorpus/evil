local function FizzlePlayerFlashlight(ply)
    ply:SetNW2Bool("flashlight", false)
    ply:EmitSound("weapons/physcannon/superphys_small_zap1.wav", 125)

    ply.FlashlightBlocked = true
    timer.Simple(5, function()
        ply.FlashlightBlocked = false
    end)
end

hook.Add("StartCommand", "EvilFlashlight", function(ply, cmd)
    if cmd:GetImpulse() != 100 then return end
    if not Round:IsPlaying() or not ply:Alive() then return end
    if not ply:Team() == TEAM_HUMAN then return end
    if not ply:GetNW2Bool("CanUseEvilFlashlight") then return end

    local toggle = not ply:GetNW2Bool("flashlight")
    ply:EmitSound("items/flashlight1.wav", 125)
    if not ply.FlashlightBlocked then
        ply:SetNW2Bool("flashlight", toggle)

        if ply.Toggles == nil then ply.Toggles = 0 end
        ply.Toggles = ply.Toggles + 1
        timer.Simple(3, function() ply.Toggles = ply.Toggles - 1 end)
        if ply.Toggles >= 12 then
            FizzlePlayerFlashlight(ply)
        end
    end
end)

hook.Add("Think", "EvilFlashlightFizzle", function()
    for _, ply in pairs(player.GetAll()) do
        if ply:GetNW2Bool("flashlight") then
            if eutil.Percent(Evil.Cfg.Flashlight.FizzleChance) then
                FizzlePlayerFlashlight(ply)
            end
        end
    end
end)

hook.Add("PlayerSpawn", "EvilFlashlightEnable", function(ply)
    if ply:IsHuman() then
        ply:SetNW2Bool("CanUseEvilFlashlight", true)
    else
        ply:SetNW2Bool("CanUseEvilFlashlight", false)
    end
end)
