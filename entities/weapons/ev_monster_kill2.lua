AddCSLuaFile()

// exactly like ev_monster_kill but will spook the player by having them be forced to face and zoom into the boss then killed

// TODO: test this swep
SWEP.Base = "ev_monster_kill"

function SWEP:KillPlayer(ent)
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
