hook.Add("Initialize", "EvilLangInit", function()
    if not Lang.ISOToLang[Evil.Cfg.ServerLanguage] then
        print(Evil.Cfg.ServerLanguage, "is not a valid language, fallback to English")
    else
        Lang.Locale = Lang.ISOToLang[Evil.Cfg.ServerLanguage]
    end

    SetGlobalString("EvilServerLang", Lang.Locale)
end)
