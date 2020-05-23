local useStockFlashlight = false

local function RenderUserFlashlight(ply)
    if ply != LocalPlayer() and useStockFlashlight then
        if ply.EvilFlashlight then
            ply.EvilFlashlight:Remove()
            ply.EvilFlashlight = nil
        end

        if not ply:IsEffectActive(EF_DIMLIGHT) then
            ply:AddEffects(EF_DIMLIGHT)
        end

        return
    elseif not useStockFlashlight then
        if ply:IsEffectActive(EF_DIMLIGHT) then
            ply:RemoveEffects(EF_DIMLIGHT)
        end
    end

    if Evil.Cfg.Flashlight.UseProjectedTexture then
        if not ply.EvilFlashlight or not ply.EvilFlashlight:IsValid() then
            local light = ProjectedTexture()
            light:SetTexture("effects/flashlight/soft")
            light:SetPos(ply:EyePos() + ply:GetAimVector() * 14)
            light:SetAngles(ply:EyeAngles())
            light:SetFarZ(Evil.Cfg.Flashlight.FlashlightDistance)
            light:SetFOV(Evil.Cfg.Flashlight.FlashlightSize)
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

local function RemoveLight(ply)
    if ply.EvilFlashlight then
        ply.EvilFlashlight:Remove()
        ply.EvilFlashlight = nil
    end

    if ply:IsEffectActive(EF_DIMLIGHT) then
        ply:RemoveEffects(EF_DIMLIGHT)
    end
end

local switchToShitLights = SysTime() + 60
local switchToGoodLights = SysTime() + 60
local fpshist = {}
local fpslen = 10
hook.Add("Think", "EvilFlashlight", function()
    local tmpfps = 1 / RealFrameTime()
    table.insert(fpshist, 1, tmpfps)
    if #fpshist > fpslen then fpshist[fpslen] = nil end
    local fps = 0
    for _, n in ipairs(fpshist) do fps = fps + n end
    fps = fps / #fpshist

    local st = SysTime()

    if fps > 35 then
        switchToShitLights = st + 5
    end

    if fps < 65 then
        switchToGoodLights = st + 5
    end

    if st > switchToShitLights and not useStockFlashlight then
        useStockFlashlight = true
        switchToGoodLights = math.huge
    end

    if st > switchToGoodLights and useStockFlashlight then
        useStockFlashlight = false
        switchToShitLights = math.huge
    end

    if Round:IsPlaying() or Round:IsPost() then
        for _, ply in pairs(player.GetAll()) do
            if SR.ActiveRounds["allalone"] and ply != LocalPlayer() then RemoveLight(ply) continue end
            if (ply:IsHuman() and ply:Alive()) or (ply == LocalPlayer() and ply:IsGhost()) then
                if ply:GetNW2Bool("flashlight") and ply:GetNW2Bool("CanUseEvilFlashlight") then
                    RenderUserFlashlight(ply)
                else
                    RemoveLight(ply)
                end
            else
                RemoveLight(ply)
            end
        end
    else
        for _, ply in pairs(player.GetAll()) do
            RemoveLight(ply)
        end
    end
end)
