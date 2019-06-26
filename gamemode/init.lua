AddCSLuaFile("cl_init.lua")
include("shared.lua")

function Evil:Lock(reason)
    Evil.bLocked = true
    Evil.strLockReason = reason or Lang:Get("#NoReasonGiven")
end

hook.Add("Think", "KickJoinedPlayers", function() // may as well do it here cuz if someone is mid-join they wont get kicked (i dont think)
    if not Evil.bLocked then return end
    
    for _, ply in pairs(player.GetAll()) do
        ply:Kick(Lang:Format("#ServerLocked", { error = Evil.strLockReason }))
    end
end)

hook.Add("CheckPassword", "DontJoinOnLocked", function()
    if Evil.bLocked then
        return false, Lang:Format("#ServerLocked", { error = Evil.strLockReason })
    end
end)
