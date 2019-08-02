hook.Add("RoundSet", "SpawnCollectables", function(round)
    if round != ROUND_PLAYING then return end
    if not istable(Map.collectables) then return end

    local op        = {}
    local normal    = {}

    for name, info in pairs(Collectable.Collectables) do
        if info.op then
            op[name] = info
        else
            normal[name] = info
        end
    end

    if table.Count(op) > 0 and istable(Map.collectables.op) then
        for i = 1, eutil.PRNS(Evil.Cfg.Collectables.Odds.OP) do
            local info, key = table.Random(op)
            local pos  = Map.collectables.op[math.random(#Map.collectables.op)]
            local ent = ents.Create("evil_collectable")
            dbg.print(info, key, ent, pos)
            ent:SetModel(info.mdl)
            ent:SetCollectable(key)
            ent:SetPos(pos)
            ent:Spawn()
        end
    end

    if table.Count(normal) > 0 and istable(Map.collectables.normal) then
        local t = math.ceil(eutil.PRNS(Evil.Cfg.Collectables.Odds.Normal) * #Map.collectables.normal)
        dbg.print("normal", t)
        for i = 1, t do
            local info, key = table.Random(normal)
            local pos = Map.collectables.normal[math.random(#Map.collectables.normal)]
            local ent = ents.Create("evil_collectable")
            dbg.print(info, key, ent, pos)
            ent:SetModel(info.mdl)
            ent:SetNW2String("Collectable", key)
            ent:SetPos(pos)
            ent:Spawn()
        end
    end
end)
