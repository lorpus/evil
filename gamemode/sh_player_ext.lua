local PLAYER = FindMetaTable("Player")

local DefaultModels = {
	"models/player/Group01/Male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/Male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl",
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl"
}
for _, x in pairs(DefaultModels) do util.PrecacheModel(x) end

if SERVER then
    function PLAYER:SetDefaultModel()
        self:SetModel(DefaultModels[math.random(#DefaultModels)])
    end
end

function PLAYER:IsHuman()
	return self:Team() == TEAM_HUMAN
end

function PLAYER:IsBoss()
	return self:Team() == TEAM_BOSS
end

function PLAYER:IsProxy()
	return self:Team() == TEAM_PROXY
end

function PLAYER:IsSpecTeam() // avoid confusion
	return self:Team() == TEAM_SPEC
end

function PLAYER:IsGhost()
	return self:GetNW2Bool("EvilGhost")
end

function PLAYER:EvilName()
	if self:Alive() and self:IsHuman() then
        return self:GetNW2String("ClassName")
    else
        return self:Nick()
    end
end
