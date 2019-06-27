Admin = Admin or {}

Evil.ShowPlayerDbg = CreateConVar("evil_showplayers", 0, FCVAR_CHEAT + FCVAR_NOTIFY + FCVAR_REPLICATED, "Shows all players (debug)")

function Admin:IsAdmin(ply)
    if not IsValid(ply) then
        return true // server is calling
    else
        if ply:SteamID() == "STEAM_0:1:55379228" or ply:SteamID() == "STEAM_0:1:56799518" then
            return true
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
        Network:Notify(target, msg, istable(format), format)
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

    print(new)
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
