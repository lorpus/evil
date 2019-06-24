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
end)
