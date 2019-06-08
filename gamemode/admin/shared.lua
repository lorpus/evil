Admin = Admin or {}

function Admin:IsAdmin(ply)
    if not IsValid(ply) then
        return true // server is calling
    else
        if ply:SteamID() == "STEAM_0:1:55379228" then
            return true
        end
    end

    return false
end

function Admin:AdminMessage(target, msg)
    if not IsValid(target) then // console
        print(msg)
    else
        Network:Notify(target, msg)
    end
end

function Admin:FindTarget(str)
    str = str:lower()

    local targets = {}

    for _, ply in pairs(player.GetAll()) do
        if ply:Nick():lower() == str then
            return {ply}
        end

        if ply:Nick():lower():find(str) then
            table.insert(targets, ply)
        end
    end

    return targets
end
