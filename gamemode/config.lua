// this file is shared
AddCSLuaFile()

local configuration = {
    Debug = true,    // set to true to enable debugging and lots of verbosity

    Stamina = {
        maxstamina  = 100, // you shouldnt really need to change this
        loserate    = 1 / 5, // how fast to drain stamina while sprinting
        gainrate    = 1 / 4, // how fast to regain stamina when not sprinting
        runspeed    = 320,
        walkspeed   = 200
    },

    PlayerWalkspeed = 200,
    PlayerRunspeed  = 320
}

function ApplyConfiguration(tab)
    table.Merge(tab, configuration)
end
