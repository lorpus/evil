Evil.API = Evil.API or {
    Packs = {},
    PackFilter = {},
    DeferredPacks = {}
}

function Evil:RegisterPack(id, ws, callback)
    Evil.API.DeferredPacks[id] = { ws = ws, cb = callback }
end

function Evil:RegisterBoss(key, data)
    if not istable(data) then return end
    if Evil.Bosses[key] then
        return print(Lang:Format("#API_BossRegisterFailExists", { id = key }))
    end

    // check to make sure format of everything is right
    for _, v in ipairs({
        "string,name",      "string,model",
        "number,runspeed",  "number,walkspeed"
    }) do
        local x = string.Split(v, ",")
        if not _G["is" .. x[1]](data[x[2]]) then // this is what we call good code
            return print(Lang:Format("#API_BossRegisterFailKey", { id = key, key = x[2] }))
        end
    end

    for _, v in ipairs({
        "number,modelscale",    "string,round_music",
        "string,hands_model",   "table,weapons",
        "table,traits",         "string,ability",
        "function,killhook",    "function,think",
        "table,jumpscare",      "table,taunts",
        "table,tauntdisplay",   "table,killsounds",
        "table,proxy",          "bool,no_running_animation",
        "bool,stamina",         "string,intro",
    }) do
        local x = string.Split(v, ",")
        if data[x[2]] != nil and not _G["is" .. x[1]](data[x[2]]) then
            return print(Lang:Format("#API_BossRegisterFailKey", { id = key, key = x[2] }))
        end
    end

    Evil.Bosses[key] = data
    dbg.print("registering", key, "ok")
end
