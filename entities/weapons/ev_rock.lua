AddCSLuaFile()

SWEP.PrintName = "Rock"
SWEP.Purpose = "You can throw it"
SWEP.ViewModel = "models/props_wasteland/rockgranite03b.mdl"
SWEP.WorldModel = "models/props_wasteland/rockgranite03b.mdl"
SWEP.SwayScale = 0
SWEP.Secondary.Automatic = false
SWEP.IsDown = false
SWEP.LastToggle = 0
SWEP.LastBeep = 0

function SWEP:Initialize()
    self:SetHoldType("grenade")
    self:SetModelScale(0.3)
end

function SWEP:CalcViewModelView(vm, oldeyepos, oldeyeang, eyepos, eyeang)
    vm:SetModelScale(0.5)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    if SERVER then
        self:StoneToss()
    end

    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:StoneToss()
    local e = ents.Create("evil_thrown_rock")
    e:SetOwner(self.Owner)
    local eyeang = self.Owner:GetAimVector():Angle()
    local right = eyeang:Right()
    local up = eyeang:Up()
    e:SetPos(self.Owner:GetShootPos() + right * 6 + up * -2)
    e:SetAngles(self.Owner:GetAngles())
    e:SetPhysicsAttacker(self.Owner)
    e:Spawn()

    local phys = e:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocity(self.Owner:GetAimVector() * 1000)
        phys:ApplyForceOffset(e:GetUp() * math.random(-20, -50), e:GetPos() + e:GetRight() * math.random(-5, 5))
    end
end

function SWEP:DrawWorldModel()
    local pos = self:GetPos()
    local ang = self:GetAngles()

    if not IsValid(self.Owner) then
        return self:DrawModel()
    end

    local hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

    if not hand then
        return self:DrawModel()
    end

    local offset = hand.Ang:Right() * -20 + hand.Ang:Forward() * 30 + hand.Ang:Up() * 1
    self:SetRenderOrigin(hand.Pos + offset)

    hand.Ang:RotateAroundAxis(hand.Ang:Right(), 180)
    self:SetRenderAngles(hand.Ang)

    self:DrawModel()
end

function SWEP:GetViewModelPosition(pos, ang)
    ang.p = math.max(ang.p, 0)

    ang:RotateAroundAxis(ang:Right(), -20)
    ang:RotateAroundAxis(ang:Up(), -47)
    ang:RotateAroundAxis(ang:Forward(), 3.5)

    pos = pos + -5 * ang:Right()
    pos = pos + 20 * ang:Forward()
    pos = pos + math.Clamp(-14 + 50 * (CurTime() - self.LastToggle), -14, -7) * ang:Up()

    return pos, ang
end

function SWEP:SecondaryAttack() end
function SWEP:Think() end
