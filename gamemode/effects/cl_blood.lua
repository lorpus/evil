local VignetteMat = Material("evil/vignette.png")

local lastAlpha = 0
local lastAmp = 0
hook.Add("PostDrawHUD", "EvilDrawBloodVignette", function()
    local lp = LocalPlayer()
    local health = lp:Health()
    local amp = 0
    local alpha = 0

    if health < 100 then
        alpha = (100 - health) / 2
        amp = (100 - health) / 3
    end

    lastAlpha = math.Approach(lastAlpha, alpha, 0.5)
    lastAmp = math.Approach(lastAmp, amp, 0.5)

    if not IsValid(lp) or not lp:Alive() or not lp:IsHuman() or not Round:IsPlaying() then
        lastAlpha = 0
        lastAmp = 0
        return
    end

    if lastAlpha == 0 and lastAmp == 0 then return end

    surface.SetMaterial(VignetteMat)
    local pulse = math.abs(math.sin(CurTime() * 5)) * lastAmp
    surface.SetDrawColor(255, 0, 0, lastAlpha + pulse)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)
