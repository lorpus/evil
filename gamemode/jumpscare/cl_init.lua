local drawing
function Jumpscare:Scare(data)
    if data.mat then
        Jumpscare.Running = data
        drawing = Material(data.mat)
        drawing:SetFloat("$frame", 0)

        timer.Simple(data.len or 2, function()
            Jumpscare.Running = nil
            drawing = nil
        end)
    end

    if data.sound then
        local delay = data.sound_delay or 0
        timer.Simple(delay, function()
            // rip ForceMaxVolume
            surface.PlaySound(data.sound)
        end)
    end
end

function Jumpscare:NetReceive()
    local data = Jumpscare:GetJumpscare()
    if istable(data) then
        Jumpscare:Scare(data)
    end
end

hook.Add("DrawOverlay", "DrawJumpscare", function()
    if Jumpscare.Running and drawing then
        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(drawing)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end
end)

for _, v in pairs(Evil.Bosses) do
    if v.jumpscare then
        util.PrecacheSound(v.jumpscare.sound)
    end
end
