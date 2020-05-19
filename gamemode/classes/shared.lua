Classes = Classes or {}

Classes.CitizenStats = {
    "#CitizenStat1",
    "#CitizenStat2",
    "#CitizenStat3",
    "#CitizenStat4",
    "#CitizenStat5",
    "#CitizenStat6",
    "#CitizenStat7",
    "#CitizenStat8",
    "#CitizenStat9",
    "#CitizenStat10",
    "#CitizenStat11",
    "#CitizenStat12",
    "#CitizenStat13",
    "#CitizenStat14",
    "#CitizenStat15",
    "#CitizenStat16",
    "#CitizenStat17",
    "#CitizenStat18",
    "#CitizenStat19",
    "#CitizenStat20",
    "#CitizenStat21",
}

Classes.CitizenNames = {
    m = {
        "John", "Edward", "Karl", "Frank", "Muhammad", "Austin", "Jacob", "Lloyd", "Clint",
        "Fred", "Richard", "George", "Peter", "James", "Jason", "Timmy", "Kyle", "Keith",
        "Jose", "Walter", "Chad", "Bruce", "Marcel", "Leonard", "Ronald", "Louis", "David",
        "Trapper", "Garry", "Mark", "Glenn", "Thomas", "Alvaro", "Josiah", "Ben", "Albert",
        "Tyrone", "Ming", "Jamal", "Ryan", "Logan", "Kerf", "Gabriel", "Gonzo", "Jack", "Pedro",
        "Sheen", "Parker", "Thor", "Ken", "Alex", "DJ", "Tony"
    },

    f = {
        "Barbara", "Mary", "Peggy", "Kerry", "Christina", "Rebecca", "Judy", "Hilary", "Precious", "Asia",
        "Pearl", "Cheryl", "Debbie", "Heather", "Jasmine", "Sarah", "Nidia", "Monica", "Elizabeth", "Lucy",
        "Alycia", "Anna", "Nancy", "Morgan", "Amanda", "Rose", "Tamara", "Anna", "Gretchen", "Veronica",
        "Layal", "Emma", "Lydia", "Candy", "Samantha", "Kelsi", "Ruth", "Margaret", "Juliana", "Donna", "Robin",
    },

    last = {
        "Miller", "Trump", "Kelloway", "Kermuffin", "Roseberry", "Powell", "Fielder", "Wallace", "Hamilton", "Bootski",
        "Werbenjagermanjensen", "Sanders", "Elijah", "Makiej", "Slinkard", "Pierce", "Goodman", "Hunter", "Jenner", "Rock",
        "Grant", "Conley", "Kardashian", "Wysong", "Timmons", "Smith", "Johnson", "Gooch", "Garcia", "Biddle",
        "Weinstein", "Black", "Eichelberger", "Shekelberg", "Nelson", "Cook", "Christian", "Mantooth", "Wood", "Epstein",
        "Coffee", "Martin", "Worthington", "Aldrin", "Davis", "Zhou", "Nguyen", "Wong", "Chan", "Tang", "Powers", "Shitsworth",
        "Schumer", "Salameh",
    },
}

Classes.Classes = {
    alyx = {
        name    = "Alyx",
        desc    = "#AlyxDesc",
        model   = "models/player/alyx.mdl",

        speed   = 15,

        apply   = function(ply)
            timer.Simple(0.1, function()
                ply:SetWalkSpeed(Evil.Cfg.PlayerWalkspeed + Classes.Classes.alyx.speed)
                ply:SetRunSpeed (Evil.Cfg.PlayerRunspeed  + Classes.Classes.alyx.speed)
            end)
        end,
    },

    monk = {
        name    = "Monk",
        desc    = "#MonkDesc",
        model   = "models/player/monk.mdl",

        speed   = -15,

        apply   = function(ply)
            timer.Simple(0.1, function()
                ply:SetWalkSpeed(Evil.Cfg.PlayerWalkspeed + Classes.Classes.monk.speed)
                ply:SetRunSpeed (Evil.Cfg.PlayerRunspeed  + Classes.Classes.monk.speed)
            end)
        end,
    },

    barney = {
        name    = "Barney",
        desc    = "#BarneyDesc",
        model   = "models/player/barney.mdl",

        apply   = function(ply)
            hook.Add("PlayerStaminaScale", "EvilClassWTF_" .. tostring(ply), function(p)
                if ply == p then
                    return 0.5
                end
            end)
        end,

        remove  = function(ply)
            hook.Remove("PlayerStaminaScale", "EvilClassWTF_" .. tostring(ply))
        end,
    },

    kleiner = {
        name    = "Kleiner",
        desc    = "#KleinerDesc",
        model   = "models/player/kleiner.mdl",

        apply   = function(ply)
            if SERVER then return end
            hook.Add("PostDrawOpaqueRenderables", ply, function()
                local page = ents.FindByClass("evil_page")[1]
                if IsValid(page) then
                    Game:DrawESP({page})
                end
            end)
        end,

        remove = function(ply)
            if SERVER then return end
            hook.Remove("PostDrawOpaqueRenderables", ply)
        end,
    },

    eli = {
        name    = "Eli",
        desc    = "#EliDesc",
        model   = "models/player/eli.mdl",

        apply   = function(ply)
            if not SERVER then return end
            ply:SetNW2Bool("EvilForceESP", true)
        end,

        remove  = function(ply)
            if not SERVER then return end
            ply:SetNW2Bool("EvilForceESP", false)
        end,

        canset  = function(ply)
            return #player.GetAll() > 5
        end,
    },

    sealteam = {
        name    = "A Seal Team member",
        desc    = "#SealTeamDesc",
        model   = {
            "models/player/riot.mdl",
            "models/player/swat.mdl",
            "models/player/urban.mdl",
        },

        apply   = function(ply)
            if not SERVER then return end
            ply:SetNW2Bool("EvilNightVision", true)
        end,

        remove  = function(ply)
            if not SERVER then return end
            ply:SetNW2Bool("EvilNightVision", false)
        end,
    }
}

hook.Add("EvilSetClass", "EvilApplyClass", function(ply, key)
    if CLIENT then
        if ply != LocalPlayer() then return end
    end

    local info = Classes.Classes[key]
    if isfunction(info.apply) then
        info.apply(ply)
    end
end)

hook.Add("EvilClearClass", "EvilRemoveClass", function(ply, key)
    if CLIENT then
        if ply != LocalPlayer() then return end
    end

    local info = Classes.Classes[key]
    if isfunction(info.remove) then
        info.remove(ply)
    end
end)

hook.Add("StaminaWalkspeed", "EvilClassWalkspeeds", function(ply, walkspeed)
    local class = ply:GetNW2String("EvilClass", nil)
    if not class then return end
    local info = Classes.Classes[class]
    if not info then return end

    if info.speed then
        return walkspeed + info.speed
    end
end)

hook.Add("StaminaRunspeed", "EvilClassRunspeeds", function(ply, runspeed)
    local class = ply:GetNW2String("EvilClass", nil)
    if not class then return end
    local info = Classes.Classes[class]
    if not info then return end

    if info.speed then
        return runspeed + info.speed
    end
end)
