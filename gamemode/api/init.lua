API.RegisteredBosses = API.RegisteredBosses or {}

function Evil:SVAPINetHandler(len, ply)
    local bfiles = {}
    local pfiles = {}
    for k, v in pairs(API.RegisteredBosses) do
        table.insert(bfiles, k .. ".lua")
        if v._Proxy then
            table.insert(pfiles, v._Proxy .. ".lua")
        end
    end
    net.Start(Network.Id)
        net.WriteInt(N_CONTENT, Network.CmdBits)
        net.WriteTable(bfiles)
        net.WriteTable(pfiles)
    net.Send(ply)
end

function API:LoadAllBosses()
    local f, _ = file.Find("evil/bosses/*.lua", "LUA")
    for _, filename in ipairs(f) do
        API:LoadBoss(filename)
        AddCSLuaFile("evil/bosses/" .. filename)
    end

    f, _ = file.Find("evil/proxies/*.lua", "LUA")
    for _, filename in ipairs(f) do
        API:LoadProxy(filename)
        AddCSLuaFile("evil/proxies/" .. filename)
    end
end

function API:ChoosePack()
    return nil
end

local function DoLoad()
    API.RegisteredBosses = {}
    API.Bosses = {}
    Evil.Bosses = {}
    API:LoadAllBosses()
    dbg.print(table.Count(API.Bosses) .. " total bosses found")
    local pack = API:ChoosePack()
    if pack then
        
    else
        dbg.print("No pack chosen, falling back to " .. Evil.Cfg.Bosses.FallbackCount .. " max random bosses")
        local i = 1
        for k, v in RandomPairs(API.Bosses) do
            if i > Evil.Cfg.Bosses.FallbackCount then
                break
            end
            API.RegisteredBosses[k] = v
            i = i + 1
        end
    end

    dbg.print("Using: " .. table.concat(table.GetKeys(API.RegisteredBosses), ", "))

    for k, v in pairs(API.RegisteredBosses) do
        API:RegisterBoss(k, v)
        if Evil.Cfg.DownloadMethod == "workshop" or not Evil.Cfg.DownloadMethod then
            if v._WSID then
                resource.AddWorkshop(v._WSID)
            else
                Evil.Log("Warning: Boss profile " .. k .. " doesn't have an assigned Workshop ID!")
            end
        elseif Evil.Cfg.DownloadMethod == "fastdl" then
            for _, res in ipairs(v._Resources) do
                resource.AddFile(res)
            end
        end
    end
    API:SharedLoad()
end

hook.Add("EvilPreLoad", "EvilLoadBosses", function()
    DoLoad()
end)

concommand.Add("evil_force_reload", function(ply)
    if not IsValid(ply) then
        DoLoad()
        Evil.Log("Warning: This command will only reload server-side")
    end
end)
