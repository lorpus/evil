hook.Add("Think", "EvilDoChaseMusic", function()
    local lp
    local boss
    if CLIENT then
        lp = LocalPlayer()
        boss = Game:GetBoss()
        if not IsValid(lp) or not IsValid(boss) or not lp:Alive() or not boss:Alive() or not Round:IsPlaying() then
            if IsValid(Evil._ChaseMusic) then
                Evil._ChaseMusic:Stop()
                Evil._ChaseMusic = nil
                Evil._ChaseMusicPlaying = false
            end
            return
        end
    elseif SERVER then
        if not Round:IsPlaying() then return end
    end

    local profile = Game:GetProfileInfo()
    if not profile or not profile.chase_music then return end

    if CLIENT then
        if lp:IsBoss() then return end

        local distanceToBoss = lp:GetPos():Distance(boss:GetPos())
        local tr = util.TraceLine({
            start = lp:EyePos(),
            endpos = boss:EyePos(),
            filter = { lp, boss },
            mask = MASK_VISIBLE
        })

        local head = boss:EyePos():ToScreen()
        local visible = head.x > 0 and head.x < ScrW() and head.y > 0 and head.y < ScrH() and distanceToBoss < 1350 and not tr.Hit
        if not visible and IsValid(Evil._ChaseMusic) and Evil._ChaseMusicPlaying then // not visible, is playing; check if the boss has lost us for 5 seconds
            local timeSinceSpotted = CurTime() - lp:GetNW2Float("EvilLastSpotted")
            if timeSinceSpotted > 5 then // fade out
                local vol = math.Approach(Evil._ChaseMusic:GetVolume(), -1, 0.005)
                if vol <= 0 then
                    Evil._ChaseMusic:Stop()
                    Evil._ChaseMusic = nil
                    Evil._ChaseMusicPlaying = false
                    return
                end
                Evil._ChaseMusic:SetVolume(vol)
            end
        elseif visible and not IsValid(Evil._ChaseMusic) and not Evil._ChaseMusicPlaying then // visible, not playing; start
            Evil._ChaseMusicPlaying = true
            sound.PlayFile("sound/" .. profile.chase_music, "", function(chan, errid, errname)
                if IsValid(chan) then
                    chan:Play()
                    Evil._ChaseMusic = chan
                else
                    dbg.print("chase music", errid, errname)
                end
            end)
        elseif visible and IsValid(Evil._ChaseMusic) and Evil._ChaseMusicPlaying then
            Evil._ChaseMusic:SetVolume(1)
        end
    else
        if not Round:IsPlaying() or not IsValid(Game:GetBoss()) then return end
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsLineOfSightClear(Game:GetBoss()) and ply:GetPos():DistToSqr(Game:GetBoss():GetPos()) < (1350 * 1350) then
                ply:SetNW2Float("EvilLastSpotted", CurTime())
            end
        end
    end
end)
