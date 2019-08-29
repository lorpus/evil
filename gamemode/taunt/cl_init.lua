local function InsideConvexPolygon(point, vertices)
    local odd = false
    local j = #vertices
    for i = 1, #vertices do
        if (vertices[i].y < point.y and vertices[j].y >= point.y or vertices[j].y < point.y and vertices[i].y >= point.y) then
            if (vertices[i].x + (point.y - vertices[i].y) / (vertices[j].y - vertices[i].y) * (vertices[j].x - vertices[i].x) < point.x) then
                odd = not odd
            end
        end

        j = i
    end

    return odd
end

local function tracepoly(poly)
    local lastVertex
    for i, vertex in pairs(poly) do
        if not lastVertex then
            lastVertex = vertex
            continue
        end

        surface.SetDrawColor(255, 0, 0, 150)
        surface.DrawLine(lastVertex.x, lastVertex.y, vertex.x, vertex.y)
        lastVertex = vertex
    end
end

local function centroid(verts)
    local sumcx = 0
    local sumcy = 0
    local sumac = 0

    for i = 1, #verts - 1 do
        cx = (verts[i].x + verts[i + 1].x) * (verts[i].x * verts[i + 1].y - verts[i + 1].x * verts[i].y)
        cy = (verts[i].y + verts[i + 1].y) * (verts[i].x * verts[i + 1].y - verts[i + 1].x * verts[i].y)
        pa = (verts[i].x * verts[i + 1].y) - (verts[i + 1].x * verts[i].y)
        sumcx = sumcx + cx
        sumcy = sumcy + cy
        sumac = sumac + pa
    end

    local ar = sumac / 2
    return (1 / (6 * ar)) * sumcx, (1 / (6 * ar)) * sumcy
end

local function DrawCircle(centerX, centerY, radius, startDeg, endDeg, segments, color)
    local cir = {}
    
    table.insert(cir, {
        x = centerX,
        y = centerY
    })

    for i = 0, segments do
        local a = math.rad((i / segments) * (endDeg - startDeg) + startDeg)
        table.insert(cir, {
            x = math.sin(a) * radius + centerX,
            y = math.cos(a) * radius + centerY
        })
    end

    surface.SetDrawColor(color.r, color.b, color.g, color.a)
    surface.DrawPoly(cir)
    tracepoly(cir)
    return cir
end

local mainframe
local hovering
local Taunts
local function open(bool)
    Evil.DrawingTauntMenu = bool
    if not bool then
        if mainframe then
            mainframe:Remove() mainframe = nil
        end

        return
    end

    local profile = Game:GetProfileInfo()
    if not profile then return end
    if LocalPlayer():IsBoss() then
        Taunts = profile.taunts
    elseif LocalPlayer():IsProxy() then
        Taunts = profile.proxy.taunts
    end
    if not istable(Taunts) then return end

    local tauntdisplay
    if LocalPlayer():IsBoss() then
        tauntdisplay = profile.tauntdisplay
    elseif LocalPlayer():IsProxy() then
        tauntdisplay = profile.proxy.tauntdisplay
    end

    mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScrH() * 0.9, ScrH() * 0.9)
    mainframe:Center()
    mainframe:SetDraggable(false)
    mainframe:SetTitle("")
    mainframe:ShowCloseButton(false)

    local radius = mainframe:GetWide() / 2 - 10
    local polys = {}
    local numTaunts = #Taunts
    function mainframe:Paint(w, h)
        local frameX, frameY = self:GetPos()
        local mouseX, mouseY = input.GetCursorPos()
        local originX, originY = w / 2, h / 2
        surface.SetDrawColor(0, 0, 0)
        inc = 360 / numTaunts
        local n = 1
        for i = 0, 361 - inc, inc do
            if not polys[n] then polys[n] = {color = Color(0, 0, 0, 200)} end
            local startDeg, endDeg = i, i + inc
            local cir = DrawCircle(originX, originY, radius, startDeg, endDeg, 25, polys[n].color)
            table.insert(cir, cir[1])
            polys[n].circle = cir

            local centX, centY = centroid(polys[n].circle)
            local text
            if istable(tauntdisplay) and tauntdisplay[Taunts[n]] then
                text = tauntdisplay[Taunts[n]]
            else
                text = Taunts[n]
            end
            if text:StartWith("#") then
                text = Lang:Get(text)
            end
            surface.SetFont("ebilfontsmaller")
            local _, height = surface.GetTextSize(text)
            draw.DrawText(text, "ebilfontsmaller", centX, centY - height / 2, color_white, TEXT_ALIGN_CENTER)

            n = n + 1
        end

        local made = false
        for i = 1, n do
            if not polys[i] then continue end
            local tab = polys[i].circle
            local vert = {x = mouseX - frameX, y = mouseY - frameY}
            if InsideConvexPolygon(vert, tab) then 
                polys[i].color = Color(50, 50, 50, 200)
                if not made then
                    hovering = i
                    made = true
                end
            else
                polys[i].color = Color(0, 0, 0, 200)
            end

            if not made then
                hovering = nil
            end
        end
    end

    local text = vgui.Create("DFrame")
    text:SetSize(ScreenScale(250), ScreenScale(20))
    text:SetPos(ScrW() / 2 - text:GetWide() / 2, ((ScrH() / 2 - text:GetTall() / 2) - mainframe:GetTall() / 2) - text:GetTall())
    text:SetDraggable(false)
    text:SetTitle("")
    text:ShowCloseButton(false)

    local firstpos = input.GetCursorPos()
    function text:Paint(w, h)
        if not mainframe then self:Remove() end
        if input.GetCursorPos() == firstpos then
            draw.DrawText("Random Taunt", "evilfont1", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER)
        elseif Taunts[hovering] then
            local text
            if istable(tauntdisplay) and tauntdisplay[Taunts[hovering]] then
                text = tauntdisplay[Taunts[hovering]]
            else
                text = Taunts[hovering]
            end
            if text:StartWith("#") then
                text = Lang:Get(text)
            end
            text = text:Replace("\n", " ")
            draw.SimpleText(text, "evilfont1", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER)
        end
    end
end

local lastDown = false
local lastpos

local function RequestPlayTaunt(taunt)
    dbg.print(taunt)
    Network:RequestTaunt(taunt)
end

hook.Add("Think", "TauntHUD", function()
    if gui.IsConsoleVisible() or gui.IsGameUIVisible() or LocalPlayer():IsTyping() then return end

    if input.IsKeyDown(KEY_R) and not lastDown and (LocalPlayer():IsBoss() or LocalPlayer():IsProxy()) then
        lastDown = true
        
        local profile = Game:GetProfileInfo()
        local taunts
        if LocalPlayer():IsBoss() then
            taunts = profile.taunts
        elseif LocalPlayer():IsProxy() then
            taunts = profile.proxy.taunts
        end

        if not istable(taunts) then return end
        dbg.print(#taunts)
        if #taunts == 1 then
            return Network:RequestTaunt(taunts[1])
        end

        gui.EnableScreenClicker(true)
        lastpos = input.GetCursorPos()
        open(true)
    elseif not input.IsKeyDown(KEY_R) and lastDown then
        if lastpos == input.GetCursorPos() then 
            RequestPlayTaunt("random")
        elseif hovering and istable(Taunts) then
            RequestPlayTaunt(Taunts[hovering])
        end

        open(false)
        gui.EnableScreenClicker(false)
        lastDown = false
    elseif not input.IsKeyDown(KEY_R) then
        lastDown = false
    end
end)
