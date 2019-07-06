hook.Add("StartCommand", "EvilAFKCheck", function(ply, cmd)
    if cmd:GetButtons() != 0 or cmd:GetMouseX() != 0 or cmd:GetMouseY() != 0 then
        ply.flAFKLastMove = CurTime()
        if ply.bAFKIsBeingActedOn then
            ply.bAFKIsBeingActedOn = false
            Network:Notify(ply, "#AFK_Clear", true)
        end
    end
end)

hook.Add("Think", "EvilAFKHandler", function()
    for _, ply in pairs(player.GetAll()) do
        if ply.bAFKIsBeingActedOn or not ply.flAFKLastMove then return end

        if CurTime() - ply.flAFKLastMove > Evil.Cfg.AFKKickTime then
            ply.bAFKIsBeingActedOn = true
            Network:Notify(ply, "#AFK_Marked", true, { sec = Evil.Cfg.AFKKickDelay })

            timer.Simple(Evil.Cfg.AFKKickDelay, function()
                if ply.bAFKIsBeingActedOn then
                    ply:Kick("AFK")
                end
            end)
        end
    end
end)
