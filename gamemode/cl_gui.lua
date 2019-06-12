surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})

surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(20)
})

function guitest()
    if true then return end

    local flTime = CurTime()

    frame = vgui.Create("DFrame")
    frame:SetPos(0, 0)
    frame:SetSize(ScrW(), ScrH())
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    
    local flAlpha = 0
    local iYOffset = 0
    surface.SetFont("ebilfont")
    local _, iTextH = surface.GetTextSize("Ebil")
    local iYOffsetTarget = -ScrH() / 2 + iTextH * 2
    function frame:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
        flAlpha = math.Approach(flAlpha, 255, 0.5)
        if flAlpha > 125 then
            iYOffset = math.Approach(iYOffset, iYOffsetTarget, 1)
        end
        draw.SimpleText("Ebil", "ebilfont", w / 2, h / 2 + iYOffset, Color(255, 255, 255, flAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local text = [[This is some test text
Kowalski, analysis
aabccacxb
123
===============
]]
        local totest = ""
        for k, v in pairs(string.Explode("\n", text)) do
            if string.len(v) > string.len(totest) then
                totest = v
            end 
        end

        local iTextWide, iTextTall = surface.GetTextSize(totest)
        if iYOffset == iYOffsetTarget then
            draw.DrawText(text, "ebilfontsmaller", frame:GetWide() / 2 - iTextWide / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    local buttonStart = vgui.Create("DButton", frame)
    buttonStart:SetText("start")
    buttonStart:SetFont("ebilfontsmaller")
    surface.SetFont(buttonStart:GetFont())
    local iTextWide, iTextTall = surface.GetTextSize(buttonStart:GetText())
    buttonStart:SetPos(frame:GetWide() / 4 - iTextWide / 2, frame:GetTall() / 2)
    buttonStart:SetTextColor(color_transparent)
    buttonStart:SizeToContents()

    local buttonHelp = vgui.Create("DButton", frame)
    buttonHelp:SetText("send help")
    buttonHelp:SetFont("ebilfontsmaller")
    surface.SetFont(buttonHelp:GetFont())
    iTextWide, iTextTall = surface.GetTextSize(buttonHelp:GetText())
    buttonHelp:SetPos(frame:GetWide() - frame:GetWide() / 4 - iTextWide / 2, frame:GetTall() / 2)
    buttonHelp:SetTextColor(color_transparent)
    buttonHelp:SizeToContents()

    local flButtonAlpha = 0
    function buttonStart:Paint(w, h)
        if iYOffset == iYOffsetTarget then
           flButtonAlpha = math.Approach(flButtonAlpha, 255, 1)
           if flButtonAlpha > 125 then
                frame:MakePopup()
           end
        else
            return
        end

        if self:IsHovered() then
            self:SetTextColor(Color(255, 255, 255, flButtonAlpha))
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, flButtonAlpha))
        else
            self:SetTextColor(Color(0, 0, 0, flButtonAlpha))
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, flButtonAlpha))
        end
    end

    function buttonHelp:Paint(w, h)
        if self:IsHovered() then
            self:SetTextColor(Color(255, 255, 255, flButtonAlpha))
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, flButtonAlpha))
        else
            self:SetTextColor(Color(0, 0, 0, flButtonAlpha))
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, flButtonAlpha))
        end
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
