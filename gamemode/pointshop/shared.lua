// integration, not custom

Evil.PointshopItems = {
    beboss = {
        Model = "models/Gibs/HGIBS.mdl",
        Name = "Be the Boss",
        SingleUse = true,
        AllowDead = true,
        OnBuy = function(self, ply)
            print(ply, "buy beboss")
            Evil._NEXTBOSSPLAYER = ply
            ply.evilPurchasedBoss = true
        end,
        OnSell = function(self, ply)
            print(ply, "sell beboss")
            Evil._NEXTBOSSPLAYER = nil
        end,
    }
}

if SERVER then
    hook.Add("EvilCanPlayerBuy", "CanPlayerBuyMain", function(ply, itemid)
        if itemid == "beboss" then
            if IsValid(Evil._NEXTBOSSPLAYER) then
                if Evil._NEXTBOSSPLAYER == ply then
                    if Evil.Cfg.Pointshop.Integration == "burton" then
                        ply:PS_Notify("#PS_AlreadyBeBoss")
                    end
                else
                    if Evil.Cfg.Pointshop.Integration == "burton" then
                        ply:PS_Notify("#PS_CantBuyBeBoss")
                    end
                end
                return false
            end
        end
    end)
end

// integration for github.com/adamdburton/pointshop
local burtonps = false

if Evil.Cfg.Pointshop.Integration == "burton" then
    burtonps = true
    Evil.HasPointshop = true

    local c = {}
    c.Name = "Evil"
    c.Icon = "eye"
    c.Order = 0
    c.AllowEquipped = -1
    c.AllowedUserGroups = {}
    c.CanPlayerSee = function() return true end
    c.ModifyTab = function() end
    PS.Categories.evil = c

    if SERVER then
        local PLAYER = FindMetaTable("Player")
        local oBuyItem = PLAYER.PS_BuyItem
        function PLAYER:PS_BuyItem(itemid)
            local cat = PS.Items[itemid].Category
            if cat != "Evil" then return oBuyItem(self, itemid) end
            local r = hook.Run("EvilCanPlayerBuy", self, itemid)
            if r != nil then return r end

            return oBuyItem(self, itemid)
        end
    else
        net.Receive("PS_SendNotification", function(len)
            local str = net.ReadString()
            if str:StartWith("#") then
                str = Lang:Get(str)
            end
            notification.AddLegacy(str, NOTIFY_GENERIC, 5)
        end)
    end
else
    Evil.HasPointshop = false
end

for k, v in pairs(Evil.PointshopItems) do
    if burtonps then
        v.AdminOnly = false
        v.CanPlayerBuy = true
        v.CanPlayerEquip = true
        v.CanPlayerHolster = true
        v.CanPlayerSell = true
        v.Category = "Evil"
        v.ID = k
        v.NoPreview = false
        v.ModifyClientsideModel = function() end
        for _, x in pairs({ "OnHolster", "OnSell", "OnBuy", "OnEquip", "OnModify" }) do
            if not isfunction(v[x]) then
                v[x] = function() end
            end
        end
        v.Except = v.AllowDead
        v.Price = Evil.Cfg.Pointshop.Prices[k]
        v.__index = v

        PS.Items[k] = v
    end
end
