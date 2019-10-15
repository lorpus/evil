surface.CreateFont("proxyfont", {
    font = "Verdana",
    size = ScreenScale(7)
})

function Proxy:SendReply(reply)
    net.Start(Network.Id)
        net.WriteInt(N_PROXYASK, Network.CmdBits)
        net.WriteInt(reply, 3)
    net.SendToServer()
end

function Proxy:ShowPrompt()
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScreenScale(80), ScreenScale(35))
    frame:SetPos(0, (ScrH() / 2) - (frame:GetTall() / 2))
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    function frame:Paint(w, h)
        draw.RoundedBoxEx(10, 0, 0, w, h, Color(20, 20, 20), false, true, false, true)
        draw.SimpleText(Lang:Get("#CanBeProxy"), "proxyfont", 5, 12, color_white)
        draw.SimpleText("1. " .. Lang:Get("#Accept"), "proxyfont", 5, 28, color_white)
        draw.SimpleText("2. " .. Lang:Get("#Deny"), "proxyfont", 5, 44, color_white)
        draw.SimpleText("3. " .. Lang:Get("#DontAsk"), "proxyfont", 5, 60, color_white)

        if LocalPlayer():IsTyping() or gui.IsConsoleVisible() or gui.IsGameUIVisible() then return end
        if input.IsKeyDown(KEY_1) then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(1)
            return self:Remove()
        end

        if input.IsKeyDown(KEY_2) then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(0)
            return self:Remove()
        end

        if input.IsKeyDown(KEY_3) then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(-1)
            return self:Remove()
        end

        if not Round:IsPlaying() then
            // self:Remove()
        end
    end

    timer.Simple(15, function()
        if IsValid(frame) and frame:IsVisible() then
            surface.PlaySound("evil/chime_rd_2base_neg.wav")
            Proxy:SendReply(0)
            frame:Remove()
        end
    end)
end

hook.Add("ProxyStart", "EvilProxySystemStart", function(proxy)
    local profile = Game:GetProfileInfo()
    if profile.proxy and isfunction(profile.proxy.start) then
        profile.proxy.start(proxy)
    end
end)

hook.Add("ProxyFinish", "EvilProxySystemFinish", function(proxy)
    local profile = Game:GetProfileInfo()
    if profile.proxy and isfunction(profile.proxy.finish) then
        profile.proxy.finish(proxy)
    end
end)
