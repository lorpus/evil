local PLAYER = FindMetaTable("Player")

Spec = Spec or {}

function Spec:GetValidTargetsFor(ply)
    local ret = {}
    for _, v in pairs(player.GetAll()) do
        if v == ply then continue end
        if not v:Alive() then continue end

        if v:IsHuman() then
            table.insert(ret, v)
        end
    end

    return ret
end

function PLAYER:IsSpectating()
    return self:GetNWBool("IsSpectating")
end
