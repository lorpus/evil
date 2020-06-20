Abilities = Abilities or {}

Abilities.Abilities = Abilities.Abilities or {}

function Abilities:HasAbility(ply)
    return Abilities.Abilities[ply:GetNW2String("EvilAbility")] != nil
end
