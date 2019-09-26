hook.Add("EvilCommand", "HandleClientCommand", function(command, ...)
    local tab = Command.Commands[command]
    if not tab then
        Evil:AddTextChat(Lang:Get("#InvalidCommand"))
    elseif isfunction(tab.action) then
        tab.action(LocalPlayer())
    end
end)
