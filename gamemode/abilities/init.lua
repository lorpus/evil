function Abilities:NetHandler(len, ply)
    local ability = ply:GetNW2String("EvilAbility")
    if ability and Abilities.Abilities[ability] then
        local info = Abilities.Abilities[ability]
        if ply:GetNW2Float("AbilityCharge") < 1 then return end
        info.use(ply)
        Network:SendHook("EvilAbilityUsed", ply, ability)
        ply:SetNW2Float("AbilityCharge", 0)
    end
end

function Abilities:SetPlayerAbility(ply, ability)
    if not Abilities.Abilities[ability] then return end
    ply:SetNW2String("EvilAbility", ability)
end

function Abilities:StripPlayerAbilities(ply)
    ply:SetNW2String("EvilAbility", nil)
end

timer.Create("EvilAbilityCharge", 0.1, 0, function()
    local boss = Game:GetBoss()
    if not Round:IsPlaying() or not IsValid(boss) then return end
    if not boss:GetNW2String("EvilAbility") then return end
    local info = Abilities.Abilities[boss.strEvilAbility]
    
    local cur = boss:GetNW2Float("AbilityCharge")
    if cur >= 1 then return end
    cur = cur + Evil.Cfg.Abilities.ChargeRate + (#Game:GetDead() * Evil.Cfg.Abilities.ChargePerPlayer)
    if cur >= 1 then
        cur = 1
    end
    boss:SetNW2Float("AbilityCharge", cur)
end)
