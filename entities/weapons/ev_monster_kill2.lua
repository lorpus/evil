AddCSLuaFile()

// exactly like ev_monster_kill but will spook the player by having them be forced to face and zoom into the boss then killed

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

    if ent:GetNW2Bool("HasBible") then
        ent:SetNW2Bool("HasBible")
        self:SetNextPrimaryFire(CurTime() + 1) // avoid automatic firing too fast

        local boss = Map.spawns.boss
        local spawn = boss[math.random(#boss)]
        self.Owner:SetPos(spawn.pos)
        if spawn.ang then
            self.Owner:SetEyeAngles(spawn.ang)
        end

        Network:Notify(ent, "#Bible_Used", true)
        Network:PlaySound(self.Owner, "evil/items/bible/christ.mp3")
        return
    end

    if ent.flLastSpook then
        if CurTime() < (ent.flLastSpook + 10) then
            return
        end
    end
    ent.flLastSpook = CurTime()

    Network:SendHookFiltered(ent, "EvilSpook", self.Owner)
    ent:SetLaggedMovementValue(0)
    timer.Simple(2, function()
        ent:SetLaggedMovementValue(1)
        local info = DamageInfo()
        info:SetAttacker(self.Owner) // :Kill() doesnt carry the attacker
        info:SetDamage(ent:Health() * 10)
        ent:TakeDamageInfo(info)
    end)
end

function SWEP:Reload() end
function SWEP:SecondaryAttack() end

if not CLIENT then return end

local function ClearSpook()
    hook.Remove("InputMouseApply", "EvilKill2MouseFreeze")
    hook.Remove("CalcView", "EvilKill2FOVZoom")
    timer.Remove("SpookLerpage")
end

local function DoSpook(killer)
    dbg.print("sppok")
    hook.Add("InputMouseApply", "EvilKill2MouseFreeze", function(cmd, x, y, ang)
        cmd:SetMouseX(0)
        cmd:SetMouseY(0)

        return true
    end)

    local start = CurTime()
    hook.Add("CalcView", "EvilKill2FOVZoom", function(ply, orig, ang, fov, znear, zfar)
        return {
            fov = math.Clamp(fov - (CurTime() - start) * 80, 40, 100)
        }
    end)

    timer.Create("SpookLerpage", 0, 0, function()
        local dst = (killer:EyePos() - LocalPlayer():EyePos()):Angle()
        LocalPlayer():SetEyeAngles(LerpAngle(0.2, LocalPlayer():EyeAngles(), dst))
    end)
end

hook.Add("EvilSpook", "EvilSpookMain", function(killer)
    DoSpook(killer)
    timer.Simple(2, ClearSpook)
end)
