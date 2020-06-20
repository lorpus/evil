local ws = Evil.Cfg.DownloadMethod == "workshop" or not Evil.Cfg.DownloadMethod
local fastdl = Evil.Cfg.DownloadMethod == "fastdl"
if SERVER then
    if ws then
        resource.AddWorkshop("1897873115") // base content
    elseif fastdl and EVIL_BASE_RESOURCE_LIST then
        for _, v in ipairs(EVIL_BASE_RESOURCE_LIST) do
            resource.AddFile(v)
        end
    end

    if not EVIL_BASE_CONTENT_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            Evil.Log(Lang:Format("#ServerNoContent", { num = "Base" }))
        end
    end
else
    if ws and not EVIL_BASE_CONTENT_INSTALLED then
        Evil:AddTextChat(Lang:Format("#ClientNoContent", { num = "Base" }))
    end

    if not cookie.GetNumber("EvilHasPlayed") then
        timer.Simple(10, function()
            Evil:AddTextChat(Lang:Get("#FirstTimeResources"))
        end)
        cookie.Set("EvilHasPlayed", "1")
    end
end
