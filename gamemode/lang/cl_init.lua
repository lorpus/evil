hook.Add("Initialize", "InitLanguage", function()
    Evil.Locale = "en" // jic
    timer.Simple(1, function()
        local settings = file.Read("evilsettings.txt", "DATA")
        if settings then
            local t = util.JSONToTable(settings)
            if t and t.language then
                Lang.Locale = t.language
            end
        else
            local servlang = GetGlobalString("EvilServerLang")

            local cc = system.GetCountry()
            if not cc then // idk if this is possible
                file.Write("evilsettings.txt", "{ \"language\": \"" .. servlang .. "\" }")
                Lang.Locale = servlang
                Evil:AddTextChat(Lang:Format("#LangObtainFail", { lang = Lang.LangToName[servlang] }))
            end
            if Lang.CCToISO[cc] then
                local lang = Lang.ISOToLang[Lang.CCToISO[cc]:lower()]
                if lang then
                    file.Write("evilsettings.txt", "{ \"language\": \"" .. lang .. "\" }")
                    Lang.Locale = lang
                    Evil:AddTextChat(Lang:Format("#LangGuess", { country = Lang.CCToName[cc], lang = Lang.LangToName[lang] }))
                else
                    file.Write("evilsettings.txt", "{ \"language\": \"" .. servlang .. "\" }")
                    Lang.Locale = servlang
                    Evil:AddTextChat(Lang:Format("#LangGuessFail", { country = Lang.CCToName[cc], lang = Lang.LangToName[servlang] }))
                end
            end
        end
    end)
end)

function Lang:ChangeLanguage(try)
    if not try or #try == 0 then
        return Evil:AddTextChat(Lang:Get("#NoLangSpecified"))
    end

    if not table.HasValue(Lang:GetAvailableLangs(), try) then
        return Evil:AddTextChat(Lang:Get("#InvalidLang"))
    end

    try = Lang.ISOToLang[try:lower()]

    Lang.Locale = try

    local settings = file.Read("evilsettings.txt", "DATA")
    if settings then
        local t = util.JSONToTable(settings)
        t.language = try
        file.Write("evilsettings.txt", util.TableToJSON(t))
    else
        t.language = try
        file.Write("evilsettings.txt", "{ \"language\": \"" .. try .. "\" }")
    end

    Evil:AddTextChat(Lang:Get("#LangChanged"))
end

concommand.Add("evil_setlanguage", function(ply, cmd, args, argStr)
    Lang:ChangeLanguage(argStr)
end)
