concommand.Add("evil_getcamang", function(ply, cmd, args, argStr)
    local pos = LocalPlayer():EyePos()
    local ang = LocalPlayer():EyeAngles()
    print(string.format([[
{
    pos = Vector(%f, %f, %f),
    ang = Angle(%f, %f, %f)
}
    ]], pos.x, pos.y, pos.z, ang.p, ang.y, ang.r))
end)

concommand.Add("evil_getpagepos", function(ply, cmd, args, argStr)
    local tr = ply:GetEyeTrace()
    local pos = tr.HitPos + tr.HitNormal * 2
    local ang = tr.HitNormal:Angle()
    print(string.format([[
{
    pos = Vector(%f, %f, %f),
    ang = Angle(%f, %f, %f)
}
    ]], pos.x, pos.y, pos.z, ang.p, ang.y, ang.r))
end)
