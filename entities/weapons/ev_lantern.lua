// remade from cof cuz the original is a war crime
SWEP.Author         = "lorp"
SWEP.Purpose        = "Fool the boss by placing a lantern"
SWEP.Instructions   = "click"
SWEP.PrintName      = "ACME Lantern"
SWEP.ViewModel      = "models/cof/weapons/lantern/v_lantern.mdl"
SWEP.WorldModel     = "models/cof/weapons/lantern/w_lantern.mdl"

SWEP.BobScale   = 1
SWEP.SwayScale  = 1

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

function SWEP:Initialize()
    self:SetWeaponHoldType("knife")
    self.Idle = 0
    self.IdleTimer = CurTime() + 0.5
end

function SWEP:GetViewModelPosition(pos, ang)
    local vp = self.Owner:GetViewPunchAngles()
    return pos + ang:Right() * vp.y * 0.5 - ang:Up() * vp.x * 0.5
end

function SWEP:Deploy()
    if SERVER then
        self.Owner:EmitSound("Weapon_CoF.SleeveGeneric")
    end

    local seqlen = self.Owner:GetViewModel():SequenceDuration()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + seqlen)

    return true
end

function SWEP:Holster()
    return true
end

function SWEP:PrimaryAttack()
    if not SERVER then return end

    local tr = util.TraceLine({
        start  = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
        filter = self.Owner
    })

    local pos
    if tr.Hit then
        pos = tr.HitPos + tr.HitNormal * 2
    else
        pos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40
    end

    local ent = ents.Create("evil_placedlantern")
    ent:SetModelScale(2)
    ent:SetPos(pos)
    ent:Spawn()
    self:Remove()
end

hook.Add("Think", "RenderLanternLights", function()
    if not CLIENT then return end
    for _, ply in ipairs(player.GetAll()) do
        local w = ply:GetActiveWeapon()
        if not IsValid(w) or w:GetClass() != "ev_lantern" then continue end
        w.light = DynamicLight(w:EntIndex())
        w.light.r = 200
        w.light.g = 200
        w.light.b = 200
        w.light.brightness = 5
        w.light.decay = 1e100
        w.light.size = 400
        w.light.DieTime = CurTime() + 1
        w.light.pos = w:GetPos() + Vector(0, 0, 2)
    end
end)

function SWEP:SecondaryAttack() end
function SWEP:Reload() end
