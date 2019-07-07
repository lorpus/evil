AddCSLuaFile()

local DrawBlockMove = CreateConVar("evil_drawblockmove", 0, FCVAR_REPLICATED, "Draws wireframes for evil_blockmove entities")

DEFINE_BASECLASS("base_anim")

ENT.mins = Vector(-64, -64, -64)
ENT.maxs = Vector( 64,  64,  64)

function ENT:Initialize()
    self.Collide = CreatePhysCollideBox(self.mins, self.maxs)
    self:SetCollisionBounds(self.mins, self.maxs)

    if SERVER then
        self:PhysicsInitBox(self.mins, self.maxs)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end
    else
        self:SetRenderBounds(self.mins, self.maxs)
    end

    self:EnableCustomCollisions(true)
    self:DrawShadow(false)
end

function ENT:TestCollision(start, delta, isbox, extents)
    if not IsValid(self.Collide) then return end

    local max = extents
    local min = -extents

    max.z = max.z - min.z
    min.z = 0

    local hit, normal, fraction = self.Collide:TraceBox(
        self:GetPos(),
        self:GetAngles(),
        start,
        start + delta,
        min,
        max
    )

    if not hit then return end

    return {
        HitPos = hit,
        Normal = normal,
        Fraction = fraction
    }
end

function ENT:Draw()
    if DrawBlockMove:GetBool() then
        render.DrawWireframeBox(self:GetPos(), self:GetAngles(), self.mins, self.maxs, color_white, true)
    end
end
