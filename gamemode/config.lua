// this file is shared
AddCSLuaFile()

local configuration = {
    Debug = true,    // set to true to enable debugging and lots of verbosity

    Defaults = { // all of the following keys are required, do not remove them but you can change them
    }
}

function ApplyConfiguration(tab)
    table.Merge(tab, configuration)
end
