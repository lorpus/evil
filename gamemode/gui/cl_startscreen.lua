// rooter = useless
surface.CreateFont("StartFont", {
    font = "Chiller",
    size = ScreenScale(40),
})

surface.CreateFont("StartFontSmall", {
    font = "Chiller",
    size = ScreenScale(20),
})

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

local function RenderBossIntro(centerOffset, alpha)
    local shadowDistance = 5
    local hh = ScrH() / 2 - centerOffset

    draw.SimpleText(Lang:Get("#YouAreTheBoss"),                 "StartFont",        ScrW() / 2 + shadowDistance,    hh + shadowDistance,                    Color(0, 0, 0, 100 * alpha),    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) // shadow
    local _, h1 = draw.SimpleText(Lang:Get("#YouAreTheBoss"),   "StartFont",        ScrW() / 2,                     hh,                                     Color(150, 0, 0, 255 * alpha),  TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    draw.SimpleText(Lang:Get("#FindTheHumans"),                 "StartFontSmall",   ScrW() / 2 + shadowDistance,    hh + h1 * 0.6 + shadowDistance,         Color(0, 0, 0, 100 * alpha),    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local _, h2 = draw.SimpleText(Lang:Get("#FindTheHumans"),   "StartFontSmall",   ScrW() / 2,                     hh + h1 * 0.6,                          Color(150, 0, 0, 255 * alpha),  TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    draw.SimpleText(Lang:Get("#AndKillThem"),                   "StartFontSmall",   ScrW() / 2 + shadowDistance,    hh + h1 * 0.6 + h2 + shadowDistance,    Color(0, 0, 0, 100 * alpha),    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local _, h3 = draw.SimpleText(Lang:Get("#AndKillThem"),     "StartFontSmall",   ScrW() / 2 ,                    hh + h1 * 0.6 + h2,                     Color(150, 0, 0, 255 * alpha),  TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)    

    return (h1 + h2 + h3) * 0.6 * 0.5
end

local function RenderHumanIntro(centerOffset, alpha)
    local shadowDistance = 5
    local hh = ScrH() / 2 - centerOffset

    draw.SimpleText(Lang:Get("#YouAreAHuman"),                          "StartFont",        ScrW() / 2 + shadowDistance,    hh + shadowDistance,                    Color(0, 0, 0, 100 * alpha),    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) // shadow
    local _, h1 = draw.SimpleText(Lang:Get("#YouAreAHuman"),            "StartFont",        ScrW() / 2,                     hh,                                     Color(150, 0, 0, 255 * alpha),  TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local fmt = { count = GetGlobal2Int("PagesTotal") }
    draw.SimpleText(Lang:Format("#CollectAllPages", fmt),                  "StartFontSmall",   ScrW() / 2 + shadowDistance,    hh + h1 * 0.6 + shadowDistance,         Color(0, 0, 0, 100 * alpha),    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local _, h2 = draw.SimpleText(Lang:Format("#CollectAllPages", fmt),    "StartFontSmall",   ScrW() / 2,                     hh + h1 * 0.6,                          Color(150, 0, 0, 255 * alpha),  TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    draw.SimpleText(Lang:Get("#AvoidTheEvil"),                          "StartFontSmall",   ScrW() / 2 + shadowDistance,    hh + h1 * 0.6 + h2 + shadowDistance,    Color(0, 0, 0, 100 * alpha),    TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local _, h3 = draw.SimpleText(Lang:Get("#AvoidTheEvil"),            "StartFontSmall",   ScrW() / 2 ,                    hh + h1 * 0.6 + h2,                     Color(150, 0, 0, 255 * alpha),  TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)    

    return (h1 + h2 + h3) * 0.6 * 0.5
end

local renderedCenter = 0
local alphaFrac = 0
local alphaDir = 1
local showBossIntro = false
local showHumanIntro = false
hook.Add("HUDPaint", "semen", function()
    if showBossIntro or showHumanIntro then
        alphaFrac = alphaFrac + RealFrameTime() / 3 * alphaDir
        if alphaFrac > 1.5 then
            alphaDir = -1.5
        elseif alphaFrac <= 0 then
            alphaDir = 1
            alphaFrac = 0
            if showBossIntro then showBossIntro = false end
            if showHumanIntro then showHumanIntro = false end
        end

        renderedCenter = (showBossIntro and RenderBossIntro or RenderHumanIntro)(renderedCenter, alphaFrac)
    end
end)

hook.Add("RoundSet", "EvilStartIntro", function(round)
    if round != ROUND_PLAYING then return end
    local gt = Game:GetGametype()
    if gt == "pages" then
        if LocalPlayer():IsBoss() then
            showBossIntro = true
            ShowBossInfoPanel()
        elseif LocalPlayer():IsHuman() then
            showHumanIntro = true
        end
    end
end)
