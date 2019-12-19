local ptColor = Color(255, 50, 50)
hook.Add("Think", "EvilLight", function()
    if (LocalPlayer():IsBoss() or LocalPlayer():IsProxy()) and LocalPlayer():Alive() then
        if not projlower or not projupper then
            projlower = ProjectedTexture() // these can only be 180deg so we need two
            projupper = ProjectedTexture()

            projlower:SetTexture("effects/flashlight/soft")
            projlower:SetAngles(Angle(-90, 0, 0))
            projlower:SetFarZ(1024)
            projlower:SetFOV(179)
            projlower:SetNearZ(1)
            projlower:SetColor(ptColor)
            projlower:Update()

            projupper:SetTexture("effects/flashlight/soft")
            projupper:SetAngles(Angle(90, 0, 0))
            projupper:SetFarZ(1024)
            projupper:SetFOV(150)
            projupper:SetNearZ(1)
            projupper:Update()
            projupper:SetColor(ptColor)
            projupper:SetFarZ(1024)
            return
        end

        projlower:SetFOV(GetConVar("fov_desired"):GetInt() * (1.5))
        projlower:SetAngles(LocalPlayer():GetAimVector():Angle())

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

        projlower:SetPos(LocalPlayer():EyePos())
        projlower:Update()

        projupper:SetPos(pos)
        projupper:Update()
    else
        if IsValid(projlower) then projlower = nil end // gc'd
        if IsValid(projupper) then projupper = nil end
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

hook.Add("Think", "EvilNightVision", function()
    if not LocalPlayer():GetNW2Bool("EvilNightVision") then return end
    if not LocalPlayer():Alive() or not LocalPlayer():IsHuman() then return end
    local light = DynamicLight(129)
    light.r = 0
    light.g = 50
    light.b = 0
    light.pos = LocalPlayer():GetPos()
    light.brightness = 5
    light.size = 1e5
    light.dietime = CurTime() + 1
end)
