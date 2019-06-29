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
    sumcx = 0
    sumcy = 0
    sumac = 0

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

local Taunts = {
    "bruh1.mp3",
    "bruh2.mp3",
    "bruh3.wav",
    "bruh4.mp3",
    "bruh5.mp3",
    "bruh6.mp3"
}

local mainframe
local hovering = "Default"
local function open(bool)
    if not bool then mainframe:Remove() mainframe = nil return end
    hovering = "Default"

    mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScreenScale(200), ScreenScale(200))
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
            if not polys[n] then polys[n] = {color = {r = 0, g = 0, b = 0, a = 200}} end
            local startDeg, endDeg = i, i + inc
            local cir = DrawCircle(originX, originY, radius, startDeg, endDeg, 25, polys[n].color)
            table.insert(cir, cir[1])
            polys[n].circle = cir

            local centX, centY = centroid(polys[n].circle)
            draw.SimpleText(Taunts[n], "ebilfontsmaller", centX, centY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            n = n + 1
        end

        for i = 1, n do
            if not polys[i] then continue end
            local tab = polys[i].circle
            local vert = {x = mouseX - frameX, y = mouseY - frameY}
            if InsideConvexPolygon(vert, tab) then 
                polys[i].color = {r = 50, g = 50, b = 50, a = 200}
                hovering = i
            else
                polys[i].color = {r = 0, g = 0, b =  0, a = 200}
            end
        end
    end
end

local testtaunt = CreateClientConVar("evil_testtauntmenu", 0, false)

local lastDown = false
local lastpos

hook.Add("Think", "TauntHUD", function()
    if not testtaunt:GetBool() then return end

    if input.IsKeyDown(KEY_R) and not lastDown then
        gui.EnableScreenClicker(true)
        lastpos = input.GetCursorPos()
        lastDown = true
        open(true)
    elseif not input.IsKeyDown(KEY_R) and lastDown then
        if lastpos == input.GetCursorPos() then 
            print("Default!")
        else
            print(Taunts[hovering])
        end

        open(false)
        gui.EnableScreenClicker(false)
        lastDown = false
    elseif not input.IsKeyDown(KEY_R) then
        lastDown = false
    end
end)
