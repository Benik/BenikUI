local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions.HasMaximumRenown
local C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer = C_PlayerInfo.IsExpansionLandingPageUnlockedForPlayer

local BLUE_FONT_COLOR = BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = RENOWN_LEVEL_LABEL

local BLUE_COLOR_HEX = E:RGBToHex(BLUE_FONT_COLOR.r, BLUE_FONT_COLOR.g, BLUE_FONT_COLOR.b)

local factionIDs = {
	2503, -- Maruuk Centaur
	2507, -- Dragonscale Expedition
	2510, -- Valdrakken Accord
	2511, -- Iskaara Tuskarr
}

local lastPanel = ''

local function OnClick()
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
	if not C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_DRAGONFLIGHT) then return end
	if _G.ExpansionLandingPageMinimapButton then
		_G.ExpansionLandingPageMinimapButton:ToggleLandingPage()
	end
end

local function OnEnter(self)
	if C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_DRAGONFLIGHT) then
		DT:SetupTooltip(self)
		for _, factionID in pairs(factionIDs) do
			local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
			if not C_MajorFactions_HasMaximumRenown(factionID) then
				local name = majorFactionData.name
				local earned = C_MajorFactions_HasMaximumRenown(factionID) and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
				local max = majorFactionData.renownLevelThreshold
				local renown = majorFactionData.renownLevel
				local isUnlocked = majorFactionData.isUnlocked
				local percent = earned / max * 100

				if isUnlocked then
					DT.tooltip:AddLine(format('|cffFFFFFF%s|r', name))
					DT.tooltip:AddLine(format('%s/%s (%d%%)', earned, max, percent))
					DT.tooltip:AddLine(format('%s%s %s|r', BLUE_COLOR_HEX, RENOWN_LEVEL_LABEL, renown))
					DT.tooltip:AddLine(' ')
				else
					DT.tooltip:AddLine(format('|cff999999%s|r', name))
					DT.tooltip:AddLine(format('|cffAFAF01%s|r', MAJOR_FACTION_BUTTON_FACTION_LOCKED))
					DT.tooltip:AddLine(' ')
				end
			end
		end
		DT.tooltip:AddDoubleLine(L['Click:'], DRAGONFLIGHT_LANDING_PAGE_TITLE, 0.7, 0.7, 1, 0.7, 0.7, 1)
		DT.tooltip:Show()
	end
end

local function OnEvent(self)
	self.text:SetFormattedText(COVENANT_SANCTUM_TAB_RENOWN)
	lastPanel = self
end

DT:RegisterDatatext('Renown (BenikUI)', 'BenikUI', nil, OnEvent, nil, OnClick, OnEnter)