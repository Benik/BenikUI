local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local strjoin = strjoin

local IsInGuild = IsInGuild
local GetTotalAchievementPoints = GetTotalAchievementPoints
local GetGuildInfo = GetGuildInfo

local icon = "|TInterface\\AchievementFrame\\UI-Achievement-TinyShield:16:16:0:-2:100:100:4:60:4:60|t"

local displayString = ''

local function OnClick()
	ToggleAchievementFrame()
end

local function OnEnter()
	if not IsInGuild() then return end
	DT.tooltip:ClearLines()

	local points = BreakUpLargeNumbers(GetTotalAchievementPoints(true))
	local guildName = GetGuildInfo("player")

	DT.tooltip:AddLine(GUILD)
	DT.tooltip:AddDoubleLine(guildName, points, 1, 1, 1, 0, 1, 0)
	DT.tooltip:Show()
end

local function OnEvent(self)
	local points = BreakUpLargeNumbers(GetTotalAchievementPoints())
	self.text:SetFormattedText(displayString, icon, points)
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', '%s ', hex, '%s|r')

	OnEvent(self)
end

DT:RegisterDatatext('Achievement Points (BenikUI)', 'BenikUI', {'ACHIEVEMENT_EARNED'}, OnEvent, nil, OnClick, OnEnter, nil, nil, nil, ValueColorUpdate)
