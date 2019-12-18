surface.CreateFont("Arial30", {
    font = "Arial",
    size = ScreenScale(10)
})

surface.CreateFont("Arial14", {
    font = "Arial",
    size = ScreenScale(6)
})

hook.Add("HUDPaint", "SpectatorHUD", function()
    if LocalPlayer():IsSpectating() then
        local text = Lang:Get("#Spec_Spectating")
        if IsValid(LocalPlayer():GetObserverTarget()) then
            text = LocalPlayer():GetObserverTarget():Nick()
        end

        draw.SimpleText(text, "Arial30", ScrW() / 2, ScrH() - 75, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(Lang:Format("#Spec_HUDInfo", { key = input.LookupBinding("+reload"):upper() }), "Arial14", ScrW() / 2, ScrH() - 45, color_white, TEXT_ALIGN_CENTER)
    end
end)
