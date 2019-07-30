surface.CreateFont("srfont", {
    font = "Verdana",
    size = ScreenScale(14)
})

local ShowDelay = 1.25

local function DisplayCycleReal(rightDisplay)
    local roundcount = Round:GetRoundCount()
    dbg.print(roundcount, Round:GetRound())
    local todisplay = {}
    for k, v in pairs(SR.SpecialRounds) do
        local name, desc = v.name, v.description
        if name:StartWith("#") then name = Lang:Get(name) end
        if desc:StartWith("#") then desc = Lang:Get(desc) end
        table.insert(todisplay, name:upper() .. " - " .. desc)
    end

    local cycle = true
    hook.Add("HUDPaint", "DrawSpecialRoundCycle", function()
        if roundcount != Round:GetRoundCount() or not Round:IsPlaying() then
            return hook.Remove("HUDPaint", "DrawSpecialRoundCycle")
        end
        local displayThing
        if cycle then
            displayThing = todisplay[math.floor(CurTime() * 10 % #todisplay) + 1]
        else
            local x = SR.SpecialRounds[rightDisplay]
            local name, desc = x.name, x.description
            if name:StartWith("#") then name = Lang:Get(name) end
            if desc:StartWith("#") then desc = Lang:Get(desc) end
            displayThing = name:upper() .. " - " .. desc
        end
        draw.SimpleText(displayThing, "srfont", ScrW() / 2, 50, color_white, TEXT_ALIGN_CENTER)
    end)

    timer.Simple(SR.ApplyDelay - ShowDelay, function()
        cycle = false
        if roundcount != Round:GetRoundCount() or not Round:IsPlaying() then return end
        timer.Simple(5, function()
            if roundcount != Round:GetRoundCount() or not Round:IsPlaying() then return end
            hook.Remove("HUDPaint", "DrawSpecialRoundCycle")
        end)
    end)
end

local function DisplayCycle(rightDisplay)
    timer.Simple(ShowDelay, function() DisplayCycleReal(rightDisplay) end)
end

hook.Add("StartSRCycle", "ShowTheSpinnerHereProbably", function(key)
    dbg.print("special round cycle starting")
    surface.PlaySound("evil/itemtime.mp3")
    DisplayCycle(key)
    timer.Simple(SR.ApplyDelay, function()
        surface.PlaySound("evil/eshop2.mp3")
    end)
end)

hook.Add("ApplySR", "ApplyTheDamnThing", function(key)
    dbg.print(key)
    SR.ActiveRounds[key] = true
    local t = SR.SpecialRounds[key]
    if isfunction(t.apply) then
        t.apply()
    end
end)

hook.Add("RemoveSR", "GetRidOfTheDanThing", function(key)
    dbg.print("bye " .. key)
    SR.ActiveRounds[key] = nil
    local t = SR.SpecialRounds[key]
    if isfunction(t.remove) then
        t.remove()
    end
end)
