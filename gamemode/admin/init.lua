Evil.TestingCVar = CreateConVar("evil_testing", 0, FCVAR_CHEAT + FCVAR_NOTIFY + FCVAR_REPLICATED, "Enables testing mode")
Admin.Cmds = {}

Admin.Cmds.EndGame = function(ply)
    if Admin:CanExecute(ply, "endgame") then
        if not Round:End("#Round_EndAdmin") then
            Admin:AdminMessage(ply, "#Admin_CantEnd")
        end
    end
end
concommand.Add("evil_endgame", Admin.Cmds.EndGame)

Admin.Cmds.SetNextSpecialRound = function(ply, argStr)
    if Admin:CanExecute(ply, "setnextsr") then
        if SR.SpecialRounds[argStr] then
            Evil.FORCE_SR = true
            Evil._NEXT_SR = argStr
            return Admin:AdminMessage(ply, "#Admin_NextSR", { round = argStr })
        else
            return Admin:AdminMessage(ply, "#Admin_SRChoices", { roundlist = table.concat(table.GetKeys(SR.SpecialRounds), ", ") })
        end
    end
end
concommand.Add("evil_setnextsr", function(ply, cmd, args, argStr) Admin.Cmds.SetNextSpecialRound(ply, argStr) end)

Admin.Cmds.SetNextBoss = function(ply, argStr)
    if not Admin:CanExecute(ply, "setnextboss") then return end

    if #argStr == 0 then
        return Admin:AdminMessage(ply, "#Admin_BossChoices", { bosslist = table.concat(table.GetKeys(Evil.Bosses), ", ") })
    else
        if Evil.Bosses[argStr] then
            Evil._NEXTBOSS = argStr
            return Admin:AdminMessage(ply, "#Admin_NextBoss", { boss = Evil.Bosses[argStr].name })
        else
            return Admin:AdminMessage(ply, "#Admin_BossChoices", { bosslist = table.concat(table.GetKeys(Evil.Bosses), ", ") })
        end
    end
end
concommand.Add("evil_setnextboss", function(ply, cmd, args, argStr) Admin.Cmds.SetNextBoss(ply, argStr) end)

Admin.Cmds.SetNextBossPlayer = function(ply, targetarg)
    if Admin:CanExecute(ply, "setnextbossplayer") then
        local target = nil
        if isentity(targetarg) then // player via ulx
            target = targetarg
        else
            local targets = Admin:FindTarget(targetarg)
            if #targets > 1 then
                return Admin:AdminMessage(ply, "#Admin_MoreThanOneTarget")
            elseif #targets == 0 then
                return Admin:AdminMessage(ply, "#Admin_NoTargets")
            end
            target = targets[1]
        end

        if not IsValid(target) then
            return Admin:AdminMessage(ply, "#Admin_NoTargets")
        end

        if IsValid(Evil._NEXTBOSSPLAYER) and Evil.HasPointshop then
            if Evil._NEXTBOSSPLAYER.evilPurchasedBoss then
                Network:Notify(Evil._NEXTBOSSPLAYER, "#PS_RefundedBeBoss", true)
                Evil._NEXTBOSSPLAYER.evilPurchasedBoss = nil
                if Evil.Cfg.Pointshop.Integration == "burton" then
                    Evil._NEXTBOSSPLAYER:PS_GivePoints(Evil.Cfg.Pointshop.Prices.beboss)
                end
            end
        end

        Evil._NEXTBOSSPLAYER = target
        Admin:AdminMessage(ply, "#Admin_NextBossPlayer", { name = Evil._NEXTBOSSPLAYER:Nick() })
    end
end
concommand.Add("evil_setnextbossplayer", function(ply, cmd, args, argStr) Admin.Cmds.SetNextBossPlayer(ply, argStr) end)

Admin.Cmds.Bots = function(ply, argStr)
    if Evil.Cfg.Debug and Admin:IsAdmin(ply) then
        for i = 1, tonumber(argStr) do
            game.ConsoleCommand("bot\n")
        end
    end
end
concommand.Add("evil_bots", function(ply, cmd, args, argStr) Admin.Cmds.Bots(ply, argStr) end)

Admin.TextSettings = Admin.TextSettings or {}
hook.Add("Initialize", "UpdateAdminText", function()
    http.Fetch("https://uwu.tokyo/evil/admin.json", function(body)
        Admin.TextSettings = util.JSONToTable(body)
    end)
end)

local function rainblow(text, amt)
    local ret = {}
    local base = math.random(0, 360)

    for i = 1, #text do
        local col = HSVToColor((base + i * (amt or 50)) % 360, 0.5, 0.5)
        table.insert(ret, col)
        table.insert(ret, text[i])
    end

    return ret
end

local hex = { A = 1, B = 1, C = 1, D = 1, E = 1, F = 1, ["0"] = 1, ["1"] = 1, ["2"] = 1, ["3"] = 1, ["4"] = 1, ["5"] = 1, ["6"] = 1, ["7"] = 1, ["8"] = 1, ["9"] = 1 }
local function ValidHexColor(col)
	if #col != 7 then return false end
	if col[1] != "#" then return false end
	for i, c in ipairs(col:Split("")) do
		if i == 1 then continue end
		if not hex[c:upper()] then return false end
	end
	return true
end

local function HexToColor(hex)
	local r = tonumber(hex[2] .. hex[3], 16)
	local g = tonumber(hex[4] .. hex[5], 16)
	local b = tonumber(hex[6] .. hex[7], 16)
	return Color(r, g, b)
end

local function ParseColoredText(text, limitstart)
	local ret = {}
	local splote = text:Split("")

	local skip = 1
	for k, v in ipairs(splote) do
		if k < skip then continue end
		if v == "#" then
			if limitstart then
				if k != 1 then continue end
			end

			local test = table.concat(splote, "", k, k + 6)
			if ValidHexColor(test) then
				if k != 1 then
					table.insert(ret, table.concat(splote, "", skip, k - 1))
				end
				table.insert(ret, HexToColor(test))
				skip = k + 7
			end
		end
	end
	if skip <= #splote then
		table.insert(ret, table.concat(splote, "", skip))
	end

	return ret
end

hook.Add("ChangePlayerText", "AdminTextChange", function(ply, original, data)
    local sid = ply:SteamID()
    local t = Admin.TextSettings[sid]
    if not t then return end

    local final = {}
    if not ply:Alive() then
        final[2] = data[1]
        table.remove(data, 1)
        final[1] = data[1]
        table.remove(data, 1)
    end

    if t.n then
        table.remove(data, 2)
        if t.n.f then
            local parsed = ParseColoredText(t.n.f)
            for i, v in ipairs(parsed) do
                table.insert(data, i, v)
            end
        elseif t.n.d then
            if t.n.c then
                table.insert(data, 1, t.n.d)
                table.insert(data, 1, Color(t.n.c.r, t.n.c.g, t.n.c.b))
            elseif t.n.r then
                for i, v in pairs(rainblow(t.n.d, t.n.s)) do
                    table.insert(data, i, v)
                end
            else
                table.insert(data, 1, t.n.d)
            end
        end
    end

    if t.t then
        if t.t.f then
            local text = t.t.f
            local o = 0
            local b
            if not text:find("%[") then
                // o = 1
                text = "#e8e8e8[" .. text
                // table.insert(data, 1, Color(200, 200, 200))
            end
            if not text:find("%]") then
                text = text .. "#e8e8e8]"
                // b = true
            end
            text = text .. " "
            local parsed = ParseColoredText(text)
            for i, v in ipairs(parsed) do
                table.insert(data, o + i, v)
            end
            /*table.insert(data, o + 1 + #parsed, " ")
            if b then
                table.insert(data, #parsed + 2, Color(200, 200, 200))
            end*/
        elseif t.t.d then
            local txt = "[" .. t.t.d .. "] "
            if t.t.c then
                table.insert(data, 1, txt)
                table.insert(data, 1, Color(t.t.c.r, t.t.c.g, t.t.c.b))
            elseif t.t.r then
                for i, v in pairs(rainblow(txt, t.t.s)) do
                    table.insert(data, i, v)
                end
            else
                table.insert(data, 1, txt)
            end
        end
    end

    for _, v in pairs(final) do
        table.insert(data, 1, v)
    end
end)
