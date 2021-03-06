surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(10)
})

surface.CreateFont("ebilfontsmallerer", {
    font = "Verdana",
    size = ScreenScale(6.5)
})

surface.CreateFont("ebilfontscoreboard", {
    font = "Verdana",
    size = ScreenScale(12)
})

Scoreboard = {}

local function SortPlayers(tab)
    local boss, proxy, humans, dead = {}, {}, {}, {}

    for _, ply in pairs(tab) do
        if ply:IsHuman() then table.insert(humans, ply) continue end
        if ply:IsBoss() then table.insert(boss, ply) continue end
        if ply:IsProxy() then table.insert(proxy, ply) continue end
        table.insert(dead, ply)
    end

    return boss, proxy, humans, dead
end

function Scoreboard:Toggle()
    if Scoreboard.mainframe then
        Scoreboard.mainframe:Remove()
        Scoreboard.mainframe = nil
        return
    end

    local BossColor = team.GetColor(TEAM_BOSS)
    local HumanColor = team.GetColor(TEAM_HUMAN)
    local DeadColor = team.GetColor(TEAM_SPEC)
    local scrW, scrH = ScrW(), ScrH()
    local PadX, PadY = ScreenScale(5), ScreenScale(5)
    local Players = player.GetAll()
    local boss, proxy, humans, dead = SortPlayers(Players)

    Scoreboard.mainframe = vgui.Create("DFrame")
    Scoreboard.mainframe:SetTitle("")
    Scoreboard.mainframe:SetDraggable(false)
    Scoreboard.mainframe:ShowCloseButton(false)
    Scoreboard.mainframe:SetSize(scrW - ScreenScale(300), scrH - ScreenScale(100))
    Scoreboard.mainframe:SetPos(scrW / 2 - Scoreboard.mainframe:GetWide() / 2, scrH / 2 - Scoreboard.mainframe:GetTall() / 2)
    Scoreboard.mainframe:MakePopup()

    local MainW = Scoreboard.mainframe:GetWide()

    function Scoreboard.mainframe:Paint(w, h)
        Derma_DrawBackgroundBlur(self, 1)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 200))
        surface.SetDrawColor(0, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local ScrollPanel = vgui.Create("DScrollPanel", Scoreboard.mainframe)
    ScrollPanel:SetSize(Scoreboard.mainframe:GetWide() - PadX * 2, Scoreboard.mainframe:GetTall() - PadY * 2)
    ScrollPanel:SetPos(PadX, PadY)

    local sbar = ScrollPanel:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 40))
    end

    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
        surface.SetFont("ebilfontsmallerer")
        local TextW, TextH = surface.GetTextSize("↑")
        draw.DrawText("↑", "ebilfontsmallerer", w / 2 - TextW / 2, h / 2 - TextH / 2)
    end

    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
        surface.SetFont("ebilfontsmallerer")
        local TextW, TextH = surface.GetTextSize("↓")
        draw.DrawText("↓", "ebilfontsmallerer", w / 2 - TextW / 2, h / 2 - TextH / 2)
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55, 200))
    end

    local PanelY = 0
    local Scale = ScreenScale(16)

    local BossPlayerList, HumanPlayerList, DeadPlayerList

    if #boss > 0 then
        local Boss = vgui.Create("DPanel", ScrollPanel)
        Boss:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
        Boss:SetPos(PadX, PadY)

        function Boss:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, BossColor)

            surface.SetFont("ebilfontsmaller")
            local TextW, TextH = surface.GetTextSize(Lang:Get("#Boss"))
            draw.DrawText(Lang:Get("#Boss"), "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
        end
        PanelY = PanelY + Boss:GetTall() + PadY

        BossPlayerList = vgui.Create("DPanel", ScrollPanel)
        BossPlayerList:SetSize(MainW - (PadX * 2), math.floor(#boss * Scale))
        BossPlayerList:SetPos(PadX, PadY + (ScreenScale(25) / 2))
        function BossPlayerList:Paint(w, h)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        PanelY = PanelY + BossPlayerList:GetTall() + PadY
    end

    if #proxy > 0 then
        local Proxy = vgui.Create("DPanel", ScrollPanel)
        Proxy:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
        Proxy:SetPos(PadX, PanelY)

        function Proxy:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, BossColor)

            surface.SetFont("ebilfontsmaller")
            local TextW, TextH = surface.GetTextSize(Lang:Get("#Proxy"))
            draw.DrawText(Lang:Get("#Proxy"), "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
        end
        PanelY = PanelY + Proxy:GetTall()

        ProxyPlayerList = vgui.Create("DPanel", ScrollPanel)
        ProxyPlayerList:SetSize(MainW - (PadX * 2), math.floor(#proxy * Scale))
        ProxyPlayerList:SetPos(PadX, PanelY)
        function ProxyPlayerList:Paint(w, h)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        PanelY = PanelY + ProxyPlayerList:GetTall() + PadY
    end

    if #humans > 0 then
        local Humans = vgui.Create("DPanel", ScrollPanel)
        Humans:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
        Humans:SetPos(PadX, PanelY)

        function Humans:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, HumanColor)

            surface.SetFont("ebilfontsmaller")
            local TextW, TextH = surface.GetTextSize(Lang:Get("#Humans"))
            draw.DrawText(Lang:Get("#Humans"), "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
        end

        PanelY = PanelY + Humans:GetTall()

        HumanPlayerList = vgui.Create("DPanel", ScrollPanel)
        HumanPlayerList:SetSize(MainW - (PadX * 2), #humans * Scale)
        HumanPlayerList:SetPos(PadX, PanelY)
        function HumanPlayerList:Paint(w, h)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        PanelY = PanelY + HumanPlayerList:GetTall() + PadY
    end

    if #dead > 0 then
        local Dead = vgui.Create("DPanel", ScrollPanel)
        Dead:SetSize(MainW - (PadX * 2), ScreenScale(25) / 2)
        Dead:SetPos(PadX, PanelY)

        function Dead:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, DeadColor)

            surface.SetFont("ebilfontsmaller")
            local TextW, TextH = surface.GetTextSize(Lang:Get("#Dead"))
            draw.DrawText(Lang:Get("#Dead"), "ebilfontsmaller", w / 2 - TextW / 2, h / 2 - TextH / 2)
        end

        PanelY = PanelY + Dead:GetTall()

        DeadPlayerList = vgui.Create("DPanel", ScrollPanel)
        DeadPlayerList:SetSize(MainW - (PadX * 2), #dead * Scale)
        DeadPlayerList:SetPos(PadX, PanelY)
        function DeadPlayerList:Paint(w, h)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        PanelY = PanelY + DeadPlayerList:GetTall() + PadY
    end

    local AvatarScale = ScreenScale(Scale / 2) - PadX * 2

    local y = 0
    local addRow = function(ply, PlayerList, hideSbar)
        local panel = vgui.Create("DPanel", PlayerList)
        panel:SetSize(PlayerList:GetWide(), Scale)
        panel:SetPos(0, y)

        local Avatar = vgui.Create("AvatarImage", panel)
        Avatar:SetSize(AvatarScale, AvatarScale)
        Avatar:SetPlayer(ply, AvatarScale)
        Avatar:SetPos(PadX, PadX)
        y = y + panel:GetTall()

        function panel:Paint(w, h)
            if not IsValid(ply) then
                Scoreboard:Toggle()
                Scoreboard:Toggle()
                self:Remove()
                return
            end
            surface.SetFont("ebilfontscoreboard")
            local name
            if self:IsHovered() and ply:EvilName() != ply:Nick() then
                name = ply:Nick() .. " (" .. ply:EvilName() .. ")"
            else
                name = ply:Nick()
            end
            local TextW, TextH = surface.GetTextSize(name)
            draw.DrawText(name, "ebilfontscoreboard", Avatar:GetWide() + PadX * 2, panel:GetTall() / 2 - TextH / 2)

            surface.SetFont("ebilfontsmaller")
            local TextW = surface.GetTextSize("Status")
            local center = ScreenScale(200) + TextW / 2

            surface.SetFont("ebilfontsmaller")
            local TextW = surface.GetTextSize("Ping")
            local center = ScreenScale(290) + TextW / 2

            surface.SetFont("ebilfontscoreboard")
            local TextW, TextH = surface.GetTextSize(ply:Ping() .. " ms")
            draw.DrawText(ply:Ping() .. " ms", "ebilfontscoreboard", center - TextW / 2, h / 2 - TextH / 2)

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
            ply:ShowProfile()
        end
    end

    if #boss > 0 then
        for _, ply in pairs(boss) do addRow(ply, BossPlayerList) end
        y = 0
    end

    if #proxy > 0 then
        for _, ply in pairs(proxy) do addRow(ply, ProxyPlayerList, true) end
        y = 0
    end

    if #humans > 0 then
        for _, ply in pairs(humans) do addRow(ply, HumanPlayerList, true) end
        y = 0
    end

    if #dead > 0 then
        for _, ply in pairs(dead) do addRow(ply, DeadPlayerList, true) end
        y = 0
    end
end

function GM:ScoreboardShow()
    Scoreboard:Toggle()
end

function GM:ScoreboardHide()
    Scoreboard:Toggle()
end
