local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local strjoin, wipe, format, next, tsort, ipairs = strjoin, wipe, format, next, table.sort, ipairs

local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions.HasMaximumRenown
local C_MajorFactions_GetMajorFactionIDs = C_MajorFactions.GetMajorFactionIDs
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagonForCurrentPlayer
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local InCombatLockdown = InCombatLockdown
local ShowUIPanel = ShowUIPanel

local BLUE_FONT_COLOR = BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = RENOWN_LEVEL_LABEL
local LANDING_PAGE_RENOWN_LABEL = LANDING_PAGE_RENOWN_LABEL

local BLUE_COLOR_HEX = E:RGBToHex(BLUE_FONT_COLOR.r, BLUE_FONT_COLOR.g, BLUE_FONT_COLOR.b)

local factionIDs = {}

local displayString, lastPanel = ''

local function IsSeasonalFaction(data)
	if not data.textureKit then return false end

	local kit = data.textureKit:lower()
	return kit:find("delve") ~= nil or kit:find("prey") ~= nil
end

local function FilteredRenownFactions(factionID)
	if not factionID then return false end

	local data = C_MajorFactions_GetMajorFactionData(factionID)
	if not data then return false end

	-- Get rid of Delves and Prey Seasons
	if IsSeasonalFaction(data) then
		return false
	end

	-- Filter Factions by Expansion
	local savedExpansion = E.private.benikui.datatexts.renown.expansionID
	if savedExpansion and data.expansionID ~= savedExpansion then
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

	local factionIsValid = false
	for _, id in next, factionIDs do
		if id == factionID then
			factionIsValid = true
			break
		end
	end

	if not factionIsValid then
		factionID = factionIDs[1] or nil
		E.private.benikui.datatexts.renown.factionID = factionID
	end

	local majorFactionData = factionID and C_MajorFactions_GetMajorFactionData(factionID)

	if majorFactionData then
		self.text:SetFormattedText(displayString, LANDING_PAGE_RENOWN_LABEL, majorFactionData.renownLevel)
	else
		self.text:SetFormattedText(displayString, LANDING_PAGE_RENOWN_LABEL, "-")
	end

	lastPanel = self
end

local function setSelectedFaction(_, ...)
	local factionID, expansionID = ...
	E.private.benikui.datatexts.renown.factionID = factionID
	E.private.benikui.datatexts.renown.expansionID = expansionID

	DT:CloseMenus()
	OnEvent(lastPanel)
end

local menuList = {}

local function menu_checked(data)
	return data and data.arg1 == E.private.benikui.datatexts.renown.factionID
end

local function BuildMenu()
	for i = #menuList, 2, -1 do
		menuList[i] = nil
	end

	local factionsByExpansion = {}
	local expansionOrder = {}

	for _, factionID in next, C_MajorFactions_GetMajorFactionIDs() do
		local data = C_MajorFactions_GetMajorFactionData(factionID)

		if data and not IsSeasonalFaction(data) then
			local expID = data.expansionID

			if not factionsByExpansion[expID] then
				factionsByExpansion[expID] = {}
				expansionOrder[#expansionOrder + 1] = expID
			end

			local t = factionsByExpansion[expID]
			t[#t + 1] = factionID
		end
	end

	tsort(expansionOrder, function(a, b) return a > b end) -- Newest expansion first

	for i, expID in ipairs(expansionOrder) do
		local subMenu = {{ text = _G["EXPANSION_NAME"..expID], isTitle = true, notCheckable = true },}

		for _, factionID in next, factionsByExpansion[expID] do
			local data = C_MajorFactions_GetMajorFactionData(factionID)
			if data then
				if data.isUnlocked and data.renownLevel and data.renownLevel > 0 then
					subMenu[#subMenu + 1] = {
						text = format('%s %s(%s)|r', data.name, BLUE_COLOR_HEX, data.renownLevel),
						func = setSelectedFaction,
						arg1 = factionID,
						arg2 = expID,
						checked = menu_checked,
					}
				else
					subMenu[#subMenu + 1] = {
						text = format('|cff808080%s|r', data.name), -- cheat disabled
						func = function() end,		-- cheat to show the arrow
						checked = function() end,	-- cheat disabled
						--disabled = true, -- not working
					}
				end
			end
		end

		menuList[i + 1] = {
			text = _G["EXPANSION_NAME"..expID],
			hasArrow = true,
			notCheckable = true,
			menuList = subMenu,
		}
	end
end

local function OnClick(self, btn)
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end

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
	DT:SetupTooltip(self)

	BuildMenu()

	if not factionIDs[1] then
		DT.tooltip:AddLine('No renown factions available.', 1, 0.5, 0.5)
		DT.tooltip:Show()
		return
	end

	local activeFaction = E.private.benikui.datatexts.renown.factionID
	for _, factionID in next, factionIDs do
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
		end
	end

	DT.tooltip:AddDoubleLine('Click:', 'View Faction Journey', 0.7, 0.7, 1, 0.7, 0.7, 1)
	DT.tooltip:AddDoubleLine('Right Click:', 'Select Tracked Faction', 0.7, 0.7, 1, 0.7, 0.7, 1)
	DT.tooltip:Show()
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', '%s: ', hex, '%s|r')

	OnEvent(self)
end

DT:RegisterDatatext('Renown (BenikUI)', 'BenikUI', {'MAJOR_FACTION_UNLOCKED', 'MAJOR_FACTION_RENOWN_LEVEL_CHANGED'}, OnEvent, nil, OnClick, OnEnter, nil, nil, nil, ValueColorUpdate)
