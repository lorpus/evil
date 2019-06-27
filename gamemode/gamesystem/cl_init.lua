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

hook.Add("EvilPlayerKilled", "OnPlayerKilled", function(victim)
    local info = Game:GetProfileInfo()
    if info.killhook then
        info.killhook(victim)
    end
end)

// should this be in a diff file ?

hook.Add("PostDrawOpaqueRenderables", "EvilBossESP", function()
    if not LocalPlayer():IsBoss() then return end

    local pos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10
    local ang = LocalPlayer():EyeAngles()
    ang = Angle(ang.p + 90, ang.y, 0)

    for _, ply in pairs(player.GetAll()) do
        if not ply:IsHuman() then continue end
		if not ply:Alive() then continue end
        if not ply:GetNW2Bool("EvilForceESP") and not Game:CanESP() then continue end

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
