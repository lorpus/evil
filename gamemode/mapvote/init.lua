MapVote.Roster = MapVote.Roster or {} // maps active in vote, empty meaning no vote active
MapVote.Voters = MapVote.Voters or {} // associate a player with their vote
MapVote.Voted  = MapVote.Voted  or {} // the votes for each map (and extend)

MapVote.RoundProgress = MapVote.RoundProgress or 0

function MapVote:NetHandler(len, ply)
    local vote = net.ReadUInt(3)
    dbg.print(ply:Nick(), vote)
    local filename = MapVote.Roster[vote] // or extend :v
    if not filename then return end
    if MapVote.Voters[ply] then // drop their current vote
        local i = MapVote.Voters[ply]
        MapVote.Voted[i] = MapVote.Voted[i] - 1
    end
    MapVote.Voters[ply] = filename
    MapVote.Voted[filename] = MapVote.Voted[filename] + 1
end

local canceled = false
function MapVote:Cancel()
    if #MapVote.Roster == 0 then return end // none running
    canceled = true
    MapVote.Roster = {}
    MapVote.Voters = {}
    MapVote.Voted  = {}
    net.Start(Network.Id)
        net.WriteInt(N_MAPVOTE, Network.CmdBits)
        net.WriteTable({})
    net.Broadcast()
    Network:NotifyAll("#MapVoteCanceled", true)
end

function MapVote:StartVote()
    if #MapVote.Roster > 0 then
        return Evil.Log("There was an attempt to start a map vote while one is already in progress")
    end

    // dont show maps that will break everything if we switch to em
    local configuredmaps = file.Find(GAMEMODE.FolderName .. "/gamemode/maps/*.lua", "LUA")
    PrintTable(configuredmaps)

    // get maps
    local maps = {}
    if istable(Evil.Cfg.MapVote.Maps) then
        maps = Evil.Cfg.MapVote.Maps
    else
        local files = file.Find("maps/*.bsp", "GAME")
        for _, bsp in pairs(files) do
            local name = bsp:StripExtension()
            if name == game.GetMap() then continue end

            if table.HasValue(configuredmaps, name .. ".lua") then
                if name:StartWith("evil_") or name:StartWith("slender_") then
                    table.insert(maps, name)
                end
            end
        end
    end
    dbg.print("found", #maps, "maps")

    local chosenmaps = {}
    for _, bsp in RandomPairs(maps) do
        table.insert(chosenmaps, bsp)
        if #chosenmaps == 5 then break end
    end

    if #chosenmaps == 0 then return end

    MapVote.Roster = table.Copy(chosenmaps)
    MapVote.Roster[0] = "extend"
    for _, map in pairs(MapVote.Roster) do
        MapVote.Voted[map] = 0
    end


    net.Start(Network.Id)
        net.WriteInt(N_MAPVOTE, Network.CmdBits)
        net.WriteTable(chosenmaps)
    net.Broadcast()

    timer.Simple(Evil.Cfg.MapVote.Time, function()
        if canceled then canceled = false return end
        net.Start(Network.Id)
            net.WriteInt(N_MAPVOTE, Network.CmdBits)
            net.WriteTable({})
        net.Broadcast()
        local winner = "extend" // extend if there are no votes
        local c = 0
        for map, votes in pairs(MapVote.Voted) do
            if votes > c then
                c = votes
                winner = map
            end
        end
        dbg.print(winner)
        if winner == "extend" then
            Network:NotifyAll("#ExtendWon", true)
            MapVote.RoundProgress = 0
        else
            MapVote.NextMap = winner
            Network:SendHook("EvilMapVoteResult", winner)
        end
        MapVote.Roster = {}
        MapVote.Voted = {}
        MapVote.Voters = {}
    end)
end

hook.Add("RoundSet", "EvilCheckMapVote", function(round)
    if Evil.Cfg.MapVote.Disable then return end

    if round == ROUND_POST then
        if MapVote.NextMap then
            timer.Simple(21, function() // let end game hud do its thing
                game.ConsoleCommand("changelevel " .. MapVote.NextMap .. "\n")
            end)
        end
    elseif round == ROUND_PLAYING then
        MapVote.RoundProgress = MapVote.RoundProgress + 1
        if MapVote.RoundProgress >= Evil.Cfg.MapVote.RoundsPerVote then
            timer.Simple(6, function()
                MapVote:StartVote()
            end)
        end
    end
end)
