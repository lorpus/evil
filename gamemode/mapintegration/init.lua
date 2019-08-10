local collected = 0
// target logic_relay
hook.Add("EvilPageTaken", "EvilTriggerMapOnPage", function(taker, page)
    collected = collected + 1 // the gvar isnt consistent
    local numpage = collected
    local totrigger = ents.FindByName("OnPage" .. tostring(numpage))
    for _, ent in ipairs(totrigger) do
        ent:Fire("Trigger")
    end
end)

hook.Add("RoundSet", "EvilMapResetVars", function(round)
    if round == ROUND_POST then
        collected = 0
    end
end)
