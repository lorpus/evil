local messages = {}

surface.CreateFont("chatmeme", {
    font = "Verdana",
    size = 40
})

local function wordwrap(text)
    local output = ""
    local newlines = 0

    for i, word in pairs(string.Explode(" ", text)) do
        if #word > 25 then
            output = output .. word .. "\n"
            newlines = newlines + 1
            continue
        end

        if i % 10 == 0 then
            output = output .. word .. "\n"
            newlines = newlines + 1
        else
            output = output .. word .. " "
        end
    end

    output = string.TrimRight(output, " ")
    if string.EndsWith(output, "\n") then
        newlines = newlines - 1
    end
    output = string.TrimRight(output, "\n")
    return output, newlines
end

local function DrawText(ply, text, vecOffset /*= Vector(0,0,0)*/)
    if not vecOffset then
        vecOffset = Vector(0, 0, 0)
    end

    local centerpos
    local head = ply:LookupBone("ValveBiped.Bip01_Head1")
    if head then
        local headpos, headang = ply:GetBonePosition(head)
        centerpos = (headpos + Vector(0, 0, 16)) * ply:GetModelScale()
    else
        local min, max = ply:WorldSpaceAABB()
        local pos = ply:GetPos()
        local drawpos = Vector(pos.x, pos.y, max.z)
        centerpos = drawpos + Vector(0, 0, 10) * ply:GetModelScale()
    end

    centerpos = centerpos + vecOffset
    local ang = (centerpos - LocalPlayer():GetShootPos()):Angle()
    ang.p = 0
    ang.y = ang.y - 90
    ang.r = 90
    cam.Start3D2D(centerpos, ang, 0.1)
        draw.DrawText(text, "chatmeme", 0, 0, color_white, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

local hud_time = GetConVar("hud_saytext_time")
function AddMessage(ply, info)
    if ply == LocalPlayer() then return end
    if not messages[ply] then messages[ply] = {} end

    table.insert(messages[ply], info)
    timer.Simple(hud_time:GetFloat(), function()
        table.RemoveByValue(messages[ply], info)
    end)
end

hook.Add("OnPlayerChat", "floatychat", function(ply, _text, bTeam, bDead)
    if ply == LocalPlayer() and LocalPlayer():Alive() then
        chat.PlaySound()
        return true
    end

    if not IsValid(ply) then return false end

    AddMessage(ply, {
        text = _text,
        team = bTeam,
        dead = bDead
    })

    if not LocalPlayer():Alive() and not ply:Alive() then return false end
    return true
end)

hook.Add("PostDrawOpaqueRenderables", "drawthefloatytext", function(depth, skybox)
    for _, ply in pairs(player.GetAll()) do
        if ply == LocalPlayer() then continue end

        if messages[ply] and messages[ply] != {} then
            local total_newlines = 0
            for i, message in pairs(table.Reverse(messages[ply])) do
                local wrapped, newlines = wordwrap(message.text)
                if i <= 3 then
                    total_newlines = total_newlines + newlines
                    DrawText(ply, wrapped, Vector(0, 0, -8) + Vector(0, 0, 5) * (i + total_newlines + (ply:IsTyping() and 1 or 0)))
                end
            end
        end

        if ply:IsTyping() then
            DrawText(ply, string.rep(".", (CurTime() * 2) % 5), Vector(0, 0, -3))
        end
    end
end)
