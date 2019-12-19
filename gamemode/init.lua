AddCSLuaFile("cl_init.lua")
include("shared.lua")

hook.Add("Initialize", "EvilCheckUpdates", function()
    http.Fetch("https://uwu.tokyo/evil/version.json", function(body)
        local js = util.JSONToTable(body)
        local url = js.url
        local nt = js.version:Split(".")
        local ct = (GM and GM or GAMEMODE).Version:Split(".")
        local nmajor, nminor, npatch = tonumber(nt[1]), tonumber(nt[2]), tonumber(nt[3])
        local cmajor, cminor, cpatch = tonumber(ct[1]), tonumber(ct[2]), tonumber(ct[3])

        local u = true
        if nmajor > cmajor then
            Evil.Log(Lang:Format("#MajorUpdateAvailable", { url = url }))
        elseif nminor > cminor then
            Evil.Log(Lang:Format("#MinorUpdateAvailable", { url = url }))
        elseif npatch > cpatch then
            Evil.Log(Lang:Format("#PatchUpdateAvailable", { url = url }))
        else
            u = false
        end

        if u then
            Evil.Log(Lang:Format("#VersionCompare", { cur = (GM and GM or GAMEMODE).Version, new = js.version }))
        else
            Evil.Log(Lang:Get("#UpToDate"))
        end
    end)
end)

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
    Game:ResetPlayer(ply)
end
