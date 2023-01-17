local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local _G = _G
local next = next
local format, sort, select = format, sort, select
local wipe, ipairs = wipe, ipairs
local GetMouseFocus = GetMouseFocus
local HideUIPanel = HideUIPanel
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local BreakUpLargeNumbers = BreakUpLargeNumbers
local ShowGarrisonLandingPage = ShowGarrisonLandingPage
local C_Garrison_HasGarrison = C_Garrison.HasGarrison
local C_Garrison_GetBuildings = C_Garrison.GetBuildings
local C_Garrison_GetInProgressMissions = C_Garrison.GetInProgressMissions
local C_Garrison_GetLandingPageShipmentInfo = C_Garrison.GetLandingPageShipmentInfo
local C_Garrison_GetCompleteTalent = C_Garrison.GetCompleteTalent
local C_Garrison_GetFollowerShipments = C_Garrison.GetFollowerShipments
local C_Garrison_GetLandingPageShipmentInfoByContainerID = C_Garrison.GetLandingPageShipmentInfoByContainerID
local C_Garrison_RequestLandingPageShipmentInfo = C_Garrison.RequestLandingPageShipmentInfo
local C_Garrison_GetCompleteMissions = C_Garrison.GetCompleteMissions
local C_Garrison_GetLooseShipments = C_Garrison.GetLooseShipments
local C_Garrison_GetTalentTreeIDsByClassID = C_Garrison.GetTalentTreeIDsByClassID
local C_Garrison_GetTalentTreeInfo = C_Garrison.GetTalentTreeInfo
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_IslandsQueue_GetIslandsWeeklyQuestID = C_IslandsQueue.GetIslandsWeeklyQuestID
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_Covenants_GetCovenantData = C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local C_CovenantCallings_AreCallingsUnlocked = C_CovenantCallings.AreCallingsUnlocked
local CovenantCalling_Create = CovenantCalling_Create
local GetMaxLevelForExpansionLevel = GetMaxLevelForExpansionLevel
local GetQuestObjectiveInfo = GetQuestObjectiveInfo
local IsAltKeyDown = IsAltKeyDown

local GARRISON_LANDING_NEXT = GARRISON_LANDING_NEXT
local CAPACITANCE_WORK_ORDERS = CAPACITANCE_WORK_ORDERS
local FOLLOWERLIST_LABEL_TROOPS = FOLLOWERLIST_LABEL_TROOPS
local GARRISON_EMPTY_IN_PROGRESS_LIST = GARRISON_EMPTY_IN_PROGRESS_LIST
local GARRISON_LANDING_SHIPMENT_COUNT = GARRISON_LANDING_SHIPMENT_COUNT
local GOAL_COMPLETED = GOAL_COMPLETED
local GARRISON_MISSION_IN_PROGRESS_TOOLTIP = GARRISON_MISSION_IN_PROGRESS_TOOLTIP
local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local ISLANDS_HEADER = ISLANDS_HEADER
local ISLANDS_QUEUE_FRAME_TITLE = ISLANDS_QUEUE_FRAME_TITLE
local ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS
local LE_EXPANSION_BATTLE_FOR_AZEROTH = LE_EXPANSION_BATTLE_FOR_AZEROTH
local LE_FOLLOWER_TYPE_GARRISON_6_0 = Enum.GarrisonFollowerType.FollowerType_6_0
local LE_FOLLOWER_TYPE_GARRISON_7_0 = Enum.GarrisonFollowerType.FollowerType_7_0
local LE_FOLLOWER_TYPE_GARRISON_8_0 = Enum.GarrisonFollowerType.FollowerType_8_0
local LE_FOLLOWER_TYPE_GARRISON_6_2 = Enum.GarrisonFollowerType.FollowerType_6_2
local LE_FOLLOWER_TYPE_GARRISON_9_0 = Enum.GarrisonFollowerType.FollowerType_9_0
local LE_GARRISON_TYPE_6_0 = Enum.GarrisonType.Type_6_0
local LE_GARRISON_TYPE_7_0 = Enum.GarrisonType.Type_7_0
local LE_GARRISON_TYPE_8_0 = Enum.GarrisonType.Type_8_0
local LE_GARRISON_TYPE_9_0 = Enum.GarrisonType.Type_9_0
local RESEARCH_TIME_LABEL = RESEARCH_TIME_LABEL

local BODYGUARD_LEVEL_XP_FORMAT = L["Rank"] .. " %d (%d/%d)"
local EXPANSION_NAME5 = EXPANSION_NAME5 -- "Warlords of Draenor"
local EXPANSION_NAME6 = EXPANSION_NAME6 -- "Legion"
local EXPANSION_NAME7 = EXPANSION_NAME7 -- "Battle for Azeroth"

local iconString = "|T%s:16:16:0:0:64:64:4:60:4:60|t"

local callingsData = {}
local covenantTreeIDs = {
	[1] = {308, 312, 316, 320, 327},
	[2] = {309, 314, 317, 324, 326},
	[3] = {307, 311, 315, 319, 328},
	[4] = {310, 313, 318, 321, 329}
}

local Widget_IDs = {
	Alliance = {
		56156, -- A Tempered Blade
		{L["Farseer Ori"], 1940},
		{L["Hunter Akana"], 1613},
		{L["Bladesman Inowari"], 1966}
	},
	Horde = {
		55500, -- Save a Friend
		{L["Neri Sharpfin"], 1621},
		{L["Poen Gillbrack"], 1622},
		{L["Vim Brineheart"], 1920}
	}
}

local function sortFunction(a, b)
	return a.missionEndTime < b.missionEndTime
end

local function LandingPage(_, ...)
	if not C_Garrison_HasGarrison(...) then
		return
	end

	if _G.GarrisonLandingPage then
		HideUIPanel(_G.GarrisonLandingPage)

		for _, frame in pairs({ 'SoulbindPanel', 'CovenantCallings', 'ArdenwealdGardeningPanel' }) do
			if _G.GarrisonLandingPage[frame] then
				_G.GarrisonLandingPage[frame]:Hide()
			end
		end
	end

	ShowGarrisonLandingPage(...)
end

local menuList = {
	{text = _G.GARRISON_LANDING_PAGE_TITLE,			 func = LandingPage, arg1 = LE_GARRISON_TYPE_6_0, notCheckable = true},
	{text = _G.ORDER_HALL_LANDING_PAGE_TITLE,		 func = LandingPage, arg1 = LE_GARRISON_TYPE_7_0, notCheckable = true},
	{text = _G.WAR_CAMPAIGN,						 func = LandingPage, arg1 = LE_GARRISON_TYPE_8_0, notCheckable = true},
	{text = _G.GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, func = LandingPage, arg1 = LE_GARRISON_TYPE_9_0, notCheckable = true},
}

local data = {}
local function AddInProgressMissions(garrisonType)
	wipe(data)

	C_Garrison_GetInProgressMissions(data, garrisonType)

	if next(data) then
		sort(data, sortFunction) --Sort by time left, lowest first

		for _, mission in ipairs(data) do
			local timeLeft = mission.timeLeft:match("%d")
			local r, g, b = 1, 1, 1
			if mission.isRare then
				r, g, b = 0.09, 0.51, 0.81
			end

			if(timeLeft and timeLeft == "0") then
				DT.tooltip:AddDoubleLine(mission.name, GOAL_COMPLETED, r, g, b, GREEN_FONT_COLOR:GetRGB())
			else
				DT.tooltip:AddDoubleLine(mission.name, mission.timeLeft, r, g, b)
			end
		end
	else
		DT.tooltip:AddLine(GARRISON_EMPTY_IN_PROGRESS_LIST, 1, 1, 1)
	end
end

local function AddFollowerInfo(garrisonType)
	data = C_Garrison_GetFollowerShipments(garrisonType)

	if next(data) then
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(FOLLOWERLIST_LABEL_TROOPS) -- 'Troops'
		for _, followerShipments in ipairs(data) do
			local name, _, _, shipmentsReady, shipmentsTotal, _, _, timeleftString = C_Garrison_GetLandingPageShipmentInfoByContainerID(followerShipments)
			if name and shipmentsReady and shipmentsTotal then
				if timeleftString then
					DT.tooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal) .. ' ' .. format(GARRISON_LANDING_NEXT,timeleftString), 1, 1, 1, 1, 1, 1)
				else
					DT.tooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1, 1, 1, 1)
				end
			end
		end
	end
end

local covenantInfo = {}
local function AddTalentInfo(garrisonType, currentCovenant)
	if garrisonType == LE_GARRISON_TYPE_9_0 then
		local current = covenantTreeIDs[currentCovenant]
		if current then
			wipe(covenantInfo)
			data = E:CopyTable(covenantInfo, current)
		else
			wipe(data)
		end
	else
		data = C_Garrison_GetTalentTreeIDsByClassID(garrisonType, E.myClassID)
	end

	if next(data) then
		-- This is a talent that has completed, but has not been seen in the talent UI yet.
		-- No longer provide relevant output in SL. Still used by old content.
		local completeTalentID = C_Garrison_GetCompleteTalent(garrisonType)
		if completeTalentID > 0 and garrisonType ~= LE_GARRISON_TYPE_9_0 then
			DT.tooltip:AddLine(' ')
			DT.tooltip:AddLine(RESEARCH_TIME_LABEL) -- 'Research Time:'

			for _, treeID in ipairs(data) do
				local treeInfo = C_Garrison_GetTalentTreeInfo(treeID)
				for _, talent in ipairs(treeInfo.talents) do
					if talent.isBeingResearched or (talent.id == completeTalentID and garrisonType ~= LE_GARRISON_TYPE_9_0)then
						if talent.timeRemaining and talent.timeRemaining == 0 then
							DT.tooltip:AddDoubleLine(talent.name, GOAL_COMPLETED, 1, 1, 1, GREEN_FONT_COLOR:GetRGB())
						else
							DT.tooltip:AddDoubleLine(talent.name, SecondsToTime(talent.timeRemaining), 1, 1, 1, 1, 1, 1)
						end
					end
				end
			end
		end
	end
end

local function GetInfo(id)
	local info = C_CurrencyInfo_GetCurrencyInfo(id)
	return info.quantity, info.name, (info.iconFileID and format(iconString, info.iconFileID)) or '136012'
end

local function AddInfo(id)
	local num, _, icon = GetInfo(id)
	return format('%s %s', icon, BreakUpLargeNumbers(num))
end

local function OnEnter()
	DT.tooltip:ClearLines()

	DT.tooltip:AddLine(EXPANSION_NAME8, 1, .5, 0)
	DT.tooltip:AddDoubleLine(L["Mission(s) Report:"], AddInfo(1813), nil, nil, nil, 1, 1, 1)
	AddInProgressMissions(LE_FOLLOWER_TYPE_GARRISON_9_0)

	if C_CovenantCallings_AreCallingsUnlocked() then
		local questNum = 0
		for _, calling in ipairs(callingsData) do
			local callingObj = CovenantCalling_Create(calling)
			if callingObj:GetState() == 0 then
				questNum = questNum + 1
			end
		end
		if questNum > 0 then
			DT.tooltip:AddLine(' ')
			DT.tooltip:AddLine(format('%s %s', questNum, L["Calling Quest(s) available."]))
		end
	end

	local currentCovenant = C_Covenants_GetActiveCovenantID()
	if currentCovenant and currentCovenant > 0 then
		AddTalentInfo(LE_GARRISON_TYPE_9_0, currentCovenant)
	end

	if IsShiftKeyDown() then
		-- Battle for Azeroth
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(EXPANSION_NAME7, 1, .5, 0)
		DT.tooltip:AddDoubleLine(L["Mission(s) Report:"], AddInfo(1560), nil, nil, nil, 1, 1, 1)
		AddInProgressMissions(LE_FOLLOWER_TYPE_GARRISON_8_0)

		-- Island Expeditions
		if E.mylevel >= GetMaxLevelForExpansionLevel(LE_EXPANSION_BATTLE_FOR_AZEROTH) then
			local questID = C_IslandsQueue_GetIslandsWeeklyQuestID()
			if questID then
				local _, _, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(questID, 1, false)
				local text, r1, g1, b1

				if finished or C_QuestLog_IsQuestFlaggedCompleted(questID) then
					text = GOAL_COMPLETED
					r1, g1, b1 = GREEN_FONT_COLOR:GetRGB()
				else
					text = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:format(numFulfilled, numRequired)
					r1, g1, b1 = 1, 1, 1
				end

				DT.tooltip:AddLine(' ')
				DT.tooltip:AddLine(ISLANDS_HEADER .. ':')
				DT.tooltip:AddDoubleLine(ISLANDS_QUEUE_FRAME_TITLE, text, 1, 1, 1, r1, g1, b1)
			end
		end

		AddFollowerInfo(LE_GARRISON_TYPE_7_0)
		AddTalentInfo(LE_GARRISON_TYPE_7_0)

		-- Legion
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(EXPANSION_NAME6, 1, .5, 0)
		DT.tooltip:AddDoubleLine(L["Mission(s) Report:"], AddInfo(1220), nil, nil, nil, 1, 1, 1)

		AddInProgressMissions(LE_FOLLOWER_TYPE_GARRISON_7_0)
		AddFollowerInfo(LE_GARRISON_TYPE_7_0)

		-- 'Loose Work Orders' (i.e. research, equipment)
		data = C_Garrison_GetLooseShipments(LE_GARRISON_TYPE_7_0)
		if next(data) then
			DT.tooltip:AddLine(CAPACITANCE_WORK_ORDERS) -- 'Work Orders'

			for _, looseShipments in ipairs(data) do
				local name, _, _, shipmentsReady, shipmentsTotal, _, _, timeleftString = C_Garrison_GetLandingPageShipmentInfoByContainerID(looseShipments)
				if name then
					if timeleftString then
						DT.tooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal) .. ' ' .. format(GARRISON_LANDING_NEXT,timeleftString), 1, 1, 1, 1, 1, 1)
					else
						DT.tooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1, 1, 1, 1)
					end
				end
			end
		end

		AddTalentInfo(LE_GARRISON_TYPE_7_0)

		-- Warlords of Draenor
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(EXPANSION_NAME5, 1, .5, 0)
		DT.tooltip:AddDoubleLine(L["Mission(s) Report:"], AddInfo(824), nil, nil, nil, 1, 1, 1)
		AddInProgressMissions(LE_FOLLOWER_TYPE_GARRISON_6_0)

		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["Naval Mission(s) Report:"], AddInfo(1101), nil, nil, nil, 1, 1 , 1)
		AddInProgressMissions(LE_FOLLOWER_TYPE_GARRISON_6_2)

		--Buildings
		data = C_Garrison_GetBuildings(LE_GARRISON_TYPE_6_0)
		if next(data) then
			local AddLine = true
			for _, buildings in ipairs(data) do
				local name, _, _, shipmentsReady, shipmentsTotal, _, _, timeleftString = C_Garrison_GetLandingPageShipmentInfo(buildings.buildingID)
				if name and shipmentsTotal then
					if AddLine then
						DT.tooltip:AddLine(' ')
						DT.tooltip:AddLine(L["Building(s) Report:"])
						AddLine = false
					end

					if timeleftString then
						DT.tooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal) .. ' ' .. format(GARRISON_LANDING_NEXT,timeleftString), 1, 1, 1, 1, 1, 1)
					else
						DT.tooltip:AddDoubleLine(name, format(GARRISON_LANDING_SHIPMENT_COUNT, shipmentsReady, shipmentsTotal), 1, 1, 1, 1, 1, 1)
					end
				end
			end
		end
	else
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine('Hold Shift - Show Previous Expansion', .66, .66, .66)
	end

	DT.tooltip:Show()
end

local function OnClick(self, btn)
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end

	if btn == "LeftButton" then
		if C_Covenants_GetCovenantData(C_Covenants_GetActiveCovenantID()) then
			HideUIPanel(_G.GarrisonLandingPage)
			ShowGarrisonLandingPage(LE_GARRISON_TYPE_9_0)
		end
	elseif btn == "RightButton" then
		E:SetEasyMenuAnchor(E.EasyMenu, self)
		_G.EasyMenu(menuList, E.EasyMenu, nil, nil, nil, "MENU")
	end
end

local inProgressMissions = {}
local expansions = {
	LE_FOLLOWER_TYPE_GARRISON_6_2,
	LE_FOLLOWER_TYPE_GARRISON_6_0,
	LE_FOLLOWER_TYPE_GARRISON_7_0,
	LE_FOLLOWER_TYPE_GARRISON_8_0,
	LE_FOLLOWER_TYPE_GARRISON_9_0
}
local CountInProgress = 0
local CountCompleted = 0

local function OnEvent(self, event, ...)

	if event == 'GARRISON_SHIPMENT_RECEIVED' or (event == 'SHIPMENT_UPDATE' and select(1, ...) == true) then
		C_Garrison_RequestLandingPageShipmentInfo()
	end

	if event == 'COVENANT_CALLINGS_UPDATED' then
		wipe(callingsData)
		callingsData = ...
	end

	if event == 'GARRISON_MISSION_NPC_OPENED' then
		self:RegisterEvent('GARRISON_MISSION_LIST_UPDATE')
	elseif event == 'GARRISON_MISSION_NPC_CLOSED' then
		self:UnregisterEvent('GARRISON_MISSION_LIST_UPDATE')
	end

	if event == 'GARRISON_LANDINGPAGE_SHIPMENTS' or event == 'GARRISON_MISSION_FINISHED' or event == 'GARRISON_MISSION_NPC_CLOSED' or event == 'GARRISON_MISSION_LIST_UPDATE' then
		CountCompleted = #C_Garrison_GetCompleteMissions(LE_FOLLOWER_TYPE_GARRISON_9_0)
		+ #C_Garrison_GetCompleteMissions(LE_FOLLOWER_TYPE_GARRISON_8_0)
		+ #C_Garrison_GetCompleteMissions(LE_FOLLOWER_TYPE_GARRISON_7_0)
		+ #C_Garrison_GetCompleteMissions(LE_FOLLOWER_TYPE_GARRISON_6_0)
		+ #C_Garrison_GetCompleteMissions(LE_FOLLOWER_TYPE_GARRISON_6_2)

		for _, expansion in ipairs(expansions) do
			C_Garrison_GetInProgressMissions(inProgressMissions, expansion)
			for _, mission in ipairs(inProgressMissions) do
				local timeLeft = mission.timeLeftSeconds
				if (timeLeft ~= 0) then
					CountInProgress = #inProgressMissions
				end
			end
		end
	end

	if (CountCompleted == 0) and CountInProgress > 0 then
		self.text:SetFormattedText("%s: |cffffa500%d|r", GARRISON_MISSION_IN_PROGRESS_TOOLTIP, CountInProgress)
	elseif (CountInProgress == 0) and CountCompleted > 0 then
		self.text:SetFormattedText("%s: |cff00ff00%d|r", GOAL_COMPLETED, CountCompleted)
	elseif (CountInProgress > 0) then
		self.text:SetFormattedText("%s: |cff00ff00%d|r/|cffffa500%d|r", GARRISON_MISSIONS, CountCompleted, CountInProgress)
	else
		self.text:SetFormattedText(GARRISON_TYPE_8_0_LANDING_PAGE_TITLE)
	end

	if event == 'MODIFIER_STATE_CHANGED' and not IsAltKeyDown() and GetMouseFocus() == self then
		OnEnter(self)
	end
end

DT:RegisterDatatext('Missions (BenikUI)', 'BenikUI', {'PLAYER_ENTERING_WORLD', 'GARRISON_LANDINGPAGE_SHIPMENTS', 'GARRISON_TALENT_UPDATE', 'GARRISON_TALENT_COMPLETE', 'GARRISON_SHIPMENT_RECEIVED', 'SHIPMENT_UPDATE', 'GARRISON_MISSION_FINISHED', 'GARRISON_MISSION_NPC_CLOSED', 'GARRISON_MISSION_NPC_OPENED', 'MODIFIER_STATE_CHANGED', 'COVENANT_CALLINGS_UPDATED'}, OnEvent, nil, OnClick, OnEnter)
