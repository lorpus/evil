function SR:ApplySR(key)
    SR.ActiveRounds[key] = true
    Network:SendHook("ApplySR", key)
    local t = SR.SpecialRounds[key]
    if isfunction(t.apply) then
        t.apply()
    end
end

function SR:RemoveSR(key)
    SR.ActiveRounds[key] = nil
    Network:SendHook("RemoveSR", key)
    local t = SR.SpecialRounds[key]
    if isfunction(t.remove) then
        t.remove()
    end
end

function SR:RunSR(round)
    Network:SendHook("StartSRCycle", round)
    local roundcount = Round:GetRoundCount()
    timer.Simple(SR.ApplyDelay, function()
        if roundcount != Round:GetRoundCount() or not Round:IsPlaying() then return end
        SR:ApplySR(round)
    end)
end

local function ChooseSpecialRound()
    if Evil._NEXT_SR and SR.SpecialRounds[Evil._NEXT_SR] then
        local x = Evil._NEXT_SR
        Evil._NEXT_SR = nil
        return x
    end

    local round // key

    for k, v in RandomPairs(SR.SpecialRounds) do
        dbg.print(k, v)
        if isfunction(v.pickable) then
            if v.pickable() then
                round = k
                break
            end
        else
            round = k
            break
        end
    end

    return round
end

hook.Add("RoundSet", "SpecialRoundPicker", function(round)
    if round == ROUND_POST then
        for round, _ in pairs(SR.ActiveRounds) do
            SR:RemoveSR(round)
        end
        return
    elseif round != ROUND_PLAYING then return end

    local chance = SR.Chance
    local override = hook.Run("CalculateSpecialRoundChance", chance)
    if override != nil then chance = override end

    if eutil.Percent(chance) or Evil.FORCE_SR then
        Evil.FORCE_SR = nil

        local specialround = ChooseSpecialRound()

        dbg.print(specialround)

        if not specialround then return end

        SR:RunSR(specialround)
    end
end)
