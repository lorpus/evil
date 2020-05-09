Evil.DrawSpecESP = CreateClientConVar("evil_draw_spec_esp", "0", true, false, "Draw ESP on pages and players while spectator or ghost")
Evil.UseAltESP = CreateClientConVar("evil_use_alt_esp", "1", true, false, "Use alternative method of drawing ESP for an FPS boost")

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

local LocalPlayer = LocalPlayer
local Angle = Angle
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetBlend = render.SetBlend
local ipairs = ipairs
local cam_Start3D2D = cam.Start3D2D
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local cam_End3D2D = cam.End3D2D
function Game:DrawESP(enttab)
    local pos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10
    local ang = LocalPlayer():EyeAngles()
    ang = Angle(ang.p + 90, ang.y, 0)

    render_ClearStencil()
    render_SetStencilEnable(true)
        render_SetStencilWriteMask(255)
        render_SetStencilTestMask(255)
        render_SetStencilReferenceValue(1)
        render_SetStencilFailOperation(STENCILOPERATION_KEEP)
        render_SetStencilZFailOperation(STENCILOPERATION_REPLACE)
        render_SetStencilPassOperation(STENCILOPERATION_KEEP)
        render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render_SetBlend(0)
        for _, v in ipairs(enttab) do
            v:DrawModel()
        end    
        render_SetBlend(1)
        render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        cam_Start3D2D(pos, ang, 1)
            surface_SetDrawColor(0, 255, 0)
            surface_DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
        cam_End3D2D()
        //ent:DrawModel()

        render_SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        //ent:DrawModel()
    render_SetStencilEnable(false)
end

function Game:CanSeeEntityWithESP(ent)
    if ent:IsPlayer() and ent:Alive() then
        if true then return true end
        if (LocalPlayer():IsGhost() or LocalPlayer():IsSpectating()) and Evil.DrawSpecESP:GetBool() then
            return true
        end

        if not (ent:GetNW2Bool("EvilForceESP") and LocalPlayer():IsBoss()) and not Game:CanESP(LocalPlayer(), ent) then return false end

        return true
    elseif ent:GetClass() == "evil_page" then
        if (LocalPlayer():IsGhost() or LocalPlayer():IsSpectating()) and Evil.DrawSpecESP:GetBool() then
            return true
        end
    end

    return false
end

hook.Add("PostDrawOpaqueRenderables", "EvilESP", function(bDepth, bSkybox)
    if bSkybox then return end

    local tab = {}

    for _, ent in ipairs(ents.GetAll()) do
        if Game:CanSeeEntityWithESP(ent) then
            if Evil.UseAltESP:GetBool() and ent:IsPlayer() then continue end
            table.insert(tab, ent)
        end
    end

    Game:DrawESP(tab)
end)

local espMaterial = CreateMaterial("somethingwtf", "VertexLitGeneric", {
 	["$basetexture"] = "color/white",
  	["$model"] = 1,
 	["$translucent"] = 1,
 	["$vertexalpha"] = 1,
 	["$vertexcolor"] = 1,
 	["$ignorez"] = 1,
})

hook.Add("PrePlayerDraw", "EvilESPAlt", function(ply)
    if not Evil.UseAltESP:GetBool() then return end
    if Game:CanSeeEntityWithESP(ply) then
        ply.bColorMod = true
        cam.IgnoreZ(true)
        render.SuppressEngineLighting(true)
        render.SetColorModulation(0, 1, 0)
        render.ModelMaterialOverride(espMaterial)
    end
end)

hook.Add("PostPlayerDraw", "EvilESPAlt", function(ply)
    if not Evil.UseAltESP:GetBool() then return end
    if ply.bColorMod then
        render.ModelMaterialOverride()
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)
        cam.IgnoreZ(false)
        ply.bColorMod = false
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
