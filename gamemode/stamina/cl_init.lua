// placeholder
local flLastRatio = 0
hook.Add("HUDPaint", "stamina hud", function()
    local flStamina = LocalPlayer():GetNWFloat("stamina")
    local flMaxStamina = Stamina.maxstamina
    local flRatio = flStamina / flMaxStamina

    flRatio = Lerp(0.1, flLastRatio, flRatio)
    flLastRatio = flRatio

    draw.RoundedBox(0, 35, ScrH() * 0.85, ScrW() * 0.1 * flRatio, 30, color_white)
end)
