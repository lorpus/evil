function Jumpscare:SendScare(ply, custom)
    net.Start(Network.Id)
        net.WriteInt(N_JUMPSCARE, Network.CmdBits)
        net.WriteBool(custom != nil)
        if custom then
            net.WriteTable(custom)
        end
    net.Send(ply)
end

hook.Add("PlayerDeath", "Jumpscare", function(ply, inflictor, attacker)
    if  not Round:IsPlaying() or
        ply:IsBoss() or
        not IsValid(attacker) or
        not attacker:IsPlayer() then return end

    if attacker:IsBoss() then
        Jumpscare:SendScare(ply)

        for _, v in pairs(ply:GetSpectators()) do
            if v:GetObserverMode() == OBS_MODE_IN_EYE then
                Jumpscare:SendScare(v)
            end
        end
    end
end)
