Lang = Lang or {
    Locale = "en",
    ISOToLang = { // i wouls rename this to be correct but im lazy
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
        ["english"] = "en",
        /*["fr"]      = "fr",
        ["fr-BE"]   = "fr",
        ["fr-CA"]   = "fr",
        ["fr-CH"]   = "fr",
        ["fr-FR"]   = "fr",
        ["fr-LU"]   = "fr",
        ["fr-MC"]   = "fr",*/
    },

    LangToName = {
        ["en"] = "English",
    },

    CCToISO = {
        US = "en-US",
        CA = "en-CA",
        GB = "en-GB",
        UK = "en-GB",
        IE = "en-IE",
    },

    CCToName = {
        AD = "Andorra", AE = "United Arab Emirates", AF = "Afghanistan", AG = "Antigua and Barbuda", AI = "Anguilla", AL = "Albania", AM = "Armenia", AN = "Netherlands Antilles", AO = "Angola", AP = "African Regional Industrial Property Organization", AQ = "Antarctica", AR = "Argentina", AS = "American Samoa", AT = "Austria", AU = "Australia", AW = "Aruba", AX = "Åland Islands", AZ = "Azerbaijan",
        BA = "Bosnia and Herzegovina", BB = "Barbados", BD = "Bangladesh", BE = "Belgium", BF = "Burkina Faso", BG = "Bulgaria", BH = "Bahrain", BI = "Burundi", BJ = "Benin", BL = "Saint Barthélemy", BM = "Bermuda", BN = "Brunei Darussalam", BO = "Bolivia", BQ = "Bonaire", BR = "Brazil", BS = "Bahamas", BT = "Bhutan", BU = "Burma", BV = "Bouvet Island", BW = "Botswana", BX = "Benelux Trademarks and Designs Office", BY = "Belarus", BZ = "Belize",
        CA = "Canada", CC = "Cocos (Keeling) Islands", CD = "Democratic Republic of the Congo", CF = "Central African Republic", CG = "Congo", CH = "Switzerland", CI = "Côte d'Ivoire", CK = "Cook Islands", CL = "Chile", CM = "Cameroon", CN = "China", CO = "Colombia", CP = "Clipperton Island", CR = "Costa Rica", CS = "Serbia and Montenegro", CT = "Canton and Enderbury Islands", CU = "Cuba", CV = "Cabo Verde", CW = "Curaçao", CX = "Christmas Island", CY = "Cyprus", CZ = "Czechia",
        DD = "German Democratic Republic", DE = "Germany", DG = "Diego Garcia", DJ = "Djibouti", DK = "Denmark", DM = "Dominica", DO = "Dominican Republic", DY = "Benin", DZ = "Algeria",
        EA = "Ceuta, Melilla", EC = "Ecuador", EE = "Estonia", EF = "Union of Countries under the European Community Patent Convention", EG = "Egypt", EH = "Western Sahara", EM = "European Trademark Office", EP = "European Patent Organization", ER = "Eritrea", ES = "Spain", ET = "Ethiopia", EU = "European Union", EV = "Eurasian Patent Organization", EW = "Estonia", EZ = "Eurozone",
        FI = "Finland", FJ = "Fiji", FK = "Falkland Islands", FL = "Liechtenstein", FM = "Micronesia", FO = "Faroe Islands", FQ = "French Southern and Antarctic Territories", FR = "France", FX = "France, Metropolitan",
        GA = "Gabon", GB = "United Kingdom of Great Britain and Northern Ireland", GC = "Patent Office of the Cooperation Council for the Arab States of the Gulf", GD = "Grenada", GE = "Georgia", GF = "French Guiana", GG = "Guernsey", GH = "Ghana", GI = "Gibraltar", GL = "Greenland", GM = "Gambia", GN = "Guinea", GP = "Guadeloupe", GQ = "Equatorial Guinea", GR = "Greece", GS = "South Georgia and the South Sandwich Islands", GT = "Guatemala", GU = "Guam", GW = "Guinea-Bissau", GY = "Guyana",
        HK = "Hong Kong", HM = "Heard Island and McDonald Islands", HN = "Honduras", HR = "Croatia", HT = "Haiti", HU = "Hungary", HV = "Upper Volta",
        IB = "International Bureau of WIPO", IC = "Canary Islands", ID = "Indonesia", IE = "Ireland", IL = "Israel", IM = "Isle of Man", IN = "India", IO = "British Indian Ocean Territory", IQ = "Iraq", IR = "Iran", IS = "Iceland", IT = "Italy",
        JA = "Jamaica", JE = "Jersey", JM = "Jamaica", JO = "Jordan", JP = "Japan", JT = "Johnston Island",
        KE = "Kenya", KG = "Kyrgyzstan", KH = "Cambodia", KI = "Kiribati", KM = "Comoros", KN = "Saint Kitts and Nevis", KP = "North Korea", KR = "South Korea", KW = "Kuwait", KY = "Cayman Islands", KZ = "Kazakhstan",
        LA = "Lao People's Democratic Republic", LB = "Lebanon", LC = "Saint Lucia", LF = "Libya Fezzan", LI = "Liechtenstein", LK = "Sri Lanka", LR = "Liberia", LS = "Lesotho", LT = "Lithuania", LU = "Luxembourg", LV = "Latvia", LY = "Libya",
        MA = "Morocco", MC = "Monaco", MD = "Moldova", ME = "Montenegro", MF = "Saint Martin", MG = "Madagascar", MH = "Marshall Islands", MI = "Midway Islands", MK = "North Macedonia", ML = "Mali", MM = "Myanmar", MN = "Mongolia", MO = "Macao", MP = "Northern Mariana Islands", MQ = "Martinique", MR = "Mauritania", MS = "Montserrat", MT = "Malta", MU = "Mauritius", MV = "Maldives", MW = "Malawi", MX = "Mexico", MY = "Malaysia", MZ = "Mozambique",
        NA = "Namibia", NC = "New Caledonia", NE = "Niger", NF = "Norfolk Island", NG = "Nigeria", NH = "New Hebrides", NI = "Nicaragua", NL = "Netherlands", NO = "Norway", NP = "Nepal", NQ = "Dronning Maud Land", NR = "Nauru", NT = "Neutral Zone", NU = "Niue", NZ = "New Zealand",
        OA = "African Intellectual Property Organization", OM = "Oman", OO = "Escape code",
        PA = "Panama", PC = "Pacific Islands", PE = "Peru", PF = "French Polynesia", PG = "Papua New Guinea", PH = "Philippines", PI = "Philippines", PK = "Pakistan", PL = "Poland", PM = "Saint Pierre and Miquelon", PN = "Pitcairn", PR = "Puerto Rico", PS = "Palestine, State of", PT = "Portugal", PU = "United States Miscellaneous Pacific Islands", PW = "Palau", PY = "Paraguay", PZ = "Panama Canal Zone",
        QA = "Qatar",
        RA = "Argentina", RB = "Bolivia; Botswana", RC = "China", RE = "Réunion", RH = "Haiti", RI = "Indonesia", RL = "Lebanon", RM = "Madagascar", RN = "Niger", RO = "Romania", RP = "Philippines", RS = "Serbia", RU = "Russian Federation", RW = "Rwanda",
        SA = "Saudi Arabia", SB = "Solomon Islands", SC = "Seychelles", SD = "Sudan", SE = "Sweden", SF = "Finland", SG = "Singapore", SH = "Saint Helena, Ascension and Tristan da Cunha", SI = "Slovenia", SJ = "Svalbard and Jan Mayen", SK = "Slovakia", SL = "Sierra Leone", SM = "San Marino", SN = "Senegal", SO = "Somalia", SR = "Suriname", SS = "South Sudan", ST = "Sao Tome and Principe", SU = "USSR", SV = "El Salvador", SX = "Sint Maarten", SY = "Syrian Arab Republic", SZ = "Eswatini",
        TA = "Tristan da Cunha", TC = "Turks and Caicos Islands", TD = "Chad", TF = "French Southern Territories", TG = "Togo", TH = "Thailand", TJ = "Tajikistan", TK = "Tokelau", TL = "Timor-Leste", TM = "Turkmenistan", TN = "Tunisia", TO = "Tonga", TP = "East Timor", TR = "Turkey", TT = "Trinidad and Tobago", TV = "Tuvalu", TW = "Taiwan", TZ = "Tanzania",
        UA = "Ukraine", UG = "Uganda", UK = "United Kingdom", UM = "United States Minor Outlying Islands", UN = "United Nations", US = "United States of America", UY = "Uruguay", UZ = "Uzbekistan",
        VA = "Holy See", VC = "Saint Vincent and the Grenadines", VD = "Viet-Nam", VE = "Venezuela", VG = "Virgin Islands", VI = "Virgin Islands", VN = "Viet Nam", VU = "Vanuatu",
        WF = "Wallis and Futuna", WG = "Grenada", WK = "Wake Island", WL = "Saint Lucia", WO = "World Intellectual Property Organization", WS = "Samoa",
        WV = "Saint Vincent", YD = "Yemen, Democratic", YE = "Yemen", YT = "Mayotte", YU = "Yugoslavia", YV = "Venezuela",
        ZA = "South Africa", ZM = "Zambia", ZR = "Zaire", ZW = "Zimbabwe",
    }
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
        ["#LangGuess"] = "We think you're from {{country}}, so we automatically set you to {{lang}}",
        ["#LangGuessFail"] = "We think you're from {{country}}, but that country's language isn't supported so we set you to the server language {{lang}}. You can change this with \"/evil lang <language>\"",
        ["#LangObtainFail"] = "We couldn't guess where you were from, so you have been set to the server language {{lang}}. Type \"/evil lang <language>\" to change your language.",

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
        ["#NextBottleExplosive"] = "Your next bottle will be explosive!",
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
