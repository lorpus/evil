AddCSLuaFile()

ENT.PrintName = "Thrown Bottle"
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Threshold = 200

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    self:SetModel("models/nmrih/weapons/exp_molotov/w_exp_molotov.mdl")
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end

    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    if SERVER then
        self:SetTrigger(true)
    end

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableDrag(false)
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
        phys:SetBuoyancyRatio(0)
    end
end

function ENT:Explode(hit)
    if IsValid(hit) and hit:IsPlayer() and hit:IsHuman() then
        hit:Kill()
    end

    if self.IsExplosive then
        local e = ents.Create("env_explosion")
        e:SetPos(self:GetPos())
        e:SetKeyValue("iMagnitude", "0")
        e:Fire("Explode")

        for i = 1, 10 do
            e = ents.Create("env_physexplosion")
            e:SetPos(self:GetPos())
            e:SetKeyValue("magnitude", "100")
            e:SetKeyValue("spawnflags", 3)
            e:Fire("Explode")
            SafeRemoveEntityDelayed(e, 0.3)
        end

        for _, ent in pairs(ents.FindInSphere(self:GetPos(), 200)) do
            if ent:IsPlayer() and ent:IsHuman() then
                if ent:IsLineOfSightClear(self:GetPos() + Vector(0, 0, 10)) then
                    ent:Kill()
                end
            end
        end
    else
        local sounds = {
            "physics/glass/glass_sheet_break1.wav",
            "physics/glass/glass_sheet_break2.wav",
            "physics/glass/glass_sheet_break3.wav"
        }

        self:EmitSound(sounds[math.random(#sounds)], 160)
    end

    self:Remove()
end

function ENT:Think()
    if not SERVER then return end
    if not self.lastvel then
        self.lastvel = self:GetVelocity()
        return
    end

    if self.lastvel:Length() - self:GetVelocity():Length() > self.Threshold then
        dbg.print("explode due to low threshold")
        self:Explode()
    end

    self.lastvel = self:GetVelocity()

    if self:GetVelocity():Length() < 10 then
        self:Explode()
    end
end

function ENT:Touch(ent)
    if ent == self:GetOwner() then return end
    if ent:IsPlayer() and not ent:Alive() then return end

    self:Explode(ent)
end
