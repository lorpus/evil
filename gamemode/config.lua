// this file is shared
AddCSLuaFile()

local configuration = {
    Debug = true,    // set to true to enable debugging and lots of verbosity

    MainMenu = {
        TitleText = "Evil",
        HelpText = "Placeholder\nPlaceholder\nPlaceholder"        
    },

    Stamina = {
        maxstamina  = 100, // you shouldnt really need to change this
        loserate    = 1 / 5, // how fast to drain stamina while sprinting
        gainrate    = 1 / 4, // how fast to regain stamina when not sprinting
        runspeed    = 320, // the speed the player should have when sprinting if they have stamina
        walkspeed   = 200, // the speed the player should have when sprinting if they don't have stamina
        normaljump  = 160, // the jump power the player should have when they have stamina
        staminajump = 80, // the jump power the player should have when they don't have stamina
        jumplosestamina = 5 // how much stamina the player should lose on jump
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
    AFKKickDelay    = 12, // when flagged, the player will be kicked after this amount of time if they dont move

    VoiceDistance = 768, // how far away players are audible
}

function ApplyConfiguration(tab)
    table.Merge(tab, configuration)
end
