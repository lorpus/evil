AddCSLuaFile()

SWEP.PrintName = "Radar"
SWEP.Purpose = "Helps detect the nearest page"
SWEP.Instructions = "Listen for fast beeping"
SWEP.ViewModel = "models/Items/combine_rifle_ammo01.mdl"
SWEP.WorldModel = "models/Items/combine_rifle_ammo01.mdl"
SWEP.SwayScale = 0
SWEP.Secondary.Automatic = false
SWEP.IsDown = false
SWEP.LastToggle = 0
SWEP.LastBeep = 0

function SWEP:Initialize()
    self:SetHoldType("pistol")
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

    local offset = hand.Ang:Right() * 1 + hand.Ang:Forward() * 1 + hand.Ang:Up() * 3
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
    local min = -14
    if self.IsDown then
        // yikes
        pos = pos + math.Clamp(-7 + 50 * (self.LastToggle - CurTime()), min, -7) * ang:Up()
    else
        pos = pos + math.Clamp(min + 50 * (CurTime() - self.LastToggle), min, -7) * ang:Up()
    end

    return pos, ang
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end

    self.IsDown = not self.IsDown
    self.LastToggle = CurTime()
    if self.IsDown then
        self:SetHoldType("normal")
    else
        self:SetHoldType("pistol")
    end
end

function SWEP:GetBeepInterval()
    local maxInterval = 3
    local minInterval = 0.25
    local maxIntervalDist = 2000
    local minIntervalDist = 200

    local nearestPage
    local nearestPageDistSqr = math.huge
    local lp = LocalPlayer():GetPos()
    for _, page in ipairs(ents.FindByClass("evil_page")) do
        local distSqr = page:GetPos():DistToSqr(lp)
        if distSqr < nearestPageDistSqr then
            nearestPage = page
            nearestPageDistSqr = distSqr
        end
    end

    if not IsValid(nearestPage) then return -1 end

    local dist = math.sqrt(nearestPageDistSqr)

    if dist < minIntervalDist then
        return minInterval
    elseif dist > maxIntervalDist then
        return maxInterval
    else
        local frac = (dist - minIntervalDist) / (maxIntervalDist - minIntervalDist)
        return frac * (maxInterval - minInterval) + minInterval
    end
end

function SWEP:Think()
    if not CLIENT then return end
    if self.IsDown then return end

    local interval = self:GetBeepInterval()
    if interval < 0 then return end

    if CurTime() - self.LastBeep > interval then
        self.LastBeep = CurTime()
        surface.PlaySound("evil/sonar.mp3")
    end
end
