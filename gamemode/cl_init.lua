include("shared.lua")

function GM:ChatText(index, name, text, mtype)
    if mtype == "joinleave" then return true end
end
