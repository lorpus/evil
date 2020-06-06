AddCSLuaFile()
DEFINE_BASECLASS("weapon_base")

SWEP.PrintName = "Knife"
SWEP.Slot = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/v_csgo_bayonet.mdl"
SWEP.WorldModel = "models/weapons/w_csgo_bayonet.mdl"
SWEP.ViewModelFOV = 65

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Damage = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 1, "IdleTime")
end

function SWEP:Initialize()
    self:SetHoldType("knife")
end

function SWEP:DrawWorldModel()
    self:SetSkin(12)
    self:DrawModel()
end

function SWEP:PreDrawViewModel(vm, weapon, ply)
    if not IsValid(vm) then return end
    vm:SetSkin(12)
end

function SWEP:Think()
    if CurTime() >= self:GetIdleTime() then
        self:SendWeaponAnim(ACT_VM_IDLE)
        self:SetIdleTime(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    end
end

function SWEP:Deploy()
    self:SetIdleTime(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + 1)
    self:SetNextSecondaryFire(CurTime() + 1)

    self:EmitSound("csgo_knife/knife_push_draw.wav")

    return true
end

-- doesnt actually check if ur behind the player but neither does cs so who cares
function SWEP:IsFacingBack(ent)
    local angle = math.NormalizeAngle(self.Owner:GetAngles().y - ent:GetAngles().y)

    return angle <= 90 and angle >= -90
end

function SWEP:PrimaryAttack()
    if CurTime() < self:GetNextPrimaryFire() then return end
    self:DoAttack(false)
end

function SWEP:SecondaryAttack()
    if CurTime() < self:GetNextSecondaryFire() then return end
    self:DoAttack(true)
end

function SWEP:DoAttack(alt)
    local range = alt and 48 or 64
    self.Owner:LagCompensation(true)
    local aimVec = self.Owner:GetAimVector()
    local shootPos = self.Owner:GetShootPos()
    local shootDest = shootPos + aimVec * range

    local td = {
        start = shootPos,
        endpos = shootDest,
        filter = self.Owner,
        mask = MASK_SHOT_HULL,
        mins = Vector(-16, -16, -16),
        maxs = Vector(16, 16, 16)
    }

    local tr = util.TraceLine(td)

    if not tr.Hit then
        tr = util.TraceHull(td)
    end

    tr.HitGroup = HITGROUP_GENERIC
    local hit = tr.Hit and not tr.HitSky
    local hitEnt = IsValid(tr.Entity) and tr.Entity or game.GetWorld()
    local hitPlayer = IsValid(hitEnt) and hitEnt:IsPlayer()
    local hitBackstab = hitPlayer and self:IsFacingBack(hitEnt)
    local info = DamageInfo()
    info:SetAttacker(self.Owner)
    info:SetInflictor(self)
    info:SetDamage((hitBackstab and alt) and hitEnt:Health() * 10 or 34)
    info:SetDamageType(bit.bor(DMG_BULLET + DMG_NEVERGIB))
    info:SetDamageForce(aimVec:GetNormalized() * 300)
    info:SetDamagePosition(shootDest)
    hitEnt:DispatchTraceAttack(info, tr, aimVec)

    if hit then
        util.Decal(hitPlayer and "Blood" or "ManhackCut", shootPos - aimVec, shootDest + aimVec, true)
        local effectdata = EffectData()
        effectdata:SetOrigin(tr.HitPos + tr.HitNormal)
        effectdata:SetStart(tr.StartPos)
        effectdata:SetSurfaceProp(tr.SurfaceProps)
        effectdata:SetDamageType(DMG_SLASH)
        effectdata:SetHitBox(tr.HitBox)
        effectdata:SetNormal(tr.HitNormal)
        effectdata:SetEntity(tr.Entity)
        effectdata:SetAngles(aimVec:Angle())
        util.Effect("knife_impact", effectdata)
    end

    local nextAttack = CurTime() + (alt and 1.0 or (hit and 0.5 or 0.4))
    self:SetNextPrimaryFire(nextAttack)
    self:SetNextSecondaryFire(nextAttack)

    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM)

    if hit then
        if alt then
            if hitBackstab then
                self:SendWeaponAnim(ACT_VM_SWINGHARD)
            else
                self:SendWeaponAnim(ACT_VM_HITCENTER2)
            end
        else
            if hitBackstab then
                self:SendWeaponAnim(ACT_VM_SWINGHIT)
            else
                self:SendWeaponAnim(ACT_VM_HITCENTER)
            end
        end
    else
        if alt then
            self:SendWeaponAnim(ACT_VM_MISSCENTER2)
        else
            self:SendWeaponAnim(ACT_VM_MISSCENTER)
        end
    end

    if hitBackstab then
        self:EmitSound(alt and "csgo_knife/knife_stab.wav" or "csgo_knife/knife_hit1.wav")
    elseif hitPlayer then
        local hits = {
            "csgo_knife/knife_hit2.wav",
            "csgo_knife/knife_hit3.wav",
            "csgo_knife/knife_hit4.wav",
        }
        self:EmitSound(hits[math.random(#hits)])
    elseif hit then
        local hits = {
            "csgo_knife/knife_hit_01.wav",
            "csgo_knife/knife_hit_02.wav",
            "csgo_knife/knife_hit_03.wav",
            "csgo_knife/knife_hit_04.wav",
            "csgo_knife/knife_hit_05.wav",
        }
        self:EmitSound(hits[math.random(#hits)])
    else
        local hits = {
            "csgo_knife/knife_slash1.wav",
            "csgo_knife/knife_slash2.wav",
        }
        self:EmitSound(hits[math.random(#hits)])
    end

    self:SetIdleTime(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self.Owner:LagCompensation(false)
end

function SWEP:Reload()
end

function SWEP:Holster(wep)
    return true
end
