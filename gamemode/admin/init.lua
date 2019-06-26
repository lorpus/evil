Evil.TestingCVar = CreateConVar("evil_testing", 0, FCVAR_CHEAT + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enables testing mode")

concommand.Add("evil_endgame", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        if not Round:End("#Round_EndAdmin") then
            Admin:AdminMessage(ply, "The round could not be ended")
        end
    end
end)

concommand.Add("evil_setnextboss", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        local targets = Admin:FindTarget(argStr)
        if #targets > 1 then
            return Admin:AdminMessage(ply, "Found more than one matching target")
        elseif #targets == 0 then
            return Admin:AdminMessage(ply, "Found no matching targets")
        end

        Evil._NEXTBOSS = targets[1]
        Admin:AdminMessage(ply, "The next boss is now " .. Evil._NEXTBOSS:Nick())
    end
end)
