Evil.TestingCVar = CreateConVar("evil_testing", 0, FCVAR_CHEAT + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enables testing mode")

concommand.Add("evil_endgame", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        if not Round:End("#Round_EndAdmin") then
            Admin:AdminMessage(ply, "#Admin_CantEnd")
        end
    end
end)

concommand.Add("evil_setnextboss", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        local targets = Admin:FindTarget(argStr)
        if #targets > 1 then
            return Admin:AdminMessage(ply, "#Admin_MoreThanOneTarget")
        elseif #targets == 0 then
            return Admin:AdminMessage(ply, "#Admin_NoTargets")
        end

        Evil._NEXTBOSS = targets[1]
        Admin:AdminMessage(ply, "#Admin_NextBoss", { name = Evil._NEXTBOSS:Nick() })
    end
end)
