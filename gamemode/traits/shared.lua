Traits = Traits or {}

Traits.Traits = {
    flashlightfreeze = {
        // name stuff goes here maybe eventually
    
        think = function(ply)
            if not SERVER then return end
            local freeze
            for _, v in pairs(Game:GetHumans()) do
                if v:GetNW2Bool("flashlight") then
                    if v:EyePos():Distance(ply:EyePos()) > 755 then continue end
                    if not v:IsLineOfSightClear(ply) then continue end

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
    }
}

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
