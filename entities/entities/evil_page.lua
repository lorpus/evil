AddCSLuaFile()

ENT.PrintName = "Slender Page"
ENT.Author = "Jonascone"
ENT.Type = "anim"
ENT.Base = "base_anim"

util.PrecacheModel("models/slender/sheet.mdl")

function ENT:Initialize()
    if Map.pagemodel then
        self:SetModel(Model(Map.pagemodel))
    else
        self:SetModel(Model("models/slender/sheet.mdl"))
    end

    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
    end
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

local nig = VectorRand()
function ENT:Draw()
    if LocalPlayer():IsBoss() or LocalPlayer():IsProxy() then return end
    // i genuinely dont understand why i need to do this pls find other way (the pages are black, presumably cuz of engine.LightStyle?)
    render.SuppressEngineLighting(true)
    local ang = self:GetAngles()
    local vec = ang:Forward()
    local light = render.ComputeLighting(self:GetPos(), vec) / (Map.ambience and 8 or 1)
    for i = 0, 6 do
        render.SetModelLighting(i, light.x, light.y, light.z)
    end
    self:DrawModel()
    render.SuppressEngineLighting(false)
end

function ENT:Use(ply, caller)
    if self.taken then return end
    
    if ply:GetEyeTrace().Entity != self then return end
    if not ply:IsHuman() then return end
    
    self.taken = true

    ply:EmitSound(Sound(string.format("player/footsteps/gravel%s.wav", math.random(1, 4))), 100, math.random(120, 160))
    hook.Run("EvilPageTaken", ply, self)
    self:Remove()
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

local normCol = Color(20, 128, 20, 50)
local nvCol = Color(255, 20, 20, 255)
hook.Add("PreDrawHalos", "PageHalos", function()
    if LocalPlayer():IsBoss() then return end
    if SR.ActiveRounds["matrix"] then return end
    local c = normCol
    if LocalPlayer():GetNW2Bool("EvilNightVision") then
        c = nvCol
    end
    halo.Add(ents.FindByClass("evil_page"), c, 1, 1, 1)
end)
