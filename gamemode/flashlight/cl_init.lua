local function RenderUserFlashlight(ply)
    if Evil.Cfg.Flashlight.UseProjectedTexture then
        if not ply.EvilFlashlight or not ply.EvilFlashlight:IsValid() then
            local light = ProjectedTexture()
            light:SetTexture("effects/flashlight/soft")
            light:SetPos(ply:EyePos() + ply:GetAimVector() * 14)
            light:SetAngles(ply:EyeAngles())
            light:SetFarZ(Evil.Cfg.Flashlight.FlashlightDistance)
            light:SetFOV(50)
            light:SetNearZ(1)
            light:Update()
            ply.EvilFlashlight = light
        else
            ply.EvilFlashlight:SetPos(ply:EyePos() + ply:GetAimVector() * 14)
            ply.EvilFlashlight:SetAngles(ply:EyeAngles())
            ply.EvilFlashlight:SetNearZ(1)
            ply.EvilFlashlight:Update()
        end
    else
        local flpos = ply:GetEyeTrace().HitPos
        if flpos:Distance(ply:GetPos()) < 5000 then
            local light = DynamicLight(ply:EntIndex())
            if light then
                light.pos = flpos + Vector(0, 0, 2)
                light.r = 21
                light.g = 48
                light.b = 91
                light.brightness = math.min((5 - flpos:Distance(ply:GetPos()) ^ 1.8 / 100000), 7)
                light.Decay = 1e100
                light.Size = 420
                light.DieTime = CurTime() + 1
            end
        end
    end
end

hook.Add("Think", "EvilFlashlight", function()
    if Round:GetRound() == ROUND_PLAYING then
        for _, ply in pairs(player.GetAll()) do
            if ply:IsHuman() and ply:Alive()  then
                if ply:GetNWBool("flashlight") and ply:GetNWBool("CanUseEvilFlashlight") then
                    RenderUserFlashlight(ply)
                else
                    if ply.EvilFlashlight then
                        ply.EvilFlashlight:Remove()
                        ply.EvilFlashlight = nil
                    end
                end
            else
                if ply.EvilFlashlight then
                    ply.EvilFlashlight:Remove()
                    ply.EvilFlashlight = nil
                end
            end
        end
    end
end)
