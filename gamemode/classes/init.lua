function Classes:SetPlayerClass(ply, class)
    ply:SetNW2String("EvilClass", class)
    local info = Classes.Classes[class]
    local model = info.model
    if istable(model) then model = model[math.random(#model)] end
    ply:SetModel(model)
    Network:Notify(ply, "#YouAreClass", true, { name = info.name })
    Network:Notify(ply, info.desc, info.desc:StartWith("#"))

    ply:SetNW2String("ClassName", info.name)

    hook.Run("EvilSetClass", ply, class)
    Network:SendHook("EvilSetClass", ply, class)
end

local takenclasses = {}
function Classes:SetupRandomClass(ply)
    local key
    for k, v in RandomPairs(Classes.Classes) do
        if not takenclasses[k] then
            if isfunction(v.canset) then
                if not v.canset(ply) then continue end
            end

            key = k
            break
        end
    end
    if not key then return false end
    takenclasses[key] = true
    Classes:SetPlayerClass(ply, key)

    return true
end

function Classes:MakeCitizen(ply)
    local name
    if ply:GetModel():lower():find("male") then
        name = Classes.CitizenNames.m[math.random(#Classes.CitizenNames.m)]
    else
        name = Classes.CitizenNames.f[math.random(#Classes.CitizenNames.f)]
    end
    name = name .. " " .. Classes.CitizenNames.last[math.random(#Classes.CitizenNames.last)]
    ply:SetNW2String("ClassName", name)
    Network:SendHook("EvilClassCitizen", ply, name) // desc only shows up to the single client so it doesnt matter
end

function Classes:HandlePlayer(ply)
    if eutil.Percent(0.33) then
        if not Classes:SetupRandomClass(ply) then
            Classes:MakeCitizen(ply)
        end
    else
        Classes:MakeCitizen(ply)
    end
end

function Classes:ClearPlayerClass(ply)
    local class = ply:GetNW2String("EvilClass")
    ply:SetNW2String("EvilClass", "")

    if not class then return end
    takenclasses[class] = nil
    local info = Classes.Classes[class]
    if not info then return end

    hook.Run("EvilClearClass", ply, class)
    Network:SendHook("EvilClearClass", ply, class)
end

hook.Add("RoundSet", "EvilClassesClearTaken", function(round)
    if round == ROUND_POST then
        takenclasses = {}
    end
end)
