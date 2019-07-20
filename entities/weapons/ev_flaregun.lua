SWEP.Author         = "lorp"
SWEP.Purpose        = "shoot some flares boi"
SWEP.Instructions   = "click"
SWEP.PrintName      = "ACME Flare Gun"
SWEP.ViewModel      = "models/weapons/v_dkflaregun.mdl"
SWEP.WorldModel     = "models/weapons/w_dkflaregun.mdl"

SWEP.Primary.Automatic      = false
SWEP.Primary.ClipSize       = 2
SWEP.Primary.DefaultClip    = 2

util.PrecacheSound("weapons/flaregun/fire.wav")

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 5)
    self:EmitSound("weapons/flaregun/fire.wav")
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetClip1(self:Clip1() - 1)

    if not SERVER then return end

    if self:Clip1() == 0 then
        timer.Simple(2, function()
            self:Remove()
        end)
    end

    local flare = ents.Create("env_flare") // how convenient !
    flare:SetPos(self.Owner:GetShootPos())
    flare:SetAngles(self.Owner:GetAimVector():Angle())
    flare:SetKeyValue("spawnflags", 4) // infinite length
    flare:EmitSound("Weapon_Flaregun.Burn")
    flare:Spawn()
    flare:Activate()
    flare:Fire("Launch", "1000", 0.1)
end

function SWEP:SecondaryAttack() return end
function SWEP:Reload() return end
