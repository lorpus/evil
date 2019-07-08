surface.CreateFont("proxyfont", {
    font = "Verdana",
    size = ScreenScale(7)
})

function Proxy:SendReply(bAccept)
    net.Start(Network.Id)
        net.WriteInt(N_PROXYASK, 4)
        net.WriteBool(bAccept)
    net.SendToServer()
end

function Proxy:ShowPrompt()
    local frame = vgui.Create("DFrame")
    frame:SetSize(180, 260)
    frame:SetPos(0, (ScrH() / 2) - (frame:GetTall() / 2))
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    function frame:Paint(w, h)
        draw.RoundedBoxEx(5, 0, 0, w, h, Color(107, 107, 107, 120), false, true, false, true)
        draw.SimpleText("You may become a proxy", "proxyfont", 5, 10, color_white)
        draw.SimpleText("1. Accept", "proxyfont", 5, 24, color_white)
        draw.SimpleText("2. Deny", "proxyfont", 5, 37, color_white)

        if LocalPlayer():IsTyping() or gui.IsConsoleVisible() or gui.IsGameUIVisible() then return end
        if input.IsKeyDown(KEY_1) then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(true)
            return self:Remove()
        end

        if input.IsKeyDown(KEY_2) then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(false)
            return self:Remove()
        end

        if not Round:IsPlaying() then
            //self:Remove()
        end
    end

    timer.Simple(15, function()
        if IsValid(frame) and frame:IsVisible() then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(false)
            frame:Remove()
        end
    end)
end
