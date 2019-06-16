hook.Add("CalcView", "cameraview", function(ply, vOrigin, qAngles, flFov, flZnear, flZfar)
    if Round:IsWaiting() then
        local iCamera = math.floor(CurTime() / 5 % #Map.cameras) + 1
        local oCam = Map.cameras[iCamera]
        return {
            origin = oCam.pos,
            angles = oCam.ang
        }
    end
end)

hook.Add("EvilPlayerKilled", "OnPlayerKilled", function(victim)
    local info = Game:GetProfileInfo()
    if info.killhook then
        info.killhook(victim)
    end
end)
