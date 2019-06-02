AddCSLuaFile()

Evil = Evil or {}
include("config.lua")
ApplyConfiguration(Evil)

dbg = {}
dbg.print = function(...) if Evil.Debug then print(unpack(...)) end end

local function include_cl(x) if SERVER then AddCSLuaFile(x) else include(x) end end
local function include_sh(x) if SERVER then AddCSLuaFile(x) end include(x) end
local function include_sv(x) if SERVER then include(x) end end
local function include_md(x)
    include_sh(x .. "/shared.lua")
    include_cl(x .. "/cl_init.lua")
    include_sv(x .. "/init.lua")
end

include_md "network"
include_md "roundsystem"

// http://lua-users.org/wiki/SimpleLuaClasses
function class(base, init)
    local c = {}
    if not init and type(base) == 'function' then
        init = base
    base = nil
    elseif type(base) == 'table' then
        for i,v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end
    c.__index = c
    local mt = {}
    mt.__call = function(class_tbl, ...)
    local obj = {}
    setmetatable(obj,c)
    if init then
        init(obj,...)
    else 
        if base and base.init then
            base.init(obj, ...)
        end
    end
    return obj
    end
    c.init = init
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do 
            if m == klass then return true end
            m = m._base
        end
        return false
    end
    setmetatable(c, mt)
    return c
end
