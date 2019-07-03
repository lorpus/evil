SWEP.PrintName = "Yeeterizer"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = true

SWEP.Distance = 88

SWEP.Primary.Automatic = true

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    if not SERVER then return end
    local ply = self.Owner
    ply:LagCompensation(true)
    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * self.Distance,
        filter = { ply },
        mask = MASK_SHOT
    })
    ply:LagCompensation(false)

    local ent = tr.Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end
    if ent:Team() != TEAM_HUMAN or not ent:Alive() then return end

    local info = DamageInfo()
    info:SetAttacker(self.Owner) // :Kill() doesnt carry the attacker
    info:SetDamage(ent:Health() * 10)
    ent:TakeDamageInfo(info)
end

function SWEP:Reload() end
function SWEP:SecondaryAttack() end
