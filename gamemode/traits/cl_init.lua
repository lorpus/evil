hook.Add("ApplyTrait", "EvilClientTrait", function(ply, trait)
    if not ply.EvilTraits then ply.EvilTraits = {} end
    ply.EvilTraits[trait] = true
    if isfunction(Traits.Traits[trait].apply) then
        Traits.Traits[trait].apply(ply)
    end
end)

hook.Add("RemoveTraits", "EvilClientTrait", function(ply)
    if not istable(ply.EvilTraits) then return end
    
    for trait, _ in pairs(ply.EvilTraits) do
        local x = Traits.Traits[trait]
        if isfunction(x.remove) then
            x.remove(ply)
        end
    end

    ply.EvilTraits = {}
end)
