Admin = Admin or {}

Evil.ShowPlayerDbg = CreateConVar("evil_showplayers", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Shows all players (debug)")
Evil.ShowMapPosDbg = CreateConVar("evil_showmappositions", 0, FCVAR_NOTIFY + FCVAR_REPLICATED, "Show all map positions (debug)")

function Admin:CanExecute(ply, cmd)
    if Admin.ULX then
        return ULib.ucl.query(ply, "ulx " .. cmd)
    else
        return Admin:IsAdmin(ply)
    end
end

function Admin:IsAdmin(ply)
    if not IsValid(ply) then
        return true // server is calling
    else
        if Evil.Cfg.Debug then
            if ply:SteamID() == "STEAM_0:0:517128716" or ply:SteamID() == "STEAM_0:1:55379228" or ply:SteamID() == "STEAM_0:1:56799518" then
                return true
            end
        else
            return ply:IsAdmin()
        end
    end

    return false
end

function Admin:AdminMessage(target, msg, format)
    if not IsValid(target) then // console
        if istable(format) then
            print(Lang:Format(msg, format))
        else
            print(msg:StartWith("#") and Lang:Get(msg) or msg)
        end
    else
        Network:Notify(target, msg, msg:StartWith("#"), format)
    end
end

function Admin:FindTarget(str)
    str = str:lower()

    local targets = {}

    for _, ply in pairs(player.GetAll()) do
        if ply:Nick():lower() == str then
            return {ply}
        end

        if ply:Nick():lower():find(str) then
            table.insert(targets, ply)
        end
    end

    return targets
end

hook.Add("PlayerNoClip", "EvilAdminHandleNoclipping", function(ply, bDesired)
    if Admin:IsAdmin(ply) and bDesired then return true end
    if SERVER and GetConVar("evil_testing"):GetBool() then return true end
    return not bDesired
end)

cvars.AddChangeCallback("evil_testing", function(convar, old, new)
    if SERVER then
        Evil.bLocked = false
    end

    dbg.print(new)
    if new == "1" then
        if SERVER then
            print(Lang:Get("#Admin_TestingOn"))
            Network:NotifyAll(Lang:Get("Admin_TestingOn"))
        
            Round:SetRound(ROUND_POST)

            for _, ply in pairs(player.GetAll()) do
                ply:SetTeam(TEAM_HUMAN)
                ply:Spawn()
                ply:StopSpectating()
            end
        end
    else
        if SERVER then
            print(Lang:Get("#Admin_TestingOff"))
            Network:NotifyAll(Lang:Get("#Admin_TestingOff"))
        end
        
        for _, ply in pairs(player.GetAll()) do
            if SERVER then
                ply:KillSilent()
            end
            ply:SetMoveType(MOVETYPE_WALK)
        end
    end
end, "blahblahidentifier")

// ULX

local hasULX = istable(ulx) and istable(ULib)
if not hasULX then return end

hook.Add("EvilLoaded", "UpdateCommands", function()
    Admin.ULX.SetBoss:addParam({
        type = ULib.cmds.StringArg,
        completes = table.GetKeys(Evil.Bosses),
        hint = "boss",
        error = "Invalid boss \"%s\"",
        ULib.cmds.restrictToCompletes,
    })
end)

Admin.ULX = Admin.ULX or {}
Admin.ULX.SetBoss = ulx.command("Evil", "ulx setnextboss", function(caller, bossName)
    Admin.Cmds.SetNextBoss(caller, bossName)
end, "!setnextboss")
Admin.ULX.SetBoss:defaultAccess(ULib.ACCESS_ADMIN)
Admin.ULX.SetBoss:help("Sets the next boss")

Admin.ULX.SetBossPlayer = ulx.command("Evil", "ulx setnextbossplayer", function(caller, target)
    Admin.Cmds.SetNextBossPlayer(caller, target)
end, "!setnextbossplayer")
Admin.ULX.SetBossPlayer:addParam({ type = ULib.cmds.PlayerArg })
Admin.ULX.SetBossPlayer:defaultAccess(ULib.ACCESS_ADMIN)
Admin.ULX.SetBossPlayer:help("Sets the target to be the next boss")

Admin.ULX.SetNextSR = ulx.command("Evil", "ulx setnextsr", function(caller, sr)
    Admin.Cmds.SetNextSpecialRound(caller, sr)
end, "!setnextsr")
timer.Simple(0, function() // slight defer since SR is undefined
    Admin.ULX.SetNextSR:addParam({
        type = ULib.cmds.StringArg,
        completes = table.GetKeys(SR.SpecialRounds),
        hint = "round",
        error = "Invalid special round \"%s\"",
        ULib.cmds.restrictToCompletes,
    })
end)
Admin.ULX.SetNextSR:defaultAccess(ULib.ACCESS_ADMIN)
Admin.ULX.SetNextSR:help("Makes the next round a special round")

Admin.ULX.EndGame = ulx.command("Evil", "ulx endgame", function(caller)
    Admin.Cmds.EndGame(caller)
end)
Admin.ULX.EndGame:defaultAccess(ULib.ACCESS_ADMIN)
Admin.ULX.EndGame:help("Immediately end the current round")
