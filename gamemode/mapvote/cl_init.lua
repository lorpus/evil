local function open(MapTable)
    if MapVote then MapVote:Remove() end

    MapVote = vgui.Create("DFrame")
    MapVote:SetSize(ScrW() / 1.5, ScrH() / 1.2)
    MapVote:Center()
    MapVote:SetDraggable(false)
    MapVote:SetTitle("")
    MapVote:MakePopup()
    MapVote:ShowCloseButton(false)

    function MapVote:Paint(w, h)
        Derma_DrawBackgroundBlur(self)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        surface.SetDrawColor(40, 40, 40)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    
    local choices = {}

    local padX, padY = ScreenScale(5), ScreenScale(5)
    local w, h = MapVote:GetWide() - padX * 2, (MapVote:GetTall() - padY * 4) / 4
    local y = padY
    for i=1, 4 do
        local panel = vgui.Create("DPanel", MapVote)
        panel:SetSize(w, h - (i == 4 and padY or 0))
        panel:SetPos(padX, y)
        panel.clicked = false
        
        local MapMat = Material(MapTable.path)
        function panel:Paint(w, h)
            if i == 1 then 
                draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
                return
            end

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(MapMat)
            surface.DrawTexturedRect(0, 0, w, h)
            if panel.clicked then
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 100))
            end
        end

        if i != 1 then 
            local button = vgui.Create("DButton", MapVote)
            button:SetSize(w, h - (i == 4 and padY or 0))
            button:SetPos(padX, y)
            button:SetText("")
            function button:Paint() end
            function button:DoClick() panel.clicked = !panel.clicked end
        end
        
        y = y + h + padY
        if i == 1 then continue end

        table.insert(choices, {main = panel, button = button})
    end

end
//open({{map = "The Forest", path = "mapvote/theforest.png"}, {map = "The Forest", path = "mapvote/theforest.png"}, map = "The Forest", path = "mapvote/theforest.png"})