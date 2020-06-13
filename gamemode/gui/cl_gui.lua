surface.CreateFont("ebilfont", {
    font = "Verdana",
    size = ScreenScale(40)
})

surface.CreateFont("endgamebil", {
    font = "Chiller",
    size = ScreenScale(40),
    blursize = 0.5
})

surface.CreateFont("ebilfontsmaller", {
    font = "Verdana",
    size = ScreenScale(10),
    outline = true
})

local nFadeSpeed = 6
local nAvatarFadeSpeed = 2

local frame
// here be dragons

local globalAlpha = 0
function Evil:ShowEndScreen()
    local CurrentTimeShown = SysTime()
    if frame then frame:Remove() end

    local ScrW, ScrH = ScrW(), ScrH()
    local PadX, PadY = ScreenScale(5), ScreenScale(5)
    local Players = player.GetAll()
    local curTime = SysTime()

    frame = vgui.Create("DFrame")
    frame:SetSize(ScrW, ScrH)
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:ParentToHUD()
    frame.fade = false
    frame.opaque = false

    local delta
    function frame:Paint(w, h)
        delta = RealFrameTime() * 143

        frame.opaque = (globalAlpha >= 255)
        if not frame.fade then
            globalAlpha = math.Approach(globalAlpha, 255, nFadeSpeed * delta)
        else
            globalAlpha = math.Approach(globalAlpha, 0, nFadeSpeed * delta)
            if globalAlpha == 0 then self:Remove() dbg.print("Time it took to show: " .. SysTime() - CurrentTimeShown) end
        end
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, globalAlpha))
    end

    local survivors, deaders = {}, {}

    // sorting
    for x, ply in pairs(Players) do
        if ply:Alive() and ply:IsHuman() then
            table.insert(survivors, ply)
        elseif ply:GetNW2Bool("EvilKilled") then
            table.insert(deaders, ply)
        end
    end

    local Outline = vgui.Create("DPanel", frame)
    Outline:SetSize(ScrW - (PadX * 2), ScrH - (PadY * 2))
    Outline:SetPos(PadX, PadY)
    Outline.fadeintext = false

    local Main = vgui.Create("DPanel", Outline)
    Main:SetSize(Outline:GetWide() - ScreenScale(12.5), Outline:GetTall() - ScreenScale(100))
    Main:SetPos(ScreenScale(12.5) / 2, ScreenScale(100) - PadY)

    function Main:Paint(w, h)
        //surface.DrawOutlinedRect(0, 0, w, h)
    end

    local AvatarScale = ScreenScale(32)
    local Avatars = {}
    local SetupAvatars = function(tbl)
        if Avatars[1] then
            for  _, panel in pairs(Avatars) do panel:Remove() end
            table.Empty(Avatars)
        end

        for n, ply in pairs(tbl) do
            local AvatarImg = vgui.Create("AvatarImage", Main)
            AvatarImg:SetSize(AvatarScale, AvatarScale)
            AvatarImg:SetPlayer(ply, AvatarScale)
            AvatarImg:SetAlpha(0)
            table.insert(Avatars, AvatarImg)
        end
        return Avatars
    end

    local Arbitrary = "Placeholder"
    local textAlpha = 0
    local flPhase = 0
    local Delay = 2
    local TextFadeDelay = 2
    local TempVar = 1
    /*
        0/1 = Fade in & Survivors
        2 = Deaders
        3 = Fadeout -- highlights coming soon later in a theater near u
    */

    local centerText = false
    function Outline:Paint(w, h)
        surface.SetDrawColor(75, 75, 75, globalAlpha)
        //surface.DrawOutlinedRect(0, 0, w, h)

        if self.fadeintext then
            textAlpha =  math.Approach(textAlpha, 255, TextFadeDelay * delta)
            self.textfadefinished = (textAlpha >= 255)
        else
            textAlpha =  math.Approach(textAlpha, 0, TextFadeDelay * delta)
            self.textfadefinished = (textAlpha <= 0)
        end

        surface.SetFont("endgamebil")
        local TextW, TextH = surface.GetTextSize(Arbitrary)

        if centerText then
            draw.DrawText(Arbitrary, "endgamebil", w / 2 - TextW / 2, h / 2 - TextH / 2, Color(255, 0, 0, textAlpha))
        else
            draw.DrawText(Arbitrary, "endgamebil", w / 2 - TextW / 2, PadY, Color(255, 0, 0, textAlpha))
        end

        if frame.opaque then
            if ((flPhase == 0 and (SysTime() - curTime > Delay)) or ((flPhase > 1) and (flPhase < 2))) then

                // das setup por phase 1
                if flPhase == 0 then
                    local avatartable = SetupAvatars(survivors)
                    local total = #avatartable
                    //if total == 0 then flPhase = 2 return end -- to skip this phase

                    if total < (GetGlobal2Int("EvilStartingPlayers") / 3) then
                        Arbitrary = Lang:Format("#End_OnlyNSurvived", { count = total })
                    else
                        Arbitrary = Lang:Format("#End_NSurvived", { count = total })
                    end
                    if total == 0 then
                        Arbitrary = Lang:Get("#End_NobodySurvived")
                        centerText = true
                    end
                    if total == 1 and #survivors[1]:GetName() <= 12 then
                        Arbitrary = Lang:Format("#End_OnlySurvivor", { nick = survivors[1]:GetName() })
                    end

                    self.fadeintext = true

                    curTime = SysTime()
                    flPhase = 1.1
                    if total == 0 then flPhase = 1.3 end
                end

                // time to position tha avatars in the right spot
                if flPhase == 1.1 and (SysTime() - curTime > 1) then
                    local MainW, MainH = AvatarScale + PadX, AvatarScale + PadY
                    local maxColumns = math.Round((w - PadX * 16) / MainW)
                    local rowsMax = 1

                    local temp = #Avatars
                    while temp > maxColumns do
                        rowsMax = rowsMax + 1
                        temp = temp - maxColumns
                    end

                    if maxColumns > #Avatars then maxColumns = #Avatars end

                    Main:SetSize((MainW * maxColumns) + PadX, (MainH * rowsMax) + PadY)
                    Main:SetPos(w / 2 - Main:GetWide() / 2, TextH + PadY * 2)

                    local i = 0
                    local x, y = PadX, PadY
                    for _, panel in pairs(Avatars) do
                        panel:SetPos(x, y)

                        i = i + 1

                        x = x + PadX + AvatarScale
                        if i == maxColumns then
                            y = y + panel:GetTall() + PadY
                            x = PadX
                            i = 0
                        end
                    end

                    curTime = SysTime()
                    flPhase = 1.2
                end

                // time to do cool things with the avatars!! - aids
                local AvatarFadeSpeed = nAvatarFadeSpeed / #Avatars
                if flPhase == 1.2 and (SysTime() - curTime > AvatarFadeSpeed) then
                    for n, panel in pairs(Avatars) do
                        if TempVar != n then continue end
                        curTime = SysTime()
                        panel.myturn = true
                    end

                    TempVar = TempVar + 1
                end

                if flPhase == 1.2 then
                    for n, panel in pairs(Avatars) do
                        if panel.myturn then
                            panel:SetAlpha(math.Approach(panel:GetAlpha(), 255, 2 * delta))
                        end

                        if n == #Avatars and panel:GetAlpha() == 255 then
                            flPhase = 1.3
                            TempVar = 1
                        end
                    end
                end

                if flPhase == 1.3 and SysTime() - curTime > 5 then
                    self.fadeintext = false
                    for n, panel in pairs(Avatars) do
                        panel:SetAlpha(math.Approach(panel:GetAlpha(), 0, 2 * delta))
                        if n == #Avatars and panel:GetAlpha() == 0 then
                            flPhase = 2
                            curTime = SysTime()
                        end
                    end

                    if #Avatars == 0 then
                        flPhase = 1.4
                        curTime = SysTime()
                    end
                end

                if flPhase == 1.4 and SysTime() - curTime > 0.1 then
                    if #Avatars == 0 and self.textfadefinished then
                        flPhase = 2
                        curTime = SysTime()
                        centerText = false
                    end
                end
            end

            if ((flPhase == 2 and (SysTime() - curTime > Delay)) or ((flPhase > 2) and (flPhase < 3))) then

                // das setup por phase 1
                if flPhase == 2 then
                    local total = #SetupAvatars(deaders)
                    //if total == 0 then flPhase = 3 return end -- to skip this phase

                    if total == 0 then
                        Arbitrary = Lang:Get("#End_NobodyDied")
                        centerText = true
                        dbg.print("Everyone")
                    elseif total == GetGlobal2Int("EvilStartingPlayers") then
                        Arbitrary = Lang:Get("#End_EveryoneDied")
                    elseif total < GetGlobal2Int("EvilStartingPlayers") / 3 then
                        Arbitrary = Lang:Format("#End_OnlyNDied", { count = total })
                    else
                        Arbitrary = Lang:Format("#End_NDied", { count = total })
                    end

                    self.fadeintext = true

                    curTime = SysTime()
                    flPhase = 2.1
                    if total == 0 then flPhase = 2.3 end
                end

                // time to position tha avatars in the right spot
                if flPhase == 2.1 and (SysTime() - curTime > 1) then
                    local MainW, MainH = AvatarScale + PadX, AvatarScale + PadY
                    local maxColumns = math.Round((w - PadX * 16) / MainW)
                    local rowsMax = 1

                    local temp = #Avatars
                    while temp > maxColumns do
                        rowsMax = rowsMax + 1
                        temp = temp - maxColumns
                    end

                    if maxColumns > #Avatars then maxColumns = #Avatars end

                    Main:SetSize((MainW * maxColumns) + PadX, (MainH * rowsMax) + PadY)
                    Main:SetPos(w / 2 - Main:GetWide() / 2, TextH + PadY * 2)

                    local i = 0
                    local x, y = PadX, PadY
                    for _, panel in pairs(Avatars) do

                        panel:SetPos(x, y)

                        i = i + 1

                        x = x + PadX + AvatarScale
                        if i == maxColumns then
                            y = y + panel:GetTall() + PadY
                            x = PadX
                            i = 0
                        end
                    end

                    curTime = SysTime()
                    flPhase = 2.2
                end

                // time to do cool things with the avatars!! - aids
                local AvatarFadeSpeed = nAvatarFadeSpeed / #Avatars
                if flPhase == 2.2 and (SysTime() - curTime > AvatarFadeSpeed) then
                    for n, panel in pairs(Avatars) do
                        if TempVar != n then continue end
                        curTime = SysTime()
                        panel.myturn = true
                    end

                    TempVar = TempVar + 1
                end

                if flPhase == 2.2 then
                    for n, panel in pairs(Avatars) do
                        if panel.myturn then
                            panel:SetAlpha(math.Approach(panel:GetAlpha(), 255, 2 * delta))
                        end
                        if n == #Avatars and panel:GetAlpha() == 255 then
                            flPhase = 2.3
                            TempVar = 1
                        end
                    end
                end

                if flPhase == 2.3 and SysTime() - curTime > 5 then
                    self.fadeintext = false
                    for n, panel in pairs(Avatars) do
                        panel:SetAlpha(math.Approach(panel:GetAlpha(), 0, 2 * delta))
                        if n == #Avatars and panel:GetAlpha() == 0 then
                            flPhase = 3
                            curTime = SysTime()
                        end
                    end

                    if #Avatars == 0 then
                        flPhase = 2.4
                        curTime = SysTime()
                    end
                end

                if flPhase == 2.4 and SysTime() - curTime > 0.1 then
                    if #Avatars == 0 and self.textfadefinished then
                        flPhase = 3
                        curTime = SysTime()
                        centerText = false
                    end
                end
            end

            if ((flPhase == 3 and (SysTime() - curTime > Delay)) or ((flPhase > 3) and (flPhase < 4))) then
                frame.fade = true
            end
        end
    end
end

hook.Add("RoundSet", "EvilEndGUI", function(round)
    if round == ROUND_POST then
        timer.Simple(2, function()
            Evil:ShowEndScreen()
        end)
    end
end)

hook.Add("HUDPaint", "OnloadGUIInit", function()
    hook.Remove("HUDPaint", "OnloadGUIInit")
    if frame then frame:Remove() end
    //FirstTimeGUI()
    //Evil:ShowEndScreen()
end)
