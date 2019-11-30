AddCSLuaFile()

ENT.PrintName = "Evil Collectable"
ENT.Author = "lroppalasrpl"
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

if CLIENT then
    surface.CreateFont("CollectablePopup", {
        font = "Verdana",
        size = 300,
    })
end

function ENT:Draw()
    if LocalPlayer():IsBoss() or LocalPlayer():IsProxy() then return end // you can still see shadows but whatever
    self:DrawModel()

    local x = Collectable.Collectables[self:GetNW2String("Collectable")]
    local name = x.name
    local desc = x.desc

    if not name or not desc then return end

    local dist = LocalPlayer():EyePos():Distance(self:GetPos()) * 1.5
    local opacity = 255 - dist
    if opacity <= 0 then return end
    local ang = LocalPlayer():EyeAngles()
    ang.p = 0
    ang.y = ang.y + 270
    ang.r = ang.r + 90

    local pos = self:GetPos()
    local target = pos + Vector(0, 0, 32)
    local tr = util.TraceLine({
        start = pos,
        endpos = target,
        filter = { self },
    })
    cam.Start3D2D(tr.HitPos, ang, 0.01)
        draw.DrawText(Lang:Get(name), "CollectablePopup", 0, 0, Color(255, 255, 255, opacity), TEXT_ALIGN_CENTER)
        draw.DrawText(Lang:Get(desc), "CollectablePopup", 0, 200, Color(255, 255, 255, opacity), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Use(ply, caller)
    if self.taken then return end
    
    if ply:GetEyeTrace().Entity != self then return end
    if not ply:IsHuman() then return end

    local type = self:GetNW2String("Collectable")
    local info = Collectable.Collectables[type]
    if isfunction(info.canuse) then
        if info.canuse(self, ply) == false then
            return
        end
    end

    self.taken = true

    hook.Run("EvilCollectableTaken", ply, type)
    Network:SendHook("EvilCollectableTaken", ply, type)
    self:Remove()
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

hook.Add("PreDrawHalos", "CollectableHalos", function()
    if LocalPlayer():IsBoss() then return end
    halo.Add(ents.FindByClass("evil_collectable"), Color(20, 20, 128, 50), 1, 1, 1)
end)
