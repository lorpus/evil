surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})


surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(10),
    outline = true
})

local sTitle = Evil.Cfg.MainMenu.TitleText
local sHelp = Evil.Cfg.MainMenu.HelpText


function guitest()
    
    local sw, sh = ScrW(), ScrH()
    frame = vgui.Create("DFrame")
    local overlay = vgui.Create("DPanel", frame)
    local help = vgui.Create("DButton", frame)
    local exit = vgui.Create("DButton", frame)

    frame:SetSize(sw, sh)
    frame:SetDraggable(false)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame.Closing = false

    function frame:Paint(w, h)

        if overlay.ClosingFinished or help.Done then 
            if help.Clicked then
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
                surface.SetFont("ebilfontsmaller")
                local TxtW, TxtH = surface.GetTextSize(sHelp)
                draw.DrawText("NIGGER NGIGER EIGANSDDIGGNASD", "ebilfontsmaller", w / 2, h / 2 - TxtH / 2, color_white, TEXT_ALIGN_CENTER)
            end
            return 
        end

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

    
    help:SetSize(ScreenScale(50), ScreenScale(25))
    local centerX, centerY = ((sw / 2) - (help:GetWide() / 2)), ((sh / 2) - (help:GetTall() / 2))
    help:SetPos(centerX - help:GetWide(), centerY + (sh - sh / 1.5))
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

    exit:SetSize(ScreenScale(50), ScreenScale(25))
    local CenterX, CenterY = ((sw / 2) - (exit:GetWide() / 2)), ((sh / 2) - (exit:GetTall() / 2))
    exit:SetPos(CenterX + exit:GetWide(), CenterY + (sh - sh / 1.5))
    exit:SetText("")
    
    function exit:Paint(w, h)
        if help.Clicked and not help.Done then self:SetVisible(false) end

        local color = ((self:IsHovered() and Color(50, 50, 50)) or Color(0, 0, 0))
        draw.RoundedBox(0, 0, 0, w, h, color)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawOutlinedRect(0, 0, w, h) 
        surface.SetFont("ebilfontsmaller")
        local TxtW, TxtH = surface.GetTextSize("Exit")
        draw.DrawText("Exit", "ebilfontsmaller", w / 2 - TxtW / 2, h / 2 - TxtH / 2, Color(255,255,255,255))
    end

    // das do click functions (better to have them together to understand whats happening)

    function help:DoClick()
        self.Clicked = true
        self.Done = false
        overlay:SetVisible(true)
        self:SetVisible(false)
    end

    function exit:DoClick()
        frame.Closing = true
        overlay:SetVisible(true)
        frame:SetMouseInputEnabled(false)
        frame:SetKeyboardInputEnabled(false)    
        self:Remove()
    end

    overlay:SetSize(sw, sh)
    overlay:SetVisible(false)
    overlay.ClosingFinished = false
    local alpha = 0
    function overlay:Paint(w, h)
        if help.Clicked and not help.Done then
            if alpha == 255 and not self.ClosingFinished then self.ClosingFinished = true end
            if alpha == 0 and self.ClosingFinished then 
                exit:SetPos(CenterX, CenterY + (sh - sh / 1.5)) 
                help.Done = true 
                self.ClosingFinished = false
                exit:SetVisible(true)
                self:SetVisible(false) 
            end

            if self.ClosingFinished then
                alpha = math.Approach(alpha, 0, 0.5)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, alpha))
                return
            end

            alpha = math.Approach(alpha, 255, 0.5)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, alpha))
            return
        end

        if not frame.Closing then return end

        if alpha == 255 and not self.ClosingFinished then self.ClosingFinished = true help.Clicked = false end
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
