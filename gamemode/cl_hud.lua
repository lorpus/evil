local OldHealth = 0
local flLastRatio = 0
local HealthMaterial = CreateMaterial("healthmuhterial", "UnlitGeneric", {
    ["$basetexture"] = "detail/metal_detail_01"
})

hook.Add("HUDPaint", "Screen_Attributes", function()
    //if LocalPlayer():IsBoss() then return end
    local nWide, nTall = ScreenScale(110), ScreenScale(50) // n case people deside to change res midgame
    local nScrW, nScrH = ScrW(), ScrH()
    local nRoundness = 0
    local PadX, PadY = 10, 10

    local ColorA = Color(25, 25, 25)
    local StamColorA = Color(255, 255, 255)
    local StamColorB = Color(255, 255, 255, 25)
    local HealthColorA = Color(255, 0, 0)
    local HealthColorB = Color(255, 0, 0, 25)

    local nExtra = 5
    draw.RoundedBox(nRoundness, -nRoundness, (nScrH - nTall) + nRoundness + PadY + nExtra, nWide, (nTall - PadY) - nExtra, ColorA)

    nTall = nTall - 50
    draw.RoundedBox(nRoundness, nWide - (nRoundness * 2), (nScrH - nTall) + nRoundness, (nWide / 2), nTall, ColorA)

    // Health Bar
    local HealthBarW = nWide + (((nWide / 2) - nRoundness * 2) - PadX * 2)
    local MaxHealth = LocalPlayer():GetMaxHealth()

    local Health = LocalPlayer():Health()
    Health = Lerp(0.1, OldHealth, Health)
    OldHealth = Health

    local NewHealthBarW, HealthBarT = (Health / MaxHealth) * HealthBarW, ScreenScale(12.5)
    
    draw.RoundedBox(0, PadX, (nScrH - HealthBarT / 2) - nTall / 2, HealthBarW, HealthBarT, HealthColorB)
    surface.SetDrawColor(HealthColorA)
    surface.SetMaterial(HealthMaterial)
    surface.DrawTexturedRect(PadX, (nScrH - HealthBarT / 2) - nTall / 2, NewHealthBarW, HealthBarT) 

    // Stamina Bar

    local flStamina = LocalPlayer():GetNWFloat("stamina")
    local flMaxStamina = Stamina.maxstamina
    local flRatio = flStamina / flMaxStamina
    local StamBarW, StamBarT = (nWide - (PadX * 2)) - nRoundness, ScreenScale(12.5)

    flRatio = Lerp(0.1, flLastRatio, flRatio)
    flLastRatio = flRatio

    nTall = nTall + 50
    draw.RoundedBox(0, PadX, ((nScrH - StamBarT / 2) - nTall / 2) - PadY, StamBarW, StamBarT, StamColorB)
    draw.RoundedBox(0, PadX, ((nScrH - StamBarT / 2) - nTall / 2) - PadY, flRatio * StamBarW, StamBarT, StamColorA)
end)

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true
}

hook.Add("HUDShouldDraw", "HideDasDefaults", function(n)
	if hide[n] then return false end
end)