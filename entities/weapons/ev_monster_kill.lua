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
    local tr = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:GetAimVector() * self.Distance,
        filter = { ply },
        mask = MASK_SHOT
    })

    local ent = tr.Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end
    if not ent:Team() == TEAM_HUMAN or not ent:Alive() then return end

    local info = DamageInfo()
    info:SetAttacker(self.Owner) // :Kill() doesnt carry the attacker
    info:SetDamage(ent:Health() * 10)
    ent:TakeDamageInfo(info)
end

function SWEP:Reyload() end
function SWEP:SecondaryAttack() end
