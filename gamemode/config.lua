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
        UseProjectedTexture = true // uses the ProjectedTexture flashlight instead of the DynamicLight flashlight
    },

    PlayerWalkspeed = 200,
    PlayerRunspeed  = 320
}

function ApplyConfiguration(tab)
    table.Merge(tab, configuration)
end
