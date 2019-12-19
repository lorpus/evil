local DisplayTime = 3
local function ShowClassInfoPanel(key, optname, optdesc)
    local iscitizen = key == true
    local info = Classes.Classes[key]
    local frame = vgui.Create("DFrame")

    frame:SetSize(ScreenScale(100), ScrW() / 5)
    frame:SetPos(0, ScrH() / 2 - frame:GetTall() / 2)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame.drawwidth = 0

    local movedir = 1.5
    function frame:Think()
        if self.drawwidth >= frame:GetWide() and movedir > 0 then
            movedir = 0 // stop multiple timers
            timer.Simple(DisplayTime, function()
                movedir = -3
            end)

            return
        elseif self.drawwidth < 0 then
            self:Remove()
        end
        self.drawwidth = self.drawwidth + movedir * RealFrameTime() * 50
    end

    local pad = 16
    function frame:Paint(w, h)
        draw.RoundedBoxEx(10, 0, 0, self.drawwidth, h, Color(20, 20, 20), false, true, false, true)

        local text
        if iscitizen then
            draw.SimpleText(Lang:Format("#YourName", { name = optname }), "EvilInfoPanelTitle", self.drawwidth - w / 2, 5, color_white, TEXT_ALIGN_CENTER)
            text = optdesc
        else
            draw.SimpleText(Lang:Format("#YouAreClass", { name = info.name }), "EvilInfoPanelTitle", self.drawwidth - w / 2, 5, color_white, TEXT_ALIGN_CENTER)
            text = info.desc
            if text:StartWith("#") then text = Lang:Get(text) end
        end
        draw.DrawText(eutil.NewlineText(text, 30), "EvilInfoPanelSub", self.drawwidth - w / 2, self:GetTall() * 0.7 + pad, color_white, TEXT_ALIGN_CENTER)
    end

    local model = vgui.Create("DModelPanel", frame)
    model:SetPos(0, 30)
    model:SetSize(frame:GetWide(), frame:GetTall() * 0.6)
    model:SetModel(LocalPlayer():GetModel())
    model:SetFOV(100)
    model.xpos = -100

    local movedirb = 0.7
    function model:Think()
        if self.xpos >= 0 and movedirb > 0 then
            movedirb = 0 // stop multiple timers
            timer.Simple(DisplayTime, function()
                movedirb = -1.3
            end)

            return
        elseif self.xpos < -self:GetWide() then
            self:Remove()
        end
        self.xpos = self.xpos + movedirb * RealFrameTime() * 50

        self.Entity:SetPos(Vector(-self.xpos, self.xpos, -20))
    end
end

// the method for doing this has been marked for deprecation
// except it has been for 7 years
// im sure this wont stop working anytime soon
local function OverrideVoiceNames()
    VoiceNotify.Think = function(self)
        if IsValid(self.ply) then
            self.LabelName:SetText(self.ply:EvilName())
        end

        if self.fadeAnim then
            self.fadeAnim:Run()
        end
    end
end
hook.Add("HUDPaint", "EvilOverrideVoiceDerma", function()
    OverrideVoiceNames()
    hook.Remove("HUDPaint", "EvilOverrideVoiceDerma")
end)

hook.Add("EvilSetClass", "ShowClassHUD", function(ply, key)
    if ply == LocalPlayer() then
        timer.Simple(1, function()
            ShowClassInfoPanel(key)
        end)
    end
end)

hook.Add("EvilClassCitizen", "ShowClassHUDCitizen", function(ply, name)
    if ply == LocalPlayer() then
        timer.Simple(1, function()
            local desc = Classes.CitizenStats[math.random(#Classes.CitizenStats)]
            if desc:StartWith("#") then desc = Lang:Get(desc) end
            ShowClassInfoPanel(true, name, desc) // i didnt have this in mind when making the class thing but whatever
        end)
    end
end)
