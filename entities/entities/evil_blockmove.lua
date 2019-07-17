AddCSLuaFile()

local DrawBlockMove = CreateConVar("evil_drawblockmove", 1, FCVAR_REPLICATED, "Draws wireframes for evil_blockmove entities")

DEFINE_BASECLASS("base_anim")

function ENT:Initialize()
    self.Collide = CreatePhysCollideBox(self:GetMins(), self:GetMaxs())
    self:SetCollisionBounds(self:GetMins(), self:GetMaxs())

    if SERVER then
        self:PhysicsInitBox(self:GetMins(), self:GetMaxs())
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:EnableMotion(false)
        end
    else
        self:SetRenderBounds(self:GetMins(), self:GetMaxs())
    end

    self:EnableCustomCollisions(true)
    self:DrawShadow(false)
end

function ENT:SetupDataTables()
    self:NetworkVar("Vector", 0, "Mins")
    self:NetworkVar("Vector", 1, "Maxs")
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
        local sin = math.abs(math.sin(CurTime())) * 50 + 50
        local top1 = self:GetMins() top1.z = self:GetMaxs().z top1 = top1 + self:GetPos()
        local bottom2 = self:GetMaxs() bottom2.z = 0 bottom2 = bottom2 + self:GetPos()
        local top2 = self:GetMaxs() top2 = top2 + self:GetPos()
        local bottom1 = self:GetMins() bottom1 = bottom1 + self:GetPos()
        local col = Color(sin, 0, 0)
        render.DrawLine(top1, bottom2, col, true)
        render.DrawLine(top2, bottom1, col, true)
        render.DrawWireframeBox(self:GetPos(), self:GetAngles(), self:GetMins(), self:GetMaxs(), Color(sin, 0, 0), true)
    end
end
