surface.CreateFont("MapVoteTitle", {
    font = "Verdana",
    size = ScreenScale(11)
})

surface.CreateFont("MapVoteText", {
    font = "Verdana",
    size = ScreenScale(6)
})

/*local recv = {
    {
        filename = "slender_forest",
        lang = "#The_Forest",
        fallback = "The Forest",
        img = "construct.png"
    },
    {
        filename = "slender_forest",
        lang = "#The_Forest",
        fallback = "The Forest"
    },
    {
        filename = "slender_forest",
        lang = "#The_Forest",
        fallback = "The Forest"
    },
    {
        filename = "slender_forest",
        lang = "#The_Forest",
        fallback = "The Forest"
    },
    {
        filename = "slender_forest",
        lang = "#The_Forest",
        fallback = "The Forest"
    }
}*/

local matcache = {}
local mapnames = {} // kept for notification of result (if not extend)

hook.Add("EvilMapVoteResult", "EvilShowMapResult", function(winner)
    Evil:AddTextChat(Lang:Format("#NewMapWon", { map = mapnames[winner] }))
end)

local mvframe
function MapVote:ShowVoteUI(recv)
    if #recv == 0 and mvframe then mvframe:Remove() mvframe = nil return end

    local frame = vgui.Create("DFrame")
    mvframe = frame

    frame:SetSize(ScreenScale(100), ScrW() / 5)
    frame:SetPos(0, ScrH() / 2 - frame:GetTall() / 2)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    function frame:Paint(w, h)
        draw.RoundedBoxEx(10, 0, 0, w, h, Color(20, 20, 20), false, true, false, true)
    end

    local endTime = CurTime() + Evil.Cfg.MapVote.Time

    local title = vgui.Create("DLabel", frame)
    title:SetFont("MapVoteTitle")
    title:SetText(Lang:Format("#MapVote", { secs = Evil.Cfg.MapVote.Time }))
    title:SizeToContents()
    title:SetPos(frame:GetWide() / 2 - title:GetWide() / 2, 0)

    function title:Think()
        title:SetText(Lang:Format("#MapVote", { secs = math.Round(endTime - CurTime()) }))
        title:SizeToContents()
    end

    local padding = 4
    local basePos = frame:GetTall() / 8
    local posOffset = basePos
    local index = 1

    local selectedIndex = 0
    local lastDown = {}
    function frame:Think()
        for i = 1, #recv + 1 do
            if input.IsKeyDown(KEY_0 + i) and not lastDown[i] then
                if selectedIndex == i then continue end

                selectedIndex = i
                lastDown[i] = true
                if not recv[i] then
                    dbg.print("selected extend")
                else
                    dbg.print("selected", recv[i])
                end
                net.Start(Network.Id)
                    net.WriteInt(N_MAPVOTE, Network.CmdBits)
                    if recv[i] then
                        net.WriteUInt(i, 3)
                    else
                        net.WriteUInt(0, 3) // extend
                    end
                net.SendToServer()
            elseif not input.IsKeyDown(KEY_0 + i) then
                lastDown[i] = false
            end
        end
    end

    local function addthing(text, mat)
        local opt = vgui.Create("DPanel", frame)
        opt:SetSize(frame:GetWide() * 0.9, basePos)
        opt:SetPos(10, posOffset)
        
        local dindex = index
        function opt:Paint(w, h)
            if mat then
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(0, 0, w, h) 
            else
                draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50)) // rounded outline
                draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(20, 20, 20))
            end

            draw.SimpleText(string.format("%s. %s", dindex, text), "MapVoteText", 10, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if selectedIndex == dindex then
                draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(100, 255, 100, 5))
            end
        end

        index = index + 1
        posOffset = posOffset + basePos + padding
    end

    for k, v in pairs(recv) do
        local dat = Evil.Cfg.MapVote.MapInfo[v]
        local text
        local mat
        if dat then
            text = Lang:Get(dat.lang)
            if not text then text = dat.fallback end
            // cache materials & load if no exist
            if dat.img then
                if matcache[v] then
                    mat = matcache[v]
                else
                    mat = Material(dat.img, "noclamp smooth")
                    matcache[v] = mat
                end
            end
        end
        if not text then text = v end
        mapnames[v] = text
        addthing(text, mat)
    end
    addthing("Extend")
end
concommand.Add("mapvote", function() MapVote:ShowVoteUI({"slender_forest"}) end)
