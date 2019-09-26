Command = Command or {
    Registered = {},
    AliasMap = {},
    Prefixes = { "!", "/" },
}

Command.Commands = {
    lang = {
        aliases = { "lang", "language" },
        action = function(ply, ...)
            if CLIENT then
                Lang:ChangeLanguage(...)
            end
        end,
    }
}

for k, v in pairs(Command.Commands) do
    Command.Registered[k] = v
    for _, alias in ipairs(v.aliases) do
        Command.AliasMap[alias] = k
    end
end
