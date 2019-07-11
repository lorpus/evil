AddCSLuaFile()

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

local anims = {
    "zombie_attack_01",
    "zombie_attack_02",
    "zombie_attack_03",
    "zombie_attack_04",
    "zombie_attack_05",
    "zombie_attack_06",
    "zombie_attack_07",
    "zombie_attack_08"
}

function SWEP:GetAttackAnimation()
    return anims[math.random(#anims)]
end

function SWEP:PrimaryAttack()
    if not SERVER then return end
    local ply = self.Owner
    if not ply.flLastGesture then ply.flLastGesture = 0 end
    if not self.flLastSeqLen then self.flLastSeqLen = 0 end

    if CurTime() - ply.flLastGesture > 1.5 then
        ply.flLastGesture = CurTime()
        local seq = ply:LookupSequence(self:GetAttackAnimation())

        ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, seq, 0, true)
        Network:SendAnim(ply, GESTURE_SLOT_ATTACK_AND_RELOAD, seq)
    end

    if not SERVER then return end

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
