if SERVER then
    resource.AddWorkshop("1897873115") // base content
    
    if not EVIL_BASE_CONTENT_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            Evil.Log(Lang:Format("#ServerNoContent", { num = "Base" }))
        end
    end
else
    if not EVIL_BASE_CONTENT_INSTALLED then
        Evil:AddTextChat(Lang:Format("#ClientNoContent", { num = "Base" }))
    end

    if not cookie.GetNumber("EvilHasPlayed") then
        Evil:AddTextChat(Lang:Get("#FirstTimeResources"))
        cookie.Set("EvilHasPlayed", "1")
    end
end
