local ptColor = Color(255, 50, 50)
hook.Add("Think", "EvilLight", function()
    if (LocalPlayer():IsBoss() or LocalPlayer():IsProxy()) and LocalPlayer():Alive() then
        if not Evil._projlower or not Evil._projupper then
            Evil._projlower = ProjectedTexture() // these can only be 180deg so we need two
            Evil._projupper = ProjectedTexture()

            Evil._projlower:SetTexture("effects/flashlight/soft")
            Evil._projlower:SetAngles(Angle(-90, 0, 0))
            Evil._projlower:SetFarZ(1024)
            Evil._projlower:SetFOV(179)
            Evil._projlower:SetNearZ(1)
            Evil._projlower:SetColor(ptColor)
            Evil._projlower:Update()

            Evil._projupper:SetTexture("effects/flashlight/soft")
            Evil._projupper:SetAngles(Angle(90, 0, 0))
            Evil._projupper:SetFarZ(1024)
            Evil._projupper:SetFOV(150)
            Evil._projupper:SetNearZ(1)
            Evil._projupper:Update()
            Evil._projupper:SetColor(ptColor)
            Evil._projupper:SetFarZ(1024)
            return
        end

        Evil._projlower:SetFOV(GetConVar("fov_desired"):GetInt() * (1.5))
        Evil._projlower:SetAngles(LocalPlayer():GetAimVector():Angle())

        local tr = util.TraceLine({
            start = LocalPlayer():GetPos() + Vector(0, 0, 20),
            endpos = LocalPlayer():GetPos() + Vector(0, 0, 200),
            filter = {LocalPlayer()}
        })

        local pos = tr.HitPos
        if not tr.Hit then
            pos = LocalPlayer():GetPos() + Vector(0, 0, 512)
        else
            pos = tr.HitPos - tr.HitNormal * 5
        end

        Evil._projlower:SetPos(LocalPlayer():EyePos())
        Evil._projlower:Update()

        Evil._projupper:SetPos(pos)
        Evil._projupper:Update()
    else
        if IsValid(Evil._projlower) then Evil._projlower = nil end // gc'd
        if IsValid(Evil._projupper) then Evil._projupper = nil end
    end

    if LocalPlayer():IsSpectating() then
        local target = LocalPlayer():GetObserverTarget()
        local pos
        local size
        local brightness
        if IsValid(target) and LocalPlayer():GetObserverMode() != OBS_MODE_ROAMING then
            pos = target:GetPos() + Vector(0, 0, 2)
            size = 600
            brightness = 2.7
        else
            target = LocalPlayer()
            pos = LocalPlayer():EyePos()
            size = 2222
            brightness = 4
        end

        local light = DynamicLight(target:EntIndex())
        if light then
            light.pos = pos
            light.r = 21
            light.g = 48
            light.b = 91
            light.brightness = brightness
            light.Decay = 1000
            light.Size = size
            light.DieTime = CurTime() + 1
        end
    end
end)

local nvColor = Color(0, 50, 0)
hook.Add("Think", "EvilNightVision", function()
    if LocalPlayer():GetNW2Bool("EvilNightVision") and LocalPlayer():Alive() and LocalPlayer():IsHuman() then
        if not Evil._nvprojlower or not Evil._nvprojupper then
            Evil._nvprojlower = ProjectedTexture() // these can only be 180deg so we need two
            Evil._nvprojupper = ProjectedTexture()

            Evil._nvprojlower:SetTexture("effects/flashlight/soft")
            Evil._nvprojlower:SetAngles(Angle(-90, 0, 0))
            Evil._nvprojlower:SetFarZ(1024)
            Evil._nvprojlower:SetFOV(179)
            Evil._nvprojlower:SetNearZ(1)
            Evil._nvprojlower:SetColor(nvColor)
            Evil._nvprojlower:Update()

            Evil._nvprojupper:SetTexture("effects/flashlight/soft")
            Evil._nvprojupper:SetAngles(Angle(90, 0, 0))
            Evil._nvprojupper:SetFarZ(1024)
            Evil._nvprojupper:SetFOV(150)
            Evil._nvprojupper:SetNearZ(1)
            Evil._nvprojupper:Update()
            Evil._nvprojupper:SetColor(nvColor)
            Evil._nvprojupper:SetFarZ(1024)
            return
        end

        Evil._nvprojlower:SetFOV(GetConVar("fov_desired"):GetInt() * (1.5))
        Evil._nvprojlower:SetAngles(LocalPlayer():GetAimVector():Angle())

        local tr = util.TraceLine({
            start = LocalPlayer():GetPos() + Vector(0, 0, 20),
            endpos = LocalPlayer():GetPos() + Vector(0, 0, 200),
            filter = {LocalPlayer()}
        })

        local pos = tr.HitPos
        if not tr.Hit then
            pos = LocalPlayer():GetPos() + Vector(0, 0, 512)
        else
            pos = tr.HitPos - tr.HitNormal * 5
        end

        Evil._nvprojlower:SetPos(LocalPlayer():EyePos())
        Evil._nvprojlower:Update()

        Evil._nvprojupper:SetPos(pos)
        Evil._nvprojupper:Update()
    else
        if IsValid(Evil._nvprojlower) then Evil._nvprojlower = nil end // gc'd
        if IsValid(Evil._nvprojupper) then Evil._nvprojupper = nil end
    end
end)
