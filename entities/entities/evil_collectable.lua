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
    
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Draw()
    if LocalPlayer():IsBoss() or LocalPlayer():IsProxy() then return end // you can still see shadows but whatever
    self:DrawModel()
end

function ENT:Use(ply, caller)
    if self.taken then return end
    
    if ply:GetEyeTrace().Entity != self then return end
    if not ply:IsHuman() then return end
    
    self.taken = true

    hook.Run("EvilCollectableTaken", ply, self:GetNW2String("Collectable"))
    Network:SendHook("EvilCollectableTaken", ply, self:GetNW2String("Collectable"))
    self:Remove()
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

hook.Add("PreDrawHalos", "CollectableHalos", function()
    if LocalPlayer():IsBoss() then return end
    halo.Add(ents.FindByClass("evil_collectable"), Color(20, 20, 128, 50), 1, 1, 1)
end)
