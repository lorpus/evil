surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})


surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(10),
    outline = true
})

local sHelp = [[
Placeholder
]]

local sTitle = "Evil"

function guitest()
    
    local sw, sh = ScrW(), ScrH()
    frame = vgui.Create("DFrame")
    local Overlay = vgui.Create("DPanel", frame)

    frame:SetSize(sw, sh)
    frame:SetDraggable(false)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame.Closing = false

    function frame:Paint(w, h)
        if Overlay.ClosingFinished then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))

        // shittitle
        surface.SetFont("ebilfont")
        local TxtW = surface.GetTextSize(sTitle)
        draw.DrawText(sTitle, "ebilfont", w / 2 - TxtW / 2, h / 5, color_white)
        draw.SimpleTextOutlined(sTitle, "ebilfont", w / 2 - TxtW / 2, h / 5, color_white, nil, nil, 2, Color(255, 0, 0, 50))

        // info
        surface.SetFont("ebilfontsmaller")
        local TxtW, TxtH = surface.GetTextSize(sHelp)
        draw.DrawText(sHelp, "ebilfontsmaller", w / 2, h / 2 - TxtH / 2, color_white, TEXT_ALIGN_CENTER)
    end

    local help = vgui.Create("DButton", frame)
    help:SetSize(ScreenScale(50), ScreenScale(25))
    local CenterX, CenterY = ((sw / 2) - (help:GetWide() / 2)), ((sh / 2) - (help:GetTall() / 2))
    help:SetPos(CenterX - help:GetWide(), CenterY + (sh - sh / 1.5))
    help:SetText("")

    function help:Paint(w, h)
        if frame.Closing then self:Remove() end
        local color = ((self:IsHovered() and Color(50, 50, 50)) or Color(0, 0, 0))
        draw.RoundedBox(0, 0, 0, w, h, color)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        surface.SetFont("ebilfontsmaller")
        local TxtW, TxtH = surface.GetTextSize("Help")
        draw.DrawText("Help", "ebilfontsmaller", w / 2 - TxtW / 2, h / 2 - TxtH / 2, Color(255,255,255,255))
    end

    local exit = vgui.Create("DButton", frame)
    exit:SetSize(ScreenScale(50), ScreenScale(25))
    local CenterX, CenterY = ((sw / 2) - (exit:GetWide() / 2)), ((sh / 2) - (exit:GetTall() / 2))
    exit:SetPos(CenterX + exit:GetWide(), CenterY + (sh - sh / 1.5))
    exit:SetText("")
    
    function exit:Paint(w, h)
        if frame.Closing then self:Remove() end
        local color = ((self:IsHovered() and Color(50, 50, 50)) or Color(0, 0, 0))
        draw.RoundedBox(0, 0, 0, w, h, color)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h) 
        surface.SetFont("ebilfontsmaller")
        local TxtW, TxtH = surface.GetTextSize("Exit")
        draw.DrawText("Exit", "ebilfontsmaller", w / 2 - TxtW / 2, h / 2 - TxtH / 2, Color(255,255,255,255))
    end

    function exit:DoClick()
        frame.Closing = true
        Overlay:SetVisible(true)
        frame:SetMouseInputEnabled(false)
        frame:SetKeyboardInputEnabled(false)    
    end

    Overlay:SetSize(sw, sh)
    Overlay:SetVisible(false)
    Overlay.ClosingFinished = false
    local alpha = 0
    function Overlay:Paint(w, h)
        if !frame.Closing then return end
        if alpha == 255 and !self.ClosingFinished then self.ClosingFinished = true end
        if alpha == 0 and self.ClosingFinished then frame:Remove() end

        if self.ClosingFinished then
            alpha = math.Approach(alpha, 0, 0.5)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, alpha))
            return
        end
        alpha = math.Approach(alpha, 255, 0.5)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, alpha))
    end
end

hook.Add("HUDPaint", "OnloadGUIInit", function()
    hook.Remove("HUDPaint", "OnloadGUIInit")
    if frame then frame:Remove() end
    guitest()
end)

concommand.Add("rmtest", function()
    frame:Remove()
end)
