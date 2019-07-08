Game.Gametypes = {
    pages = {
        name = "Pages",

        start = function()
            dbg.print("pages.start()")
            SetGlobal2Int("PagesCollected", 0)
            local pagesTotal = math.min(8, #Map.pages)
            SetGlobal2Int("PagesTotal", pagesTotal)
            local inc = 0
            for i, v in RandomPairs(Map.pages) do
                if inc >= pagesTotal then break end
                inc = inc + 1

                local ent = ents.Create("evil_page")
                if not v.pos and istable(v[1]) then
                    v = v[math.random(#v)]
                end
                ent:SetPos(v.pos)
                ent:SetAngles(v.ang)
                ent:SetMaterial(string.format("models/jason278/slender/sheets/sheet_%s.vtf", inc))
                ent:Spawn()
            end
        end,

        finish = function()
            dbg.print("pages.finish()")
        end,

        pagetaken = function(taker, page)
            Network:NotifyAll("#Game_PageCollected", true, { player = taker:Nick() })
            SetGlobal2Int("PagesCollected", GetGlobal2Int("PagesCollected") + 1)
            if not SR.ActiveRounds["deadline"] then
                Round:AddTime(30)
            end
        end,

        playable = function()
            return Map.pages != nil
        end,

        think = function()
            if SERVER then
                if GetGlobal2Int("PagesCollected") >= GetGlobal2Int("PagesTotal") then
                    Round:End("#Round_EndPagesCollected")
                end
            end
        end
    }
}

hook.Add("EvilPageTaken", "PageTaken", function(taker, page)
    Game.Gametypes.pages.pagetaken(taker, page)
end)
