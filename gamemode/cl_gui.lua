surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})

surface.CreateFont("beteterebilfont", {
    font = "Verdana",
    size = ScreenScale(20)
})

surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(20)
})


function guitest()
    local sw, sh = ScrW(), ScrH()
    frame = vgui.Create("DFrame")
    frame:SetSize(sw, sh)
    frame:SetDraggable(false)
    frame:SetTitle("")
    frame:MakePopup()
    function frame:Paint(w, h)
        draw.RoundedBox(1, 0, 0, w, h, Color(0, 0, 0))

        // shittitle
        local txt = "EBILIEST GAME THERE EVER WAS DERP :333 oWo"
        surface.SetFont("beteterebilfont")
        local TxtW, TxtH = surface.GetTextSize("EBILIEST GAME THERE EVER WAS DERP :333 oWo")
        draw.DrawText(txt, "beteterebilfont", w/2 - TxtW/2, 0, color_white)
    end
end

hook.Add("HUDPaint", "OnloadGUIInit", function()
    hook.Remove("HUDPaint", "OnloadGUIInit")
    if frame then frame:Remove() end
    guitest()
end)

concommand.Add("rmtest", function()
    frame:Remove()
end)
