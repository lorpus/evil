if SERVER then
    resource.AddWorkshop("1780893440")

    if not EVIL_CONTENT_1_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            print("Evil Content Pack 1 is NOT installed. This can cause big problems!")
        end
    end
else // cli
    // placeholder
    if not EVIL_CONTENT_1_INSTALLED then
        Evil:AddTextChat("You are missing Evil Content Pack 1. Please install it to get the f u l l experience")
    end
end
