local function CheckContent()
    local cid = "eiws" .. game.GetIPAddress()

    local filter = GetConVar("cl_downloadfilter"):GetString()
    if filter == "mapsonly" or filter == "none" then
        if cookie.GetNumber(cid) then return end
        for key, ws in pairs(Evil.API.Packs) do
            if not steamworks.IsSubscribed(ws) then
                Evil:AddTextChat(Lang:Format("#API_ClientMaybeNoContent", { name = key }))
            end
        end
    else
        cookie.Delete(cid)
    end
    cookie.Set(cid, "1")
end

function Evil:CLAPINetHandler()
    local askAgain = net.ReadBool()
    if askAgain then
        dbg.print("askAgain")
        return timer.Simple(1, function()
            net.Start(Network.Id)
                net.WriteInt(N_CONTENT, Network.CmdBits)
            net.SendToServer()
        end)
    else
        Evil.API.PackFilter = net.ReadTable()
        local hasfilter = table.Count(Evil.API.PackFilter) != 0
        dbg.print("hasfilter", hasfilter)
        for id, data in pairs(Evil.API.DeferredPacks) do
            if hasfilter and not Evil.API.PackFilter[id] then continue end
            Evil.API.Packs[id] = data.ws
            if isfunction(data.cb) then
                data.cb()
            end
        end
        CheckContent()
    end
end

hook.Add("InitPostEntity", "EvilGetContent", function()
    net.Start(Network.Id)
        net.WriteInt(N_CONTENT, Network.CmdBits)
    net.SendToServer()
end)
