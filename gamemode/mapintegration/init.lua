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

hook.Add("InitPostEntity", "EvilMapLoadOverrides", function()
    if not istable(Map) then
        return dbg.print("not loading map overrides because map table missing!")
    end

    if Map.ignore_overrides then
        return dbg.print("not loading map overrides because map config explicitly disables them")
    end

    if istable(Map[1]) then
        return dbg.print("not loading map overrides because map is mulit-config!")
    end

    local pageoverride = ents.FindByName("OverridePage")
    if #pageoverride > 0 then
        dbg.print("page override found")
        table.Empty(Map.pages)
    else
        return
    end

    local singlepages = {}
    local pagegroups  = {}
    local pages = ents.FindByName("Page_*")
    for _, page in pairs(pages) do
        local name = page:GetName()
        if name:lower() == "page" then
            table.insert(singlepages, page)
        else
            local group = name:lower():match("_(%w+)")
            if not pagegroups[group] then pagegroups[group] = {} end
            table.insert(pagegroups[group], page)
        end
    end

    dbg.print("loaded " .. tostring(#singlepages) .. " single page locations")
    dbg.print("loaded " .. tostring(table.Count(pagegroups))  .. " page group locations")

    for _, page in pairs(singlepages) do
        table.insert(Map.pages, {
            pos = page:GetPos(),
            ang = page:GetAngles()
        })
    end

    for _, group in pairs(pagegroups) do
        local ins = {}
        for _, page in pairs(group) do
            table.insert(ins, {
                pos = page:GetPos(),
                ang = page:GetAngles()
            })
        end

        table.insert(Map.pages, ins)
    end
end)