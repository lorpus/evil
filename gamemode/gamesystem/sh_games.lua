Game.Gametypes = {
    pages = {
        name = "Pages",

        start = function()
            dbg.print("pages.start()")
            SetGlobalInt("PagesCollected", 0)
            local pagesTotal = math.min(8, #Map.pages)
            SetGlobalInt("PagesTotal", pagesTotal)
            local inc = 0
            for i, v in RandomPairs(Map.pages) do
                if inc >= pagesTotal then break end
                inc = inc + 1

                local ent = ents.Create("evil_page")
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
            SetGlobalInt("PagesCollected", GetGlobalInt("PagesCollected") + 1)
            Round:AddTime(30)
        end,

        playable = function()
            return Map.pages != nil
        end,

        think = function()
            if SERVER then
                if GetGlobalInt("PagesCollected") >= GetGlobalInt("PagesTotal") then
                    Round:End("#Round_EndPagesCollected")
                end
            end
        end
    }
}

hook.Add("EvilPageTaken", "PageTaken", function(taker, page)
    Game.Gametypes.pages.pagetaken(taker, page)
end)
