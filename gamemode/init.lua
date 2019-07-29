AddCSLuaFile("cl_init.lua")
include("shared.lua")

hook.Add("Think", "KickJoinedPlayers", function() // may as well do it here cuz if someone is mid-join they wont get kicked (i dont think)
    if not Evil.bLocked then return end
    
    for _, ply in pairs(player.GetAll()) do
        ply:Kick("This server has been locked due to an error: " .. Evil.strLockReason)
    end
end)

hook.Add("CheckPassword", "DontJoinOnLocked", function()
    if Evil.bLocked then
        return false, "This server has been locked due to an error: " .. Evil.strLockReason
    end
end)

function GM:PlayerConnect(name, ip)
    Network:NotifyAll("#Player_Joined", true, { name = name })
end

function GM:PlayerDisconnected(ply)
    Network:NotifyAll("#Player_Left_NoReason", true, { name = ply:Nick() })
end
