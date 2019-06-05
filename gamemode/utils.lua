eutil = eutil or {}

function eutil.GetLivingPlayers(enTeam)
    assert(enTeam != nil)

    local oRet = {}
    for k, v in pairs(player.GetAll()) do
        if v:Alive() and v:Team() == enTeam then
            table.insert(oRet, v)
        end
    end

    return oRet
end
