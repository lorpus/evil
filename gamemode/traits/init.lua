function Traits:AddTrait(ply, trait)
    if not ply.EvilTraits then ply.EvilTraits = {} end
    Network:SendHook("ApplyTrait", ply, trait)
    ply.EvilTraits[trait] = true

    local x = Traits.Traits[trait]
    if isfunction(x.apply) then
        x.apply(ply)
    end
end

function Traits:ClearTraits(ply)
    if not istable(ply.EvilTraits) then return end
    
    for trait, _ in pairs(ply.EvilTraits) do
        local x = Traits.Traits[trait]
        if isfunction(x.remove) then
            x.remove(ply)
        end
    end

    Network:SendHook("RemoveTraits", ply)
    ply.EvilTraits = {}
end
