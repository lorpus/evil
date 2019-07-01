SR = SR or {}
SR.Chance = 1 / 6
SR.ApplyDelay = 13.67
SR.ActiveRounds = SR.ActiveRounds or {}

SR.SpecialRounds = {
    allalone = {
        name = "All Alone",
        description = "Where are your fellow humans?",

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
        name = "Night Vision",
        description = "No more flashlight, goggles only!",

        apply = function()
            if SERVER then
                for _, ply in pairs(player.GetAll()) do
                    ply:SetNW2Bool("CanUseEvilFlashlight", false)
                end
                return
            end
            hook.Add("Think", "Evil_SRNightVision", function()
                if not LocalPlayer():Alive() or not LocalPlayer():IsHuman() then return end
                local light = DynamicLight(129)
                light.r = 0
                light.g = 50
                light.b = 0
                light.pos = LocalPlayer():GetPos()
                light.brightness = 5
                light.size = 1e5
                light.dietime = CurTime() + 1
            end)
        end,

        remove = function()
            if SERVER then
                for _, ply in pairs(player.GetAll()) do
                    ply:SetNW2Bool("CanUseEvilFlashlight", true)
                end
                return
            end
            hook.Remove("Think", "Evil_SRNightVision")
        end
    },

    countdown = { // gui/cl_hud.lua
        name = "Countdown",
        description = "Your timer seems to be missing!"
    },

    realism = {
        name = "Realism",
        description = "Full realism! Say bye to your HUD!"
    },

    deadline = {
        name = "Deadline",
        description = "No time will ever be added to the clock!"
    },

    matrix = {
        name = "The Matrix",
        description = "Pages will only materialize when you are within their range",

        apply = function()
            for _, ent in pairs(ents.FindByClass("evil_page")) do
                ent:SetRenderFX(kRenderFxHologram)
            end
        end
    },

    blind = {
        name = "Blindness",
        description = "You cannot see anything unless your flashlight is on!",

        apply = function()
            if not CLIENT then return end
            hook.Add("PreDrawHUD", "Evil_SRBlind", function()
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
    }
}
