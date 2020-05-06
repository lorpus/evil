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

hook.Add("HUDPaint", "EvilDrawAbilityBar", function()
    draw.RoundedBox(0, ScrW() - 210, ScrH() - 30, 200 * (LocalPlayer():GetNW2Float("AbilityCharge")), 20, Color(255, 0, 0))
end)
