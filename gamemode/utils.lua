eutil = eutil or {}

function eutil.GetLivingPlayers(enTeam)
    assert(nTeam != nil)

    local nCount = 0
    for k, v in pairs(player.GetAll()) do
        if v:Alive() and v:Team() == enTeam then
            nCount = nCount + 1
        end
    end

    return nCount
end
