surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})

surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(20)
})

function guitest()
    
end

hook.Add("HUDPaint", "OnloadGUIInit", function()
    hook.Remove("HUDPaint", "OnloadGUIInit")
    if frame then frame:Remove() end
    guitest()
end)

concommand.Add("rmtest", function()
    frame:Remove()
end)
