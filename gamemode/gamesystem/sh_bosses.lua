Evil.Bosses = {
    mrbones = { // referred to as profiles
        name        = "Mr. Bones", // display name of the boss
        bio         = "Spook the fleshy bone bois", // description/bio of the boss
        model       = "models/player/skeleton.mdl", // playermodel
        runspeed    = 350, // sprinting speed of the boss
        walkspeed   = 250, // walking speed of hte boss
        proximity_music = "evil/mrbones/monster_proximity2.mp3",

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

        proxy = {
            model = "models/player/skeleton.mdl", // required
            walkspeed = 250, // required
            runspeed = 250, // required

            killhook = function(victim)
                if SERVER then
                    victim:SetModel("models/player/skeleton.mdl")
                end
            end,

            weapons = {
                "ev_monster_kill"
            },

            taunts = {
                "evil/mrbones/proxy_ree.mp3", // this is an absolute mistake
            },

            tauntdisplay = {
                ["evil/mrbones/proxy_ree.mp3"] = "ree",
                ["evil/test"] = "bruh moment"
            },

            taunt_cooldown = 15,

            start = function(proxy)
                proxy.vProxyViewOffset = proxy:GetViewOffset()
                proxy.vProxyViewOffsetDucked = proxy:GetViewOffsetDucked()
                proxy:SetModelScale(0.4)
                proxy:SetViewOffset(proxy.vProxyViewOffset - Vector(0, 0, proxy.vProxyViewOffset.z * (1 - proxy:GetModelScale())))
                proxy:SetViewOffsetDucked(proxy.vProxyViewOffsetDucked - Vector(0, 0, proxy.vProxyViewOffsetDucked.z * (1 - proxy:GetModelScale())))
            end,

            finish = function(proxy)
                proxy:SetModelScale(1)
                proxy:SetViewOffset(proxy.vProxyViewOffset)
                proxy:SetViewOffsetDucked(proxy.vProxyViewOffsetDucked)
                proxy.vProxyViewOffset = nil
                proxy.vProxyViewOffsetDucked = nil
            end
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
            mat = "evil/scares/gman/scare1",
            sound = "evil/gman/jumpscare.mp3",
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

        jumpscare = {
            mat = "evil/scares/loli/bruhmoment",
            sound = "evil/loli/reee.mp3",
            len = 0.5
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
    },

    neckbeard = {
        name        = "Neckbeard Nick",
        bio         = "Certified NEET who has lived in his mother's basement for 12 years",
        model       = "models/player/neckbeard.mdl",
        runspeed    = 350,
        walkspeed   = 250,

        weapons = {
            "ev_monster_kill"
        },

        killhook = function(victim) // called when a player is killed
            if SERVER then
                victim:SetModel("models/pinkiepie.mdl")
            end
        end,

        jumpscare = {
            mat = "evil/scares/neckbeard/mlady",
            sound = "evil/neckbeard/reee.mp3",
            len = 1.96
        },

        /*proxy = {
            model = "models/pinkiepie.mdl",
            walkspeed = 270,
            runspeed = 320,

            weapons = {
                "ev_monster_kill"
            }
        },*/

        taunts = {
            "evil/neckbeard/bodypillow1.mp3",
            "evil/neckbeard/bodypillow2.mp3",
            "evil/neckbeard/katana.mp3",
            // "evil/neckbeard/maniac.mp3",
            "evil/neckbeard/stophittingme.mp3",
            "evil/neckbeard/waifu.mp3"
        },

        tauntdisplay = {
            ["evil/neckbeard/bodypillow1.mp3"] = "Let me show you my\nbody pillow collection",
            ["evil/neckbeard/bodypillow2.mp3"] = "I'm gonna turn\nyou into a body pillow!",
            ["evil/neckbeard/katana.mp3"] = "I wanna show you\nmy favorite katana!",
            ["evil/neckbeard/stophittingme.mp3"] = "Stop hitting me dad!",
            ["evil/neckbeard/waifu.mp3"] = "You're looking\na lot like my waifu"
        },

        killsounds = {
            "evil/neckbeard/uwu2.mp3",
            "evil/neckbeard/maniac.mp3"
        }
    },

    xenomorph = {
        name        = "Xenomorph",
        bio         = "",
        model       = "models/player/slow_alien.mdl",
        modelscale  = 1.3,
        runspeed    = 425,
        walkspeed   = 300,

        weapons = {
            "ev_monster_kill",
        },

        jumpscare = {
            mat = "evil/scares/xenomorph/xenscare",
            sound = "evil/xenomorph/scare.mp3",
            len = 39 / 30
        },

        taunts = {
            "evil/xenomorph/chatter1.mp3",
            "evil/xenomorph/chatter2.mp3",
            "evil/xenomorph/chatter3.mp3",
            "evil/xenomorph/growl1.mp3",
            "evil/xenomorph/growl2.mp3",
            "evil/xenomorph/growl3.mp3",
            "evil/xenomorph/hiss1.mp3",
            "evil/xenomorph/hiss2.mp3",
            "evil/xenomorph/hiss3.mp3",
            "evil/xenomorph/scream1.mp3",
        },
        
        tauntdisplay = {
            ["evil/xenomorph/chatter1.mp3"] = "Chatter 1",
            ["evil/xenomorph/chatter2.mp3"] = "Chatter 2",
            ["evil/xenomorph/chatter3.mp3"] = "Chatter 3",
            ["evil/xenomorph/growl1.mp3"] = "Growl 1",
            ["evil/xenomorph/growl2.mp3"] = "Growl 2",
            ["evil/xenomorph/growl3.mp3"] = "Growl 3",
            ["evil/xenomorph/hiss1.mp3"] = "Hiss 1",
            ["evil/xenomorph/hiss2.mp3"] = "Hiss 2",
            ["evil/xenomorph/hiss3.mp3"] = "Hiss 3",
            ["evil/xenomorph/scream1.mp3"] = "Scream",
        },

        killsounds = {
            "evil/xenomorph/attack1.mp3",
            "evil/xenomorph/attack2.mp3",
            "evil/xenomorph/scream2.mp3",
            "evil/xenomorph/scream3.mp3",
            "evil/xenomorph/scream4.mp3"
        },
    },

    greyman = {
        name        = "The Grey Man",
        bio         = "",
        model       = "models/lsd_de/simspy.mdl",
        runspeed    = 275,
        walkspeed   = 200,

        proximity_music = "evil/lsdman/monster_proximity2.mp3",
    
        think = function()
            local boss = Game:GetBoss()
            if not IsValid(boss) or not boss:Alive() then return end
            if not SERVER then return end
            for _, ent in pairs(ents.FindInSphere(boss:GetPos(), 192)) do
                if ent:IsPlayer() and ent:IsHuman() then
                    local d = DamageInfo()
					d:SetDamage(ent:Health())
					d:SetAttacker(boss)
					d:SetDamageType(DMG_DISSOLVE)

					ent:TakeDamageInfo(d)
                end
            end
        end
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
