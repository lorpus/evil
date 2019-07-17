hook.Add("EvilAbilityUsed", "EvilHandleAbilityUse", function(ply, ability)
    local info = Abilities.Abilities[ability]
    info.use(ply)
end)
