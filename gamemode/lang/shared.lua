Lang = Lang or {}

Lang.Translations = {
    en = {
        ["#Round_EndBossWin"] = "The boss has won!",
        ["#Round_EndBossDie"] = "The boss has mysteriously died!",
        ["#Round_EndPagesCollected"] = "The humans have collected all the pages!",
        ["#Round_EndTimeUp"] = "Times up! The boss has won!",
        ["#Round_EndAdmin"] = "An admin has forcefully ended the game",
        ["#Round_WaitingForPlayers"] = "Waiting for players...",
        ["#Round_EndUnknown"] = "The game has been ended for an unknown reason (likely manually)",
        ["#Game_PageCollected"] = "{{player}} has collected a page!",
        ["#InvalidLocale"] = "Unfortunately this isn't a supported language setting",
        ["#LocaleChanged"] = "Language successfully changed",
        ["#NoLangSpecified"] = "You need to specify a language. (e.g. /evil lang en)",
        ["#Spec_Spectating"] = "Spectating",
        ["#Spec_HUDInfo"] = "Press {{key}} to cycle modes. Click to cycle targets"
    }
}

function Lang:Get(key)
    return Lang.Translations[Lang.Locale][key]
end

function Lang:Format(key, tab)
    local ret = Lang:Get(key)
    for key, replacement in pairs(tab) do
        ret = string.Replace(ret, "{{" .. key .. "}}", replacement)
    end
    return ret
end

function Lang:GetAvailableLocales()
    return table.GetKeys(Lang.Translations)
end
