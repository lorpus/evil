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
    },

    ghost = {
        aliases = { "ghost" },
        action = function(ply)
            if SERVER then
                if ply:GetNW2Bool("EvilGhost") then
                    Network:Notify(ply, "#Ghost_Disabled", true)
                    Game:RemoveGhost(ply)
                else
                    if ply:Alive() then
                        return Network:Notify(ply, "#Ghost_NotDead", true)
                    end

                    Network:Notify(ply, "#Ghost_Enabled", true)
                    Game:SetGhost(ply)
                end
            end
        end,
    },

    discord = {
        aliases = { "discord", "dc" },
        action = function(ply)
            if CLIENT then
                Evil:AddTextChat("https://discord.gg/25mPwWB")
            end
        end
    },

    tips = {
        aliases = { "tips", "tip" },
        action = function(ply)
            if CLIENT then
                Evil.ShowTips:SetBool(not Evil.ShowTips:GetBool())
            end
        end
    },

    esp = {
        aliases = { "esp" },
        action = function(ply)
            if CLIENT then
                Evil.DrawSpecESP:SetBool(not Evil.DrawSpecESP:GetBool())
            end
        end
    },
}

for k, v in pairs(Command.Commands) do
    Command.Registered[k] = v
    for _, alias in ipairs(v.aliases) do
        Command.AliasMap[alias] = k
    end
end
