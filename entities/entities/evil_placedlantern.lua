AddCSLuaFile()

ENT.PrintName = "Evil Lantern"
ENT.Author = "lroppalasrpl"
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
    self:SetModel("models/cof/weapons/lantern/w_lantern.mdl")
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
    self:DrawModel()

    if LocalPlayer():IsBoss() then
        local opacity = 255 - LocalPlayer():EyePos():Distance(self:GetPos())
        local ang = (LocalPlayer():EyePos() - self:GetPos()):Angle()
        ang.p = 0
        ang.y = ang.y + 90
        ang.r = ang.r + 45 // homosexuality
        cam.Start3D2D(self:GetPos() + Vector(0, 0, 32), ang, 0.2)
            draw.DrawText(Lang:Format("#Lantern_Destroy", { button = input.LookupBinding("use"):upper() }), "Default", 0, 0, Color(255, 255, 255, opacity), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

function ENT:Use(ply, caller)
    if self.taken then return end

    if ply:GetEyeTrace().Entity != self then return end
    if ply:IsBoss() then
        self.taken = true

        local dat = EffectData()
        dat:SetOrigin(self:GetPos())
        util.Effect("ManhackSparks", dat, true, true)
        self:EmitSound("ambient/energy/zap1.wav")
        self:Remove()
    elseif ply:IsHuman() then
        self.taken = true

        ply:Give("ev_lantern")
        self:Remove()
    end
end

function ENT:Think()
    if not CLIENT then return end

    self.light = DynamicLight(self:EntIndex())
    self.light.r = 200
    self.light.g = 200
    self.light.b = 200
    self.light.brightness = 5
    self.light.decay = 1e100
    self.light.size = 400
    self.light.DieTime = CurTime() + 1
    self.light.pos = self:GetPos() + Vector(0, 0, 2)

    /*if not self.projlower or not self.projupper then
        self.projlower = ProjectedTexture() // these can only be 180deg so we need two
        self.projupper = ProjectedTexture()

        self.projlower:SetTexture("effects/flashlight/soft")
        self.projlower:SetAngles(Angle(-90, 0, 0))
        self.projlower:SetFarZ(Evil.Cfg.Flashlight.FlashlightDistance / 2)
        self.projlower:SetFOV(179)
        self.projlower:SetPos(self:GetPos() + Vector(0, 0, 32))
        self.projlower:SetNearZ(1)
        self.projlower:Update()

        self.projupper:SetTexture("effects/flashlight/soft")
        self.projupper:SetAngles(Angle(90, 0, 0))
        self.projupper:SetFarZ(Evil.Cfg.Flashlight.FlashlightDistance / 2)
        self.projupper:SetFOV(179)
        self.projupper:SetPos(self:GetPos() + Vector(0, 0, 32))
        self.projupper:SetNearZ(1)
        self.projupper:Update()
        return
    end

    self.projupper:SetFOV(120)
    self.projupper:SetFarZ(Evil.Cfg.Flashlight.FlashlightDistance)
    self.projlower:SetFOV(1)

    local tr = util.TraceLine({
        start = self:GetPos() + Vector(0, 0, 20),
        endpos = self:GetPos() + Vector(0, 0, 200)
    })

    local pos = tr.HitPos
    if not tr.Hit then pos = self:GetPos() + Vector(0, 0, 200) end

    self.projlower:SetPos(self:GetPos() + Vector(0, 0, 100))
    self.projlower:SetNearZ(1)
    self.projlower:Update()
    
    self.projupper:SetPos(pos) // slightly offset because of a gap in the fov
    self.projupper:SetNearZ(1)
    self.projupper:Update()*/
end

function ENT:OnRemove()
    if not CLIENT then return end
    /*self.projlower:Remove()
    self.projupper:Remove()*/
end

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end
