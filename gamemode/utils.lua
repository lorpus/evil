eutil = eutil or {}

function eutil.GetLivingPlayers(enTeam)
    local oRet = {}

    for k, v in pairs(player.GetAll()) do
        if v:Alive() and v:Team() == enTeam then
            table.insert(oRet, v)
        end
    end

    return oRet
end

function eutil.Percent(p)
    return math.random() <= p
end
