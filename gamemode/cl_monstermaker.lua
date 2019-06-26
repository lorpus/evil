surface.CreateFont("ebilifont", {
    font = "Verdana",
    size = ScreenScale(20)
})

surface.CreateFont("ebilmonstermaker", {
    font = "Verdana",
    size = ScreenScale(15)
})

surface.CreateFont("smallebilmonstermaker", {
    font = "Verdana",
    size = ScreenScale(10)
})

local monstertable = [[
{
    name        = "%s", // display name of the boss
    bio         = "%s", // description/bio of the boss
    model       = "%s", // playermodel
    runspeed    = %s, // sprinting speed of the boss
    walkspeed   = %s, // walking speed of hte boss

    weapons     = { // what to give the boss
        "ev_monster_kill" // default insta-kill wep
    },

    killhook = function(victim) // called when a player is killed
        if SERVER then
            victim:SetModel("models/player/skeleton.mdl")
        end
    end,

    jumpscare = {
        mat = "%s",
        sound = "%s",
        len = %s
    }

    taunts = %s
}
]]
local Taunts = {}
local function output(name, walkspeed, runspeed, modelpath, biotext, jumpmat, jumpsound, jumplen)
    local string = monstertable
    local tauntstring = [[{]]
    for i, t in pairs(Taunts) do
        tauntstring = tauntstring .. [["]] .. t.path .. (i == #Taunts and "" or [[", ]])
    end
    tauntstring = tauntstring .. [[}]]
    local string = string.format(monstertable, name, biotext, modelpath, runspeed, walkspeed, jumpmat, jumpsound, jumplen, tauntstring)
    print(string)
end

local function tauntlist()
    if TauntFrame then TauntFrame:Remove() end
    
    local tauntvolume, tauntpath
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)
    TauntFrame = vgui.Create("DFrame")
    TauntFrame:SetSize(ScreenScale(350), ScreenScale(200))
    TauntFrame:Center()
    TauntFrame:MakePopup()

    function TauntFrame:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local taunts = vgui.Create("DListView", TauntFrame)
    taunts:SetMultiSelect(false)
    taunts:SetSize(TauntFrame:GetWide(), TauntFrame:GetTall() - ScreenScale(50))
    taunts:AddColumn("Path")
    taunts:AddColumn("Volume")
    
    function taunts:DoDoubleClick(id, line) 
        table.remove(Taunts, id)
        self:RemoveLine(id)
    end
    for _, v in pairs(Taunts) do
        taunts:AddLine(v.path, v.volume)
    end

    local panel = vgui.Create("DPanel", TauntFrame)
    panel:SetSize(TauntFrame:GetWide() / 2 - padX * 4, ScreenScale(25))
    panel:SetPos(padX, taunts:GetTall() + padY)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not tauntpath:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    tauntpath = vgui.Create("DTextEntry", TauntFrame)
    tauntpath:SetSize(TauntFrame:GetWide() / 2 - padX * 4, ScreenScale(25))
    tauntpath:SetPos(padX, taunts:GetTall() + padY)
    tauntpath:SetFont("ebilmonstermaker")
    tauntpath:SetPlaceholderText("Taunt Path")
    tauntpath:SetPaintBackground(false)
    tauntpath:SetTextColor(Color(165, 0, 0))
    
    local panel = vgui.Create("DPanel", TauntFrame)
    panel:SetSize(TauntFrame:GetWide() / 2 - padX * 4, ScreenScale(25))
    panel:SetPos(TauntFrame:GetWide() / 2 + padX * 4, taunts:GetTall() + padY)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not tauntvolume:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    function tauntpath:DoDoubleClick(id, line)
        self:RemoveLine(id)
    end

    tauntvolume = vgui.Create("DTextEntry", TauntFrame)
    tauntvolume:SetSize(TauntFrame:GetWide() / 2 - padX * 4, ScreenScale(25))
    tauntvolume:SetPos(TauntFrame:GetWide() / 2 + padX * 4, taunts:GetTall() + padY)
    tauntvolume:SetFont("ebilmonstermaker")
    tauntvolume:SetPlaceholderText("Taunt Volume")
    tauntvolume:SetPaintBackground(false)
    tauntvolume:SetTextColor(Color(165, 0, 0))
    tauntvolume:SetNumeric(true)

    local done = vgui.Create("DButton", TauntFrame)
    done:SetSize(ScreenScale(50), ScreenScale(15))
    done:SetPos((TauntFrame:GetWide() / 2 - done:GetWide() / 2) - done:GetWide() - padX, (TauntFrame:GetTall() - done:GetTall()) - padY)
    done:SetFont("smallebilmonstermaker")
    done:SetText("Done")

    function done:DoClick() 
        table.Empty(Taunts)
        for _, line in pairs(taunts:GetLines()) do
            table.insert(Taunts, {id = id, path = line:GetValue(1), volume = line:GetValue(2)})
        end
        TauntFrame:Remove() 
    end
    
    function done:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local add = vgui.Create("DButton", TauntFrame)
    add:SetSize(ScreenScale(50), ScreenScale(15))
    add:SetPos((TauntFrame:GetWide() / 2 - add:GetWide() / 2) + done:GetWide() + padX, (TauntFrame:GetTall() - add:GetTall()) - padY)
    add:SetFont("smallebilmonstermaker")
    add:SetText("Add")

    function add:DoClick() 
        taunts:AddLine(tauntpath:GetValue(), tauntvolume:GetValue())
    end
    
    function add:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
end

local function open()
    if MonsterMaker then MonsterMaker:Remove() end
    local padX, padY = ScreenScale(2.5), ScreenScale(2.5)
    local currentModel = "models/player/alyx.mdl"
    local mosntername, walkspeed, runspeed, modelpath, bio

    MonsterMaker = vgui.Create("DFrame")
    MonsterMaker:SetSize(ScrW() - ScreenScale(350), ScrH() - ScreenScale(100))
    MonsterMaker:Center()
    MonsterMaker:SetTitle("")
    MonsterMaker:MakePopup()
    local y = 0
    function MonsterMaker:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        surface.SetDrawColor(45, 45, 45)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        surface.SetFont("ebilifont")
        local textwide = surface.GetTextSize("Monster Maker 3000")
        draw.DrawText("Monster Maker 3000", "ebilifont", w / 2 - textwide / 2, padY)
    end

    local mw, mh = MonsterMaker:GetWide(), MonsterMaker:GetTall()
    local w, h = (mw - padX) - mw / 2.5, ScreenScale(25)
    local x, y = mw / 2.5, ScreenScale(20) + padY * 2

    local model = vgui.Create("DModelPanel", MonsterMaker)
    model:SetSize(mw / 2.5, mh - (padY * 2))
    model:SetModel(currentModel)
    
    function model:LayoutEntity()
        model:SetFOV(ScreenScale(35 / 2))
    end

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(mw / 2.5, mh - (padY * 2))
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(padX * 2, ScreenScale(20) + padY * 2, w - padX * 2, h - (ScreenScale(20) + padY * 2))
    end

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)
        
        if not monstername:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    monstername = vgui.Create("DTextEntry", MonsterMaker)
    monstername:SetSize(w - padX * 2, h)
    monstername:SetPos(x + padX, y)
    monstername:SetFont("ebilmonstermaker")
    monstername:SetPlaceholderText("Monster Name")
    monstername:SetPaintBackground(false)
    monstername:SetTextColor(Color(165, 0, 0))
    y = y + monstername:GetTall() + padY
    
    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not modelpath:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    modelpath = vgui.Create("DTextEntry", MonsterMaker)
    modelpath:SetSize(w - padX * 2, h)
    modelpath:SetPos(x + padX, y)
    modelpath:SetFont("ebilmonstermaker")
    modelpath:SetPlaceholderText("Model Path")
    modelpath:SetPaintBackground(false)
    modelpath:SetTextColor(Color(165, 0, 0))

    function modelpath:OnEnter() 
        currentModel = self:GetValue() 
        model:SetModel(self:GetValue())
    end
    y = y + modelpath:GetTall() + padY

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not walkspeed:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    walkspeed = vgui.Create("DTextEntry", MonsterMaker)
    walkspeed:SetSize(w - padX * 2, h)
    walkspeed:SetPos(x + padX, y)
    walkspeed:SetFont("ebilmonstermaker")
    walkspeed:SetPlaceholderText("Walkspeed")
    walkspeed:SetPaintBackground(false)
    walkspeed:SetTextColor(Color(165, 0, 0))
    walkspeed:SetNumeric(true)
    y = y + walkspeed:GetTall() + padY

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not runspeed:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    runspeed = vgui.Create("DTextEntry", MonsterMaker)
    runspeed:SetSize(w - padX * 2, h)
    runspeed:SetPos(x + padX, y)
    runspeed:SetFont("ebilmonstermaker")
    runspeed:SetPlaceholderText("Runspeed")
    runspeed:SetPaintBackground(false)
    runspeed:SetTextColor(Color(165, 0, 0))
    runspeed:SetNumeric(true)
    y = y + runspeed:GetTall() + padY

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(w - padX * 2, h + h + padY)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not bio:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    bio = vgui.Create("DTextEntry", MonsterMaker)
    bio:SetSize(w - padX * 2, h + h + padY)
    bio:SetPos(x + padX, y)
    bio:SetFont("ebilmonstermaker")
    bio:SetPlaceholderText("Biography")
    bio:SetPaintBackground(false)
    bio:SetTextColor(Color(165, 0, 0))
    bio:SetMultiline(true)
    y = y + bio:GetTall() + padY

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize(w - padX * 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not jumpscaremat:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    jumpscaremat = vgui.Create("DTextEntry", MonsterMaker)
    jumpscaremat:SetSize(w - padX * 2, h)
    jumpscaremat:SetPos(x + padX, y)
    jumpscaremat:SetFont("ebilmonstermaker")
    jumpscaremat:SetPlaceholderText("Jumpscare Material")
    jumpscaremat:SetPaintBackground(false)
    jumpscaremat:SetTextColor(Color(165, 0, 0))
    y = y + jumpscaremat:GetTall()

    local panel = vgui.Create("DPanel", MonsterMaker)
    panel:SetSize((w - padX * 2) / 2, h)
    panel:SetPos(x + padX, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not jumpscaresound:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    jumpscaresound = vgui.Create("DTextEntry", MonsterMaker)
    jumpscaresound:SetSize((w - padX * 2) / 2, h)
    jumpscaresound:SetPos(x + padX, y)
    jumpscaresound:SetFont("ebilmonstermaker")
    jumpscaresound:SetPlaceholderText("Sound")
    jumpscaresound:SetPaintBackground(false)
    jumpscaresound:SetTextColor(Color(165, 0, 0))
    
    local panel = vgui.Create("DPanel", MonsterMaker)

    panel:SetSize((w - padX * 2) / 2, h)
    panel:SetPos(x + padX + (w - padX * 2) / 2, y)
    function panel:Paint(w, h) 
        surface.SetDrawColor(50, 50, 50)
        surface.DrawOutlinedRect(0, 0, w, h)

        if not jumpscarelen:IsEditing() then return end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    jumpscarelen = vgui.Create("DTextEntry", MonsterMaker)
    jumpscarelen:SetSize((w - padX * 2) / 2, h)
    jumpscarelen:SetPos(x + padX + (w - padX * 2) / 2, y)
    jumpscarelen:SetFont("ebilmonstermaker")
    jumpscarelen:SetPlaceholderText("Length")
    jumpscarelen:SetPaintBackground(false)
    jumpscarelen:SetTextColor(Color(165, 0, 0))
    jumpscarelen:SetNumeric(true)
    y = y + jumpscarelen:GetTall() + padY

    local done = vgui.Create("DButton", MonsterMaker)
    done:SetSize(ScreenScale(50), ScreenScale(15))
    done:SetPos(mw - done:GetWide() - padX, (mh - done:GetTall()) - padY)
    done:SetFont("smallebilmonstermaker")
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

    local tauntbutton = vgui.Create("DButton", MonsterMaker)
    tauntbutton:SetSize(ScreenScale(50), ScreenScale(25))
    tauntbutton:SetPos()
    tauntbutton:SetFont("smallebilmonstermaker")
    tauntbutton:SetText("Taunts")
    
    function tauntbutton:Paint(w, h)
        local a = 50
        if self:IsHovered() then a = 150 end
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, a))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(padX * 2, ScreenScale(20) + padY * 2, w - padX * 2, h - (ScreenScale(20) + padY * 2))
    end

    function tauntbutton:DoClick() tauntlist() end
end
concommand.Add("monster_maker", open)
