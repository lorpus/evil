function Classes:SetPlayerClass(ply, class)
    ply:SetNW2String("EvilClass", class)
    local info = Classes.Classes[class]
    local model = info.model
    if istable(model) then model = model[math.random(#model)] end
    ply:SetModel(model)
    Network:Notify(ply, "#YouAreClass", true, { name = info.name })
    Network:Notify(ply, info.desc, info.desc:StartWith("#"))

    hook.Run("EvilSetClass", ply, class)
    Network:SendHook("EvilSetClass", ply, class)
end

local takenclasses = {}
function Classes:SetupRandomClass(ply)
    local key
    for k, v in RandomPairs(Classes.Classes) do
        if not takenclasses[k] then
            key = k
            break
        end
    end
    takenclasses[key] = true
    Classes:SetPlayerClass(ply, key)
end

function Classes:HandlePlayer(ply)
    if eutil.Percent(0.33) then
        Classes:SetupRandomClass(ply)
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
