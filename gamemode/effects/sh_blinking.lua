local blinkLength = 0.5

if CLIENT then
    local drawBlink = false
    hook.Add("DrawOverlay", "EvilDrawBlink", function()
        if drawBlink then
            draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
        end
    end)

    local function DoBlink()
        if drawBlink then return end

        drawBlink = true
        timer.Simple(blinkLength, function()
            drawBlink = false
        end) 
    end

    local eyeMat = Material("evil/eye.png")
    local colorGray = Color(65, 65, 65, 50)
    hook.Add("HUDPaint", "EvilBlinkHUD", function()
        if not Round:IsPlaying() or not LocalPlayer():IsHuman() or not LocalPlayer():Alive() then return end
        local shouldBlink = hook.Run("EvilDoBlinking")
        if not shouldBlink then return end

        local scrw, scrh = ScrW(), ScrH()
        local width = ScreenScale(20)
        local x = ScreenScale(30) + 30
        local y = scrh - width - 10

        local blinkInterval = LocalPlayer():GetNW2Int("EvilBlinkInterval", 10)
        local nextBlink = LocalPlayer():GetNW2Int("EvilNextBlink")

        local frac = (nextBlink - CurTime()) / blinkInterval
        if frac < 0 then
            DoBlink()
        end

        draw.RoundedBox(0, x, y + width * (1 - frac), width, width * frac, Color(150, 25, 25, 100))
        draw.RoundedBox(0, x, y, width, width, colorGray)
        surface.SetDrawColor(25, 25, 100, 255)
        surface.DrawOutlinedRect(x, y, width, width)
        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(eyeMat)
        surface.DrawTexturedRect(x, y + width / 4, width, width / 2)
    end)    
else
    hook.Add("Think", "EvilBlinkThinkTink", function()
        local shouldBlink = hook.Run("EvilDoBlinking")
        if not shouldBlink then return end

        for _, ply in ipairs(Game:GetHumans()) do
            local interval = ply:GetNW2Int("EvilBlinkInterval")
            if interval == 0 then
                local n = math.random(13, 17)
                ply:SetNW2Int("EvilBlinkInterval", n)
                ply:SetNW2Float("EvilNextBlink", CurTime() + n + math.random(-5, 5))
                continue
            end
            local nextBlink = ply:GetNW2Float("EvilNextBlink")
            if nextBlink == 0 then
                nextBlink = CurTime() + interval
            end
            if nextBlink < CurTime() then
                nextBlink = CurTime() + interval
                if not ply:GetNW2Bool("EvilIsBlinking") then
                    ply:SetNW2Bool("EvilIsBlinking", true)
                    timer.Simple(blinkLength, function()
                        if IsValid(ply) then
                            ply:SetNW2Bool("EvilIsBlinking", false)
                        end
                    end)
                end
            end
            ply:SetNW2Float("EvilNextBlink", nextBlink)
        end
    end)

    hook.Run("RoundSet", "EvilRandomizeBlinkLength", function(round)
        if round == ROUND_PLAYING then
            for _, ply in ipairs(player.GetAll()) do
                local n = math.random(13, 17)
                ply:SetNW2Int("EvilBlinkInterval", n)
                ply:SetNW2Float("EvilNextBlink", CurTime() + n + math.random(-5, 5))
            end
        end
    end)
end