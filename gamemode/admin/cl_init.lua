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
