local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local strjoin = strjoin

local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions.HasMaximumRenown
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer = C_PlayerInfo.IsExpansionLandingPageUnlockedForPlayer

local BLUE_FONT_COLOR = BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = RENOWN_LEVEL_LABEL
local COVENANT_SANCTUM_TAB_RENOWN = COVENANT_SANCTUM_TAB_RENOWN
local LE_EXPANSION_DRAGONFLIGHT = LE_EXPANSION_DRAGONFLIGHT
local LE_EXPANSION_WAR_WITHIN = LE_EXPANSION_WAR_WITHIN

local BLUE_COLOR_HEX = E:RGBToHex(BLUE_FONT_COLOR.r, BLUE_FONT_COLOR.g, BLUE_FONT_COLOR.b)

local factionIDs = {
	-- DF
	2503, -- Maruuk Centaur
	2507, -- Dragonscale Expedition
	2510, -- Valdrakken Accord
	2511, -- Iskaara Tuskarr
	2564, -- Loamm Niffen
	2574, -- Dream Wardens
	-- TWW
	2590, -- Council of Dornogal
	2570, -- Hallowfall Arathi
	2594, -- The Assembly of the Deeps
	2600, -- The Severed Threads
	2653, -- The Cartels of Undermine
}

local displayString, lastPanel = ''

local function OnEvent(self)
	local factionID = E.private.benikui.datatexts.renown.factionID

	if (C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_DRAGONFLIGHT) or C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_WAR_WITHIN)) then
		local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
		self.text:SetFormattedText(displayString, COVENANT_SANCTUM_TAB_RENOWN, majorFactionData.renownLevel)
	else
		self.text:SetFormattedText(displayString, COVENANT_SANCTUM_TAB_RENOWN, "-")
	end

	lastPanel = self
end

local function setSelectedFaction(_, ...)
	local factionID = (...)
	E.private.benikui.datatexts.renown.factionID = factionID
	OnEvent(lastPanel)
end

local menuList = {
	{text = L["Renown"], isTitle = true, notCheckable = true },
	{text = nil, func = setSelectedFaction, arg1 = nil, notCheckable = true, disabled = true},
}

local function menu_checked(data) return data and data.arg1 == E.private.benikui.datatexts.renown.factionID end

local function OnClick(self, btn)
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
	if not (C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_DRAGONFLIGHT) or C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_WAR_WITHIN)) then return end

	if btn == 'RightButton' then
		E:SetEasyMenuAnchor(E.EasyMenu, self)
		E:ComplicatedMenu(menuList, E.EasyMenu, nil, nil, nil, 'MENU')
	else
		if _G.ExpansionLandingPageMinimapButton then
			_G.ExpansionLandingPageMinimapButton:ToggleLandingPage()
		end
	end
end

local function OnEnter(self)
	if (C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_DRAGONFLIGHT) or C_PlayerInfo_IsExpansionLandingPageUnlockedForPlayer(LE_EXPANSION_WAR_WITHIN)) then
		DT:SetupTooltip(self)

		local activeFaction = E.private.benikui.datatexts.renown.factionID
		for i, factionID in pairs(factionIDs) do
			local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
			local earned = C_MajorFactions_HasMaximumRenown(factionID) and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
			local max = majorFactionData.renownLevelThreshold
			local percent = earned / max * 100
			local factionName = majorFactionData.name
			local factionRenownLevel = majorFactionData.renownLevel
			local factionIsUnlocked = majorFactionData.isUnlocked
			local isParagon = C_Reputation_IsFactionParagon(factionID)

			if isParagon then
				local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
				if currentValue and threshold then
					max = threshold
					earned = currentValue % threshold
					if hasRewardPending then
						earned = earned + threshold
					end
					percent = earned / max * 100
				end
			end

			if factionIsUnlocked then
				if activeFaction == factionID then
					DT.tooltip:AddLine(format('|cff3CEF3D%s (Active)|r', factionName))
				else
					DT.tooltip:AddLine(format('|cffFFFFFF%s|r', factionName))
				end
				DT.tooltip:AddLine(format('%s/%s (%d%%)', earned, max, percent))
				DT.tooltip:AddLine(format('%s%s|r', BLUE_COLOR_HEX, RENOWN_LEVEL_LABEL:format(factionRenownLevel)))
				DT.tooltip:AddLine(' ')

				menuList[i + 1] = {text = factionName,	func = setSelectedFaction, arg1 = factionID, checked = menu_checked, disabled = false}
			else
				DT.tooltip:AddLine(format('|cff999999%s|r', factionName))
				DT.tooltip:AddLine(format('|cffAFAF01%s|r', MAJOR_FACTION_BUTTON_FACTION_LOCKED))
				DT.tooltip:AddLine(' ')

				menuList[i + 1] = {text = factionName,	func = setSelectedFaction, arg1 = factionID, notCheckable = true, disabled = true}
			end
		end

		DT.tooltip:AddDoubleLine('Right Click:', 'Track Faction', 0.7, 0.7, 1, 0.7, 0.7, 1)
		DT.tooltip:AddDoubleLine('Left Click:', 'Expansion Landing Page', 0.7, 0.7, 1, 0.7, 0.7, 1)
		DT.tooltip:Show()
	end
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', '%s: ', hex, '%s|r')

	OnEvent(self)
end

DT:RegisterDatatext('Renown (BenikUI)', 'BenikUI', {'MAJOR_FACTION_UNLOCKED', 'MAJOR_FACTION_RENOWN_LEVEL_CHANGED'}, OnEvent, nil, OnClick, OnEnter, nil, nil, nil, ValueColorUpdate)
