local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local strjoin, wipe, format, next = strjoin, wipe, format, next

local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions.HasMaximumRenown
local C_MajorFactions_GetMajorFactionIDs = C_MajorFactions.GetMajorFactionIDs
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagonForCurrentPlayer
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_SeasonInfo_GetCurrentDisplaySeasonExpansion = C_SeasonInfo.GetCurrentDisplaySeasonExpansion
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local GetExpansionLevel = GetExpansionLevel
local InCombatLockdown = InCombatLockdown
local ShowUIPanel = ShowUIPanel

local BLUE_FONT_COLOR = BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = RENOWN_LEVEL_LABEL
local LANDING_PAGE_RENOWN_LABEL = LANDING_PAGE_RENOWN_LABEL
local JOURNEYS_RENOWN_LABEL = JOURNEYS_RENOWN_LABEL
local JOURNEYS_TOOLTIP_VIEW_JOURNEY = JOURNEYS_TOOLTIP_VIEW_JOURNEY
local LE_EXPANSION_DRAGONFLIGHT = LE_EXPANSION_DRAGONFLIGHT

local BLUE_COLOR_HEX = E:RGBToHex(BLUE_FONT_COLOR.r, BLUE_FONT_COLOR.g, BLUE_FONT_COLOR.b)

local factionIDs = {}

local displayString, lastPanel = ''
local expansionName = _G["EXPANSION_NAME" .. GetExpansionLevel()] or ""

local function IsExpansionAvailable()
	return GetExpansionLevel() >= LE_EXPANSION_DRAGONFLIGHT
end

local function IsDelvesSeasonFaction(data)
	return data.textureKit and data.textureKit:lower():find("delve") ~= nil
end

local function FilteredRenownFactions(factionID)
	if not factionID then return false end

	local data = C_MajorFactions_GetMajorFactionData(factionID)
	if not data then return false end

	-- Get rid of Delves Seasons
	if IsDelvesSeasonFaction(data) then
		return false
	end

	-- Filter Factions by Expansion
	local selectedExpansion = E.private.benikui.datatexts.renownFilter.expansion or 0
	if selectedExpansion ~= 0 and data.expansionID ~= selectedExpansion then
		return false
	end

	-- Check if a Faction is unlocked
	if not data.isUnlocked then
		return false
	end

	-- Must have renown levels?
	local renownValue = data.renownLevel
	if not renownValue or renownValue == 0 then
		return false
	end

	return true
end

local function UpdateDB()
	wipe(factionIDs)

	for _, factionID in next, C_MajorFactions_GetMajorFactionIDs() do
		if FilteredRenownFactions(factionID) then
			factionIDs[#factionIDs + 1] = factionID
		end
	end
end

local function OnEvent(self)
	UpdateDB()

	local factionID = E.private.benikui.datatexts.renown.factionID
	local majorFactionData = factionID and C_MajorFactions_GetMajorFactionData(factionID)

	if majorFactionData then
		self.text:SetFormattedText(displayString, LANDING_PAGE_RENOWN_LABEL, majorFactionData.renownLevel)
	else
		self.text:SetFormattedText(displayString, LANDING_PAGE_RENOWN_LABEL, "-")
	end

	lastPanel = self
end

local function setSelectedFaction(_, ...)
	local factionID = (...)
	E.private.benikui.datatexts.renown.factionID = factionID

	DT:CloseMenus()
	OnEvent(lastPanel)
end

local menuList = {
	{text = (format('%s (%s)', JOURNEYS_RENOWN_LABEL, expansionName)), isTitle = true, notCheckable = true },
}

local function menu_checked(data)
	return data and data.arg1 == E.private.benikui.datatexts.renown.factionID
end

local function OnClick(self, btn)
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end

	if not IsExpansionAvailable() then return end

	if btn == 'RightButton' then
		E:SetEasyMenuAnchor(E.EasyMenu, self)
		E:ComplicatedMenu(menuList, E.EasyMenu, nil, nil, nil, 'MENU')
	else
		if not IsAddOnLoaded('Blizzard_EncounterJournal') then
			EncounterJournal_LoadUI()
		end

		local ej = _G.EncounterJournal
		if ej then
			if not ej:IsShown() then
				ShowUIPanel(ej)
			end

			local journeys = _G.EncounterJournalJourneysFrame
			if journeys then
				local factionID = E.private.benikui.datatexts.renown.factionID
				journeys:ResetView(nil, factionID)
			end
		end
	end
end

local function OnEnter(self)
	if not IsExpansionAvailable() then return end

	DT:SetupTooltip(self)

	local activeFaction = E.private.benikui.datatexts.renown.factionID

	-- keep the title at index 1
	for i = #menuList, 2, -1 do
		menuList[i] = nil
	end

	for i, factionID in next, factionIDs do
		local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
		if majorFactionData then
			local isMaxRenown = C_MajorFactions_HasMaximumRenown(factionID)
			local earned = isMaxRenown and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
			local max = majorFactionData.renownLevelThreshold
			local factionName = majorFactionData.name
			local factionRenownLevel = majorFactionData.renownLevel
			local isParagon = C_Reputation_IsFactionParagon(factionID)

			if isParagon then
				local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
				if currentValue and threshold and threshold > 0 then
					max = threshold
					earned = currentValue % threshold
					if hasRewardPending then
						earned = earned + threshold
					end
				end
			end

			local percent = (max and max > 0) and (earned / max * 100) or 0

			if activeFaction == factionID then
				DT.tooltip:AddLine(format('|cff3CEF3D%s (Active)|r', factionName))
			else
				DT.tooltip:AddLine(format('|cffFFFFFF%s|r', factionName))
			end

			DT.tooltip:AddLine(format('%s/%s (%d%%)', earned, max, percent))
			DT.tooltip:AddLine(format('%s%s|r', BLUE_COLOR_HEX, RENOWN_LEVEL_LABEL:format(factionRenownLevel)))
			DT.tooltip:AddLine(' ')

			menuList[i + 1] = {text = (format('%s %s(%s)|r', factionName, BLUE_COLOR_HEX, factionRenownLevel)),	func = setSelectedFaction, arg1 = factionID, checked = menu_checked}
		end
	end

	DT.tooltip:AddDoubleLine('Right Click:', 'Track Faction', 0.7, 0.7, 1, 0.7, 0.7, 1)
	DT.tooltip:AddDoubleLine('Left Click:', JOURNEYS_TOOLTIP_VIEW_JOURNEY, 0.7, 0.7, 1, 0.7, 0.7, 1)
	DT.tooltip:Show()
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', '%s: ', hex, '%s|r')

	OnEvent(self)
end

DT:RegisterDatatext('Renown (BenikUI)', 'BenikUI', {'MAJOR_FACTION_UNLOCKED', 'MAJOR_FACTION_RENOWN_LEVEL_CHANGED'}, OnEvent, nil, OnClick, OnEnter, nil, nil, nil, ValueColorUpdate)
