hook.Add("PlayerSpawn", "staminareset", function(ply)
    ply:SetNW2Float("stamina", Stamina.maxstamina)
end)
