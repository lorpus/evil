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
            "evil/mrbones/ache.mp3",
            "evil/mrbones/bonetopick.mp3",
            "evil/mrbones/howunpleasant.mp3",
            "evil/mrbones/suitcase.mp3"
        },

        tauntdisplay = {
            ["evil/mrbones/ache.mp3"] = "I ache to smash\nyou out of\nexistence!",
            ["evil/mrbones/suitcase.mp3"] = "I'll turn you\ninto a suitcase!",
            ["evil/mrbones/howunpleasant.mp3"] = "How unpleasant it\nis to see you, you\nsniveling coward!",
            ["evil/mrbones/bonetopick.mp3"] = "I've got a\nbone to pick\nwith you!",
        },

        killsounds = {
            "evil/mrbones/hmyaa.mp3",
        }
    },

    gman = {
        name        = "GMan",
        bio         = "Always watching, always lurking. Be mindful, he can be anywhere at anytime.",
        model       = "models/player/gman_high.mdl",
        runspeed    = 450,
        walkspeed   = 350,

        weapons     = {
            "ev_monster_kill"
        },

        jumpscare = {
            mat = "evil/scares/gman",
            sound = "evil/mrbones/scare1.mp3",
            len = 27 / 30
        },

        taunts = {
            "vo/Citadel/gman_exit01.wav", 
            "vo/Citadel/gman_exit10.wav", 
            "vo/Citadel/gman_exit04.wav", 
            "vo/Citadel/gman_exit03.wav", 
            "vo/Citadel/gman_exit02.wav", 
            "vo/gman_misc/gman_03.wav", 
            "vo/gman_misc/gman_04.wav", 
        },


        tauntdisplay = {
            ["vo/Citadel/gman_exit01.wav"] = "Time?", 
            ["vo/Citadel/gman_exit10.wav"] = "This is where\nI get off", 
            ["vo/Citadel/gman_exit04.wav"] = "Done a great\ndeal in a\nsmall timespan", 
            ["vo/Citadel/gman_exit03.wav"] = "Seems as if\nyou only just\n arrived", 
            ["vo/Citadel/gman_exit02.wav"] = "Is it really\nthat time again", 
            ["vo/gman_misc/gman_03.wav"] = "The right man\nin the wrong\nplace", 
            ["vo/gman_misc/gman_04.wav"] = "Wake up"
        },

        killsounds = {
            "vo/gman_misc/gman_riseshine.wav",
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

        tauntdisplay = {
            ["evil/loli/bulgywulgy.mp3"] = "I\nsee\na\nbulgy\nwulgy!",
            ["evil/loli/canthide.mp3"] = "You can run\nbut you\ncan't hide!",
            ["evil/loli/fun.mp3"] = "We're gonna have\nso much fun\ntogether!",
            ["evil/loli/maga.mp3"] = "Make America\nGreat Again! Awoo!", // im not proud of this
            ["evil/loli/nuzzle.mp3"] = "I'm\ngonna\nnuzzle\nyou to\ndeath\nwhen\nI find you!",
            ["evil/loli/playwithme.mp3"] = "Why don't you\nwant to\ncome\nplay\nwith me!",
            ["evil/loli/question06.mp3"] = "Sometimes,\nI dream about\ncheese.",
            ["evil/loli/senpai.mp3"] = "owo senpai, I'm\ncoming for you!", // or this one
            ["evil/loli/stophiding.mp3"] = "Stop trying\nto hide from me!",
            ["evil/loli/trap.mp3"] = "I'm not a trap,\nI promise!",
            ["evil/loli/yiff.mp3"] = "I'm gonna\nyiff you\nso hard\nyou won't\nknow what\nhit you!"
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
