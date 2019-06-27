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

    loli = {
        name        = "Loli",
        bio         = "unused",
        model       = "models/jazzmcfly/kantai/nt/nt.mdl",
        hands_model = "models/jazzmcfly/kantai/nt/c_arms/nt.mdl",
        runspeed    = 350,
        walkspeed   = 250,

        weapons     = {
            "ev_monster_kill"
        },

        taunts = {
            "evil/loli/bulgywulgy.mp3",
            "evil/loli/canthide.mp3",
            "evil/loli/fun.mp3",
            "evil/loli/maga.mp3",
            "evil/loli/nuzzle.mp3",
            "evil/loli/playwithme.mp3",
            "evil/loli/question06.mp3",
            "evil/loli/senpai.mp3",
            "evil/loli/stophiding.mp3",
            "evil/loli/trap.mp3",
            "evil/loli/yiff.mp3"
        },

        killsounds = {
            "evil/loli/gotyou.mp3",
            "evil/loli/noescape.mp3",
            "evil/loli/thereyouare.mp3",
            "evil/loli/rawr.mp3",
            "evil/loli/uwu.mp3",
        }
    }

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
