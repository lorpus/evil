eutil = eutil or {}

function eutil.Percent(p)
    return math.random() <= p
end

function eutil.PRNS(kv, fallback)
    local max = 0
    for _, prob in pairs(kv) do
        max = max + (prob or fallback)
    end
    local p = math.random() * max
    for result, prob in pairs(kv) do
        if p < prob then return result end
        p = p - prob
    end
end

function eutil.NewlineText(str, count)
    local lines = {}
    local words = {}
    local chars = 0
    for _, word in pairs(string.Explode(" ", str, false)) do
        chars = chars + string.len(word)
        if chars >= count then
            table.insert(lines, table.concat(words, " "))
            words = {}
            chars = 0
        end

        table.insert(words, word)
    end

    if #words != 0 then
        table.insert(lines, table.concat(words, " "))
    end

    return table.concat(lines, "\n")
end

local isChatOpen = false
hook.Add("StartChat", "eutilTrackChat", function()
    isChatOpen = true
end)
hook.Add("FinishChat", "eutilTrackChat", function()
    isChatOpen = false
end)
function eutil.IsChatOpen()
    return isChatOpen
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

        OutlineMat:SetTexture("$basetexture", DrawTexture)
        render.SetMaterial(OutlineMat)

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

local BlipPos = {}
local BlipDel = {}
local BlipID = 1

function eutil.AddBlip(vector)
    BlipPos[BlipID] = { v = vector, s = RealTime() }
    BlipID = BlipID + 1
end

hook.Add("HUDPaint", "EvilRenderBlips", function()
    local maxrad = ScreenScale(9)
    for k, v in pairs(BlipPos) do
        if not BlipDel[k] then BlipDel[k] = {} end
        if BlipDel[k][1] /*and BlipDel[k][2] and BlipDel[k][3]*/ then
            BlipDel[k] = {}
            table.remove(BlipPos, k)
        end

        local ts = v.v:ToScreen()
        //for i = 1, 3 do
            local r = math.pow(5, RealTime() - v.s - 1 /* -i + 1 */)
            local op = (maxrad - r) / maxrad * 5
            if op < 0 then
                BlipDel[k][1 /* i */] = true
                continue
            end
            surface.DrawCircle(ts.x, ts.y, r, 20, 225, 20, op)
        //end
    end
end)
