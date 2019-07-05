eutil = eutil or {}

function eutil.Percent(p)
    return math.random() <= p
end

// outline system adopted from https://github.com/Facepunch/garrysmod/pull/1590

if not CLIENT then return end

OUTLINE_MODE_BOTH       = 0
OUTLINE_MODE_NOTVISIBLE = 1
OUTLINE_MODE_VISIBLE    = 2

local OutlineList, OutlineListSize = {}, 0
local RenderEnt = NULL

local OutlineMatSettings = {
    ["$ignorez"]    = 1,
    ["$alphatest"]  = 1
}

local CopyMat       = Material("pp/copy")
local OutlineMat    = CreateMaterial("OutlineMat", "UnlitGeneric", OutlineMatSettings)
local StoreTexture  = render.GetScreenEffectTexture(0)
local DrawTexture   = render.GetScreenEffectTexture(1)

local ENTS  = 1
local COLOR = 2
local MODE  = 3

function eutil.AddOutline(ents, color, mode)
    if OutlineListSize >= 255 then return end
    if not istable(ents) then ents = { ents } end
    if ents[1] == nil then return end

    local t = {
        [ENTS]  = ents,
        [COLOR] = color,
        [MODE]  = mode or OUTLINE_MODE_BOTH
    }
    table.insert(OutlineList, t)

    OutlineListSize = OutlineListSize + 1
end

local function RenderOutlines()
    local scene = render.GetRenderTarget()
    render.CopyRenderTargetToTexture(StoreTexture)

    local w = ScrW()
    local h = ScrH()

    render.Clear(0, 0, 0, 0, true, true)

    render.SetStencilEnable(true)
        cam.IgnoreZ(true)
        render.SuppressEngineLighting(true)

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)

        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilFailOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_REPLACE)
        render.SetStencilPassOperation(STENCIL_REPLACE)

        cam.Start3D()
            for i = 1, OutlineListSize do
                local v = OutlineList[i]
                local mode = v[MODE]
                local ents = v[ENTS]

                render.SetStencilReferenceValue(i)

                for j = 1, #ents do
                    local ent = ents[j]
                    if not IsValid(ent) then continue end

                    if (mode == OUTLINE_MODE_NOTVISIBLE and
                        LocalPlayer():IsLineOfSightClear(ent)) or
                        (mode == OUTLINE_MODE_VISIBLE and
                        not LocalPlayer():IsLineOfSightClear(ent)) then continue end

                    RenderEnt = ent

                    ent:DrawModel()
                end
            end

            RenderEnt = NULL
        cam.End3D()

        render.SetStencilCompareFunction(STENCIL_EQUAL)

        cam.Start2D()
            for i = 1, OutlineListSize do
				render.SetStencilReferenceValue(i)

				surface.SetDrawColor(OutlineList[i][COLOR])
				surface.DrawRect(0, 0, w, h)
			end
        cam.End2D()

        render.SuppressEngineLighting(false)
        cam.IgnoreZ(false)
    render.SetStencilEnable(false)

    render.CopyRenderTargetToTexture(DrawTexture)

    render.SetRenderTarget(scene)
	CopyMat:SetTexture("$basetexture", StoreTexture)
	render.SetMaterial(CopyMat)
	render.DrawScreenQuad()

	render.SetStencilEnable(true)
		render.SetStencilReferenceValue(0)
		render.SetStencilCompareFunction(STENCIL_EQUAL)

		OutlineMat:SetTexture( "$basetexture", DrawTexture )
		render.SetMaterial( OutlineMat )

		render.DrawScreenQuadEx(-1, -1, w ,h)
		render.DrawScreenQuadEx(-1, 0, w, h)
		render.DrawScreenQuadEx(-1, 1, w, h)
		render.DrawScreenQuadEx(0, -1, w, h)
		render.DrawScreenQuadEx(0, 1, w, h)
		render.DrawScreenQuadEx(1, 1, w, h)
		render.DrawScreenQuadEx(1, 0, w, h)
		render.DrawScreenQuadEx(1, 1, w, h)

	render.SetStencilEnable(false)
end

hook.Add("PostDrawEffects", "renderoutlines", function()
    hook.Run("PreDrawOutlines")
    if OutlineListSize == 0 then return end
    RenderOutlines()
    
    OutlineList = {}
    OutlineListSize = 0
end)
