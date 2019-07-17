hook.Add("KeyPress", "EvilAbility", function(ply, key)
    if key == IN_ATTACK2 then
        if ply.strEvilAbility then
            local info = Abilities.Abilities[ply.strEvilAbility]
            if not ply.flEvilAbilityLastUse then ply.flEvilAbilityLastUse = 0 end
            if CurTime() - ply.flEvilAbilityLastUse > info.cooldown then
                info.use(ply)
                Network:SendHook("EvilAbilityUsed", ply, ply.strEvilAbility)
                ply.flEvilAbilityLastUse = CurTime()
            else
                Network:Notify(ply, "#AbilityCooldown", true, { time = tostring(math.Round((ply.flEvilAbilityLastUse + info.cooldown) - CurTime(), 1)) })
            end
        end
    end
end)

function Abilities:SetPlayerAbility(ply, ability)
    if not Abilities.Abilities[ability] then return end
    ply.strEvilAbility = ability
end

function Abilities:StripPlayerAbilities(ply)
    ply.strEvilAbility = nil
end
