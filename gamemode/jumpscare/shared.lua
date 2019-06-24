Jumpscare = Jumpscare or {}

function Jumpscare:GetJumpscare()
    local info = Game:GetProfileInfo()
    if info and info.jumpscare then
        return info.jumpscare
    end
end
