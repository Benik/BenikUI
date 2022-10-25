local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local strjoin = strjoin

local C_Reputation_IsMajorFaction = C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions.HasMaximumRenown

local factionID = 2507
local majorFactionData

local displayString, lastPanel = ''

local function OnClick()
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
	if _G.ExpansionLandingPageMinimapButton then
		_G.ExpansionLandingPageMinimapButton:ToggleLandingPage()
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	if not C_MajorFactions_HasMaximumRenown(factionID) then
		local name = majorFactionData.name
		local earned = majorFactionData.renownReputationEarned
		local max = majorFactionData.renownLevelThreshold
		local percent = earned / max * 100

		DT.tooltip:AddLine(format('|cffFFFFFF%s|r', name))
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(format('%s/%s (%d%%)', earned, max, percent))
		DT.tooltip:Show()
	end
end

local function OnEvent(self)
	local isMajorFaction = factionID and C_Reputation_IsMajorFaction(factionID)

	if isMajorFaction then
		majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
		self.text:SetFormattedText(displayString, COVENANT_SANCTUM_TAB_RENOWN, majorFactionData.renownLevel)
	end

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = strjoin('', '%s: ', hex, '%s|r')

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Renown (BenikUI)', 'BenikUI', {'MAJOR_FACTION_UNLOCKED', 'MAJOR_FACTION_RENOWN_LEVEL_CHANGED'}, OnEvent, nil, OnClick, OnEnter, nil, nil, nil, ValueColorUpdate)