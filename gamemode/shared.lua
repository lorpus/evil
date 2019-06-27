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

include_sh("maps/" .. game.GetMap() .. ".lua")

if SERVER and not Map then
    Evil:Lock("this map is not configured or has a faulty configuration!")
end

include_sh "utils.lua"
include_sh "sh_player_ext.lua"
//include_cl "textchat/cl_init.lua"
include_cl "effects/cl_lights.lua"
include_sv "effects/sv_ambience.lua"
include_sh "effects/sh_runanimation.lua"
include_cl "gui/cl_gui.lua"
include_cl "gui/cl_hud.lua"
include_cl "gui/cl_scoreboard.lua"
include_cl "gui/cl_monstermaker.lua"
include_sv "taunt/init.lua"

include_md "lang"
include_md "flashlight"
include_md "admin"
include_md "network"
include_md "stamina"
include_md "gamesystem"
include_md "roundsystem"
include_md "spectator"
include_md "jumpscare"
include_md "specialrounds"

include_sh "sh_resources.lua"

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
