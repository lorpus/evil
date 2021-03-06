Collectable = Collectable or {}

Collectable.Collectables = {
    clock = {
        name = "#Collectable_Clock",
        desc = "#Collectable_Clock_Desc",
        mdl = "models/props_combine/breenclock.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            Network:NotifyAll("#Clock_Collect", true, { name = collector:EvilName() })
            Round:AddTime(60)
        end,
    },

    lantern = {
        name = "#Collectable_Lantern",
        desc = "#Collectable_Lantern_Desc",
        mdl = "models/cof/weapons/lantern/w_lantern.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            collector:Give("ev_lantern")
        end
    },

    /*flaregun = {
        name = "#Collectable_Flare",
        desc = "#Collectable_Flare_Desc",
        mdl = "models/weapons/w_dkflaregun.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            collector:Give("ev_flaregun")
        end,
    },*/

    bible = {
        name = "#Collectable_Bible",
        desc = "#Collectable_Bible_Desc",
        mdl = "models/sharaprops/revolutionary pack/revolutionary_book.mdl",
        op = true,
        oncollect = function(collector)
            if not SERVER then return end
            Network:Notify(collector, "#Bible_Collect", true)
            collector:SetNW2Bool("HasBible", true)
        end,
    },

    nightvison = {
        name = "#Collectable_NightVision",
        desc = "#Collectable_NightVision_Desc",
        mdl = "models/vinrax/props/nvg.mdl",
        oncollect = function(collector)
            if SERVER then
                collector:SetNW2Bool("EvilNightVision", true)
            else
                if collector == LocalPlayer() then
                    surface.PlaySound("evil/items/nvg/on.mp3")
                end
            end
        end,
    },

    soda = {
        name = "#Collectable_Soda",
        desc = "#Collectable_Soda_Desc",
        mdl = "models/props_junk/popcan01a.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            collector:SetLaggedMovementValue(1.25)
            collector:EmitSound("npc/barnacle/barnacle_gulp1.wav")
            timer.Simple(15, function()
                if not IsValid(collector) then return end
                collector:SetLaggedMovementValue(1)
            end)
        end,
    },

    skull = {
        name = "#Collectable_Skull",
        desc = "#Collectable_Skull_Desc",
        mdl = "models/Gibs/HGIBS.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            local dead = {}
            for _, ply in pairs(player.GetAll()) do
                if (not ply:Alive() or ply:IsGhost()) and ply:GetNW2Bool("HasSpawned") then
                    table.insert(dead, ply)
                end
            end
            if #dead == 0 then
                Network:Notify(collector, "#Skull_NoPlayers", true)
            else
                Network:NotifyAll("#Skull_Revive", true, { name = collector:EvilName() })
                local ply = dead[math.random(#dead)]
                Game:ResetPlayer(ply)
                Game:SetupHuman(ply)
            end
        end,

        canuse = function(ent, collector)
            local dead = {}
            for _, ply in pairs(player.GetAll()) do
                if (not ply:Alive() or ply:IsGhost()) and ply:GetNW2Bool("HasSpawned") then
                    table.insert(dead, ply)
                end
            end

            if #dead == 0 then
                Network:Notify(collector, "#Skull_NoPlayers", true)
                return false
            else
                return true
            end
        end,
    },

    pagedetector = {
        name = "#Collectable_PageDetector",
        desc = "#Collectable_PageDetector_Desc",
        mdl = "models/Items/combine_rifle_ammo01.mdl",
        oncollect = function(collector)
            if not SERVER then return end
            collector:Give("ev_radar")
        end,
    },
}

hook.Add("EvilCollectableTaken", "EvilCollectableHandle", function(collector, type)
    local info = Collectable.Collectables[type]
    if not info then return end

    if isfunction(info.oncollect) then
        info.oncollect(collector)
    end
end)
