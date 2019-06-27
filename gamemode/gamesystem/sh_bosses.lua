Evil.Bosses = {
    mrbones = { // referred to as profiles
        name        = "Mr. Bones", // display name of the boss
        bio         = "Spook the fleshy bone bois", // description/bio of the boss
        model       = "models/player/skeleton.mdl", // playermodel
        runspeed    = 350, // sprinting speed of the boss
        walkspeed   = 250, // walking speed of hte boss

        weapons     = { // what to give the boss
            "ev_monster_kill" // default insta-kill wep
        },

        killhook = function(victim) // called when a player is killed
            if SERVER then
                victim:SetModel("models/player/skeleton.mdl")
            end
        end,

        jumpscare = {
            mat = "evil/scares/mrbones/scare1",
            sound = "evil/mrbones/scare1.mp3",
            len = 27 / 30
        },

        taunts = {
            "evil/mrbones/ache.wav",
            "evil/mrbones/bone to pick1.wav",
            "evil/mrbones/bone to pick2.wav",
            "evil/mrbones/how unpleasant.wav",
            "evil/mrbones/suitcase.wav",
        },

        killsounds = {
            "evil/mrbones/hmyaa.wav",
        }
    },

    /*jeffthekiller = {
        name        = "Jeff The Killer",
        bio         = "A schizophrenic boy that doesn't play nicely. ",
        model       = "models/player/skeleton.mdl"
        runspeed    = 350,
        walkspeed   = 250,

        weapons     = {
            "ev_monster_kill"
        },

        killhook = function(victim)
            if SERVER then
                victim:SetModel("models/player/skeleton.mdl")
            end
        end,

        taunts = {
            "evil/jeff/bequiet.wav",
            "evil/jeff/find you.wav",
            "evil/jeff/sleep.wav",
            "evil/jeff/whats wrong.wav",
        }
    }*/
}
