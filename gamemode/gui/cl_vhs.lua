Evil.NoiseOpacity = CreateClientConVar("evil_vhs_noise_opacity", "150")

function Game:ShouldDrawVHS()
    local lp = LocalPlayer()
    if not IsValid(lp) then return false end
    if lp:IsBoss() or lp:IsProxy() then
        return false
    end

    return true
end

local noisemats = {}
for i = 1, 60 do
	local mat = ("evil/noise/%03d.png"):format(i)
	noisemats[i] = Material(mat)
end

local NormalMats = { // explicit needed cuz mat has 2 return values
	[1] = Material("evil/vhs_norm_1"),
	[2] = Material("evil/vhs_norm_2"),
}

local curmat
local function GetDistortParams()
	if SysTime() % 5 > 1 then
		curmat = NormalMats[math.random(#NormalMats)]
		return
	end
	local var = util.SharedRandom("mat", 0, 100, SysTime() * 10)
	if var < 10 then
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
	local n = math.random(0, 50)
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
	surface.SetMaterial(noisemats[i])
	surface.SetDrawColor(255, 255, 255, Evil.NoiseOpacity:GetInt())
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	i = i + 1
end)
