local PLAYER = FindMetaTable("Player")

hook.Add("Think", "ForceSpectator", function()
    for _, ply in pairs(player.GetAll()) do
        if ply:IsSpectating() then
            if ply:GetObserverMode() == OBS_MODE_NONE then
                ply:SetObserverMode(OBS_MODE_ROAMING)
                ply:SetMoveType(MOVETYPE_NOCLIP) // gay
            end
        end
    end
end)

function PLAYER:StartSpectating()
    if self:IsSpectating() then return end
    self:Spectate(OBS_MODE_IN_EYE)
    self:SetMoveType(MOVETYPE_NONE)
    self:CycleSpectatorTarget(1)
    self:SetNWBool("IsSpectating", true)
end

function PLAYER:StopSpectating()
    self:Spectate(OBS_MODE_NONE)
    self:SetNWBool("IsSpectating", false)
end

function PLAYER:CycleSpectatorMode()
    if not self:IsSpectating() then return end

    if #Spec:GetValidTargetsFor(self) > 0 then
        if self:GetObserverMode() == OBS_MODE_IN_EYE then
            return self:SetObserverMode(OBS_MODE_CHASE)
        elseif self:GetObserverMode() == OBS_MODE_CHASE then
            self:SetObserverMode(OBS_MODE_ROAMING)
            return self:SetMoveType(MOVETYPE_NOCLIP)
        elseif self:GetObserverMode() == OBS_MODE_ROAMING then
            self:SetObserverMode(OBS_MODE_IN_EYE)
            return self:SetMoveType(MOVETYPE_NONE)
        end
    end

    self:SetObserverMode(OBS_MODE_ROAMING)
    self:SetMoveType(MOVETYPE_NOCLIP)
end

function PLAYER:CycleSpectatorTarget(direction)
    local target = self:GetObserverTarget()
    local valid = Spec:GetValidTargetsFor(self)
    local currentkey = table.KeyFromValue(valid, target) // ew
    if not currentkey then
        currentkey = 1
    end

    if direction == 1 then
        local nx = valid[currentkey + 1]
        if not nx then
            self:SpectateEntity(valid[1])
        else
            self:SpectateEntity(nx)
        end
    elseif direction == -1 then
        local nx = valid[currentkey - 1]
        if not nx then
            self:SpectateEntity(valid[#valid])
        else
            self:SpectateEntity(nx)
        end
    end
end

hook.Add("KeyPress", "CycleSpectator", function(ply, key)
    if not ply:IsSpectating() then return end

    if key == IN_RELOAD then
        ply:CycleSpectatorMode()
    elseif key == IN_ATTACK then
        ply:CycleSpectatorTarget(1)
    elseif key == IN_ATTACK2 then
        ply:CycleSpectatorTarget(-1)
    end
end)

hook.Add("PlayerNoClip", "ucantescape", function(ply, desired)
    if ply:IsSpectating() and not desired then
        return false
    end
end)
