local acid = {
    ["$pp_colour_brightness"]   = -0.04,
    ["$pp_colour_contrast"]     = 0.9,
    ["$pp_colour_colour"]       = 5
}

local function DrawLSD()
    DrawSharpen(3.11, 0.52)
    DrawColorModify(acid)
    DrawMaterialOverlay("effects/water_warp", -0.05)
    DrawMotionBlur(0.32, 0.5, 0.03)
end

hook.Add("RenderScreenspaceEffects", "EvilLSDEffect", function()
    if LocalPlayer():IsBoss() then return end
    if not Round:IsPlaying() then return end

    if Game:GetProfile() == "greyman" or LocalPlayer():GetNW2Bool("EvilLSD") then
        DrawLSD()
    end
end)
