// so you can adapt maps to the gm even if theyre all bright and sunny
Ambience = Ambience or {
    Enabled = Map and Map.ambience
}

hook.Add("InitPostEntity", "Ambience", function()
    if not Ambience.Enabled then return end
    
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
    for i = 0, 63 do
        engine.LightStyle(i, "b")
    end
end)
