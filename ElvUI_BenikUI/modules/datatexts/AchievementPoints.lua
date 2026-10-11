local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local _G = _G
local strjoin = strjoin
local BreakUpLargeNumbers = BreakUpLargeNumbers

local IsInGuild = IsInGuild
local GetTotalAchievementPoints = GetTotalAchievementPoints
local GetNumCompletedAchievements = GetNumCompletedAchievements
local GetGuildInfo = GetGuildInfo

local GUILD = GUILD
local ACHIEVEMENTS_COMPLETED = ACHIEVEMENTS_COMPLETED

local icon = "|TInterface\\AchievementFrame\\UI-Achievement-TinyShield:16:16:0:-2:100:100:4:60:4:60|t"

local displayString = ''

local function OnClick()
	_G.ToggleAchievementFrame()
end

local function OnEnter()
	DT.tooltip:ClearLines()

	if IsInGuild() then
		local points = BreakUpLargeNumbers(GetTotalAchievementPoints(true))
		local guildName = GetGuildInfo("player")
		DT.tooltip:AddLine(GUILD)
		DT.tooltip:AddDoubleLine(guildName, points, 1, 1, 1, 0, 1, 0)
		DT.tooltip:AddLine(" ")
	end

	local total, completed = GetNumCompletedAchievements()
	local diff = (total ~= 0 and total) or 1
	local percent = (completed / diff * 100)

	DT.tooltip:AddLine(ACHIEVEMENTS_COMPLETED)
	DT.tooltip:AddDoubleLine(format('%s / %s', BreakUpLargeNumbers(completed), BreakUpLargeNumbers(total)), format('%.2f%%', percent), 1, 1, 1, 0, 1, 0)
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
