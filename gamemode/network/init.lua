util.AddNetworkString(Network.Id)

local function StartNotify(str)
    net.Start(Network.Id)
    net.WriteString(str)
end

function Network:Notify(ply, str)
    StartNotify(str)
    net.Send(ply)
end

function Network:NotifyAll(str)
    StartNotify(str)
    net.Broadcast()
end
