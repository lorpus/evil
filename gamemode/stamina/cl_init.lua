local StamMaterial = Material("evil/stamina.png")

hook.Add("HUDPaint", "EvilDrawStamina", function()
    if SR.ActiveRounds["realism"] then return end

    if hook.Run("ShouldCheckStamina", LocalPlayer()) == false then return end
    if not LocalPlayer():Alive() then return end

    local nScrW, nScrH = ScrW(), ScrH()
    local PadX, PadY = 10, 10
    local Scaled = ScreenScale(30)
    local x, y = 0, nScrH - Scaled

    local fmul = 1 - LocalPlayer():GetNW2Float("stamina") / Stamina.maxstamina

    surface.SetDrawColor(65, 65, 65, 50)
    surface.DrawRect(x, y - (PadY * 2), Scaled + (PadX * 2), Scaled + (PadY * 2))

    surface.SetDrawColor(0, 0, 0)
    surface.DrawOutlinedRect(x, y - (PadY * 2), Scaled + (PadX * 2), Scaled + (PadY * 2))

    surface.SetMaterial(StamMaterial)
    surface.SetDrawColor(0, 0, 0)
    surface.DrawTexturedRect(x + PadX, nScrH - PadY - Scaled, Scaled, Scaled)
    surface.SetDrawColor(150, 25, 25)
    surface.DrawTexturedRectUV(x + PadX, nScrH - PadY - Scaled * (1 - fmul), Scaled, Scaled * (1 - fmul), 0, fmul, 1, 1)
end)
