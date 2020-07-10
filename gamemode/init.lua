AddCSLuaFile("cl_init.lua")
include("shared.lua")

hook.Add("Think", "EvilCheckUpdates", function()
    hook.Remove("Think", "EvilCheckUpdates")
    http.Fetch("https://uwu.tokyo/evil/version.json", function(body)
        local js = util.JSONToTable(body)
        local note = js.note or ""
        local nt = js.version:Split(".")
        local ct = (GM and GM or GAMEMODE).Version:Split(".")
        local nmajor, nminor, npatch = tonumber(nt[1]), tonumber(nt[2]), tonumber(nt[3])
        local cmajor, cminor, cpatch = tonumber(ct[1]), tonumber(ct[2]), tonumber(ct[3])

        local u
        local f
        if nmajor > cmajor then
            f = "#MajorUpdateAvailable"
        elseif nminor > cminor then
            f = "#MinorUpdateAvailable"
        elseif npatch > cpatch then
            f = "#PatchUpdateAvailable"
        end
        if f then u = Lang:Format(f, { note = note }) end

        if u then
            timer.Create("EvilUpdateNotification", 600, 0, function()
                Network:NotifyAll(f, true, { note = "" })
            end)
            Evil.Log(u)
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

hook.Add("EntityEmitSound", "EvilNoBubbles", function(data)
    if data.OriginalSoundName == "Player.DrownStart" then
        return false
    end
end)
