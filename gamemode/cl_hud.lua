surface.CreateFont("evilfont1", {
    font = "Verdana",
    size = ScreenScale(10),
})

surface.CreateFont("evilfont2", {
    font = "Verdana",
    size = ScreenScale(7),
})

local function Timer()
    local nScrW, nScrH = ScrW(), ScrH()
    local TimerW, TimerT = ScreenScale(60), ScreenScale(15)
    local ArbritratyText = nil
    local FontA, FontB = "evilfont2", "evilfont1"
    local ColorA = Color(25, 25, 25)
    
    local nTimerValue = math.floor(Round:GetEndTime() - CurTime())
    local TimerText = "Timer: " .. string.ToMinutesSeconds(math.floor(nTimerValue))

    surface.SetFont(FontB)
    local TextW, TextH = surface.GetTextSize(TimerText)
    draw.DrawText(TimerText, FontB, nScrW / 2 - TextW / 2, TimerT / 2 - TextH / 2, Color(219, 255, 201))

    if not ArbritratyText then return end

    local Awide, Atall = TimerW, TimerT / 2

    surface.SetFont(FontA)
    local TextW, TextH = surface.GetTextSize(ArbritratyText)
    draw.DrawText(ArbritratyText, FontA, nScrW / 2 - TextW / 2, TimerT + (Atall / 2 - TextH / 2), Color(255,255,255,255))

end

local Old = 0
local StamMaterial = Material("ebil/stamina.png")

local function PlayerStats()

    if LocalPlayer():IsBoss() then return end

    local nScrW, nScrH = ScrW(), ScrH()
    local PadX, PadY = 10, 10
    local Scaled = ScreenScale(48)
    local x, y = 0, nScrH - Scaled

    local ColorA = {25, 25, 25, 120}
    local ColorB = {0, 0, 0}

    local fmul = 1 - LocalPlayer():GetNWFloat("stamina") / Stamina.maxstamina

    surface.SetDrawColor(unpack(ColorA))
    surface.DrawRect(x, y - (PadY * 2), Scaled + (PadX * 2), Scaled + (PadY * 2))

    surface.SetDrawColor(unpack(ColorB))
    surface.DrawOutlinedRect(x, y - (PadY * 2), Scaled + (PadX * 2), Scaled + (PadY * 2))
    
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(StamMaterial)
    surface.DrawTexturedRectUV(x + PadX, nScrH - PadY - Scaled * (1 - fmul), Scaled, Scaled * (1 - fmul), 0, fmul, 1, 1)

end

hook.Add("HUDPaint", "Screen_Attributes", function()
    PlayerStats()
    Timer()
end)

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

hook.Add("HUDShouldDraw", "HideDasDefaults", function(n)
	if hide[n] then return false end
end)
