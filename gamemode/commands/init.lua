hook.Add("PlayerSay", "EvilCommandHandler", function(ply, text, isTeam)
    local good = false
    for _, prefix in ipairs(Command.Prefixes) do
        if text:StartWith(prefix) then
            good = true
            break
        end 
    end
    if not good then return end

    local cmdstr = text:Split(" ")[1]:sub(2)
    local cmd = Command.AliasMap[cmdstr]
    local tab = Command.Commands[cmd]

    if not tab then
        Network:SendHookFiltered(ply, "EvilCommand")
        return ""
    end

    if isfunction(tab.action) then
        tab.action(ply)
    end

    Network:SendHookFiltered(ply, "EvilCommand", cmd)

    return ""
end)