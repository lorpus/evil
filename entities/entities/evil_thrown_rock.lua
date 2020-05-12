AddCSLuaFile()

ENT.PrintName = "Thrown Rock"
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    self:SetModel("models/props_wasteland/rockgranite03b.mdl")
    self:SetModelScale(0.3)

    local mins, maxs = self:GetCollisionBounds()
    mins = mins * self:GetModelScale()
    maxs = maxs * self:GetModelScale()
    if SERVER then
        self:PhysicsInitBox(mins, maxs)
    end
    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
    self:DrawShadow(false)

    if SERVER then
        self:SetTrigger(true)
    end

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:RockHit(ent)
    if ent:IsPlayer() and ent:IsHuman() then
        local info = DamageInfo()
        info:SetAttacker(self.Owner)
        info:SetInflictor(self)
        info:SetDamage(ent:Health() * 10)
        ent:TakeDamageInfo(info)
    end

    self:Remove()
end

function ENT:Think()
    if self:IsOnGround() or self:GetVelocity():Length2DSqr() < 20 and not self.bHitGround then
        self.bHitGround = true

        if SERVER then
            timer.Simple(10, function()
                SafeRemoveEntityDelayed(self, 2)
                self:SetModelScale(0, 2)
            end)
        end
    end
end

function ENT:Touch(ent)
    if ent == self:GetOwner() then return end
    if ent:IsPlayer() and not ent:Alive() then return end
    if self.bHitGround then return end
    if not ent:IsPlayer() then return end

    self:RockHit(ent)
end
