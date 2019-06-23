surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(10)
})

surface.CreateFont("ebilfontscoreboard", {
    font = "Verdana",
    size = ScreenScale(12)
})


Scoreboard = {}

local function GetPlayerStatus(ply)
    if ply:IsBoss() then return "???" end
    if ply:Alive() then return "Alive" else return "Dead" end
end

local function SortPlayers(tab)
    local boss, humans, dead = {}, {}, {}

    for _, ply in pairs(tab) do
        if ply:Team() == TEAM_HUMAN then table.insert(humans, ply) continue end
        if ply:Team() == TEAM_BOSS then table.insert(boss, ply) continue end
        table.insert(dead, ply)
    end
    PrintTable(boss)
    return boss, humans, dead
end

local BossColor = team.GetColor(TEAM_BOSS)
local HumanColor = team.GetColor(TEAM_HUMAN)
local DeadColor = team.GetColor(TEAM_SPEC)

function Scoreboard:Toggle()
    if Scoreboard.mainframe then 
        Scoreboard.mainframe:Remove() 
        Scoreboard.mainframe = nil
        return
    end
    
    local scrW, scrH = ScrW(), ScrH()
    local PadX, PadY = ScreenScale(5), ScreenScale(5)
    local Players = player.GetAll()
    local boss, humans, dead = SortPlayers(Players)

    Scoreboard.mainframe = vgui.Create("DFrame")
    Scoreboard.mainframe:SetTitle("")
    Scoreboard.mainframe:SetDraggable(false)
    Scoreboard.mainframe:ShowCloseButton(false)
    Scoreboard.mainframe:SetSize(scrW - ScreenScale(300), scrH - ScreenScale(100))
    Scoreboard.mainframe:SetPos(scrW / 2 - Scoreboard.mainframe:GetWide() / 2, scrH / 2 - Scoreboard.mainframe:GetTall() / 2)
    Scoreboard.mainframe:MakePopup()

    local MainW, MainT =  Scoreboard.mainframe:GetWide(), Scoreboard.mainframe:GetTall()

    function Scoreboard.mainframe:Paint(w, h)
        Derma_DrawBackgroundBlur(self, 1) 
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 200))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local PanelY = 0

    local Boss = vgui.Create("DPanel", Scoreboard.mainframe)
    Boss:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
    Boss:SetPos(PadX, PadY)

    function Boss:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, BossColor)
        
        surface.SetFont("ebilfontsmaller")
        local TextW, TextH = surface.GetTextSize("Boss")
        draw.DrawText("Boss", "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
    end
    PanelY = PanelY + Boss:GetTall() + PadY

    local BossPlayerList = vgui.Create("DScrollPanel", Scoreboard.mainframe)
    BossPlayerList:SetSize(MainW - (PadX * 2), ScreenScale(32))
    BossPlayerList:SetPos(PadX, PadY + (ScreenScale(25) / 2))
    function BossPlayerList:Paint(w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    PanelY = PanelY + BossPlayerList:GetTall() + PadY

    local Humans = vgui.Create("DPanel", Scoreboard.mainframe)
    Humans:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
    Humans:SetPos(PadX, PanelY)

    function Humans:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, HumanColor)
        
        surface.SetFont("ebilfontsmaller")
        local TextW, TextH = surface.GetTextSize("Humans")
        draw.DrawText("Humans", "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
    end
    PanelY = PanelY + Humans:GetTall()

    local halved = (MainT - PanelY - PadY * 2) / 2
    local HumanPlayerList = vgui.Create("DScrollPanel", Scoreboard.mainframe)
    HumanPlayerList:SetSize(MainW - (PadX * 2), halved)
    HumanPlayerList:SetPos(PadX, PanelY)
    function HumanPlayerList:Paint(w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    PanelY = PanelY + HumanPlayerList:GetTall() + PadY

    local Dead = vgui.Create("DPanel", Scoreboard.mainframe)
    Dead:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
    Dead:SetPos(PadX, PanelY)

    function Dead:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, DeadColor)
        
        surface.SetFont("ebilfontsmaller")
        local TextW, TextH = surface.GetTextSize("Dead")
        draw.DrawText("Dead", "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
    end
    PanelY = PanelY + Dead:GetTall()

    local DeadPlayerList = vgui.Create("DScrollPanel", Scoreboard.mainframe)
    DeadPlayerList:SetSize(MainW - (PadX * 2), halved - PadY * 2)
    DeadPlayerList:SetPos(PadX, PanelY)
    function DeadPlayerList:Paint(w, h)
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local sbar = BossPlayerList:GetVBar()
    function sbar:Paint() end

    local sbar = HumanPlayerList:GetVBar()
    function sbar:Paint() end

    local sbar = DeadPlayerList:GetVBar()
    function sbar:Paint() end

    local rowWidth, rowTall = BossPlayerList:GetWide(), BossPlayerList:GetTall()
    local AvatarScale = ScreenScale(rowTall / 2) - PadX * 2

    local y = 0
    local addRow = function(ply, PlayerList, hideSbar)
        local panel = vgui.Create("DPanel", PlayerList)
        panel:SetSize(rowWidth, rowTall)
        panel:SetPos(0, y)
        
        local Avatar = vgui.Create("AvatarImage", panel)
        Avatar:SetSize(AvatarScale, AvatarScale)
        Avatar:SetPlayer(ply, AvatarScale)
        Avatar:SetPos(PadX, PadX)
        y = y + panel:GetTall()

        function panel:Paint(w, h)
            surface.SetFont("ebilfontscoreboard")
            local TextW, TextH = surface.GetTextSize(ply:GetName())
            draw.DrawText(ply:GetName(), "ebilfontscoreboard", Avatar:GetWide() + PadX * 2, panel:GetTall() / 2 - TextH / 2)

            surface.SetFont("ebilfontsmaller")
            local TextW = surface.GetTextSize("Status")
            local center = ScreenScale(200) + TextW / 2

           --[[surface.SetFont("ebilfontscoreboard")
            local TextW, TextH = surface.GetTextSize(GetPlayerStatus(ply))
            draw.DrawText(GetPlayerStatus(ply), "ebilfontscoreboard", center - TextW / 2, h / 2 - TextH / 2)]]

            surface.SetFont("ebilfontsmaller")
            local TextW = surface.GetTextSize("Ping")
            local center = ScreenScale(300) + TextW / 2

            surface.SetFont("ebilfontscoreboard")
            local TextW, TextH = surface.GetTextSize(ply:Ping())
            draw.DrawText(ply:Ping(), "ebilfontscoreboard", center - TextW / 2, h / 2 - TextH / 2)

            surface.SetDrawColor(5, 5, 5, 125)
            surface.DrawOutlinedRect(0, 0, hideSbar and (sbar and w - sbar:GetWide()) or w, h)

        end
        
        if ply:IsBot() then return end
        local button = vgui.Create("DButton", panel)
        button:SetSize(Avatar:GetSize())
        button:SetPos(Avatar:GetPos())
        button:SetText("")
        function button:Paint() end
        function button:DoClick()
            gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64()) 
        end
    end

    for _, ply in pairs(boss) do addRow(ply, BossPlayerList) end
    y = 0
    for _, ply in pairs(humans) do addRow(ply, HumanPlayerList, true) end
    y = 0
    for _, ply in pairs(dead) do addRow(ply, DeadPlayerList, true) end
end


function GM:ScoreboardShow()
    print("shown")
	Scoreboard:Toggle()
end

function GM:ScoreboardHide()
    print("hide")
	Scoreboard:Toggle()
end