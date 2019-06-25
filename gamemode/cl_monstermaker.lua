surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(20)
})

local function open()
    if mainframe then mainframe:Remove() end
    local currentModel = "models/player/alyx.mdl"
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)

    mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScrW() - ScreenScale(350), ScrH() - ScreenScale(100))
    mainframe:Center()
    mainframe:SetTitle("")
    mainframe:MakePopup()
    
    function mainframe:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        surface.SetDrawColor(45, 45, 45)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        surface.SetFont("ebilfont")
        local textwide, textheight = surface.GetTextSize("Monster Maker 3000")
        draw.DrawText("Monster Maker 3000", "ebilfont", w / 2 - textwide / 2, padY)
    end

    local mw, mh = mainframe:GetWide(), mainframe:GetTall()

    local monstername = vgui.Create("DTextEntry", mainframe)

    local model = vgui.Create("DModelPanel", mainframe)
    model:SetSize(mw / 2.5, mh - (padY * 2))
    model:SetModel(currentModel)
    
    function model:LayoutEntity()
        model:SetFOV(ScreenScale(35 / 2))
    end

    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(mw / 2.5, mh - (padY * 2))
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(padX * 2, (padY * 2) + ScreenScale(20), w - padX * 2, (h - (padY * 2)) - ScreenScale(20))
    end
end
concommand.Add("monster_maker", open)
open()