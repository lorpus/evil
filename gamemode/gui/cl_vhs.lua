Evil.NoiseOpacity = CreateClientConVar("evil_vhs_noise_opacity", "150")

function Game:ShouldDrawVHS()
    local lp = LocalPlayer()
    if not IsValid(lp) then return false end
    if lp:IsBoss() or lp:IsProxy() then
        return false
    end

    return true
end

function Game:GetVHSRate()
	local smallDistortInterval = 5
	local smallDistort = 10
	local largeDistort = 50

	if not IsValid(LocalPlayer()) or not Round:IsPlaying() or not IsValid(Game:GetBoss()) then
		return smallDistortInterval, smallDistort, largeDistort
	end
	local distance = LocalPlayer():GetPos():Distance(Game:GetBoss():GetPos())
	local maxDistance = 2500
	local minDistance = 100
	local maxScale = 4
	local clamped = math.Clamp(distance, minDistance, maxDistance)
	local scale = (clamped - clamped * maxScale + maxDistance * maxScale - minDistance) / (maxDistance - minDistance)

	return math.max(smallDistortInterval / scale, 1.1), smallDistort * scale, (largeDistort / (scale ^ 2.16))
end

local noisemats = {}
for i = 1, 60 do
	local mat = ("evil/noise/%03d.png"):format(i)
	noisemats[i] = Material(mat)
	if noisemats[i]:IsError() then
		noisemats[i] = nil
	end
end

local NormalMats = { // explicit needed cuz mat has 2 return values
	[1] = Material("evil/vhs_norm_1"),
	[2] = Material("evil/vhs_norm_2"),
}

local curmat
local function GetDistortParams()
	local interval, small = Game:GetVHSRate()
	if SysTime() % interval > 1 then
		curmat = NormalMats[math.random(#NormalMats)]
		return
	end
	local var = util.SharedRandom("mat", 0, 100, SysTime() * 10)
	if var < small then
		return curmat, 0
	end
end

local shiftMat = Material("evil/vhs_norm_fullshift")
local doFullShift = false
local shiftOffset = 0
local shiftHeight = 0
local function GetFullShift()
	if doFullShift then
		return shiftMat, shiftOffset, shiftHeight
	end
end

timer.Create("CheckFullShift", 0.5, 0, function()
	local _, _, var = Game:GetVHSRate()
	local n = math.random(0, var)
	doFullShift = false
	if n == 0 then
		shiftHeight = math.random(0.2, 0.3)
		shiftOffset = math.random(0, ScrH() * 0.5)
		doFullShift = true
	end
end)

hook.Add("RenderScreenspaceEffects", "EvilRenderVHSGlitch", function()
	if not Game:ShouldDrawVHS() then return end

	render.UpdateScreenEffectTexture()
	local mat, yoffset = GetDistortParams()
	local rshiftMat, rshiftOffset, rshiftHeight = GetFullShift()

	if rshiftMat then
		rshiftMat:SetFloat("$envmap", 0)
		rshiftMat:SetFloat("$envmaptint", 0)
		rshiftMat:SetInt("$ignorez", 1)
		render.SetMaterial(rshiftMat)
		render.DrawScreenQuadEx(0, rshiftOffset, ScrW(), ScrH() * rshiftHeight)
	end

	if mat then
		mat:SetFloat("$envmap", 0)
		mat:SetFloat("$envmaptint", 0)
		mat:SetInt("$ignorez", 1)
		render.SetMaterial(mat)
		render.DrawScreenQuadEx(0, yoffset, ScrW(), ScrH())
	end
end)

local i = 1
hook.Add("DrawOverlay", "EvilRenderVHSNoise", function()
	if not Game:ShouldDrawVHS() then return end

	if i > 60 then i = 1 end
	if not noisemats[i] then return end
	surface.SetMaterial(noisemats[i])
	surface.SetDrawColor(255, 255, 255, Evil.NoiseOpacity:GetInt())
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	i = i + 1
end)

timer.Create("EvilPlayStatic", 0.1, 0, function()
	local lp = LocalPlayer()

	local shouldPlay = Round:IsPlaying() and IsValid(lp) and IsValid(Game:GetBoss()) and not lp:IsBoss() and lp:GetPos():Distance(Game:GetBoss():GetPos()) < 600

	if not Evil._StaticPlaying and shouldPlay then
		Evil._StaticPlaying = true
		sound.PlayFile("sound/evil/static.mp3", "", function(chan, errnum, errid)
			if not IsValid(chan) then
				Evil._StaticPlaying = false
				return dbg.print("error playing static", errnum, errid)
			end

			Evil._StaticAudioChannel = chan
			chan:SetVolume(0)
		end)
	elseif IsValid(Evil._StaticAudioChannel) then
		if not shouldPlay then
			Evil._StaticAudioChannel:Stop()
			Evil._StaticAudioChannel = nil
			Evil._StaticPlaying = false
		else
			Evil._StaticAudioChannel:SetVolume(math.Approach(Evil._StaticAudioChannel:GetVolume(), 1, 0.01))
		end
	end
end)
