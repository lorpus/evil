hook.Add("RoundSet", "SpawnCollectables", function(round)
    if round != ROUND_PLAYING then return end
    if not istable(Map.collectables) then return end

    local max = math.ceil(#Map.collectables / 3)
    local i = 0 
    for _, pos in RandomPairs(Map.collectables) do
        i = i + 1
        if i > max then break end
        local info, key = table.Random(Collectable.Collectables)
        local ent = ents.Create("evil_collectable")
        dbg.print(info, key, ent, pos)
        ent:SetModel(info.mdl)
        ent:SetNW2String("Collectable", key)
        ent:SetPos(pos)
        ent:Spawn()
    end
end)
