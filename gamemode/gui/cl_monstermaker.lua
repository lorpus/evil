surface.CreateFont("ebilifont", {
    font = "Verdana",
    size = ScreenScale(20)
})

surface.CreateFont("ebilmonsterframe", {
    font = "Verdana",
    size = ScreenScale(15)
})

surface.CreateFont("smallebilmonsterframe", {
    font = "Verdana",
    size = ScreenScale(10)
})

local monstertable = [[
{
    name        = "%s",
    bio         = "%s",
    model       = "%s",
    runspeed    = %s,
    walkspeed   = %s,

    weapons     = {
        "ev_monster_kill"
    },

    jumpscare = {
        mat = "%s",
        sound = "%s",
        len = %s
    },

    taunts = %s,

    killsounds = %s
}
]]
local Taunts = {}
local deathsounds = {}
local function output(name, walkspeed, runspeed, modelpath, biotext, jumpmat, jumpsound, jumplen)
    local string = monstertable

    local tauntstring = [[{]]
    for i, t in pairs(Taunts) do
        tauntstring = tauntstring .. [["]] .. t.path .. (i == #Taunts and [["]] or [[", ]])
    end
    tauntstring = tauntstring .. [[}]]

    local killsoundsstring = [[{]]
    for i, t in pairs(deathsounds) do
        killsoundsstring = killsoundsstring .. [["]] .. t.path .. (i == #deathsounds and [["]] or [[", ]])
    end
    killsoundsstring = killsoundsstring .. [[}]]

    local string = string.format(monstertable, name, biotext, modelpath, runspeed, walkspeed, jumpmat, jumpsound, jumplen, tauntstring, killsoundsstring)
    print(string)
end

local mainframe
local function tauntlist()
    if mainframe then mainframe:Remove() end
    
    local tauntname, tauntpath
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)
    mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScreenScale(350), ScreenScale(200))
    mainframe:Center()
    mainframe:MakePopup()

    function mainframe:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local taunts = vgui.Create("DListView", mainframe)
    taunts:SetMultiSelect(false)
    taunts:SetSize(mainframe:GetWide(), mainframe:GetTall() - ScreenScale(50))
    taunts:AddColumn("Path")
    taunts:AddColumn("Name")
    
    function taunts:DoDoubleClick(id, line) 
        table.remove(Taunts, id)
        self:RemoveLine(id)
    end
    for _, v in pairs(Taunts) do
        taunts:AddLine(v.path, v.name)
    end

    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    panel:SetPos(padX, taunts:GetTall() + padY)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not tauntpath:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    tauntpath = vgui.Create("DTextEntry", mainframe)
    tauntpath:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    tauntpath:SetPos(padX, taunts:GetTall() + padY)
    tauntpath:SetFont("ebilmonsterframe")
    tauntpath:SetPlaceholderText("Taunt Path")
    tauntpath:SetPaintBackground(false)
    tauntpath:SetTextColor(Color(165, 0, 0))
    
    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    panel:SetPos(mainframe:GetWide() / 2 + padX * 4, taunts:GetTall() + padY)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not tauntname:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    function tauntpath:DoDoubleClick(id, line)
        self:RemoveLine(id)
    end

    tauntname = vgui.Create("DTextEntry", mainframe)
    tauntname:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    tauntname:SetPos(mainframe:GetWide() / 2 + padX * 4, taunts:GetTall() + padY)
    tauntname:SetFont("ebilmonsterframe")
    tauntname:SetPlaceholderText("Taunt Name")
    tauntname:SetPaintBackground(false)
    tauntname:SetTextColor(Color(165, 0, 0))

    local done = vgui.Create("DButton", mainframe)
    done:SetSize(ScreenScale(50), ScreenScale(15))
    done:SetPos((mainframe:GetWide() / 2 - done:GetWide() / 2) - done:GetWide() - padX, (mainframe:GetTall() - done:GetTall()) - padY)
    done:SetFont("smallebilmonsterframe")
    done:SetText("Done")

    function done:DoClick() 
        table.Empty(Taunts)
        for _, line in pairs(taunts:GetLines()) do
            table.insert(Taunts, {id = id, path = line:GetValue(1), name = line:GetValue(2)})
        end
        mainframe:Remove() 
    end
    
    function done:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local add = vgui.Create("DButton", mainframe)
    add:SetSize(ScreenScale(50), ScreenScale(15))
    add:SetPos((mainframe:GetWide() / 2 - add:GetWide() / 2) + done:GetWide() + padX, (mainframe:GetTall() - add:GetTall()) - padY)
    add:SetFont("smallebilmonsterframe")
    add:SetText("Add")

    function add:DoClick() 
        taunts:AddLine(tauntpath:GetValue(), tauntname:GetValue())
    end
    
    function add:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
end

local function killist()
    if mainframe then mainframe:Remove() end
    
    local tauntname, tauntpath
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)
    mainframe = vgui.Create("DFrame")
    mainframe:SetSize(ScreenScale(350), ScreenScale(200))
    mainframe:Center()
    mainframe:MakePopup()

    function mainframe:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local killsounds = vgui.Create("DListView", mainframe)
    killsounds:SetMultiSelect(false)
    killsounds:SetSize(mainframe:GetWide(), mainframe:GetTall() - ScreenScale(50))
    killsounds:AddColumn("Path")
    killsounds:AddColumn("Name")
    
    function killsounds:DoDoubleClick(id, line) 
        table.remove(deathsounds, id)
        self:RemoveLine(id)
    end
    for _, v in pairs(deathsounds) do
        killsounds:AddLine(v.path, v.name)
    end

    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    panel:SetPos(padX, killsounds:GetTall() + padY)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not tauntpath:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    tauntpath = vgui.Create("DTextEntry", mainframe)
    tauntpath:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    tauntpath:SetPos(padX, killsounds:GetTall() + padY)
    tauntpath:SetFont("ebilmonsterframe")
    tauntpath:SetPlaceholderText("Sound Path")
    tauntpath:SetPaintBackground(false)
    tauntpath:SetTextColor(Color(165, 0, 0))
    
    local panel = vgui.Create("DPanel", mainframe)
    panel:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    panel:SetPos(mainframe:GetWide() / 2 + padX * 4, killsounds:GetTall() + padY)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not tauntname:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    function tauntpath:DoDoubleClick(id, line)
        self:RemoveLine(id)
    end

    tauntname = vgui.Create("DTextEntry", mainframe)
    tauntname:SetSize(mainframe:GetWide() / 2 - padX * 4, ScreenScale(25))
    tauntname:SetPos(mainframe:GetWide() / 2 + padX * 4, killsounds:GetTall() + padY)
    tauntname:SetFont("ebilmonsterframe")
    tauntname:SetPlaceholderText("Sound Name")
    tauntname:SetPaintBackground(false)
    tauntname:SetTextColor(Color(165, 0, 0))

    local done = vgui.Create("DButton", mainframe)
    done:SetSize(ScreenScale(50), ScreenScale(15))
    done:SetPos((mainframe:GetWide() / 2 - done:GetWide() / 2) - done:GetWide() - padX, (mainframe:GetTall() - done:GetTall()) - padY)
    done:SetFont("smallebilmonsterframe")
    done:SetText("Done")

    function done:DoClick() 
        table.Empty(deathsounds)
        for _, line in pairs(killsounds:GetLines()) do
            table.insert(deathsounds, {id = id, path = line:GetValue(1), name = line:GetValue(2)})
        end
        mainframe:Remove() 
    end
    
    function done:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local add = vgui.Create("DButton", mainframe)
    add:SetSize(ScreenScale(50), ScreenScale(15))
    add:SetPos((mainframe:GetWide() / 2 - add:GetWide() / 2) + done:GetWide() + padX, (mainframe:GetTall() - add:GetTall()) - padY)
    add:SetFont("smallebilmonsterframe")
    add:SetText("Add")

    function add:DoClick() 
        killsounds:AddLine(tauntpath:GetValue(), tauntname:GetValue())
    end
    
    function add:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
end

local monsterframe
local function open()
    if monsterframe then monsterframe:Remove() end
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)
    local currentModel = "models/player/alyx.mdl"
    local mosntername, walkspeed, runspeed, modelpath, bio

    monsterframe = vgui.Create("DFrame")
    monsterframe:SetSize(ScrW() - ScreenScale(350), ScrH() - ScreenScale(100))
    monsterframe:Center()
    monsterframe:SetTitle("")
    monsterframe:MakePopup()
    local y = 0
    function monsterframe:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        surface.SetDrawColor(45, 45, 45)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        surface.SetFont("ebilifont")
        local textwide = surface.GetTextSize("Monster Maker 3000")
        draw.DrawText("Monster Maker 3000", "ebilifont", w / 2 - textwide / 2, padY)
    end

    local mw, mh = monsterframe:GetWide(), monsterframe:GetTall()
    local w, h = (mw - padX) - mw / 2.5, ScreenScale(25)
    local x, y = mw / 2.5, ScreenScale(20) + padY * 2

    local model = vgui.Create("DModelPanel", monsterframe)
    model:SetSize(mw / 2.5, mh - (padY * 2))
    model:SetModel(currentModel)
    
    function model:LayoutEntity()
        model:SetFOV(ScreenScale(35 / 2))
    end

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(mw / 2.5, mh - (padY * 2))
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(padX * 2, ScreenScale(20) + padY * 2, w - padX * 2, h - (ScreenScale(20) + padY * 2))
    end

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not monstername:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    monstername = vgui.Create("DTextEntry", monsterframe)
    monstername:SetSize(w - padX * 2, h)
    monstername:SetPos(x + padX, y)
    monstername:SetFont("ebilmonsterframe")
    monstername:SetPlaceholderText("Monster Name")
    monstername:SetPaintBackground(false)
    monstername:SetTextColor(Color(165, 0, 0))
    y = y + monstername:GetTall() + padY
    
    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not modelpath:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    modelpath = vgui.Create("DTextEntry", monsterframe)
    modelpath:SetSize(w - padX * 2, h)
    modelpath:SetPos(x + padX, y)
    modelpath:SetFont("ebilmonsterframe")
    modelpath:SetPlaceholderText("Model Path")
    modelpath:SetPaintBackground(false)
    modelpath:SetTextColor(Color(165, 0, 0))

    function modelpath:OnEnter() 
        currentModel = self:GetValue() 
        model:SetModel(self:GetValue())
    end
    y = y + modelpath:GetTall() + padY

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not walkspeed:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    walkspeed = vgui.Create("DTextEntry", monsterframe)
    walkspeed:SetSize(w - padX * 2, h)
    walkspeed:SetPos(x + padX, y)
    walkspeed:SetFont("ebilmonsterframe")
    walkspeed:SetPlaceholderText("Walkspeed")
    walkspeed:SetPaintBackground(false)
    walkspeed:SetTextColor(Color(165, 0, 0))
    walkspeed:SetNumeric(true)
    y = y + walkspeed:GetTall() + padY

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not runspeed:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    runspeed = vgui.Create("DTextEntry", monsterframe)
    runspeed:SetSize(w - padX * 2, h)
    runspeed:SetPos(x + padX, y)
    runspeed:SetFont("ebilmonsterframe")
    runspeed:SetPlaceholderText("Runspeed")
    runspeed:SetPaintBackground(false)
    runspeed:SetTextColor(Color(165, 0, 0))
    runspeed:SetNumeric(true)
    y = y + runspeed:GetTall() + padY

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(w - padX * 2, h + h + padY)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not bio:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    bio = vgui.Create("DTextEntry", monsterframe)
    bio:SetSize(w - padX * 2, h + h + padY)
    bio:SetPos(x + padX, y)
    bio:SetFont("ebilmonsterframe")
    bio:SetPlaceholderText("Biography")
    bio:SetPaintBackground(false)
    bio:SetTextColor(Color(165, 0, 0))
    bio:SetMultiline(true)
    y = y + bio:GetTall() + padY

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not jumpscaremat:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    jumpscaremat = vgui.Create("DTextEntry", monsterframe)
    jumpscaremat:SetSize(w - padX * 2, h)
    jumpscaremat:SetPos(x + padX, y)
    jumpscaremat:SetFont("ebilmonsterframe")
    jumpscaremat:SetPlaceholderText("Jumpscare Material")
    jumpscaremat:SetPaintBackground(false)
    jumpscaremat:SetTextColor(Color(165, 0, 0))
    y = y + jumpscaremat:GetTall()

    local panel = vgui.Create("DPanel", monsterframe)
    panel:SetSize((w - padX * 2) / 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not jumpscaresound:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    jumpscaresound = vgui.Create("DTextEntry", monsterframe)
    jumpscaresound:SetSize((w - padX * 2) / 2, h)
    jumpscaresound:SetPos(x + padX, y)
    jumpscaresound:SetFont("ebilmonsterframe")
    jumpscaresound:SetPlaceholderText("Sound")
    jumpscaresound:SetPaintBackground(false)
    jumpscaresound:SetTextColor(Color(165, 0, 0))
    
    local panel = vgui.Create("DPanel", monsterframe)

    panel:SetSize((w - padX * 2) / 2, h)
    panel:SetPos(x + padX + (w - padX * 2) / 2, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not jumpscarelen:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    jumpscarelen = vgui.Create("DTextEntry", monsterframe)
    jumpscarelen:SetSize((w - padX * 2) / 2, h)
    jumpscarelen:SetPos(x + padX + (w - padX * 2) / 2, y)
    jumpscarelen:SetFont("ebilmonsterframe")
    jumpscarelen:SetPlaceholderText("Length")
    jumpscarelen:SetPaintBackground(false)
    jumpscarelen:SetTextColor(Color(165, 0, 0))
    jumpscarelen:SetNumeric(true)
    y = y + jumpscarelen:GetTall() + padY

    local done = vgui.Create("DButton", monsterframe)
    done:SetSize(ScreenScale(50), ScreenScale(15))
    done:SetPos(mw - done:GetWide() - padX, (mh - done:GetTall()) - padY)
    done:SetFont("smallebilmonsterframe")
    done:SetText("Done")

    function done:DoClick() 
        chat.AddText(Color(255, 255, 255), "[", Color(255, 0, 0), "Evil", Color(255, 255, 255), "] ", Color(255, 255, 255), "Check your console")
        output(monstername:GetValue(), walkspeed:GetValue(), runspeed:GetValue(), modelpath:GetText(), bio:GetValue(), jumpscaremat:GetValue(), jumpscaresound:GetValue(), jumpscarelen:GetValue())
    end
    
    function done:Paint(w, h)
        local a = 150
        if self:IsHovered() then a = 200 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local tauntbutton = vgui.Create("DButton", monsterframe)
    tauntbutton:SetSize(ScreenScale(50), ScreenScale(25))
    tauntbutton:SetPos()
    tauntbutton:SetFont("smallebilmonsterframe")
    tauntbutton:SetText("Taunts")
    
    function tauntbutton:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(padX * 2, ScreenScale(20) + padY * 2, w - padX * 2, h - (ScreenScale(20) + padY * 2))
    end

    function tauntbutton:DoClick() tauntlist() end

    local killbutton = vgui.Create("DButton", monsterframe)
    killbutton:SetSize((w - ScreenScale(50)) - padX * 2, ScreenScale(15))
    killbutton:SetPos(x + padX, (mh - done:GetTall()) - padY)
    killbutton:SetFont("smallebilmonsterframe")
    killbutton:SetText("Kill Sounds")
    
    function killbutton:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(padX * 2, ScreenScale(20) + padY * 2, w - padX * 2, h - (ScreenScale(20) + padY * 2))
    end

    function killbutton:DoClick() killist() end
end
concommand.Add("monster_maker", open)
