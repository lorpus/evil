// this file is shared
AddCSLuaFile()

local configuration = {
    Debug = true,    // set to true to enable debugging and lots of verbosity

    ServerLanguage = "en",

    DisableAFK = true,

    MainMenu = {
        TitleText = "Evil",
        HelpText = "Placeholder\nPlaceholder\nPlaceholder"        
    },

    Collectables = {
        Odds = {
            OP = { // count
                [0] = 0.15,
                [1] = 0.65,
                [2] = 0.15,
            },

            Normal = {
                [1    ] = 0.25,
                [2 / 3] = 0.45,
                [1 / 2] = 0.20,
                [1 / 4] = 0.1,
            }
        }
    },

    MapVote = {
        Disable = true,
        Time = 30, // seconds for the map vote to last
        RoundsPerVote = 5, // how many rounds should occur before asking to vote for map

        MapInfo = {
            ["evil_forest"] = { // filename of the map (no .bsp)
                img = "evil/mapvote/slender_forest.png", // optional png file to draw
                lang = "#The_Forest", // language entry to display
                fallback = "The Forest" // fallback text if language entry doesn't exist
            },

            ["slender_ravine"] = {
                img = "evil/mapvote/slender_ravine.png",
                lang = "#The_Ravine",
                fallback = "The Ravine",
            }
        }
    },

    Stamina = {
        maxstamina  = 100, // you shouldnt really need to change this
        loserate    = 1 / 5, // how fast to drain stamina while sprinting
        gainrate    = 1 / 4, // how fast to regain stamina when not sprinting
        runspeed    = 320, // the speed the player should have when sprinting if they have stamina
        walkspeed   = 200, // the speed the player should have when sprinting if they don't have stamina
        normaljump  = 160, // the jump power the player should have when they have stamina
        staminajump = 80, // the jump power the player should have when they don't have stamina
        jumplosestamina = 5, // how much stamina the player should lose on jump
        gainwait = 2.5, // how long before stamina starts recharging
    },

    Flashlight = {
        UseProjectedTexture = true, // uses the ProjectedTexture flashlight instead of the DynamicLight flashlight
        FlashlightDistance = 1024, // ProjectedTexture only: where the ProjectedTexture ends
        FizzleChance = 0.0001, // probability of a players flashlight flickering out
        FlashlightSize = 60 // FOV of the flashlight for projected texture lights
    },

    PlayerWalkspeed = 200,
    PlayerRunspeed  = 320,
    TauntCooldown   = 5,

    AFKKickTime     = 300, // if a player hasnt moved in this amount of seconds, theyll be flagged as afk and eventually kicked
    AFKKickDelay    = 30, // when flagged, the player will be kicked after this amount of time if they dont move

    ProxyAskInterval = 45, // how many seconds between asking players to become proxy

    VoiceDistance = 768, // how far away players are audible
}

function ApplyConfiguration(tab)
    table.Merge(tab, configuration)
end
