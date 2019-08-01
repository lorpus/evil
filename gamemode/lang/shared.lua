Lang = Lang or {
    Locale = "en",
    ISOToLang = {
        ["en"]      = "en",
        ["en-au"]   = "en",
        ["en-bz"]   = "en",
        ["en-ca"]   = "en",
        ["en-cb"]   = "en",
        ["en-gb"]   = "en",
        ["en-ie"]   = "en",
        ["en-jm"]   = "en",
        ["en-nz"]   = "en",
        ["en-ph"]   = "en",
        ["en-tt"]   = "en",
        ["en-us"]   = "en",
        ["en-za"]   = "en",
        ["en-zw"]   = "en",
        /*["fr"]      = "fr",
        ["fr-BE"]   = "fr",
        ["fr-CA"]   = "fr",
        ["fr-CH"]   = "fr",
        ["fr-FR"]   = "fr",
        ["fr-LU"]   = "fr",
        ["fr-MC"]   = "fr",*/
    },
}

Lang.Translations = {
    en = {
        // generic things
        ["#Help"] = "Help",
        ["#Exit"] = "Exit",
        ["#Boss"] = "Boss",
        ["#Proxy"] = "Proxies",
        ["#Humans"] = "Humans",
        ["#Dead"] = "Dead",
        ["#Player_Joined"] = "{{name}} connected",
        ["#Player_Left"] = "{{name}} disconnected ({{reason}})",
        ["#Player_Left_NoReason"] = "{{name}} disconnected",

        // gui
        ["#YouAreBoss"] = "You are {{name}}!",
        ["#HowToAttack_A"] = "Hold left click to attack!",
        ["#HowToTaunt"] = "Press {{key}} to taunt",
        ["#HowToAbility"] = "Right click to use your ability!",

        // map vote/map names
        ["#MapVote"] = "Map Vote! ({{secs}}s)",
        ["#MapVoteCanceled"] = "The map vote has been canceled by an admin",
        ["#ExtendWon"] = "The vote has decided that the current map will be extended!",
        ["#NewMapWon"] = "The vote has decided that we will change to {{map}}! The map will change after the round ends",
        ["#The_Forest"] = "The Forest",

        // round
        ["#Round_EndBossWin"] = "The boss has won!",
        ["#Round_EndBossDie"] = "The boss has mysteriously died!",
        ["#Round_EndPagesCollected"] = "The humans have collected all the pages!",
        ["#Round_EndTimeUp"] = "Times up! The boss has won!",
        ["#Round_EndAdmin"] = "An admin has forcefully ended the game",
        ["#Round_WaitingForPlayers"] = "Waiting for players...",
        ["#Round_EndUnknown"] = "The game has been ended for an unknown reason (likely manually)",
        ["#End_OnlyNSurvived"] = "Only {{count}} Survived",
        ["#End_NSurvived"] = "{{count}} Survived",
        ["#End_NobodySurvived"] = "Nobody Survived",
        ["#End_OnlySurvivor"] = "{{nick}} was the only survivor!",
        ["#End_OnlyNDied"] = "Only {{count}} Died",
        ["#End_NDied"] = "{{count}} Died",
        ["#End_NobodyDied"] = "Nobody Died",
        ["#End_EveryoneDied"] = "Everyone Died",

        // special rounds
        ["#SR_AllAlone"] = "All Alone",
        ["#SR_AllAloneDesc"] = "Where are your fellow humans?",
        ["#SR_NightVision"] = "Night Vision",
        ["#SR_NightVisionDesc"] = "No more flashlight, goggles only!",
        ["#SR_Countdown"] = "Countdown",
        ["#SR_CountdownDesc"] = "Your timer seems to be missing!",
        ["#SR_Realism"] = "Realism",
        ["#SR_RealismDesc"] = "Full realism! Say bye to your HUD!",
        ["#SR_Deadline"] = "Deadline",
        ["#SR_DeadlineDesc"] = "No time will ever be added to the clock!",
        ["#SR_Matrix"] = "The Matrix",
        ["#SR_MatrixDesc"] = "Pages will only materialize when you are within their range",
        ["#SR_Blindness"] = "Blindness",
        ["#SR_BlindnessDesc"] = "You cannot see anything unless your flashlight is on!",
        ["#SR_Wallhacks"] = "Wallhacks",
        ["#SR_WallhacksDesc"] = "The boss is now visible through walls!",
        ["#SR_Earthquake"] = "Earthquake",
        ["#SR_EarthquakeDesc"] = "The ground is so scared of the boss it will tremble around it too!",
        ["#SR_DeathSwap"] = "Page Swap",
        ["#SR_DeathSwapDesc"] = "Watch out whenever someone collects a page!",

        // gametype
        ["#Game_PageCollected"] = "{{player}} has collected a page!",
        ["#Deathmatch_EndTimeUp"] = "Times up! {{winners}} won with {{kills}} kills!",
        ["#Deathmatch_EndTimeUpNone"] = "Times up! Somehow everyone was so bad that nobody got a single kill!",
        ["#CollectPages"] = "Collect all {{count}} pages",
        ["#StopHumansPages"] = "Stop the humans from collecting all {{count}} pages",
        
        // lang
        ["#InvalidLang"] = "Unfortunately this isn't a supported language setting",
        ["#LangChanged"] = "Language successfully changed",
        ["#NoLangSpecified"] = "You need to specify a language. (e.g. /evil lang en)",

        // spectator
        ["#Spec_Spectating"] = "Spectating",
        ["#Spec_HUDInfo"] = "Press {{key}} to cycle modes. Click to cycle targets",

        // admin
        ["#Admin_MoreThanOneTarget"] = "Found more than one matching target",
        ["#Admin_NoTargets"] = "Found no matching targets",
        ["#Admin_CantEnd"] = "The round could not be ended",
        ["#Admin_TestingOn"] = "Testing mode is enabled",
        ["#Admin_TestingOff"] = "Testing mode is disabled",
        ["#Admin_NextBossPlayer"] = "The next boss player is now {{name}}",
        ["#Admin_NextBoss"] = "The next boss is now {{boss}}",
        ["#Admin_BossChoices"] = "Available boss choices: {{bosslist}}",

        // server shit
        ["#NoReasonGiven"] = "No reason given",
        ["#ServerLocked"] = "This server has been locked due to a large error: {{error}}",
        ["#ServerNoContent"] = "Evil Content Pack {{num}} is NOT installed. This will cause big problems!",
        ["#ClientNoContent"] = "You are missing Evil Content Pack {{num}}. Please install it to avoid errors and bugs!",

        // afk
        ["#AFK_Marked"] = "You have been marked as AFK! Move within {{sec}} seconds to avoid being kicked!",
        ["#AFK_Clear"] = "You are no longer marked as AFK",

        // collectables
        ["#Clock_Collect"] = "{{name}} collected a clock! 60 seconds has been added to the timer!",
        ["#Skull_NoPlayers"] = "There are no players to revive...",
        ["#Skull_Revive"] = "{{name}} collected Apollyon's Skull! A random player has been revived",
        ["#Bible_Collect"] = "You put the trusty Holy Bible into your back pocket...",
        ["#Bible_Used"] = "The boss tried to spook you but was banished by the power of Christ. Unfortunately, he stole your bible...",
        ["#Lantern_Destroy"] = "Press {{button}} to destroy this lantern!",
        
        // abilities
        ["#Teleport"] = "Teleport", // unused
        ["#TeleportDesc"] = "Teleport to a random human spawn", // unused
        ["#AbilityCooldown"] = "You need to wait {{time}} seconds before using your ability again",
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

function Lang:GetAvailableLangs()
    return table.GetKeys(Lang.ISOToLang)
end
