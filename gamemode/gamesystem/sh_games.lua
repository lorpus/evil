Game.Gametypes = {
    deathmatch = {
        name = "Deathmatch",
        
        start = function()
            dbg.print("deatchmath.start()")
            for _, ply in pairs(player.GetAll()) do
                if ply:IsBoss() then continue end
                timer.Simple(1, function()
                    if IsValid(ply) then
                        ply:Give("weapon_357")
                    end
                end)
            end
        end,

        finish = function()
            for _, ply in pairs(player.GetAll()) do
                ply:SetNW2Int("EvilDMKills", 0)
            end
        end,

        deathlogic = function(victim, inflictor, attacker)
            if victim:IsHuman() then
                local boomboy

                // gay i know
                if inflictor:IsPlayer() and inflictor:IsHuman() then
                    boomboy = inflictor
                elseif type(attacker) == "CTakeDamageInfo" and attacker:GetAttacker():IsPlayer() and attacker:GetAttacker():IsHuman() then
                    boomboy = attacker:GetAttacker()
                end

                boomboy:SetNW2Int("EvilDMKills", boomboy:GetNW2Int("EvilDMKills") + 1)

                timer.Simple(5, function()
                    if IsValid(victim) then
                        Game:SetupHuman(victim, true)
                        victim:Give("weapon_357")
                    end
                end)
            end
        end,

        endlogic = function()
            if CurTime() > Round:GetEndTime() then
                local max = 0
                local winrars = {}
                for _, ply in pairs(player.GetAll()) do
                    local kills = ply:GetNW2Int("EvilDMKills")
                    if kills > max then
                        max = kills
                    end
                end
                
                for _, ply in pairs(player.GetAll()) do
                    if ply:GetNW2Int("EvilDMKills") == max then
                        table.insert(winrars, ply:Nick())
                    end
                end

                if max == 0 then
                    Round:End("#Deathmatch_EndTimeUpNone")
                else
                    Round:End("#Deathmatch_EndTimeUp", { winners = table.concat(winrars, ", "), kills = tostring(max) })
                end
            end
        end,

        playable = function()
            return #player.GetAll() >= 3
        end,
    },

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
