function Evil:CLAPINetHandler()
    local bossFiles = net.ReadTable()
    local proxyFiles = net.ReadTable()
    for _, filename in ipairs(bossFiles) do
        API:LoadBoss(filename)
    end

    for _, filename in ipairs(proxyFiles) do
        API:LoadProxy(filename)
    end

    // client only gets registered bosses so register them all
    for profile, info in pairs(API.Bosses) do
        API:RegisterBoss(profile, info)
    end

    API:SharedLoad()
end

local initpostentity = false // hack for lua refresh
hook.Add("InitPostEntity", "EvilGetProfiles", function()
    net.Start(Network.Id)
        net.WriteInt(N_CONTENT, Network.CmdBits)
    net.SendToServer()
    initpostentity = true
end)

if initpostentity then
    net.Start(Network.Id)
        net.WriteInt(N_CONTENT, Network.CmdBits)
    net.SendToServer()
end
