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

hook.Add("EvilPostBossSetup", "EvilClientBossSetup", function(key, ply)
	local info = Evil.Bosses[key]
	dbg.print(LocalPlayer(), ply, LocalPlayer() == ply)
	if info.modelscale and LocalPlayer() != ply then // no serverside so no collisions, no localplayer so no glitchy shit
		dbg.print(ply, info.modelscale)
		timer.Simple(1, function()
			ply:SetModelScale(info.modelscale)
		end)
	end
end)

hook.Add("RoundSet", "FixModelShit", function(round)
	if round == ROUND_PLAYING then return end
	dbg.print(round)
	for _, ply in pairs(player.GetAll()) do
		ply:SetModelScale(1)
	end
end)

hook.Add("EvilPlayerKilled", "OnPlayerKilled", function(victim)
    local info = Game:GetProfileInfo()
    if info.killhook then
        info.killhook(victim)
    end
end)

// should this be in a diff file ?

hook.Add("PostDrawOpaqueRenderables", "EvilBossESP", function()
    local pos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10
    local ang = LocalPlayer():EyeAngles()
    ang = Angle(ang.p + 90, ang.y, 0)

    for _, ply in pairs(player.GetAll()) do
        if not ply:GetNW2Bool("EvilForceESP") and not Game:CanESP(LocalPlayer(), ply) then continue end

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
			ply:DrawModel()
			render.SetBlend(1)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			cam.Start3D2D(pos, ang, 1)
				local hp = (ply:Health() / ply:GetMaxHealth()) * 255
				surface.SetDrawColor(255 - hp, hp, 0)
				surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
			cam.End3D2D()
			ply:DrawModel()

			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			ply:DrawModel()
		render.SetStencilEnable(false)
    end
end)
