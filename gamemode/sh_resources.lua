if SERVER then
    // resource.AddWorkshop("1780893440") // ecp 1
    resource.AddWorkshop("1885257980") // ebc

    /*if not EVIL_CONTENT_1_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            print(Lang:Format("#ServerNoContent", { num = "1" }))
        end
    end*/

    if not EVIL_BASE_CONTENT_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            Evil.Log(Lang:Format("#ServerNoContent", { num = "Base" }))
        end
    end
else // cli
    // placeholder
    /*if not EVIL_CONTENT_1_INSTALLED then
        Evil:AddTextChat(Lang:Format("#ClientNoContent", { num = "1" }))
    end*/

    if not EVIL_BASE_CONTENT_INSTALLED then
        Evil:AddTextChat(Lang:Format("#ClientNoContent", { num = "Base" }))
    end
end
