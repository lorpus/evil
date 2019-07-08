if SERVER then
    resource.AddWorkshop("1780893440")

    if not EVIL_CONTENT_1_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            print(Lang:Format("#ServerNoContent", { num = "1" }))
        end
    end
else // cli
    // placeholder
    if not EVIL_CONTENT_1_INSTALLED then
        Evil:AddTextChat(Lang:Format("#ClientNoContent", { num = "1" }))
    end
end
