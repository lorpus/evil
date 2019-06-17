local OldHealth = 0
local flLastRatio = 0
local oldAlpha = 0
local HealthMaterial = CreateMaterial("blud", "UnlitGeneric", {
    ["$basetexture"] = "ebil/blood",
    ["$basetexturetransform"] = "scale 2 2"
})


hook.Add("HUDPaint", "Screen_Attributes", function()
    //if LocalPlayer():IsBoss() then return end

    local nWide, nTall = ScreenScale(110), ScreenScale(50) // n case people deside to change res midgame
    local nScrW, nScrH = ScrW(), ScrH()
    
    local nRoundness = 0
    local PadX, PadY = 10, 10
    local nSmallBoxT = nTall / 2

    local ColorA = Color(25, 25, 25)
    local StamColorA = Color(0, 0, 255)
    local StamColorB = Color(50, 50, 255, math.abs(math.sin(CurTime() * 0.7)) * (50 - 25) + 25)
    local HealthColorA = Color(255, 50, 50, math.abs(math.sin(CurTime() * 5)) * (50 - 25) + 25)
    local BarOutlineColor = Color(75, 0, 0)

    // Main Elements
    draw.RoundedBox(nRoundness, -nRoundness, (nScrH - nTall) + nRoundness + PadY, nWide, (nTall - PadY), ColorA)
    draw.RoundedBox(nRoundness, nWide - (nRoundness * 2), ((nScrH - nTall) + nSmallBoxT) + nRoundness, (nWide / 2), nTall - nSmallBoxT, ColorA)

    // Health Bar
    local HealthBarW, HealthBarT = nWide + (((nWide / 2) - nRoundness * 2) - PadX * 2), (nTall - nSmallBoxT) - (PadY * 2)
    local MaxHealth = LocalPlayer():GetMaxHealth()

    local Health = LocalPlayer():Health()
    Health = Lerp(0.1, OldHealth, Health)
    OldHealth = Health
    local NewHealthBarW = (Health / MaxHealth) * HealthBarW
    
    draw.RoundedBox(0, PadX, (nScrH - HealthBarT) - PadX, HealthBarW, HealthBarT, HealthColorA)
    surface.SetDrawColor(BarOutlineColor)
    surface.SetMaterial(HealthMaterial)
    surface.DrawTexturedRectUV(PadX, (nScrH - HealthBarT) - PadX, NewHealthBarW, HealthBarT, 0, 0, NewHealthBarW / ScreenScale(32), HealthBarT / ScreenScale(32))
    surface.DrawOutlinedRect(PadX, (nScrH - HealthBarT) - PadX, HealthBarW, HealthBarT, 0, 0, NewHealthBarW / ScreenScale(32), HealthBarT / ScreenScale(32)) 

    // Stamina Bar

    local flStamina = LocalPlayer():GetNWFloat("stamina")
    local flMaxStamina = Stamina.maxstamina
    local flRatio = flStamina / flMaxStamina
    local StamBarW, StamBarT = (nWide - (PadX * 2)) - nRoundness, (nTall - nSmallBoxT) - (PadY * 2)

    flRatio = Lerp(0.1, flLastRatio, flRatio)
    flLastRatio = flRatio

    draw.RoundedBox(0, PadX, ((nScrH - StamBarT) - nTall / 2), StamBarW, StamBarT, StamColorB)
    draw.RoundedBox(0, PadX, ((nScrH - StamBarT) - nTall / 2), flRatio * StamBarW, StamBarT, StamColorA)
    surface.DrawOutlinedRect(PadX, ((nScrH - StamBarT) - nTall / 2), StamBarW, StamBarT) 
end)

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true
}

hook.Add("HUDShouldDraw", "HideDasDefaults", function(n)
	if hide[n] then return false end
end)