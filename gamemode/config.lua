// this file is shared
AddCSLuaFile()

local configuration = {
    Debug = true,    // set to true to enable debugging and lots of verbosity

    PlayerWalkspeed = 200,
    PlayerRunspeed  = 320
}

function ApplyConfiguration(tab)
    table.Merge(tab, configuration)
end
