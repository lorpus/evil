Evil.TestingCVar = CreateConVar("evil_testing", 0, FCVAR_CHEAT + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enables testing mode")

concommand.Add("evil_endgame", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        if not Round:End("#Round_EndAdmin") then
            Admin:AdminMessage(ply, "#Admin_CantEnd")
        end
    end
end)

concommand.Add("evil_setnextboss", function(ply, cmd, args, argStr)
    if not Admin:IsAdmin(ply) then return end

    if #argStr == 0 then
        return Admin:AdminMessage(ply, "#Admin_BossChoices", { bosslist = table.concat(table.GetKeys(Evil.Bosses), ", ") })
    else
        if Evil.Bosses[argStr] then
            Evil._NEXTBOSS = argStr
            return Admin:AdminMessage(ply, "#Admin_NextBoss", { boss = Evil.Bosses[argStr].name })
        else
            return Admin:AdminMessage(ply, "#Admin_BossChoices", { bosslist = table.concat(table.GetKeys(Evil.Bosses), ", ") })
        end
    end
end)

concommand.Add("evil_setnextbossplayer", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        local targets = Admin:FindTarget(argStr)
        if #targets > 1 then
            return Admin:AdminMessage(ply, "#Admin_MoreThanOneTarget")
        elseif #targets == 0 then
            return Admin:AdminMessage(ply, "#Admin_NoTargets")
        end

        Evil._NEXTBOSSPLAYER = targets[1]
        Admin:AdminMessage(ply, "#Admin_NextBossPlayer", { name = Evil._NEXTBOSSPLAYER:Nick() })
    end
end)
