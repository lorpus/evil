Evil.DrawSpecESP = CreateClientConVar("evil_draw_spec_esp", "0", true, false, "Draw ESP on pages and players while spectator or ghost")

local bossMusicChannel // map cleanup invalidates this i think!!11
function Game:StartBossProximityMusic(snd)
    sound.PlayFile("sound/" .. snd, "3d", function(chan, errId, errName)
        if errId then
            dbg.print(string.format("play file failed! %s - %s", errId, errName))
        end

        if IsValid(chan) then
            bossMusicChannel = chan
            bossMusicChannel:Set3DFadeDistance(640, 3500)
            bossMusicChannel:EnableLooping(true)
            bossMusicChannel:Play()
        end
    end)
end

hook.Add("Think", "EvilUpdateBossMusic", function()
    if IsValid(bossMusicChannel) and IsValid(Game:GetBoss()) then
        if not Game:GetBoss():Alive() then
            return bossMusicChannel:Stop()
        end

        bossMusicChannel:SetPos(Game:GetBoss():GetPos())
    end
end)

gameevent.Listen("player_spawn")
hook.Add("player_spawn", "EvilPlayerSpawnClient", function(data)
    timer.Simple(1, function() // gay
        local ply = Player(data.userid)
        if ply == LocalPlayer() then
            local profile = Game:GetProfileInfo()
            if profile and profile.hands_model then
                local hands = LocalPlayer():GetHands()
                if IsValid(hands) then
                    hands:SetModel(profile.hands_model)
                end
            end
        end
    end)
end)

hook.Add("CalcView", "cameraview", function(ply, vOrigin, qAngles, flFov, flZnear, flZfar)
    if Round:IsWaiting() then
        local iCamera = math.floor(CurTime() / 15 % #Map.cameras) + 1
        local oCam = Map.cameras[iCamera]
        return {
            origin = oCam.pos,
            angles = oCam.ang
        }
    end
end)

local function EvilClientBossSetup(key, ply)
    local info = Evil.Bosses[key]
    if not info then return timer.Simple(0, function() EvilClientBossSetup(key, ply) end) end
    dbg.print(LocalPlayer(), ply, LocalPlayer() == ply)
    if info.modelscale and LocalPlayer() != ply then // no serverside so no collisions, no localplayer so no glitchy shit
        dbg.print(ply, info.modelscale)
        timer.Simple(1, function()
            if IsValid(ply) then
                ply:SetModelScale(info.modelscale)
            end
        end)
    end

    if info.intro then
        surface.PlaySound(info.intro)
    end
end
hook.Add("EvilPostBossSetup", "EvilClientBossSetup", EvilClientBossSetup)

hook.Add("RoundSet", "FixModelShit", function(round)
    if round == ROUND_PLAYING then return end
    dbg.print(round)
    for _, ply in pairs(player.GetAll()) do
        ply:SetModelScale(1)
    end
end)

hook.Add("EvilPlayerKilled", "OnPlayerKilled", function(victim)
    local info = Game:GetProfileInfo()
    if istable(info) and info.killhook then
        info.killhook(victim)
    end
end)

hook.Add("RunGTFunc", "EvilRunGametypeFunc", function(key, func, ...)
    local info = Game.Gametypes[key]
    if istable(info) and isfunction(info[func]) then
        info[func](...)
    end
end)

// should this be in a diff file ?

function Game:DrawESP(ent)
    local pos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10
    local ang = LocalPlayer():EyeAngles()
    ang = Angle(ang.p + 90, ang.y, 0)

    render.ClearStencil()
    render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(1)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetBlend(0)
        ent:DrawModel()
        render.SetBlend(1)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        cam.Start3D2D(pos, ang, 1)
            surface.SetDrawColor(0, 255, 0)
            surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
        cam.End3D2D()
        ent:DrawModel()

        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        ent:DrawModel()
    render.SetStencilEnable(false)
end

hook.Add("PostDrawOpaqueRenderables", "EvilESP", function()
    local ang = LocalPlayer():EyeAngles()
    ang = Angle(ang.p + 90, ang.y, 0)

    for _, ent in ipairs(ents.GetAll()) do // findbyclass enumerates over this, so its faster to just do it once
        if ent:IsPlayer() and ent:Alive() then
            if (LocalPlayer():IsGhost() or LocalPlayer():IsSpectating()) and Evil.DrawSpecESP:GetBool() then
                Game:DrawESP(ent)
                continue
            end

            if not (ent:GetNW2Bool("EvilForceESP") and LocalPlayer():IsBoss()) and not Game:CanESP(LocalPlayer(), ent) then continue end

            Game:DrawESP(ent)
        elseif ent:GetClass() == "evil_page" then
            if (LocalPlayer():IsGhost() or LocalPlayer():IsSpectating()) and Evil.DrawSpecESP:GetBool() then
                Game:DrawESP(ent)
            end
        end
    end
end)

hook.Add("PrePlayerDraw", "EvilHideGhosts", function(ply)
    if not LocalPlayer():IsGhost() and ply:IsGhost() then
        return true
    end
end)

timer.Create("EvilDrawBossBlips", 10, 0, function()
    if LocalPlayer():IsBoss() and Game:CanBossSeePlayers() then
        for _, ply in ipairs(Game:GetHumans()) do
            eutil.AddBlip(ply:GetPos() + Vector(0, 0, 36))
        end
    end
end)
