Abilities = Abilities or {}

Abilities.Abilities = {
    teleport = {
        name = "#Teleport",
        description = "#TeleportDesc",

        cooldown = 30,

        use = function(ply)
            if SERVER then
                local spawns = Map.spawns.humans
                local spawn = spawns[math.random(#spawns)]
                ply:SetPos(spawn.pos)
                if spawn.ang then
                    ply:SetEyeAngles(spawn.ang)
                end
            else
                surface.PlaySound("plats/elevbell1.wav")
            end
        end
    },

    adrenalinerush = {
        name = "#Adrenaline",
        description = "#AdrenalineDesc",

        cooldown = 30,

        use = function(ply)
            if not SERVER then return end
            ply:SetLaggedMovementValue(2)
            timer.Simple(5, function() // there cant possibly be anything wrong with this ffs
                ply:SetLaggedMovementValue(1)
            end)
        end,
    },

    blinder = {
        name = "#Blinder",
        description = "#BlinderDesc",

        cooldown = 30,

        use = function(ply)
            if CLIENT then
                if not LocalPlayer():IsHuman() then return end
                if LocalPlayer():GetPos():Distance(ply:GetPos()) > 1500 then return end
                hook.Add("PreDrawHUD", "EvilAbilityBlinder", function()
                    if not LocalPlayer():Alive() or not LocalPlayer():IsHuman() then return end
                    cam.Start2D()
                    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
                    cam.End2D()
                end)

                timer.Simple(10, function()
                    hook.Remove("PreDrawHUD", "EvilAbilityBlinder")
                end)
            else
                for _, v in pairs(Game:GetHumans()) do
                    if v:GetPos():Distance(ply:GetPos()) < 1500 then
                        v:SetNW2Bool("AbilityBlinded", true)
                        timer.Simple(10, function()
                            if IsValid(v) then
                                v:SetNW2Bool("AbilityBlinded", false)
                            end
                        end)
                    end
                end
            end
        end,
    },

    linklight = {
        name = "#LinkLight",
        description = "#LinkLightDesc",

        cooldown = 60,

        use = function(ply)
            if SERVER then
                for _, ply in pairs(Game:GetHumans()) do
                    FizzlePlayerFlashlight(ply)
                end

                ply:SetNW2Bool("EvilAbilityLinkESP", true)
                timer.Simple(5, function()
                    if IsValid(ply) then
                        ply:SetNW2Bool("EvilAbilityLinkESP", false)
                    end
                end)
            else
                surface.PlaySound("evil/link/laugh2.mp3")
            end
        end,
    },

    scp096burst = {
        name = "#SCP096Burst",
        description = "#SCP096BurstDesc",

        cooldown = 60,

        use = function(ply)
            if not SERVER then return end
            ply:EmitSound("npc/stalker/go_alert2a.wav", 160)
            ply:SetNW2Bool("NoForceSpeeds", true)
            local rs = ply:GetRunSpeed()
            local ws = ply:GetWalkSpeed()
            ply:SetRunSpeed(rs * 2)
            ply:SetWalkSpeed(ws * 2)
            timer.Simple(3, function()
                if IsValid(ply) then
                    ply:SetRunSpeed(rs)
                    ply:SetWalkSpeed(ws)
                    ply:SetNW2Bool("NoForceSpeed", false)
                end
            end)
        end,
    },

    explosivebottle = {
        name = "#ExplosiveBottle",
        description = "#ExplosiveBottleDesc",

        cooldown = 30,

        use = function(ply)
            if not SERVER then return end
            local sounds = {
                "vo/ravenholm/madlaugh01.wav",
                "vo/ravenholm/madlaugh02.wav",
                "vo/ravenholm/madlaugh03.wav",
                "vo/ravenholm/madlaugh04.wav",
            }

            local wep = ply:GetActiveWeapon()
            if not IsValid(wep) then return end

            wep.ShouldThrowExplosive = true
            ply:EmitSound(sounds[math.random(#sounds)])
            Network:Notify(ply, "#NextBottleExplosive", true)
        end,
    },
}

hook.Add("CanSeePlayerESP", "EvilAbilityLinkESP", function(viewer, viewed)
    local a
    if SERVER then
        a = viewer.strEvilAbility
    else
        a = viewer:GetNW2String("EvilAbility")
    end
    if a == "linklight" and viewer:GetNW2Bool("EvilAbilityLinkESP") then
        return true
    end
end)
