surface.CreateFont("evilfont1", {
    font = "Verdana",
    size = ScreenScale(10),
})

surface.CreateFont("evilfont2", {
    font = "Verdana",
    size = ScreenScale(7),
})

local function RoundHUD()
    local nScrW, nScrH = ScrW(), ScrH()
    local tall = ScreenScale(15)

    local text = string.ToMinutesSeconds(math.floor(math.floor(Round:GetEndTime() - CurTime())))

    if SR.ActiveRounds["countdown"] then return end
    surface.SetFont("evilfont1")
    local w, h = surface.GetTextSize(text)
    draw.DrawText(text, "evilfont1", ScrW() / 2 - w / 2, tall / 2 - h / 2, Color(219, 255, 201))

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
    local name = ent:EvilName()
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

function GM:DrawDeathNotice() end
function GM:HUDWeaponPickedUp() end
function GM:HUDAmmoPickedUp() end
