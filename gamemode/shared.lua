AddCSLuaFile()

GM.Name = "Evil"

Evil = Evil or {
    Cfg = {},
    Debug = true
}
include("config.lua")
ApplyConfiguration(Evil.Cfg)

dbg = {}
dbg.print = function(...) if Evil.Debug then print(unpack({...})) end end

local function include_cl(x) if SERVER then AddCSLuaFile(x) else include(x) end end
local function include_sh(x) if SERVER then AddCSLuaFile(x) end include(x) end
local function include_sv(x) if SERVER then include(x) end end
local function include_md(x)
    include_sh(x .. "/shared.lua")
    include_cl(x .. "/cl_init.lua")
    include_sv(x .. "/init.lua")
end
local function include_fl(scanDirectory)
    scanDirectory = GM.FolderName .. "/gamemode/" .. scanDirectory
	local q = { scanDirectory }
	while #q > 0 do
		for _, directory in pairs( q ) do
			local files, directories = file.Find( directory .. "/*", "LUA" )
			local toinc = {}
			for _, fileName in pairs( files ) do
                local relativePath = directory .. "/" .. fileName
				if string.match( fileName, "^sh" ) then
					table.insert(toinc, 1, { n = relativePath, o = 0 })
				end
				if string.match( fileName, "^sv" ) or fileName == "init.lua" then
					table.insert(toinc, { n = relativePath, o = 1 })
				end
				if string.match( fileName, "^cl" ) then
					table.insert(toinc, { n = relativePath, o = 2 })
				end
			end
            for _, v in ipairs(toinc) do
                if v.o == 0 then include_sh(v.n) end
                if v.o == 1 then include_sv(v.n) end
                if v.o == 2 then include_cl(v.n) end
            end
			for _, subdirectory in pairs( directories ) do
				table.insert( q, directory .. "/" .. subdirectory )
			end
			table.RemoveByValue( q, directory )
		end
	end
end

if SERVER then
    function Evil:Lock(reason)
        if Evil.TestingCvar and Evil.TestingCVar:GetBool() then return end
        Evil.bLocked = true
        Evil.strLockReason = reason or Lang:Get("#NoReasonGiven")
    end
end

include_sh("maps/" .. game.GetMap() .. ".lua")

if SERVER and not Map then
    Evil:Lock("this map is not configured or has a faulty configuration!")
end

if istable(Map[1]) then
    GMap = Map
    Map = GMap[1]
    hook.Add("RoundSet", "ChangeMapConfigs", function(round)
        if round != ROUND_POST then return end
        Map = GMap[math.random(#GMap)]
    end)
end

include_sh "utils.lua"
include_sh "sh_player_ext.lua"
//include_cl "textchat/cl_init.lua"
include_fl "effects"
include_fl "gui"

include_fl "lang"
include_fl "flashlight"
include_fl "admin"
include_fl "mapvote"
include_fl "network"
include_fl "stamina"
include_fl "gamesystem"
include_fl "taunt"
include_fl "roundsystem"
include_fl "spectator"
include_fl "jumpscare"
include_fl "specialrounds"
include_fl "antiafk"
include_fl "proxy"
include_fl "collectables"
include_fl "abilities"
include_fl "traits"
include_fl "classes"
include_fl "mapintegration"
include_fl "api"

include_sh "sh_resources.lua"

hook.Run("EvilLoaded")

function GM:Initialize()
    if SERVER then
        Round:Initialize()
    end
end

hook.Add("InitPostEntity", "RunMapHook", function()
    if isfunction(Map.InitPostEntity) then
        Map.InitPostEntity()
    end
end)

hook.Add("PostCleanupMap", "RunMapHook", function()
    if isfunction(Map.PostCleanUpMap) then
        Map.PostCleanUpMap()
    end
end)
