// so you can adapt maps to the gm even if theyre all bright and sunny
Ambience = Ambience or {
    Enabled = Map and Map.ambience
}

if SERVER then
    hook.Add("InitPostEntity", "Ambience", function()
        if not Ambience.Enabled then return end
        
        game.ConsoleCommand("sv_skyname painted\n")

        local skypaint = ents.FindByClass("env_skypaint")[1]
        if not IsValid(skypaint) then
            skypaint = ents.Create("env_skypaint")
            skypaint:Spawn()
        end

        Ambience.Sky = skypaint
        Ambience.Sky:SetTopColor(Vector(0, 0, 0))
        Ambience.Sky:SetBottomColor(Vector(0, 0, 0))
        Ambience.Sky:SetDuskScale(0)
        Ambience.Sky:SetDuskIntensity(0)

        for i = 0, 63 do
            engine.LightStyle(i, "b")
        end
    end)

    hook.Add("PostCleanupMap", "AmbienceLighting", function()
        if not Ambience.Enabled then return end
        for i = 0, 63 do
            engine.LightStyle(i, "b")
        end
    end)
else
    local function renderfog(skybox)
        if Map.extra_ambience then
            render.FogStart(1)
            render.FogMode(MATERIAL_FOG_LINEAR)
            render.FogEnd(2)
            if isnumber(Map.extra_ambience) then
                render.FogMaxDensity(Map.extra_ambience)
            else
                render.FogMaxDensity(0.95)
            end
            render.FogColor(0, 0, 0)
            
            return true
        end
    end
    hook.Add("SetupWorldFog", "EvilAmbienceFog", renderfog)
    hook.Add("SetupSkyBox",   "EvilAmbienceFog", renderfog)
end
