Traits = Traits or {}

Traits.Traits = {
    flashlightfreeze = {
        // name stuff goes here maybe eventually

        think = function(ply)
            if not SERVER then return end
            local freeze
            for _, v in pairs(Game:GetHumans()) do
                if v:GetNW2Bool("flashlight") then
                    if v:EyePos():Distance(ply:GetPos()) > 1500 then continue end
                    local tr = util.TraceLine({
                        start = v:EyePos(),
                        endpos = ply:EyePos(),
                        filter = { v, ply }
                    })

                    if tr.Hit then continue end

                    local p = -(v:GetAimVector():Dot((v:EyePos() - ply:EyePos()):GetNormalized()))
                    if p > 0.9 then
                        freeze = true
                        break
                    end
                end
            end

            if freeze and not ply:IsFrozen() then
                dbg.print("lock")
                ply:Lock()
            elseif not freeze and ply:IsFrozen() then
                dbg.print("unlock")
                ply:UnLock()
            end
        end,

        remove = function(ply)
            if not SERVER then return end
            ply:UnLock()
        end
    },

    lookfreeze = {
        think = function(ply)
            if not SERVER then return end
            local freeze
            for _, v in pairs(Game:GetHumans()) do
                if v:GetNW2Bool("AbilityBlinded") then continue end
                if v:EyePos():Distance(ply:GetPos()) > 1500 then continue end
                if v:GetNW2Bool("EvilIsBlinking") then continue end
                local tr = util.TraceLine({
                    start = v:EyePos(),
                    endpos = ply:EyePos(),
                    filter = { v, ply }
                })

                if tr.Hit then continue end

                local p = -(v:GetAimVector():Dot((v:EyePos() - ply:EyePos()):GetNormalized()))
                local frac = 1.215 - 0.0095 * ply:GetFOV()
                if p > frac then
                    freeze = true
                    break
                end
            end

            if freeze and not ply:IsFrozen() then
                dbg.print("lock")
                ply:Lock()
            elseif not freeze and ply:IsFrozen() then
                dbg.print("unlock")
                ply:UnLock()
            end
        end,

        remove = function(ply)
            if not SERVER then return end
            ply:UnLock()
        end,
    },

    digestion = {
        apply = function(ply)
            if not SERVER then return end
            hook.Add("EvilPlayerKilled", "EvilTraitDigest_" .. tostring(ply), function(victim, killerteam, killer)
                if killer == ply then
                    killer:EmitSound("npc/stalker/breathing3.wav")
                    ply:SetLaggedMovementValue(0)
                    timer.Create(ply:SteamID64() .. "_EvilTraitDigest", 5, 1, function()
                        if IsValid(ply) then
                            ply:SetLaggedMovementValue(1)
                        end
                    end)
                end
            end)
        end,

        remove = function(ply)
            if not SERVER then return end
            hook.Remove("EvilPlayerKilled", "EvilTraitDigest_" .. tostring(ply))
        end,
    },

    onlyforwardmove = {
        apply = function(ply)
            if CLIENT and ply != LocalPlayer() then return end
            hook.Add("StartCommand", "TraitOFM_" .. tostring(ply), function(p2, cmd)
                if ply != p2 then return end
                cmd:SetButtons(bit.band(cmd:GetButtons(), bit.bnot(bit.bor(IN_MOVELEFT, IN_MOVERIGHT, IN_BACK))))
                cmd:SetSideMove(0)
                cmd:SetForwardMove(math.max(0, cmd:GetForwardMove()))
            end)
        end,

        remove = function(ply)
            if CLIENT and ply != LocalPlayer() then return end
            hook.Remove("StartCommand", "TraitOFM_" .. tostring(ply))
        end,
    },
}

function Traits:HasTrait(ply, trait)
    local tab = ply.EvilTraits
    if not istable(ply.EvilTraits) then return false end
    return ply.EvilTraits[trait] != nil
end

hook.Add("Think", "TraitThink", function()
    for _, ply in pairs(player.GetAll()) do
        if not istable(ply.EvilTraits) then continue end
        for trait, _ in pairs(ply.EvilTraits) do
            if isfunction(Traits.Traits[trait].think) then
                Traits.Traits[trait].think(ply)
            end
        end
    end
end)
