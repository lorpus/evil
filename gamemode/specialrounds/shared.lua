SR = SR or {}
SR.Chance = 1 / 6
SR.ApplyDelay = 13.67
SR.ActiveRounds = SR.ActiveRounds or {}

SR.SpecialRounds = {
    allalone = {
        name = "#SR_AllAlone",
        description = "#SR_AllAloneDesc",

        pickable = function()
            return #Game:GetHumans() >= 2
        end,

        apply = function()
            if CLIENT then
                hook.Add("Think", "Evil_SRAllAlone", function()
                    if LocalPlayer():Alive() and LocalPlayer():IsHuman() then
                        for _, ply in pairs(player.GetAll()) do
                            ply:SetNoDraw(true)
                        end
                        local t = Game:GetBoss()
                        if IsValid(t) then t:SetNoDraw(false) end
                    else
                        for _, ply in pairs(player.GetAll()) do
                            ply:SetNoDraw(false)
                        end
                    end
                end)
            end
        end,

        remove = function()
            if CLIENT then
                hook.Remove("Think", "Evil_SRAllAlone")
                for _, ply in pairs(player.GetAll()) do
                    ply:SetNoDraw(false)
                end
            end
        end
    },

    nightvision = {
        name = "#SR_NightVision",
        description = "#SR_NightVisionDesc",

        apply = function()
            if SERVER then
                for _, ply in pairs(player.GetAll()) do
                    ply:SetNW2Bool("CanUseEvilFlashlight", false)
                    ply:SetNW2Bool("EvilNightVision", true)
                end
            end
        end,

        remove = function()
            if SERVER then
                for _, ply in pairs(player.GetAll()) do
                    ply:SetNW2Bool("CanUseEvilFlashlight", true)
                    ply:SetNW2Bool("EvilNightVision", false)
                end
            end
        end
    },

    countdown = { // gui/cl_hud.lua
        name = "#SR_Countdown",
        description = "#SR_CountdownDesc"
    },

    realism = {
        name = "#SR_Realism",
        description = "#SR_RealismDesc"
    },

    deadline = {
        name = "#SR_Deadline",
        description = "No time will ever be added to the clock!"
    },

    matrix = {
        name = "#SR_Matrix",
        description = "#SR_MatrixDesc",

        apply = function()
            for _, ent in pairs(ents.FindByClass("evil_page")) do
                ent:SetRenderFX(kRenderFxHologram)
            end
        end
    },

    blind = {
        name = "#SR_Blindness",
        description = "#SR_BlindnessDesc",

        apply = function()
            if not CLIENT then return end
            hook.Add("PreDrawHUD", "Evil_SRBlind", function()
                if not LocalPlayer():Alive() or not LocalPlayer():IsHuman() then return end
                if LocalPlayer():GetNW2Bool("flashlight") and LocalPlayer():GetNW2Bool("CanUseEvilFlashlight") then return end
                cam.Start2D()
                draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
                cam.End2D()
            end)
        end,

        remove = function()
            if not CLIENT then return end
            hook.Remove("PreDrawHUD", "Evil_SRBlind")
        end
    },

    hax = {
        name = "#SR_Wallhacks",
        description = "#SR_WallhacksDesc",

        apply = function()
            if not CLIENT then return end
            hook.Add("PreDrawOutlines", "DrawBossOutline", function()
                eutil.AddOutline(Game:GetBoss(), team.GetColor(TEAM_BOSS), OUTLINE_MODE_BOTH)
            end)
        end,

        remove = function()
            if not CLIENT then return end
            hook.Remove("PreDrawOutlines", "DrawBossOutline")
        end
    },

    earthquake = {
        name = "#SR_Earthquake",
        description = "#SR_EarthquakeDesc",

        apply = function()
            if not CLIENT then return end
            timer.Create("EvilSR_Earthquake", 0.25, 0, function()
                if LocalPlayer():IsBoss() then return end

                local boss = Game:GetBoss()
                if not IsValid(boss) then return end
                local amp = 15 - LocalPlayer():GetPos():Distance(boss:GetPos()) / 150 // i would just go serverside but i dont want boss to shake too
                if amp < 0 then return end
                dbg.print(amp)
                util.ScreenShake(vector_origin, amp, 10, 0.5, 5000)
            end)
        end,

        remove = function()
            if not CLIENT then return end
            timer.Remove("EvilSR_Earthquake")
        end
    },

    deathswap = {
        name = "#SR_DeathSwap",
        description = "#SR_DeathSwapDesc",

        apply = function()
            if not SERVER then return end
            hook.Add("EvilPageTaken", "EvilSR_DeathSwap", function()
                local plys = Game:GetHumans()
                if #plys == 1 then return end
                for _, ply in pairs(Game:GetHumans()) do
                    local target
                    for _, targ in RandomPairs(plys) do
                        if ply != targ then
                            target = targ
                            break
                        end
                    end

                    ply.tmpNewPos = target:GetPos()
                    table.RemoveByValue(plys, target)
                end

                for _, ply in pairs(Game:GetHumans()) do
                    ply:SetPos(ply.tmpNewPos)
                    ply.tmpNewPos = nil
                end
            end)
        end,

        remove = function()
            if not SERVER then return end
            hook.Remove("EvilPageTaken", "EvilSR_DeathSwap")
        end
    }
}
