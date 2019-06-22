hook.Add("StartCommand", "EvilFlashlight", function(ply, cmd)
    if cmd:GetImpulse() != 100 then return end
    if not Round:IsPlaying() or not ply:Alive() then return end
    if not ply:Team() == TEAM_HUMAN then return end
    if not ply:GetNWBool("CanUseEvilFlashlight") then return end

    local toggle = not ply:GetNWBool("flashlight")
    ply:EmitSound("items/flashlight1.wav", 125)
    if not ply.FlashlightBlocked then
        ply:SetNWBool("flashlight", toggle)
    end
end)

hook.Add("Think", "EvilFlashlightFizzle", function()
    for _, ply in pairs(player.GetAll()) do
        if ply:GetNWBool("flashlight") then
            if eutil.Percent(Evil.Cfg.Flashlight.FizzleChance) then
                ply:SetNWBool("flashlight", false)
                ply:EmitSound("weapons/physcannon/superphys_small_zap1.wav", 125)

                ply.FlashlightBlocked = true
                timer.Simple(5, function()
                    ply.FlashlightBlocked = false
                end)
            end
        end
    end
end)

hook.Add("PlayerSpawn", "EvilFlashlightEnable", function(ply)
    if ply:IsHuman() then
        ply:SetNWBool("CanUseEvilFlashlight", true)
    else
        ply:SetNWBool("CanUseEvilFlashlight", false)
    end
end)
