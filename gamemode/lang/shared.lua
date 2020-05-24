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
        ["ru"]      = "ru",
        ["ru-ru"]   = "ru",
        ["russian"] = "ru",
        ["россия"]  = "ru",
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
        RU = "ru-RU",
        BY = "ru-RU",
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
        WF = "Wallis and Futuna", WG = "Grenada", WK = "Wake Island", WL = "Saint Lucia", WO = "World Intellectual Property Organization", WS = "Samoa", WV = "Saint Vincent",
        YD = "Yemen, Democratic", YE = "Yemen", YT = "Mayotte", YU = "Yugoslavia", YV = "Venezuela",
        ZA = "South Africa", ZM = "Zambia", ZR = "Zaire", ZW = "Zimbabwe",
    }
}

Lang.Translations = Lang.Translations or {
    en = {
        // generic things
        ["#Help"]                                           = "Help",
        ["#Exit"]                                           = "Exit",
        ["#Boss"]                                           = "Boss",
        ["#Proxy"]                                          = "Mini-Monsters",
        ["#Humans"]                                         = "Humans",
        ["#Dead"]                                           = "Dead",
        ["#Player_Joined"]                                  = "{{name}} connected",
        ["#Player_Left"]                                    = "{{name}} disconnected ({{reason}})",
        ["#Player_Left_NoReason"]                           = "{{name}} disconnected",
        ["#Collected"]                                      = "{{collected}} / {{total}} {{{#PageNamePlural}}} Collected",
        ["#FirstTimeResources"]                             = "This seems to be your first time on Evil! You may need to restart Garry's Mod just once to avoid some content errors!",
        ["#PageName"]                                       = "Page",
        ["#PageNamePlural"]                                 = "Pages",
        ["#Unbound"]                                        = "Unbound",

        // proxy
        ["#Accept"]                                         = "Accept",
        ["#Deny"]                                           = "Deny",
        ["#DontAsk"]                                        = "Don't Ask",
        ["#CanBeProxy"]                                     = "You may become a mini-monster",

        // updates
        ["#MajorUpdateAvailable"]                           = "A major update for the gamemode is available! Visit {{url}}",
        ["#MinorUpdateAvailable"]                           = "A minor update for the gamemode is available! Visit {{url}}",
        ["#PatchUpdateAvailable"]                           = "A patch update for the gamemode is available! Visit {{url}}",
        ["#VersionCompare"]                                 = "You are on version {{cur}} while the latest is {{new}}",
        ["#UpToDate"]                                       = "Your version is up to date!",

        // commands
        ["#InvalidCommand"]                                 = "That command doesn't exist",
        ["#Ghost_NotDead"]                                  = "You have to be dead to become a ghost",
        ["#Ghost_CantUse"]                                  = "You can't become a ghost right now",
        ["#Ghost_Disabled"]                                 = "You are no longer a ghost.",
        ["#Ghost_Enabled"]                                  = "You are now a ghost. Use this command again to stop being a ghost",

        // pointshop stuff
        ["#PS_BurtonOld"]                                   = "Adam Burton's pointshop was found, but is not version 8. Pointshop integration will not be loaded",
        ["#PS_CantBuyBeBoss"]                               = "You can't buy this since somebody else already has this round",
        ["#PS_AlreadyBeBoss"]                               = "You already bought this for next round",
        ["#PS_RefundedBeBoss"]                              = "An admin forcefully set someone to become the boss, so you have been refunded",

        // gui
        ["#YouAreBoss"]                                     = "You are {{name}}!",
        ["#HowToAttack_A"]                                  = "Hold left click to attack!",
        ["#HowToTaunt"]                                     = "Hold {{key}} to taunt",
        ["#HowToAbility"]                                   = "Right click to use your ability!",
        ["#YouAreTheBoss"]                                  = "YOU ARE THE BOSS",
        ["#FindTheHumans"]                                  = "FIND THE HUMANS",
        ["#AndKillThem"]                                    = "AND KILL THEM",
        ["#YouAreAHuman"]                                   = "YOU ARE A HUMAN",
        ["#CollectAllPages"]                                = "COLLECT ALL {{count}} {{{u#PageNamePlural}}}",
        ["#AvoidTheEvil"]                                   = "AVOID THE EVIL",

        // map vote/map names
        ["#MapVote"]                                        = "Map Vote! ({{secs}}s)",
        ["#MapVoteCanceled"]                                = "The map vote has been canceled by an admin",
        ["#ExtendWon"]                                      = "The vote has decided that the current map will be extended!",
        ["#NewMapWon"]                                      = "The vote has decided that we will change to {{map}}! The map will change after the round ends",
        ["#The_Forest"]                                     = "The Forest",
        ["#The_Ravine"]                                     = "The Ravine",
        ["#Underground"]                                    = "Underground",
        ["#LostSnow"]                                       = "Lost Snow",
        ["#Waredhouz"]                                      = "Waredhouz",
        ["#CalebsBasement"]                                 = "Caleb's Basement",
        ["#TheVoid"]                                        = "Void",

        // round
        ["#Round_EndBossWin"]                               = "The boss has won!",
        ["#Round_EndBossDie"]                               = "The boss has mysteriously died!",
        ["#Round_EndPagesCollected"]                        = "The humans have collected all the {{{l#PageNamePlural}}}!",
        ["#Round_EndTimeUp"]                                = "Times up! The boss has won!",
        ["#Round_EndAdmin"]                                 = "An admin has forcefully ended the game",
        ["#Round_WaitingForPlayers"]                        = "Waiting for players...",
        ["#Round_EndUnknown"]                               = "The game has been ended for an unknown reason (likely manually)",
        ["#End_OnlyNSurvived"]                              = "Only {{count}} Survived",
        ["#End_NSurvived"]                                  = "{{count}} Survived",
        ["#End_NobodySurvived"]                             = "Nobody Survived",
        ["#End_OnlySurvivor"]                               = "{{nick}} was the only survivor!",
        ["#End_OnlyNDied"]                                  = "Only {{count}} Died",
        ["#End_NDied"]                                      = "{{count}} Died",
        ["#End_NobodyDied"]                                 = "Nobody Died",
        ["#End_EveryoneDied"]                               = "Everyone Died",

        // special rounds
        ["#SR_AllAlone"]                                    = "All Alone",
        ["#SR_AllAloneDesc"]                                = "Where are your fellow humans?",
        ["#SR_NightVision"]                                 = "Night Vision",
        ["#SR_NightVisionDesc"]                             = "No more flashlight, goggles only!",
        ["#SR_Countdown"]                                   = "Countdown",
        ["#SR_CountdownDesc"]                               = "Your timer seems to be missing!",
        ["#SR_Realism"]                                     = "Realism",
        ["#SR_RealismDesc"]                                 = "Full realism! Say bye to your HUD!",
        ["#SR_Deadline"]                                    = "Deadline",
        ["#SR_DeadlineDesc"]                                = "No time will ever be added to the clock!",
        ["#SR_Matrix"]                                      = "The Matrix",
        ["#SR_MatrixDesc"]                                  = "{{{#PageNamePlural}}} will only materialize when you are within their range",
        ["#SR_Blindness"]                                   = "Blindness",
        ["#SR_BlindnessDesc"]                               = "You cannot see anything unless your flashlight is on!",
        ["#SR_Wallhacks"]                                   = "Wallhacks",
        ["#SR_WallhacksDesc"]                               = "The boss is now visible through walls!",
        ["#SR_Earthquake"]                                  = "Earthquake",
        ["#SR_EarthquakeDesc"]                              = "The ground is so scared of the boss it will tremble around it too!",
        ["#SR_DeathSwap"]                                   = "{{{#PageName}}} Swap",
        ["#SR_DeathSwapDesc"]                               = "Watch out whenever someone collects a {{{l#PageName}}}!",
        ["#SR_Mario"]                                       = "Mario",
        ["#SR_MarioDesc"]                                   = "Hop around like Mario!",

        // gametype
        ["#Game_PageCollected"]                             = "{{player}} has collected a {{{l#PageName}}}!",
        ["#Deathmatch_EndTimeUp"]                           = "Times up! {{winners}} won with {{kills}} kills!",
        ["#Deathmatch_EndTimeUpNone"]                       = "Times up! Somehow everyone was so bad that nobody got a single kill!",
        ["#CollectPages"]                                   = "Collect all {{count}} {{{l#PageNamePlural}}}",
        ["#StopHumansPages"]                                = "Stop the humans from collecting all {{count}} {{{l#PageNamePlural}}}",

        // lang
        ["#InvalidLang"]                                    = "Unfortunately this isn't a supported language setting",
        ["#LangChanged"]                                    = "Language successfully changed",
        ["#NoLangSpecified"]                                = "You need to specify a language. (e.g. /lang en)",
        ["#LangGuess"]                                      = "We think you're from {{country}}, so we automatically set you to {{lang}}",
        ["#LangGuessFail"]                                  = "We think you're from {{country}}, but that country's language isn't supported so we set you to the server language {{lang}}. You can change this with \"/lang <language>\"",
        ["#LangObtainFail"]                                 = "We couldn't guess where you were from, so you have been set to the server language {{lang}}. Type \"/lang <language>\" to change your language.",

        // spectator
        ["#Spec_Spectating"]                                = "Spectating",
        ["#Spec_HUDInfo"]                                   = "Press {{key}} to cycle modes. Click to cycle targets",

        // ghost
        ["#Ghost_YouAreGhost"]                              = "You are a ghost",
        ["#Ghost_GhostInfo"]                                = "Type /ghost to exit. Type /esp to toggle ESP",

        // admin
        ["#Admin_MoreThanOneTarget"]                        = "Found more than one matching target",
        ["#Admin_NoTargets"]                                = "Found no matching targets",
        ["#Admin_CantEnd"]                                  = "The round could not be ended",
        ["#Admin_TestingOn"]                                = "Testing mode is enabled",
        ["#Admin_TestingOff"]                               = "Testing mode is disabled",
        ["#Admin_NextBossPlayer"]                           = "The next boss player is now {{name}}",
        ["#Admin_NextBoss"]                                 = "The next boss is now {{boss}}",
        ["#Admin_BossChoices"]                              = "Available boss choices: {{bosslist}}",
        ["#Admin_NextSR"]                                   = "The next special round is now {{round}}",
        ["#Admin_SRChoices"]                                = "Available special round choices: {{roundlist}}",

        // server shit
        ["#NoReasonGiven"]                                  = "No reason given",
        ["#ServerLocked"]                                   = "This server has been locked due to a large error: {{error}}",
        ["#ServerNoContent"]                                = "Evil Content Pack {{num}} is NOT installed. This will cause big problems!",
        ["#ClientNoContent"]                                = "You are missing Evil Content Pack {{num}}. Please install it to avoid errors and bugs!",

        // afk
        ["#AFK_Marked"]                                     = "You have been marked as AFK! Move within {{sec}} seconds to avoid being kicked!",
        ["#AFK_Clear"]                                      = "You are no longer marked as AFK",

        // collectables
        ["#Clock_Collect"]                                  = "{{name}} collected a clock! 60 seconds has been added to the timer!",
        ["#Clock_Deadline"]                                 = "The Deadline special round is active! You can't collect this!",
        ["#Skull_NoPlayers"]                                = "There are no players to revive...",
        ["#Skull_Revive"]                                   = "{{name}} collected Apollyon's Skull! A random player has been revived",
        ["#Bible_Collect"]                                  = "You put the trusty Holy Bible into your back pocket...",
        ["#Bible_Used"]                                     = "The boss tried to spook you but was banished by the power of Christ. Unfortunately, he stole your bible...",
        ["#Jesus"]                                          = "Jesus",
        ["#Bible_JesusBro"]                                 = "Don't worry I got you guys",
        ["#Lantern_Destroy"]                                = "Press {{button}} to destroy this lantern!",
        ["#Collectable_Lantern"]                            = "Lantern",
        ["#Collectable_Lantern_Desc"]                       = "Emits light. Click to place",
        ["#Collectable_Clock"]                              = "Clock",
        ["#Collectable_Clock_Desc"]                         = "Adds 60 seconds to the clock",
        ["#Collectable_Flare"]                              = "Flare Gun",
        ["#Collectable_Flare_Desc"]                         = "",
        ["#Collectable_Bible"]                              = "Holy Bible",
        ["#Collectable_Bible_Desc"]                         = "Repel the boss when attacked",
        ["#Collectable_NightVision"]                        = "Night Vision Goggles",
        ["#Collectable_NightVision_Desc"]                   = "See in the dark",
        ["#Collectable_Soda"]                               = "Soda",
        ["#Collectable_Soda_Desc"]                          = "Give yourself a boost and run faster",
        ["#Collectable_Skull"]                              = "Apollyon's Skull",
        ["#Collectable_Skull_Desc"]                         = "Bring a human back from the dead",
        ["#Collectable_PageDetector"]                       = "{{{#PageName}}} Detector",
        ["#Collectable_PageDetector_Desc"]                  = "Helps to locate {{{l#PageNamePlural}}}",

        // abilities
        ["#Teleport"]                                       = "Teleport", // unused
        ["#TeleportDesc"]                                   = "Teleport to a random human spawn", // unused
        ["#AbilityCooldown"]                                = "You need to wait {{time}} seconds before using your ability again",
        ["#NextBottleExplosive"]                            = "Your next bottle will be explosive!",

        // classes
        ["#YouAreClass"]                                    = "Your class is {{name}}!",
        ["#YourName"]                                       = "Your name is {{name}}!",
        ["#AlyxDesc"]                                       = "You have +15 speed!",
        ["#MonkDesc"]                                       = "You have -15 speed!",
        ["#BarneyDesc"]                                     = "You have twice the stamina of a normal person!",
        ["#KleinerDesc"]                                    = "You can see one {{{l#PageName}}} at a time!",
        ["#EliDesc"]                                        = "The boss can always see you, watch out!",
        ["#SealTeamDesc"]                                   = "You have night vision goggles!",
        ["#CitizenStat1"]                                   = "Leader of Harvard Chess Club",
        ["#CitizenStat2"]                                   = "Spongebob Fan-Art Critic",
        ["#CitizenStat3"]                                   = "Critically Acclaimed Burger Flipper",
        ["#CitizenStat4"]                                   = "Cat Fluffer",
        ["#CitizenStat5"]                                   = "Janitor at the FCC Headquarters",
        ["#CitizenStat6"]                                   = "Morbidly Obese Antifa \"Protester\"",
        ["#CitizenStat7"]                                   = "10-Time MAL Anime Watching Challenge Champion",
        ["#CitizenStat8"]                                   = "Linux Evangelist",
        ["#CitizenStat9"]                                   = "Turnip Shepherd",
        ["#CitizenStat10"]                                  = "Artifical Fish Colorist",
        ["#CitizenStat11"]                                  = "Bigfoot Hunting Fanatic",
        ["#CitizenStat12"]                                  = "Goldfish Catcher",
        ["#CitizenStat13"]                                  = "Proprietor of Midgets",
        ["#CitizenStat14"]                                  = "Disinfector of Railways",
        ["#CitizenStat15"]                                  = "World Record Holder for Blindfolded Reverse 2x2 Rubix Tetrahedron Solving",
        ["#CitizenStat16"]                                  = "First Person to Undergo Nipple Enlargement Surgery",
        ["#CitizenStat17"]                                  = "Professional Flag Critic",
        ["#CitizenStat18"]                                  = "Political \"Humor\" Connoiseur",
        ["#CitizenStat19"]                                  = "Tim Sweeney's Chinese Slave",
        ["#CitizenStat20"]                                  = "Asspizza Fanatic",
        ["#CitizenStat21"]                                  = "Recurring Donator to Twitch Thots",

        // api
        ["#API_BossRegisterFailKey"]                        = "Registering boss {{id}} failed because the key {{key}} is invalid",
        ["#API_BossRegisterFailExists"]                     = "Registering boss {{id}} failed because an entry already exists with that id",
        ["#API_ClientMaybeNoContent"]                       = "It seems you may not have the Evil content pack \"{{name}}\" downloaded from the workshop. This will likely cause errors. We'll stop warning you on this server in case we're wrong",

        // tips
        ["#Tip"]                                            = "Tip: {{tip}}",
        ["#Tip_1"]                                          = "As a human, you can't hear the boss's footsteps",
        ["#Tip_2"]                                          = "If you find a lantern as a human, pick it up and place it somewhere to try and trick the boss",
        ["#Tip_3"]                                          = "Don't want these tips? Type /tips. You can also turn them back on the same way",
        ["#Tip_4"]                                          = "Keep an eye out for things on the ground when you're a human, they can help you",
        ["#Tip_5"]                                          = "{{{#PageNamePlural}}} can be in hard-to-see places, so always look carefully if you want to win as a human",
        ["#Tip_6"]                                          = "As a boss, you can hear your own footsteps, but humans can't hear them",
        ["#Tip_7"]                                          = "As a boss, you can't see the {{{l#PageNamePlural}}}, so don't think you can camp them",
        ["#Tip_8"]                                          = "As a boss, pay attention to lights. They may be a human's flashlight",
        ["#Tip_9"]                                          = "If you're dead, you can't communicate with the living. No cheating!",
        ["#Tip_10"]                                         = "Join the official Discord! Type \"/discord\"",
        ["#Tip_11"]                                         = "You can type \"/ghost\" if you're dead and explore the map without interfering",
        ["#Tip_12"]                                         = "As a spectator, you can use the \"/esp\" command to see all players and {{{l#PageNamePlural}}}!",
    },

    ru = {
        // generic things
        ["#Help"]                                           = "Помощь",
        ["#Exit"]                                           = "Выход",
        ["#Boss"]                                           = "Монстр",
        ["#Proxy"]                                          = "Мини-монстр",
        ["#Humans"]                                         = "Выживший",
        ["#Dead"]                                           = "Умер",
        ["#Player_Joined"]                                  = "{{name}} подключился",
        ["#Player_Left"]                                    = "{{name}} вышел ({{reason}})",
        ["#Player_Left_NoReason"]                           = "{{name}} отключился",
        ["#Collected"]                                      = "{{collected}} / {{total}} {{{#PageNamePlural}}} Собрал",
        ["#FirstTimeResources"]                             = "Похоже вы впервые играете на этом режиме! Советуем вам перезапустить Garry's mod,чтобы избежать ошибок!",
        ["#PageName"]                                       = "записку",
        ["#PageNamePlural"]                                 = "записки",

        // proxy
        ["#Accept"]                                         = "Принять",
        ["#Deny"]                                           = "Отклонить",
        ["#DontAsk"]                                        = "Проигнорировать",
        ["#CanBeProxy"]                                     = "Вы можете стать мини боссом",

        // updates
        ["#MajorUpdateAvailable"]                           = "Большое обновление теперь доступно! Ссылка: {{url}}",
        ["#MinorUpdateAvailable"]                           = "Небольшое обновление теперь доступно! Ссылка: {{url}}",
        ["#PatchUpdateAvailable"]                           = "A patch update for the gamemode is available! Visit {{url}}",
        ["#VersionCompare"]                                 = "Версия режима {{cur}} Последняя версия {{new}}",
        ["#UpToDate"]                                       = "У вас актуальная версия!",

        // commands
        ["#InvalidCommand"]                                 = "Эта команда не существует!",
        ["#Ghost_NotDead"]                                  = "Вы должны быть мертвым, чтобы стать призраком.",
        ["#Ghost_CantUse"]                                  = "Вы не можете стать призраком сейчас.",
        ["#Ghost_Disabled"]                                 = "Вы больше не призрак.",
        ["#Ghost_Enabled"]                                  = "Вы теперь призрак. Напишите повторно команду,чтобы выйти из данного режима.",

        // pointshop stuff
        ["#PS_BurtonOld"]                                   = "Adam Burton's pointshop was found, but is not version 8. Pointshop integration will not be loaded",
        ["#PS_CantBuyBeBoss"]                               = "You can't buy this since somebody else already has this round",
        ["#PS_AlreadyBeBoss"]                               = "You already bought this for next round",
        ["#PS_RefundedBeBoss"]                              = "An admin forcefully set someone to become the boss, so you have been refunded",

        // gui
        ["#YouAreBoss"]                                     = "Вас зовут: {{name}}!",
        ["#HowToAttack_A"]                                  = "Удерживайте ЛКМ,чтобы атаковать!",
        ["#HowToTaunt"]                                     = "Удерживайте {{key}} для фраз",
        ["#HowToAbility"]                                   = "ПКМ чтобы использовать способность!",
        ["#YouAreTheBoss"]                                  = "ВЫ МОНСТР",
        ["#FindTheHumans"]                                  = "НАЙДИТЕ ВЫЖИВШИХ",
        ["#AndKillThem"]                                    = "И УБЕЙТЕ ИХ ВСЕХ",
        ["#YouAreAHuman"]                                   = "ВЫ ВЫЖИВШИЙ",
        ["#CollectAllPages"]                                = "СОБЕРИТЕ ВСЕ {{count}} {{{u#PageNamePlural}}}",
        ["#AvoidTheEvil"]                                   = "ПЫТАЙТЕСБ ИЗБЕГАТЬ МОНСТРА",

        // map vote/map names
        ["#MapVote"]                                        = "Голосование! ({{secs}}s)",
        ["#MapVoteCanceled"]                                = "Смена карты отклонена админом",
        ["#ExtendWon"]                                      = "Карта будет продлена по результатам голосования!",
        ["#NewMapWon"]                                      = "Карта будет сменена на: {{map}}! Карта смениться после окончания раунда",
        ["#The_Forest"]                                     = "The Forest",
        ["#The_Ravine"]                                     = "The Ravine",
        ["#Underground"]                                    = "Underground",

        // round
        ["#Round_EndBossWin"]                               = "Монстр победил!",
        ["#Round_EndBossDie"]                               = "Монстр мистически умер!",
        ["#Round_EndPagesCollected"]                        = "Выжившие собрали все {{{l#PageNamePlural}}}!",
        ["#Round_EndTimeUp"]                                = "Время вышло! Монстр победил!",
        ["#Round_EndAdmin"]                                 = "Админ немедленно закончил раунд",
        ["#Round_WaitingForPlayers"]                        = "Ожидание игроков...",
        ["#Round_EndUnknown"]                               = "Игра окончена,по неизвестной причине... (likely manually)",
        ["#End_OnlyNSurvived"]                              = "Только {{count}} Выжили",
        ["#End_NSurvived"]                                  = "{{count}} Выжили",
        ["#End_NobodySurvived"]                             = "Все погибли...",
        ["#End_OnlySurvivor"]                               = "{{nick}} кто выжил!",
        ["#End_OnlyNDied"]                                  = "Только {{count}} Погибли",
        ["#End_NDied"]                                      = "{{count}} Умершие",
        ["#End_NobodyDied"]                                 = "Никто не погиб",
        ["#End_EveryoneDied"]                               = "Все были убиты",

        // special rounds
        ["#SR_AllAlone"]                                    = "Полное одиночество",
        ["#SR_AllAloneDesc"]                                = "Где все выжившие?",
        ["#SR_NightVision"]                                 = "Ночное зрение",
        ["#SR_NightVisionDesc"]                             = "Нет больше фонарика, только ночное зрение!",
        ["#SR_Countdown"]                                   = "А где время?",
        ["#SR_CountdownDesc"]                               = "Ваш счётчик времени пропал!",
        ["#SR_Realism"]                                     = "Реализм",
        ["#SR_RealismDesc"]                                 = "Ваш экран становиться полностью чистым",
        ["#SR_Deadline"]                                    = "Время смерти",
        ["#SR_DeadlineDesc"]                                = "Время не будет добавляться",
        ["#SR_Matrix"]                                      = "Матрица",
        ["#SR_MatrixDesc"]                                  = "{{{#PageNamePlural}}} Материализуется только тогда, когда вы находитесь в их диапазоне",
        ["#SR_Blindness"]                                   = "Слепота",
        ["#SR_BlindnessDesc"]                               = "Вы ничего не видите, если ваш фонарик не включен!",
        ["#SR_Wallhacks"]                                   = "Ренген зрение",
        ["#SR_WallhacksDesc"]                               = "Моснтра видно теперь через стены!",
        ["#SR_Earthquake"]                                  = "Землятрясение",
        ["#SR_EarthquakeDesc"]                              = "Земля начинается трястись,когда рядом с вами монстр!",
        ["#SR_DeathSwap"]                                   = "{{{#PageName}}} Замена",
        ["#SR_DeathSwapDesc"]                               = "Вас рандомно телепортирует,когда вы взяли {{{l#PageName}}}!",
        ["#SR_Mario"]                                       = "Марио",
        ["#SR_MarioDesc"]                                   = "Прыжок,Марио одобряет!",

        // gametype
        ["#Game_PageCollected"]                             = "{{player}} нашёл {{{l#PageName}}}!",
        ["#Deathmatch_EndTimeUp"]                           = "Время вышло! {{winners}} победа с  {{kills}} убийства!",
        ["#Deathmatch_EndTimeUpNone"]                       = "Время вышло! Почему-то никто не погиб!",
        ["#CollectPages"]                                   = "Собрать все {{count}} {{{l#PageNamePlural}}}",
        ["#StopHumansPages"]                                = "Остановить,когда выжившие нашли всё {{count}} {{{l#PageNamePlural}}}",

        // lang
        ["#InvalidLang"]                                    = "К сожаление ваш язык не поддерживается",
        ["#LangChanged"]                                    = "Язык успешно изменён",
        ["#NoLangSpecified"]                                = "Вам нужен специальный язык. (e.g. /lang en)",
        ["#LangGuess"]                                      = "Мы думаем вы из {{country}}, поэтому автоматически поменяли язык на {{lang}}",
        ["#LangGuessFail"]                                  = "Мы думаем вы из {{country}}, но мы не можем вам поменять язык {{lang}}. Но вы можете поменять язык так: \"/lang <language>\"",
        ["#LangObtainFail"]                                 = "Мы не могли угадать, откуда вы, поэтому вы установили язык сервера {{lang}}. Тип \"/lang <language>\" смените на ваш язык.",

        // spectator
        ["#Spec_Spectating"]                                = "Наблюдение",
        ["#Spec_HUDInfo"]                                   = "Нажмите {{key}} чтобы поменять с 1ого на 3ье лицо или наоборот",

        // ghost
        ["#Ghost_YouAreGhost"]                              = "Вы призрак",
        ["#Ghost_GhostInfo"]                                = "Команда /ghost чтобы выйти. Команда /esp чтобы наблюдать",

        // admin
        ["#Admin_MoreThanOneTarget"]                        = "Найдено более одной подходящей цели",
        ["#Admin_NoTargets"]                                = "Не найдено подходящих целей",
        ["#Admin_CantEnd"]                                  = "Раунд не может быть закончен",
        ["#Admin_TestingOn"]                                = "Тестовый режим включен",
        ["#Admin_TestingOff"]                               = "Тестовый режим выключен",
        ["#Admin_NextBossPlayer"]                           = "Следущий монстр кого выберет рандом {{name}}",
        ["#Admin_NextBoss"]                                 = "Следующий монстр {{boss}}",
        ["#Admin_BossChoices"]                              = "Монстр выбран: {{bosslist}}",
        ["#Admin_NextSR"]                                   = "Следуюший специальный раунд: {{round}}",
        ["#Admin_SRChoices"]                                = "Доступные специальные раунды: {{roundlist}}",

        // server shit
        ["#NoReasonGiven"]                                  = "Причина не дана",
        ["#ServerLocked"]                                   = "Этот сервер был заблокирован из-за большой ошибки: {{error}}",
        ["#ServerNoContent"]                                = "Evil Content Pack {{num}} не установлен. Это вызовет большие проблемы!",
        ["#ClientNoContent"]                                = "Вы потеряли Evil Content Pack {{num}}. Пожалуйста установите контент,для устранения ошибок!",

        // afk
        ["#AFK_Marked"]                                     = "Вы AFK: {{sec}}секунд до вашего исключения из сервера!",
        ["#AFK_Clear"]                                      = "Вы вышли из AFK режима",

        // collectables
        ["#Clock_Collect"]                                  = "{{name}} собрал часы! 60 секунд добавлено как дополнительное время!",
        ["#Skull_NoPlayers"]                                = "Нет возможности воскресить выжившего...",
        ["#Skull_Revive"]                                   = "{{name}} собран Ритуальный Череп! Случайный игрок воскрешён",
        ["#Bible_Collect"]                                  = "Вы подобрали Библию,она вас спасёт от одного удара Монстра!",
        ["#Bible_Used"]                                     = "Монстр напал на вас,но к счастью господь бог спас вас",
        ["#Jesus"]                                          = "Иисус",
        ["#Bible_JesusBro"]                                 = "Не беспокойся мой друг,я займусь этим грешником!",
        ["#Lantern_Destroy"]                                = "Нажмите {{button}} чтобы взять этот фонарь!",
        ["#Collectable_Lantern"]                            = "Киросиновая лампа",
        ["#Collectable_Lantern_Desc"]                       = "Излучает свет.Нажмите повторно,чтобы выбросить",
        ["#Collectable_Clock"]                              = "Часы",
        ["#Collectable_Clock_Desc"]                         = "Добавить 60 секунд к общему времени.",
        ["#Collectable_Flare"]                              = "Сигнальная ракетница",
        ["#Collectable_Flare_Desc"]                         = "С помощью ее вы можете отвлечь монстра или его замедлить",
        ["#Collectable_Bible"]                              = "Библия",
        ["#Collectable_Bible_Desc"]                         = "Спасёт вас от одной атаки монстра",
        ["#Collectable_NightVision"]                        = "Очки ночного виденья",
        ["#Collectable_NightVision_Desc"]                   = "Вы можете видеть в темноте",
        ["#Collectable_Soda"]                               = "Энергетик",
        ["#Collectable_Soda_Desc"]                          = "Даёт вам дополнительную скорость бега на время",
        ["#Collectable_Skull"]                              = "Ритуальный Череп",
        ["#Collectable_Skull_Desc"]                         = "Воскрешает рандомного игрока",
        ["#Collectable_PageDetector"]                       = "{{{#PageName}}} Детектор записок",
        ["#Collectable_PageDetector_Desc"]                  = "Помогает вам найти записки {{{l#PageNamePlural}}}",

        // abilities
        ["#Teleport"]                                       = "Телепорт", // unused
        ["#TeleportDesc"]                                   = "Телепортирует вас в случайное место", // unused
        ["#AbilityCooldown"]                                = "Вам надо подождать {{time}} секунд чтобы снова это использовать",
        ["#NextBottleExplosive"]                            = "Следущая бутылка - ВЗРЫВНАЯ!",

        // classes
        ["#YouAreClass"]                                    = "Ваш роль: {{name}}!",
        ["#YourName"]                                       = "Вас зовут: {{name}}!",
        ["#AlyxDesc"]                                       = "У вас +15% к скорости перемещения!",
        ["#MonkDesc"]                                       = "У вас -15% к скорости перемещения!",
        ["#BarneyDesc"]                                     = "У вас в два раза больше выносливости!",
        ["#KleinerDesc"]                                    = "Вы можете видеть одну записку {{{l#PageName}}} !",
        ["#EliDesc"]                                        = "Монстр всегда видит вас!",
        ["#SealTeamDesc"]                                   = "У вас есть очки ночного виденья!",
        ["#CitizenStat1"]                                   = "Директор Флоридской школы",
        ["#CitizenStat2"]                                   = "Любитель порисовать разные арты",
        ["#CitizenStat3"]                                   = "Чемпион по поеданию бургеров",
        ["#CitizenStat4"]                                   = "Котолюб",
        ["#CitizenStat5"]                                   = "Профессиональный баксетболист",
        ["#CitizenStat6"]                                   = "Любитель Аниме",
        ["#CitizenStat7"]                                   = "Посмтрел 2 сезона аниме за сутки,настоящий чемпион!",
        ["#CitizenStat8"]                                   = "Пользователь Линукс",
        ["#CitizenStat9"]                                   = "Просто рыбак",
        ["#CitizenStat10"]                                  = "Любитель обчистить твой холодильник",
        ["#CitizenStat11"]                                  = "Профессиональный охотник на школьниц",
        ["#CitizenStat12"]                                  = "Препод университета",
        ["#CitizenStat13"]                                  = "Независимый критик",
        ["#CitizenStat14"]                                  = "Машинист вагонетки",
        ["#CitizenStat15"]                                  = "Чемпион по спидрану Garry's mod",
        ["#CitizenStat16"]                                  = "Человек,который умрёт первым",
        ["#CitizenStat17"]                                  = "Профессиональный критик фастфуда",
        ["#CitizenStat18"]                                  = "Политик школы",
        ["#CitizenStat19"]                                  = "Работник Казахстана",
        ["#CitizenStat20"]                                  = "Любитель вкусно поесть",
        ["#CitizenStat21"]                                  = "Копатель могил",

        // api
        ["#API_BossRegisterFailKey"]                        = "Проверка монстра {{id}} неудачно зафиксирован {{key}} это не дейстивтелен",
        ["#API_BossRegisterFailExists"]                     = "Проверка монстра {{id}} не удалось, поскольку запись с таким идентификатором уже существует",
        ["#API_ClientMaybeNoContent"]                       = "У вас нет контента Evil Gamemode \"{{name}}\"Скачайте его с мастерской Стима,чтобы избежать различные баги или ошибки режима",

        // tips
        ["#Tip"]                                            = "Подсказка: {{tip}}",
        ["#Tip_1"]                                          = "Выжившие не слышат шаги монстра,но монстр их прекрасно слышит!",
        ["#Tip_2"]                                          = "Если вы найдёте киросиновую лампу,то используйте ее как приманку для монстра,выбросив её где-то!",
        ["#Tip_3"]                                          = "Вы не хотите видить эти подсказки? Команда: /tips. Вы можете их также включить через эту же команду!",
        ["#Tip_4"]                                          = "Смотрите чаще под ногами,вы можете найти полезные вещи для себя и других выживших!",
        ["#Tip_5"]                                          = "{{{#PageNamePlural}}} могут быть в труднодоступных местах,поэтому советуем вам быть более внимательным!",
        ["#Tip_6"]                                          = "Выжившие должны собрать 8 записек или 8 газовых балнов",
        ["#Tip_7"]                                          = "Монстр не может видеть {{{l#PageNamePlural}}}, так что не думайте что можете так их остановить!",
        ["#Tip_8"]                                          = "Монстрам следует обращать внимание на любой свет,там может быть выживший! ",
        ["#Tip_9"]                                          = "Когда вы мертвы,вы не можете общаться с живыми!",
        ["#Tip_10"]                                         = "Присоединяйтесь на наш канал в Дискорде! Команда: \"/discord\"",
        ["#Tip_11"]                                         = "Вы можете прописать команду: \"/ghost\" если вам не интересно наблюдать за игроками",
        ["#Tip_12"]                                         = "Наблюдатели могут использовать команду: \"/esp\" команда чтобы видеть всех игроков и записки/газовые балоны {{{l#PageNamePlural}}}!",
    },
}

function Lang:Add(lang, key, fmt)
    local t = Lang.Translations[lang]
    if not t then Lang.Translations[lang] = {} end

    if Lang.Translations[lang][key] then
        return Evil.Log(lang .. "." .. key .. " is extant")
    elseif isstring(fmt) then
        Lang.Translations[lang][key] = fmt
    end
end

function Lang:Override(lang, key, fmt)
    local t = Lang.Translations[lang]
    if not t then Lang.Translations[lang] = {} end

    Lang.Translations[lang][key] = fmt
end

function Lang:ExpandInline(text)
    if not text then return end

    local max = 0
    while true do
        max = max + 1
        if max > 10 then return text end
        local start, endpos, group = text:find("{{{(.*)}}}")
        if not group then return text end

        local split = group:Split("#")
        local mods, group = split[1], "#" .. split[2]

        local lang = Lang:Get(group)
        if lang then
            if mods:find("l") then
                lang = lang:lower()
            elseif mods:find("u") then
                lang = lang:upper()
            end
            text = text:sub(0, start - 1) .. lang .. text:sub(endpos + 1)
        end
    end
end

function Lang:Get(key)
    local ret = Lang.Translations[Lang.Locale][key]

    if not ret then
        ret = Lang.Translations["en"][key]
    end

    return Lang:ExpandInline(ret)
end

function Lang:Format(key, tab)
    local ret = Lang:Get(key)

    ret = Lang:ExpandInline(ret)

    for key, replacement in pairs(tab) do
        ret = string.Replace(ret, "{{" .. key .. "}}", replacement)
    end

    return ret
end

function Lang:GetAvailableLangs()
    return table.GetKeys(Lang.ISOToLang)
end

function Lang:GetTable()
    return Lang.Translations[Lang.Locale]
end
