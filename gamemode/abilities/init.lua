function Abilities:NetHandler(len, ply)
    if ply.strEvilAbility then
        local info = Abilities.Abilities[ply.strEvilAbility]
        //if not ply.flEvilAbilityLastUse then ply.flEvilAbilityLastUse = 0 end
        if ply:GetNW2Float("AbilityCharge") < 1 then return end
        info.use(ply)
        Network:SendHook("EvilAbilityUsed", ply, ply.strEvilAbility)
        //ply.flEvilAbilityLastUse = CurTime()
        ply:SetNW2Float("AbilityCharge", 0)
    end
end

function Abilities:SetPlayerAbility(ply, ability)
    if not Abilities.Abilities[ability] then return end
    ply.strEvilAbility = ability
    ply:SetNW2String("EvilAbility", ability)
end

function Abilities:StripPlayerAbilities(ply)
    ply.strEvilAbility = nil
    ply:SetNW2String("EvilAbility", nil)
end

timer.Create("EvilAbilityCharge", 0.1, 0, function()
    local boss = Game:GetBoss()
    if not Round:IsPlaying() or not IsValid(boss) then return end
    if not boss.strEvilAbility then return end
    local info = Abilities.Abilities[boss.strEvilAbility]
    
    local cur = boss:GetNW2Float("AbilityCharge")
    if cur >= 1 then return end
    cur = cur + Evil.Cfg.Abilities.ChargeRate + (#Game:GetDead() * Evil.Cfg.Abilities.ChargePerPlayer)
    if cur >= 1 then
        cur = 1
    end
    boss:SetNW2Float("AbilityCharge", cur)
end)
