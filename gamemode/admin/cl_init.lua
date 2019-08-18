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

concommand.Add("evil_getspawnpos", function(ply, cmd, args, argStr)
    local pos = ply:GetPos() + Vector(0, 0, 1)
    local ang = ply:EyeAngles()
    print(string.format([[
{
    pos = Vector(%f, %f, %f),
    ang = Angle(%f, %f, %f)
}
    ]], pos.x, pos.y, pos.z, ang.p, ang.y, ang.r))
end)

hook.Add("Think", "DebugShit", function()
    if GetConVar("evil_showplayers"):GetBool() then
        for _, ply in pairs(player.GetAll()) do
            if ply:Alive() and ply != LocalPlayer() then
                debugoverlay.Text(ply:GetPos(), ply:Nick(), 0.1, true)
            end
        end
    end
end)

hook.Add("HUDPaint", "DebugAA", function()
    if GetConVar("evil_showmappositions"):GetBool() then
        for k, v in pairs(Map.spawns.humans) do
            local scr = v.pos:ToScreen()
            draw.SimpleText("HUMAN - " .. k, "DermaDefault", scr.x, scr.y)
        end

        for k, v in pairs(Map.spawns.boss) do
            local scr = v.pos:ToScreen()
            draw.SimpleText("BOSS - " .. k, "DermaDefault", scr.x, scr.y)
        end

        for k, v in pairs(Map.pages) do
            if not v.pos and istable(v[1]) then
                for _, bruh in pairs(v) do
                    local scr = bruh.pos:ToScreen()
                    draw.SimpleText("PAGE - " .. k, "DermaDefault", scr.x, scr.y)
                end

                continue
            end

            local scr = v.pos:ToScreen()
            draw.SimpleText("PAGE - " .. k, "DermaDefault", scr.x, scr.y)
        end

        for _, v in pairs(Map.cameras) do
            local start = v.pos:ToScreen()
            local endpos = (v.pos + v.ang:Forward() * 32):ToScreen()
            surface.SetDrawColor(255, 0, 0)
            surface.DrawLine(start.x, start.y, endpos.x, endpos.y)
            draw.SimpleText("CAM", "DermaDefault", start.x, start.y)
        end

        if istable(Map.collectables) then
            if istable(Map.collectables.op) then
                for _, pos in pairs(Map.collectables.op) do
                    local scr = pos:ToScreen()
                    draw.SimpleText("OP COLLECTABLE", "DermaDefault", scr.x, scr.y)
                end
            end

            if istable(Map.collectables.normal) then
                for _, pos in pairs(Map.collectables.normal) do
                    local scr = pos:ToScreen()
                    draw.SimpleText("NORMAL COLLECTABLE", "DermaDefault", scr.x, scr.y)
                end
            end
        end
    end
end)
