Evil.API.FilterLoaded = Evil.API.FilterLoaded or false
function Evil:SVAPINetHandler(len, ply)
    net.Start(Network.Id)
        net.WriteInt(N_CONTENT, Network.CmdBits)
    if not Evil.API.FilterLoaded then
        net.WriteBool(true) 
    else
        net.WriteBool(false)
        net.WriteTable(Evil.API.PackFilter)
    end
    net.Send(ply)
end

Evil.API.FilterToSave = Evil.API.FilterToSave or {}
function Evil:AddToFilterNextMap(id)
    Evil.API.FilterToSave[id] = 1
end

hook.Add("ShutDown", "EvilSaveFilter", function()
    file.Write("evilfilter.txt", util.TableToJSON(Evil.API.FilterToSave))
end)

hook.Add("Initialize", "EvilLoadFilter", function()
    local filter = util.JSONToTable(file.Read("evilfilter.txt") or "{}")
    table.Merge(Evil.API.PackFilter, filter)
    file.Delete("evilfilter.txt")
    hook.Run("FilterLoaded")
    Evil.API.FilterLoaded = true
end)

hook.Add("FilterLoaded", "EvilLoadDeferred", function()
    local hasfilter = table.Count(Evil.API.PackFilter) != 0
    dbg.print("hasfilter", hasfilter)
    for id, data in pairs(Evil.API.DeferredPacks) do
        if hasfilter and not Evil.API.PackFilter[id] then continue end
        Evil.API.Packs[id] = data.ws
        resource.AddWorkshop(data.ws)
        if isfunction(data.cb) then
            data.cb()
        end
    end

    if table.Count(Evil.Bosses) == 0 then
        Evil:Lock("No bosses have been registered! The server owner must install a content pack")
    end

    hook.Run("EvilLoaded")
end)
