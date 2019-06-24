function Jumpscare:SendScare(ply)
    net.Start(Network.Id)
        net.WriteInt(N_JUMPSCARE, 4)
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
            Jumpscare:SendScare(v)
        end
    end
end)
