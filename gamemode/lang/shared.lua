Lang = Lang or {
    Locale = "en"
}

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
        ["#Spec_HUDInfo"] = "Press {{key}} to cycle modes. Click to cycle targets",
        ["#End_OnlyNSurvived"] = "Only {{count}} Survived",
        ["#End_NSurvived"] = "{{count}} Survived",
        ["#End_NobodySurvived"] = "Nobody Survived",
        ["#End_OnlySurvivor"] = "{{nick}} was the only survivor!",
        ["#End_OnlyNDied"] = "Only {{count}} Died",
        ["#End_NDied"] = "{{count}} Died",
        ["#End_NobodyDied"] = "Nobody Died",
        ["#End_EveryoneDied"] = "Everyone Died",
        ["#Help"] = "Help",
        ["#Exit"] = "Exit",
        ["#Boss"] = "Boss",
        ["#Proxy"] = "Proxies",
        ["#Humans"] = "Humans",
        ["#Dead"] = "Dead",
        ["#Admin_MoreThanOneTarget"] = "Found more than one matching target",
        ["#Admin_NoTargets"] = "Found no matching targets",
        ["#Admin_CantEnd"] = "The round could not be ended",
        ["#Admin_TestingOn"] = "Testing mode is enabled",
        ["#Admin_TestingOff"] = "Testing mode is disabled",
        ["#Admin_NextBossPlayer"] = "The next boss player is now {{name}}",
        ["#Admin_NextBoss"] = "The next boss is now {{boss}}",
        ["#Admin_BossChoices"] = "Available boss choices: {{bosslist}}",
        ["#NoReasonGiven"] = "No reason given",
        ["#ServerLocked"] = "This server has been locked due to a large error: {{error}}",
        ["#ServerNoContent"] = "Evil Content Pack {{num}} is NOT installed. This will cause big problems!",
        ["#ClientNoContent"] = "You are missing Evil Content Pack {{num}}. Please install it to avoid errors and bugs!",
        ["#AFK_Marked"] = "You have been marked as AFK! Move within {{sec}} seconds to avoid being kicked!",
        ["#AFK_Clear"] = "You are no longer marked as AFK",
        ["#Player_Joined"] = "{{name}} connected",
        ["#Player_Left"] = "{{name}} disconnected ({{reason}})",
        ["#Player_Left_NoReason"] = "{{name}} disconnected",
        ["#Clock_Collect"] = "{{name}} collected a clock! 60 seconds has been added to the timer!",
        ["#Skull_NoPlayers"] = "There are no players to revive...",
        ["#Skull_Revive"] = "{{name}} collected Apollyon's Skull! A random player has been revived",
        ["#CollectPages"] = "Collect all {{count}} pages",
        ["#StopHumansPages"] = "Stop the humans from collecting all {{count}} pages",
        ["#Teleport"] = "Teleport",
        ["#TeleportDesc"] = "Teleport to a random human spawn",
        ["#YouAreBoss"] = "You are the boss",
        ["#HowToTaunt"] = "Press R to taunt (if the boss has it)",
        ["#HowToAttack"] = "Hold left click to attack!",
        ["#AbilityCooldown"] = "You need to wait {{time}} seconds before using your ability again",
        ["#Deathmatch_EndTimeUp"] = "Times up! {{winners}} won with {{kills}} kills!",
        ["#Deathmatch_EndTimeUpNone"] = "Times up! Somehow everyone was so bad that nobody got a single kill!",
    }
}

function Lang:Get(key)
    local ret = Lang.Translations[Lang.Locale][key]
    
    if not ret then
        ret = Lang.Translations["en"][key]
    end

    return ret
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
