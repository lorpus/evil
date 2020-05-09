hook.Add("EvilAbilityUsed", "EvilHandleAbilityUse", function(ply, ability)
    local info = Abilities.Abilities[ability]
    info.use(ply)
end)

local function callback()
    dbg.print("click")
    net.Start(Network.Id)
        net.WriteInt(N_ABILITY, Network.CmdBits)
    net.SendToServer()
end

local lastDown
hook.Add("Think", "EvilAbilityMousePress", function()
    if input.IsMouseDown(MOUSE_RIGHT) and not lastDown then
        lastDown = true
        callback()
    elseif not input.IsMouseDown(MOUSE_RIGHT) then
        lastDown = false
    end
end)

local abilityRed = Color(255, 0, 0)
local mouse2 = Material("evil/mouse2.png")
hook.Add("HUDPaint", "EvilDrawAbilityBar", function()
    if not LocalPlayer():IsBoss() then return end
    if not Abilities:HasAbility(LocalPlayer()) then return end

    local outerWidth = 20
    local innerWidth = 18
    local x = ScrW() * 0.93
    local y = ScrH() * 0.9
    eutil.DrawCircle(x, y, ScreenScale(outerWidth + (outerWidth - innerWidth)), 0, 360, 18, color_black)
    eutil.DrawCircle(x, y, ScreenScale(outerWidth), 0, 360 * LocalPlayer():GetNW2Float("AbilityCharge"), 18, abilityRed)
    eutil.DrawCircle(x, y, ScreenScale(innerWidth), 0, 360, 18, color_black)

    surface.SetMaterial(mouse2)
    local mw = 40
    local mh = 50
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x - (mw / 2), y - 25, mw, mh)
end)
