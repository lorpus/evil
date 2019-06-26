local mylight
hook.Add("Think", "EvilLight", function()
    if LocalPlayer():IsBoss() and LocalPlayer():Alive() then
        if not mylight then
            mylight = DynamicLight(LocalPlayer():EntIndex())
        end

        if mylight then
            mylight.pos = LocalPlayer():GetPos() + Vector(0, 0, 2)
            mylight.r = 21
            mylight.g = 48
            mylight.b = 91
            mylight.brightness = 4
            mylight.Decay = 1000
            mylight.Size = 2222
            mylight.DieTime = CurTime() + 1
        end
    end

    if LocalPlayer():IsSpectating() then
        local target = LocalPlayer():GetObserverTarget()
        if not IsValid(target) then return end

        local light = DynamicLight(target:EntIndex())
        if light then
            light.pos = target:GetPos() + Vector(0, 0, 2)
            light.r = 21
            light.g = 48
            light.b = 91
            light.brightness = 2.7
            light.Decay = 1000
            light.Size = 600
            light.DieTime = CurTime() + 1
        end
    end
end)
