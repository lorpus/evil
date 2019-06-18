hook.Add("Initialize", "InitLanguage", function()
    local settings = file.Read("evilsettings.txt", "DATA")
    if settings then
        local t = util.JSONToTable(settings)
        if t and t.language then
            Lang.Locale = t.language
        end
    else
        file.Write("evilsettings.txt", "{ \"language\": \"en\" }")
        Lang.Locale = "en"
    end
end)

local function changelocale(try)
    if not table.HasValue(Lang:GetAvailableLocales(), try) then
        return chat.AddText(Lang:Get("#InvalidLocale"))
    end

    local settings = file.Read("evilsettings.txt", "DATA")
    if settings then
        local t = util.JSONToTable(settings)
        t.language = try
        file.Write("evilsettings.txt", util.TableToJSON(t))
    else
        t.language = try
        file.Write("evilsettings.txt", "{ \"language\": \"" .. try .. "\" }")
    end

    chat.AddText(Lang:Get("#LocaleChanged"))
end

concommand.Add("evil_setlanguage", function(ply, cmd, args, argStr)
    changelocale(argStr)
end)

hook.Add("OnPlayerChat", "ChangeLocaleChat", function(ply, text, bTeam, bDead)
    if text:StartWith("/evil lang") then
        if ply == LocalPlayer() then
            local try = string.sub(text, 12)
            changelocale(try)
        end

        return true
    end
end)
