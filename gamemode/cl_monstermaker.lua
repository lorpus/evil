surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(20)
})

surface.CreateFont("ebilmonstermaker", {
    font = "Verdana",
    size = ScreenScale(15)
})

local function open()
    if mainframe then mainframe:Remove() end
    local currentModel = "models/player/alyx.mdl"
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)
    local mosntername, walkspeed, runspeed, modelpath

    mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScrW() - ScreenScale(350), ScrH() - ScreenScale(100))
    mainframe:Center()
    mainframe:SetTitle("")
    mainframe:MakePopup()
    local y = 0
    function mainframe:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        surface.SetDrawColor(45, 45, 45)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        surface.SetFont("ebilfont")
        local textwide = surface.GetTextSize("Monster Maker 3000")
        draw.DrawText("Monster Maker 3000", "ebilfont", w / 2 - textwide / 2, padY)
    end

    local mw, mh = mainframe:GetWide(), mainframe:GetTall()
    local w, h = (mw - padX) - mw / 2.5, ScreenScale(25)
    local x, y = mw / 2.5, ScreenScale(20) + padY * 2

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
        surface.DrawOutlinedRect(padX * 2, ScreenScale(20) + padY * 2, w - padX * 2, h - (ScreenScale(20) + padY * 2))
    end

    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not monstername:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    monstername = vgui.Create("DTextEntry", mainframe)
    monstername:SetSize(w - padX * 2, h)
    monstername:SetPos(x + padX, y)
    monstername:SetFont("ebilmonstermaker")
    monstername:SetPlaceholderText("Monster Name")
    monstername:SetPaintBackground(false)
    monstername:SetTextColor(Color(165, 0, 0))
    y = y + monstername:GetTall() + padY
    
    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    y = y + monstername:GetTall() + padY
end
concommand.Add("monster_maker", open)
