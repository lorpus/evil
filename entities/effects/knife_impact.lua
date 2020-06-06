function EFFECT:Init(data)
    local pos = data:GetOrigin()
    local emitter = ParticleEmitter(pos)

    for i = 0, 5 do
        local particle = emitter:Add("particle/particle_smokegrenade", pos)
        particle:SetVelocity(math.random(12, 16) * math.sqrt(i) * data:GetNormal() + VectorRand() * 10)
        particle:SetColor(135, 135, 135)
        particle:SetLifeTime(0)
        particle:SetDieTime(math.Rand(0.5, 1.5))
        particle:SetStartAlpha(10)
        particle:SetEndAlpha(0)
        particle:SetStartSize(math.Rand(5, 8) * math.Clamp(i, 1, 4) / 6)
        particle:SetEndSize(math.Rand(16, 24) * math.sqrt(math.Clamp(i, 1, 4)) / 6)
        particle:SetRoll(math.Rand(-25, 25))
        particle:SetRollDelta(math.Rand(-0.05, 0.05))
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end
