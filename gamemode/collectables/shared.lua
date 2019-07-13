Collectable = Collectable or {}

Collectable.Collectables = {
    clock = {
        mdl = "models/props_combine/breenclock.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            Network:NotifyAll("#Clock_Collect", true, { name = collector:Nick() })
            Round:AddTime(60)
        end,
    },

    skull = {
        mdl = "models/Gibs/HGIBS.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            local dead = {}
            for _, ply in pairs(player.GetAll()) do
                if not ply:Alive() and ply:GetNW2Bool("HasSpawned") then
                    table.insert(dead, ply)
                end
            end
            if #dead == 0 then
                Network:Notify(collector, "#Skull_NoPlayers", true)
            else
                Network:NotifyAll("#Skull_Revive", true, { name = collector:Nick() })
                local ply = dead[math.random(#dead)]
                Game:ResetPlayer(ply)
                Game:SetupHuman(ply)
            end
        end,
    }
}

hook.Add("EvilCollectableTaken", "EvilCollectableHandle", function(collector, ent)
    local info = Collectable.Collectables[ent:GetNW2String("Collectable")]
    if not info then return end

    if isfunction(info.oncollect) then
        info.oncollect(collector)
    end
end)
