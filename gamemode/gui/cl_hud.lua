surface.CreateFont("evilfont1", {
    font = "Verdana",
    size = ScreenScale(10),
})

surface.CreateFont("evilfont2", {
    font = "Verdana",
    size = ScreenScale(7),
})

local centerPng
local matcache = {}
local centerAlpha = 0
local centerAlphaDir = 1.5

local function RoundHUD()
    local nScrW, nScrH = ScrW(), ScrH()
    local tall = ScreenScale(15)

    local text = string.ToMinutesSeconds(math.floor(math.floor(Round:GetEndTime() - CurTime())))

    if SR.ActiveRounds["countdown"] then return end
    surface.SetFont("evilfont1")
    local w, h = surface.GetTextSize(text)
    draw.DrawText(text, "evilfont1", ScrW() / 2 - w / 2, tall / 2 - h / 2, Color(219, 255, 201))

    if centerPng then
        centerAlpha = math.Approach(centerAlpha, centerAlphaDir * 26667 * RealFrameTime(), centerAlphaDir)

        if centerAlpha >= 400 then
            centerAlphaDir = -2
        elseif centerAlpha < 0 then
            centerPng = nil
            return
        end
        
        if not matcache[centerPng] then
            matcache[centerPng] = Material(centerPng, "smooth")
        end
        surface.SetMaterial(matcache[centerPng])
        surface.SetDrawColor(255, 255, 255, centerAlpha)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    else
        centerAlpha = 0
        centerAlphaDir = 1.5
    end

    local subtext
    if Game:GetGametype() == "pages" then
        subtext = string.format("%s / %s " .. Lang:Get("#Collected"), GetGlobal2Int("PagesCollected"), GetGlobal2Int("PagesTotal"))
    end
    if not subtext then return end

    surface.SetFont("evilfont2")
    local w, h = surface.GetTextSize(subtext)
    draw.DrawText(subtext, "evilfont2", ScrW() / 2 - w / 2, tall + (tall / 4 - h / 2), Color(219, 255, 201))
end

Evil.ShowTips = CreateClientConVar("evil_showtips", "1", true, false, "Show tips in the bottom left when dead")

surface.CreateFont("TipFont", {
    font = "Roboto",
    size = ScreenScale(9)
})

hook.Add("HUDPaint", "DrawTips", function()
    if not Evil.ShowTips:GetBool() then return end

    local tips = {}
    for k, _ in pairs(Lang:GetTable()) do
        if k:StartWith("#Tip_") then
            table.insert(tips, k)
        end
    end

    if not LocalPlayer():Alive() then
        local i = util.SharedRandom(math.floor(SysTime() / 15), 1, #tips, math.floor(SysTime() / 300))
        i = math.floor(i)
        local text = Lang:Format("#Tip", { tip = Lang:Get(tips[i]) })
        surface.SetFont("TipFont")
        local w, h = surface.GetTextSize(text)
        surface.SetTextPos(10, ScrH() - h)
        surface.SetTextColor(255, 255, 255)
        surface.DrawText(text)
    end
end)

hook.Add("HUDPaint", "EvilScreenStuff", function()
    if not SR.ActiveRounds["realism"] and not Evil.DrawingTauntMenu then
        if Round:IsPlaying() then
            RoundHUD()
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
    local name = ent:GetNW2String("ClassName")
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
    print(LocalPlayer():IsBoss())
    if gt == "pages" then
        if LocalPlayer():IsHuman() then
            centerPng = "evil/evil.png"
        elseif LocalPlayer():IsBoss() then
            centerPng = "evil/evil_monster.png"
        end
    end

    if LocalPlayer():IsBoss() then
        ShowBossInfoPanel()
    end
end)

function GM:DrawDeathNotice() end
function GM:HUDWeaponPickedUp() end
function GM:HUDAmmoPickedUp() end
