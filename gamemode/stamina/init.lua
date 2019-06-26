hook.Add("PlayerSpawn", "staminareset", function(ply)
    ply:SetNW2Float("stamina", Stamina.maxstamina)
end)

local function moving(ply)
    return  ply:KeyDown(IN_FORWARD) or
            ply:KeyDown(IN_BACK) or
            ply:KeyDown(IN_MOVELEFT) or
            ply:KeyDown(IN_MOVERIGHT)
end
