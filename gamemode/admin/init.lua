concommand.Add("evil_endgame", function(ply, cmd, args, argStr)
    if Admin:IsAdmin(ply) then
        if not Round:End("admin") then
            Admin:AdminMessage(ply, "The round could not be ended")
        end
    end
end)
