AddCSLuaFile()

SWEP.Author         = "lorp"
SWEP.Purpose        = "Lob this bottle into the back of the bourgeoise's heads"
SWEP.Instructions   = "click"
SWEP.PrintName      = "ACME Bottle"
SWEP.ViewModel      = "models/nmrih/weapons/exp_molotov/v_exp_molotov.mdl"
SWEP.WorldModel     = "models/nmrih/weapons/exp_molotov/w_exp_molotov.mdl"

SWEP.BobScale   = 1
SWEP.SwayScale  = 1

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.ThrowDelay = 1.5

function SWEP:Initialize()
    self:SetHoldType("grenade")
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Holster()    
    return true
end

function SWEP:PrimaryAttack()
    self:SendWeaponAnim(ACT_VM_THROW)
    self.Owner:SetAnimation(PLAYER_ATTACK1)

    if not SERVER then return end

    local e = ents.Create("evil_thrown_bottle")
    e:SetOwner(self.Owner)
    local eyeang = self.Owner:GetAimVector():Angle()
    local right = eyeang:Right()
    local up = eyeang:Up()
    e:SetPos(self.Owner:GetShootPos() + right * 6 + up * -2)
    e:SetAngles(self.Owner:GetAngles())
    e:SetPhysicsAttacker(self.Owner)
    e:Spawn()

    if self.ShouldThrowExplosive then
        e.IsExplosive = true
        self.ShouldThrowExplosive = false
    end

    local phys = e:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocity(self.Owner:GetAimVector() * 1000)
        phys:ApplyForceOffset(e:GetUp() * math.random(-20, -50), e:GetPos() + e:GetRight() * math.random(-5, 5))
    end

    self:SetNextPrimaryFire(CurTime() + self.ThrowDelay)
    timer.Simple(self.ThrowDelay, function()
        if IsValid(self) then
            self:SendWeaponAnim(ACT_VM_DRAW)
        end
    end)
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
