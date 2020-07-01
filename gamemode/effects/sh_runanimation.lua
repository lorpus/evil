// adapted from steam addon 1104562150

hook.Add("CalcMainActivity", "EvilRunAnimation", function(ply, vVel)
    local info = Game:GetProfileInfo()
    if ply:IsBoss() and info and not info.no_running_animation then
        if not ply.bLastOnGround and not ply:OnGround() then
            ply.bLastOnGround = true
        end

        if ply:IsOnGround() and ply.bLastOnGround then
            ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, ply:LookupSequence("jump_land"), 0, true)
            ply.bLastOnGround = false
        end

        ply.m_FistAttackIndex = ply.m_FistAttackIndex or ply:GetNW2Int("$fist_attack_index")
        if ply.m_FistAttackIndex != ply:GetNW2Int("$fist_attack_index") then
            ply.m_FistAttackIndex = ply:GetNW2Int("$fist_attack_index")
            ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, ply:LookupSequence("zombie_attack_0" .. ((ply.m_FistAttackIndex) % 7 + 1)), 0.5, true)
        end

        if ply:IsOnGround() and vVel:Length() > ply:GetRunSpeed() - 10 then
            if info.anim and info.anim.run_activity then
                return info.anim.run_activity
            else
                return ACT_HL2MP_RUN_FAST, -1
            end
        end
    end
end)
