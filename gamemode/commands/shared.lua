Command = Command or {
    Registered = {},
    AliasMap = {},
    Prefixes = { "!", "/" },
}

// TODO port existing commands (i.e. admin and lang) to this system

Command.Commands = {
}

for k, v in pairs(Command.Commands) do
    Command.Registered[k] = v
    for _, alias in ipairs(v.aliases) do
        Command.AliasMap[alias] = k
    end
end
