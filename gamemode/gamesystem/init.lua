function Game:SetBoss(pEnt)
    SetGlobalEntity("EvilBoss", pEnt)
end

function Game:SetProfile(strProfile)
    SetGlobalString("EvilProfile", strProfile)
end

function Game:SetupBoss(pEnt)
    local key = table.Random(table.GetKeys(Evil.Bosses))
    local info = Evil.Bosses[key]
    
    Game:SetProfile(key)
    Game:SetBoss(pEnt)
    
    pEnt:SetTeam(TEAM_BOSS)
    pEnt:SetModel(info.model)
    pEnt:SetRunSpeed(info.runspeed)
    pEnt:SetWalkSpeed(info.walkspeed)
    pEnt:Spawn()

    for _, v in pairs(info.weapons) do
        pEnt:Give(v)
    end

    pEnt:Lock()
    timer.Simple(5, function()
        pEnt:UnLock()
    end)
end

function Game:PickAndSetupBoss()
    local ply = table.Random(player.GetAll())
    Game:SetupBoss(ply)
end

function Game:SetupHuman(pEnt)
    pEnt:SetTeam(TEAM_HUMAN)
    pEnt:SetDefaultModel()
    pEnt:Spawn()

    pEnt:Lock()
    timer.Simple(5, function()
        pEnt:UnLock()
    end)
end

function Game:StartGameType(type)

end

function Game:PickAndStartGameType()

end

hook.Add("KeyPress", "bossattack", function(ply, key)
    if ply:Team() == TEAM_BOSS then
        if key == IN_ATTACK2 then
            ply.mouse2down = true
        end 
    end
end)

hook.Add("KeyRelease", "bossattack", function(ply, key)
    if ply:Team() == TEAM_BOSS then
        if key == IN_ATTACK2 then
            ply.mouse2down = false
        end
    end
end)

hook.Add("Think", "bossattack", function()
    /*local boss = Game:GetBoss()
    if IsValid(boss) then
        if boss.mouse2down then
            boss.pentup = boss.pentup + 1
        else
            local x = boss.pentup
            boss.pentup = 0
            if x > 50 then
                boss:SetVelocity(boss:GetAimVector() * x * 10)
            end
        end
    end*/
end)
