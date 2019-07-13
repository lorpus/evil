AddCSLuaFile()

ENT.PrintName = "Evil Collectable"
ENT.Author = "lroppalasrpl"
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
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
    if ply:IsBoss() or ply:IsProxy() then return end
    
    self.taken = true

    hook.Run("EvilCollectableTaken", ply, self)
    Network:SendHook("EvilCollectableTaken", ply, self)
    self:Remove()
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end
