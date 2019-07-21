surface.CreateFont("evilfont1", {
    font = "Verdana",
    size = ScreenScale(10),
})

surface.CreateFont("evilfont2", {
    font = "Verdana",
    size = ScreenScale(7),
})

local centerText
local centerTextAlpha = 0
local centerTextAlphaDir = 1.5
timer.Create("AlphaTick", 0, 0, function()
    if centerText then
        centerTextAlpha = math.Approach(centerTextAlpha, centerTextAlphaDir * 400, centerTextAlphaDir)
    else
        centerTextAlpha = 0
        centerTextAlphaDir = 1.5
    end
end)
local function Timer()
    local nScrW, nScrH = ScrW(), ScrH()
    local TimerW, TimerT = ScreenScale(60), ScreenScale(15)
    local FontA, FontB = "evilfont2", "evilfont1"
    local ColorA = Color(25, 25, 25)
    
    local nTimerValue = math.floor(Round:GetEndTime() - CurTime())
    local TimerText = string.ToMinutesSeconds(math.floor(nTimerValue))

    if SR.ActiveRounds["countdown"] then return end
    surface.SetFont(FontB)
    local TextW, TextH = surface.GetTextSize(TimerText)
    draw.DrawText(TimerText, FontB, nScrW / 2 - TextW / 2, TimerT / 2 - TextH / 2, Color(219, 255, 201))

    if Game:GetGametype() == "pages" then
        SubText = string.format("%s / %s Collected", GetGlobal2Int("PagesCollected"), GetGlobal2Int("PagesTotal"))
    end

    if centerText then
        dbg.print(centerTextAlpha, centerTextAlphaDir)
        if centerTextAlpha >= 400 then
            centerTextAlphaDir = -2
        elseif centerTextAlpha < 0 then
            centerText = nil
        end

        draw.SimpleText(centerText, FontB, nScrW / 2, nScrH / 3, Color(255, 255, 255, centerTextAlpha), TEXT_ALIGN_CENTER)
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
    
    if LocalPlayer():IsBoss() or LocalPlayer():IsProxy() then
        surface.SetDrawColor(100, 50, 50, 255)
    else
        surface.SetDrawColor(0, 0, 0)
    end
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

hook.Add("RoundSet", "EvilStartInstructions", function(round)
    if round != ROUND_PLAYING then return end
    local gt = Game:GetGametype()
    timer.Simple(1, function() // so in the amount of time it takes a hook to get networked to the client other variables like the players team cant... makes sense
        if gt == "pages" then
            if LocalPlayer():IsHuman() then
                centerText = Lang:Format("#CollectPages", { count = GetGlobal2Int("PagesTotal") })
            elseif LocalPlayer():IsBoss() then
                centerText = Lang:Format("#StopHumansPages", { count = GetGlobal2Int("PagesTotal") })
            end
        end
    end)
end)

function GM:DrawDeathNotice() end
