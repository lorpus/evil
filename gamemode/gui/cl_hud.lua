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
    local FontA, FontB = "evilfont2", "evilfont1"
    local ColorA = Color(25, 25, 25)
    
    local nTimerValue = math.floor(Round:GetEndTime() - CurTime())
    local TimerText = string.ToMinutesSeconds(math.floor(nTimerValue))

    if not SR.ActiveRounds["countdown"] then
        surface.SetFont(FontB)
        local TextW, TextH = surface.GetTextSize(TimerText)
        draw.DrawText(TimerText, FontB, nScrW / 2 - TextW / 2, TimerT / 2 - TextH / 2, Color(219, 255, 201))
    end

    if Game:GetGametype() == "pages" then
        SubText = string.format("%s / %s Collected", GetGlobal2Int("PagesCollected"), GetGlobal2Int("PagesTotal"))
    end

    if not SubText then return end

    local Awide, Atall = TimerW, TimerT / 2

    surface.SetFont(FontA)
    local TextW, TextH = surface.GetTextSize(SubText)
    draw.DrawText(SubText, FontA, nScrW / 2 - TextW / 2, TimerT + (Atall / 2 - TextH / 2), Color(219, 255, 201))
end

local Old = 0
local StamMaterial = Material("evil/stamina.png")

local function PlayerStats()
    if LocalPlayer():IsBoss() or LocalPlayer():IsProxy() then return end
    if not LocalPlayer():Alive() then return end

    local nScrW, nScrH = ScrW(), ScrH()
    local PadX, PadY = 10, 10
    local Scaled = ScreenScale(48)
    local x, y = 0, nScrH - Scaled

    local fmul = 1 - LocalPlayer():GetNW2Float("stamina") / Stamina.maxstamina

    surface.SetDrawColor(65, 65, 65, 50)
    surface.DrawRect(x, y - (PadY * 2), Scaled + (PadX * 2), Scaled + (PadY * 2))

    surface.SetDrawColor(0, 0, 0)
    surface.DrawOutlinedRect(x, y - (PadY * 2), Scaled + (PadX * 2), Scaled + (PadY * 2))
    
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(StamMaterial)
    surface.DrawTexturedRectUV(x + PadX, nScrH - PadY - Scaled * (1 - fmul), Scaled, Scaled * (1 - fmul), 0, fmul, 1, 1)
end

hook.Add("HUDPaint", "Screen_Attributes", function()
    if not SR.ActiveRounds["realism"] then
        PlayerStats()
        if Round:IsPlaying() then
            Timer()
        end
    end

    if LocalPlayer():Team() == TEAM_SPEC then return end
    local ent = LocalPlayer():GetEyeTrace().Entity
    if not ent:IsPlayer() then return end
    if ent == LocalPlayer() then return end
    if ent:IsBoss() then return end
    if LocalPlayer():IsBoss() then return end

    local pos1 = ent:GetPos()
    local pos2 = LocalPlayer():GetPos()

    if not (pos2:Distance(pos1) < 300) then return end
    surface.SetFont("evilfont2")
    local TextW, TextH = surface.GetTextSize(ent:GetName())
    draw.DrawText(ent:GetName(), "evilfont2", ScrW() / 2 - TextW / 2, ScrH() / 2 - TextH / 2 + ScreenScale(15), Color(255, 150, 150))
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

hook.Add("HUDDrawTargetID", "HidePlayerTarget", function()
    return false
end)