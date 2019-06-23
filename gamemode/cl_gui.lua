surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})

surface.CreateFont("endgamebil", {
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
local nFadeSpeed = 6


local function FirstTimeGUI()
    
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
    overlay.alpha = 0

    function overlay:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, self.alpha))
    end

    timer.Create("13/50", 0, 0, function()
        if not overlay:IsVisible() then return end
        local w, h = overlay:GetWide(), overlay:GetTall()
        local alpha = overlay.alpha

        if help.Clicked and not help.Done then
            if alpha == 255 and not overlay.ClosingFinished then overlay.ClosingFinished = true end
            if alpha == 0 and overlay.ClosingFinished then 
                exit:SetPos(CenterX, CenterY + (sh - sh / 1.5)) 
                help.Done = true 
                overlay.ClosingFinished = false
                exit:SetVisible(true)
                overlay:SetVisible(false) 
            end

            if overlay.ClosingFinished then
                overlay.alpha = math.Approach(alpha, 0, nFadeSpeed)
                return
            end

            overlay.alpha = math.Approach(alpha, 255, nFadeSpeed * 2)
            return
        end

        if not frame.Closing then return end

        if alpha == 255 and not overlay.ClosingFinished then overlay.ClosingFinished = true if help.Clicked then help.Clicked = false end end
        if alpha == 0 and overlay.ClosingFinished then timer.Destroy("13/50") frame:Remove() end

        if overlay.ClosingFinished then
            overlay.alpha = math.Approach(alpha, 0, nFadeSpeed)
            return
        end
        overlay.alpha = math.Approach(alpha, 255, nFadeSpeed)
    end)


end

local globalAlpha = 0
local function guitest()
    local ScrW, ScrH = ScrW(), ScrH()
    local PadX, PadY = ScreenScale(5), ScreenScale(5)
    local Players = player.GetAll()
    local curTime = CurTime()

    frame = vgui.Create("DFrame")
    frame:SetSize(ScrW, ScrH)
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:MakePopup()
    frame.fade = false
    frame.opaque = false

    function frame:Paint(w, h)
        frame.opaque = (globalAlpha >= 255)
        if not frame.fade then
            globalAlpha = math.Approach(globalAlpha, 255, nFadeSpeed)
        else
            globalAlpha = math.Approach(globalAlpha, 0, nFadeSpeed)
            if globalAlpha == 0 then self:Remove() end
        end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, globalAlpha))
    end

    local survivors, deaders = {}, {}

    // sorting
    for x, ply in pairs(Players) do
        if ply:Alive() then
            table.insert(survivors, ply)
            continue
        end
        table.insert(deaders, ply)
    end

    local Outline = vgui.Create("DPanel", frame)
    Outline:SetSize(ScrW - (PadX * 2), ScrH - (PadY * 2))
    Outline:SetPos(PadX, PadY)
    Outline.fadeintext = false

    local Main = vgui.Create("DPanel", Outline)
    Main:SetSize(Outline:GetWide() - ScreenScale(12.5), Outline:GetTall() - ScreenScale(100))
    Main:SetPos(ScreenScale(12.5) / 2, ScreenScale(100) - PadY)
    
    function Main:Paint(w, h) 
        //surface.DrawOutlinedRect(0, 0, w, h)
    end

    local AvatarScale = ScreenScale(32)
    local Avatars = {}
    local SetupAvatars = function(tbl)
        if Avatars[1] then
            for  _, panel in pairs(Avatars) do panel:Remove() end
            table.Empty(Avatars)
        end

        for n, ply in pairs(tbl) do
            local AvatarImg = vgui.Create("AvatarImage", Main)
            AvatarImg:SetSize(AvatarScale, AvatarScale)
            AvatarImg:SetPlayer(ply, AvatarScale)
            AvatarImg:SetAlpha(0)
            table.insert(Avatars, AvatarImg)
        end
        return Avatars
    end

    local Arbitrary = "Placeholder"
    local textAlpha = 0
    local flPhase = 0
    local Delay = 2
    local TextFadeDelay = 4
    local MainW, MainH = Main:GetWide(), Main:GetTall()
    local TempVar = 1
    --[[ 
        0/1 = Fade in & Survivors
        2 = Deaders
        3 = Fadeout -- highlights coming soon later in a theater near u
      ]]
    function Outline:Paint(w, h)
        surface.SetDrawColor(75, 75, 75, globalAlpha)
        //surface.DrawOutlinedRect(0, 0, w, h)
        
        if self.fadeintext then
            textAlpha =  math.Approach(textAlpha, 255, TextFadeDelay)
            self.textfadefinished = (textAlpha >= 255)
        else
            textAlpha =  math.Approach(textAlpha, 0, TextFadeDelay)
            self.textfadefinished = (textAlpha <= 0)
        end

        surface.SetFont("endgamebil")
        local TextW, TextH = surface.GetTextSize(Arbitrary)
        draw.DrawText(Arbitrary, "endgamebil", w / 2 - TextW / 2, PadY, Color(255, 255, 255, textAlpha))

        if frame.opaque then
            if ((flPhase == 0 and (CurTime() - curTime > Delay)) or ((flPhase > 1) and (flPhase < 2))) then 
                
                // das setup por phase 1
                if flPhase == 0 then 
                    print("Starting Phase 1")
                    local avatartable = SetupAvatars(survivors) 
                    local total = #avatartable
                    if total == 0 then flPhase = 2 return end

                    Arbitrary = ((total < 10 and "Only " or "") .. total .. " Survived")
                    if total == 0 then Arbitrary = "Nobody Survived" end
                    if total == 1 and #survivors[1]:GetName() <= 12 then Arbitrary = survivors[1]:GetName() .. " was the only survivor" end
                    
                    self.fadeintext = true

                    curTime = CurTime()
                    flPhase = 1.1
                    if total == 0 then flPhase = 1.3 end
                end

                // time to position tha avatars in the right spot
                if flPhase == 1.1 and (CurTime() - curTime > 1) then
                    local MainW, MainH = AvatarScale + PadX, AvatarScale + PadY
                    local maxColumns = math.Round((w - PadX * 16) / MainW)
                    local rowsMax = 1

                    local temp = #Avatars
                    while temp > maxColumns do
                        rowsMax = rowsMax + 1
                        temp = temp - maxColumns
                    end

                    if maxColumns > #Avatars then maxColumns = #Avatars end
                    
                    Main:SetSize((MainW * maxColumns) + PadX, (MainH * rowsMax) + PadY)
                    Main:SetPos(w / 2 - Main:GetWide() / 2, TextH + PadY * 2)
                    
                    local I = 0
                    local x, y = PadX, PadY
                    for _, panel in pairs(Avatars) do
                        
                        panel:SetPos(x, y)
                        I = I + 1
                        
                        x = x + PadX + AvatarScale
                        if I == maxColumns then
                            y = y + panel:GetTall() + PadY
                            x = PadX
                            I = 0
                        end
                    end

                    curTime = CurTime()
                    flPhase = 1.2
                end

                // time to do cool things with the avatars!! - aids
                local AvatarFadeSpeed = 0.1
                if #Avatars >= 10 then AvatarFadeSpeed = 0.4 end
                if #Avatars >= 20 then AvatarFadeSpeed = 0.3 end
                if #Avatars >= 30 then AvatarFadeSpeed = 0.2 end
                if #Avatars >= 40 then AvatarFadeSpeed = 0.1 end
                if flPhase == 1.2 and (CurTime() - curTime > AvatarFadeSpeed) then
                    for n, panel in pairs(Avatars) do
                        if TempVar != n then continue end
                        curTime = CurTime()
                        panel.myturn = true
                    end
                    TempVar = TempVar + 1
                end

                if flPhase == 1.2 then
                    for n, panel in pairs(Avatars) do
                        if panel.myturn then
                            panel:SetAlpha(math.Approach(panel:GetAlpha(), 255, 2))
                        end
                        if n == #Avatars and panel:GetAlpha() == 255 then
                            flPhase = 1.3
                            TempVar = 1
                        end
                    end
                end

                if flPhase == 1.3 and CurTime() - curTime > 5 then
                    self.fadeintext = false
                    for n, panel in pairs(Avatars) do
                        panel:SetAlpha(math.Approach(panel:GetAlpha(), 0, 2))
                        if n == #Avatars and panel:GetAlpha() == 0 then
                            flPhase = 2
                            curTime = CurTime()
                        end
                    end
                    if #Avatars == 0 then
                        flPhase = 1.4
                        curTime = CurTime()
                    end
                end

                if flPhase == 1.4 and CurTime() - curTime > 0.1 then
                    if #Avatars == 0 and self.textfadefinished then flPhase = 2 curTime = CurTime() end
                end
            end

            if ((flPhase == 2 and (CurTime() - curTime > Delay)) or ((flPhase > 2) and (flPhase < 3))) then 
                
                // das setup por phase 1
                if flPhase == 2 then 
                    print("Starting Phase 2")
                    local total = #SetupAvatars(deaders) 
                    
                    Arbitrary = ((total == 0 and "Nobody Died") or (total == #player.GetAll() and "Everyone Died") or ((total == 1 and survivors[1]:GetName()) or (total < 10 and "Only " or "") .. total .. " Died"))
                    self.fadeintext = true

                    curTime = CurTime()
                    flPhase = 2.1
                    if total == 0 then flPhase = 2.3 end
                end

                // time to position tha avatars in the right spot
                if flPhase == 2.1 and (CurTime() - curTime > 1) then
                    local MainW, MainH = AvatarScale + PadX, AvatarScale + PadY
                    local maxColumns = math.Round((w - PadX * 16) / MainW)
                    local rowsMax = 1

                    local temp = #Avatars
                    while temp > maxColumns do
                        rowsMax = rowsMax + 1
                        temp = temp - maxColumns
                    end

                    if maxColumns > #Avatars then maxColumns = #Avatars end
                    
                    Main:SetSize((MainW * maxColumns) + PadX, (MainH * rowsMax) + PadY)
                    Main:SetPos(w / 2 - Main:GetWide() / 2, TextH + PadY * 2)
                    
                    local I = 0
                    local x, y = PadX, PadY
                    for _, panel in pairs(Avatars) do
                        
                        panel:SetPos(x, y)
                        I = I + 1
                        
                        x = x + PadX + AvatarScale
                        if I == maxColumns then
                            y = y + panel:GetTall() + PadY
                            x = PadX
                            I = 0
                        end
                    end

                    curTime = CurTime()
                    flPhase = 2.2
                end

                // time to do cool things with the avatars!! - aids
                local AvatarFadeSpeed = 0.1
                if #Avatars >= 10 then AvatarFadeSpeed = 0.4 end
                if #Avatars >= 20 then AvatarFadeSpeed = 0.3 end
                if #Avatars >= 30 then AvatarFadeSpeed = 0.2 end
                if #Avatars >= 40 then AvatarFadeSpeed = 0.1 end
                if flPhase == 2.2 and (CurTime() - curTime > AvatarFadeSpeed) then
                    for n, panel in pairs(Avatars) do
                        if TempVar != n then continue end
                        curTime = CurTime()
                        panel.myturn = true
                    end
                    TempVar = TempVar + 1
                end

                if flPhase == 2.2 then
                    for n, panel in pairs(Avatars) do
                        if panel.myturn then
                            panel:SetAlpha(math.Approach(panel:GetAlpha(), 255, 2))
                        end
                        if n == #Avatars and panel:GetAlpha() == 255 then
                            flPhase = 2.3
                            TempVar = 1
                        end
                    end
                end

                if flPhase == 2.3 and CurTime() - curTime > 5 then
                    self.fadeintext = false
                    for n, panel in pairs(Avatars) do
                        panel:SetAlpha(math.Approach(panel:GetAlpha(), 0, 2))
                        if n == #Avatars and panel:GetAlpha() == 0 then
                            flPhase = 3
                            curTime = CurTime()
                        end
                    end
                    if #Avatars == 0 then
                        flPhase = 2.4
                        curTime = CurTime()
                    end
                end

                if flPhase == 2.4 and CurTime() - curTime > 0.1 then
                    if #Avatars == 0 and self.textfadefinished then flPhase = 3 curTime = CurTime() end
                end
            end

            if ((flPhase == 3 and (CurTime() - curTime > Delay)) or ((flPhase > 3) and (flPhase < 4))) then
                frame.fade = true
            end

        end
    end
end

hook.Add("HUDPaint", "OnloadGUIInit", function()
    hook.Remove("HUDPaint", "OnloadGUIInit")
    if frame then frame:Remove() end
    //FirstTimeGUI()
end)

concommand.Add("runtestgui", function()
    if frame then frame:Remove() end
    guitest()
end)