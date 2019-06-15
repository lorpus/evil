AddCSLuaFile()

GM.Name = "Evil"

Evil = Evil or {
    Cfg = {}
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

include_sh "utils.lua"
include_sh "sh_player_ext.lua"
include_cl "textchat/cl_init.lua"
include_sv "effects/sv_ambience.lua"
include_cl "cl_gui.lua"

include_md "flashlight"
include_md "admin"
include_md "network"
include_md "stamina"
include_md "gamesystem"
include_md "roundsystem"

function GM:Initialize()
    if SERVER then
        Round:Initialize()
    end
end
