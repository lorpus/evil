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
        //dbg.print(centerTextAlpha, centerTextAlphaDir)
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

hook.Add("HUDPaint", "Screen_Attributes", function()
    if not SR.ActiveRounds["realism"] and not Evil.DrawingTauntMenu then
        if Round:IsPlaying() then
            Timer()
        end
    end

    if not LocalPlayer():Alive() then return end
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
    local name = ent:Nick()
    if name == "" then name = ent:Nick() end
    draw.DrawText(name, "evilfont2", ScrW() / 2 - TextW / 2, ScrH() / 2 - TextH / 2 + ScreenScale(15), Color(255, 150, 150))
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

surface.CreateFont("EvilInfoPanelTitle", {
    font = "Chiller",
    size = ScreenScale(12)
})

surface.CreateFont("EvilInfoPanelSub", {
    font = system.IsLinux() and "DejaVu Sans" or "Tahoma",
    size = ScreenScale(7)
})

local DisplayTime = 3
local function ShowBossInfoPanel()
    // because the dmodelpanel wont draw when it's xpos is < 0 cuz of cam.Start3D we gotta do a lot of gay workarounds
    local info = Game:GetProfileInfo()
    local frame = vgui.Create("DFrame")
    // biframe = frame
    
    frame:SetSize(ScreenScale(100), ScrW() / 5)
    frame:SetPos(0, ScrH() / 2 - frame:GetTall() / 2)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame.drawwidth = 0
    
    local movedir = 1.5
    function frame:Think()
        if self.drawwidth >= frame:GetWide() and movedir > 0 then
            movedir = 0 // stop multiple timers
            timer.Simple(DisplayTime, function()
                movedir = -3
            end)

            return
        elseif self.drawwidth < 0 then
            self:Remove()
        end
        self.drawwidth = self.drawwidth + movedir * RealFrameTime() * 50
    end

    local pad = 16
    function frame:Paint(w, h)
        draw.RoundedBoxEx(10, 0, 0, self.drawwidth, h, Color(20, 20, 20), false, true, false, true)
    
        draw.SimpleText(Lang:Format("#YouAreBoss", { name = info.name }), "EvilInfoPanelTitle", self.drawwidth - w / 2, 5, color_white, TEXT_ALIGN_CENTER)
        // draw.SimpleText("Always watching, always lurking. Be mindful, he can be anywhere at anytime.", "EvilInfoPanelSub", self.drawwidth - w / 2, self:GetTall() * 0.75, color_white, TEXT_ALIGN_CENTER)
        if istable(info.weapons) and table.HasValue(info.weapons, "ev_monster_kill") then
            draw.SimpleText(Lang:Get("#HowToAttack_A"), "EvilInfoPanelSub", self.drawwidth - w / 2, self:GetTall() * 0.7 + pad, color_white, TEXT_ALIGN_CENTER)
        end
        local bump = pad * 2
        if info.taunts then
            draw.SimpleText(Lang:Format("#HowToTaunt", { key = (input.LookupBinding("reload") or "R"):upper() }), "EvilInfoPanelSub", self.drawwidth - w / 2, self:GetTall() * 0.7 + bump, color_white, TEXT_ALIGN_CENTER)
            bump = bump + pad
        end
        if info.ability then
            draw.SimpleText(Lang:Get("#HowToAbility"), "EvilInfoPanelSub", self.drawwidth - w / 2, self:GetTall() * 0.7 + bump, color_white, TEXT_ALIGN_CENTER)
            bump = bump + pad
        end
    end

    local model = vgui.Create("DModelPanel", frame)
    model:SetPos(0, 30)
    model:SetSize(frame:GetWide(), frame:GetTall() * 0.6)
    model:SetModel(info.model)
    model:SetFOV(100)
    model.xpos = -100

    local movedirb = 0.7
    function model:Think()
        if self.xpos >= 0 and movedirb > 0 then
            movedirb = 0 // stop multiple timers
            timer.Simple(DisplayTime, function()
                movedirb = -1.3
            end)

            return
        elseif self.xpos < -self:GetWide() then
            self:Remove()
        end
        self.xpos = self.xpos + movedirb * RealFrameTime() * 50

        self.Entity:SetPos(Vector(-self.xpos, self.xpos, -20))
    end
end

hook.Add("RoundSet", "EvilStartInstructions", function(round)
    if round != ROUND_PLAYING then return end
    local gt = Game:GetGametype()
    if gt == "pages" then
        if LocalPlayer():IsHuman() then
            centerText = Lang:Format("#CollectPages", { count = GetGlobal2Int("PagesTotal") })
        elseif LocalPlayer():IsBoss() then
            centerText = Lang:Format("#StopHumansPages", { count = GetGlobal2Int("PagesTotal") })
        end
    end

    if LocalPlayer():IsBoss() then
        ShowBossInfoPanel()
    end
end)

function GM:DrawDeathNotice() end
function GM:HUDWeaponPickedUp() end
function GM:HUDAmmoPickedUp() end
