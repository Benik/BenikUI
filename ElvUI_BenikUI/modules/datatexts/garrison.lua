local E, L, V, P, G =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

-- Missions are based on TukUI Garrison DataText. Credits: Hydra, Tukz

local join = string.join
local format = string.format
local tsort = table.sort

local GetCurrencyInfo = GetCurrencyInfo
local C_GarrisonRequestLandingPageShipmentInfo = C_Garrison.RequestLandingPageShipmentInfo
local C_GarrisonGetBuildings = C_Garrison.GetBuildings
local C_GarrisonGetInProgressMissions = C_Garrison.GetInProgressMissions
local C_GarrisonGetLandingPageShipmentInfo = C_Garrison.GetLandingPageShipmentInfo
local C_GarrisonGetAvailableMissions = C_Garrison.GetAvailableMissions
local C_Garrison_HasGarrison = C_Garrison.HasGarrison
local LoadAddOn = LoadAddOn
local GarrisonMissionFrame = GarrisonMissionFrame

local LE_FOLLOWER_TYPE_GARRISON_6_0, LE_FOLLOWER_TYPE_SHIPYARD_6_2 = LE_FOLLOWER_TYPE_GARRISON_6_0, LE_FOLLOWER_TYPE_SHIPYARD_6_2
local GARRISON_MISSIONS, GARRISON_LOCATION_TOOLTIP, GARRISON_SHIPMENT_EMPTY, GARRISON_MISSIONS_TITLE = GARRISON_MISSIONS, GARRISON_LOCATION_TOOLTIP, GARRISON_SHIPMENT_EMPTY, GARRISON_MISSIONS_TITLE
local AVAILABLE, GARRISON_MISSION_COMPLETE = AVAILABLE, GARRISON_MISSION_COMPLETE
local CAPACITANCE_WORK_ORDERS, SPLASH_NEW_6_2_FEATURE2_TITLE, MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP = CAPACITANCE_WORK_ORDERS, SPLASH_NEW_6_2_FEATURE2_TITLE, MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP

-- GLOBALS: selectioncolor

local displayModifierString = ''
local lastPanel;
local GARRISON_CURRENCY = 824
local GARRISON_CURRENCY_OIL = 1101

local OnEvent = function(self)
	local inProgressMissions = {};
	C_GarrisonGetInProgressMissions(inProgressMissions, LE_FOLLOWER_TYPE_GARRISON_6_0)
	local CountInProgress = 0
	local CountCompleted = 0

	for i = 1, #inProgressMissions do
		if inProgressMissions[i].inProgress then
			local TimeLeft = inProgressMissions[i].timeLeft:match("%d")
			
			if (TimeLeft ~= "0") then
				CountInProgress = CountInProgress + 1
			else
				CountCompleted = CountCompleted + 1
			end
		end
	end

	if (CountInProgress > 0) then
		self.text:SetFormattedText(displayModifierString, GARRISON_MISSIONS, CountCompleted, #inProgressMissions)
	else
		self.text:SetFormattedText(GARRISON_LOCATION_TOOLTIP..'+')
	end

	lastPanel = self
end

local garrisonType = LE_GARRISON_TYPE_6_0;

local function OnClick()
	if not (C_Garrison_HasGarrison(garrisonType)) then
		return;
	end

	local isShown = GarrisonLandingPage and GarrisonLandingPage:IsShown();
	if (not isShown) then
		ShowGarrisonLandingPage(garrisonType);
	elseif (GarrisonLandingPage) then
		local currentGarrType = GarrisonLandingPage.garrTypeID;
		HideUIPanel(GarrisonLandingPage);
		if (currentGarrType ~= garrisonType) then
			ShowGarrisonLandingPage(garrisonType);
		end
	end
end

local function sortFunction(a, b)
	return a.missionEndTime < b.missionEndTime
end

local OnEnter = function(self)
	DT:SetupTooltip(self)

	if (not GarrisonMissionFrame) then
		LoadAddOn("Blizzard_GarrisonUI")
	end

	-- Work Orders
	C_GarrisonRequestLandingPageShipmentInfo()

	local buildings = C_GarrisonGetBuildings(LE_GARRISON_TYPE_6_0);
	local NumBuildings = #buildings
	local hasBuilding = false

	if NumBuildings > 0 then
		for i = 1, NumBuildings do
			local buildingID = buildings[i].buildingID;
			if (buildingID) then
				local name, _, shipmentCapacity, shipmentsReady, shipmentsTotal, _, _, timeleftString = C_GarrisonGetLandingPageShipmentInfo(buildingID);
				if (name) then
					if(hasBuilding == false) then
						DT.tooltip:AddLine(CAPACITANCE_WORK_ORDERS, selectioncolor)
						hasBuilding = true
					end
					if shipmentsReady ~= shipmentsTotal then
						DT.tooltip:AddDoubleLine(format('%s: |cffffff00%d/%d|r |cffffffff(%d)|r', name, shipmentsReady, shipmentsTotal, shipmentCapacity), timeleftString, 1, 1, 1, selectioncolor)
					else
						DT.tooltip:AddDoubleLine(format('%s: |cffff8000%d/%d|r |cffffffff(%d)|r', name, shipmentsReady, shipmentsTotal, shipmentCapacity), GARRISON_SHIPMENT_EMPTY, 1, 1, 1, 1, 0.5, 0)
					end
				end
			end
		end
		DT.tooltip:AddLine(' ')
	end

	-- Follower Missions
	local inProgressMissions = {};
	C_GarrisonGetInProgressMissions(inProgressMissions, LE_FOLLOWER_TYPE_GARRISON_6_0)
	local NumMissions = #inProgressMissions
	local AvailableMissions = {};
	C_GarrisonGetAvailableMissions(AvailableMissions, LE_FOLLOWER_TYPE_GARRISON_6_0);

	if (NumMissions > 0) then
		DT.tooltip:AddLine(format("%s (%s: %d)", GARRISON_MISSIONS_TITLE, AVAILABLE, #AvailableMissions), selectioncolor)
		tsort(inProgressMissions, sortFunction)
		for i = 1, NumMissions do
			local Mission = inProgressMissions[i]
			local TimeLeft = Mission.timeLeft:match("%d")
			local r, g, b = 1, 1, 1
			if (Mission.isRare) then r, g, b = 0.09, 0.51, 0.81 end

			if (Mission.inProgress and (TimeLeft ~= "0")) then
				if not (Mission.isRare) then r, g, b = 0.7, 0.7, 0.7 end
				DT.tooltip:AddDoubleLine(format('%s |cffffffff(%s)|r', Mission.name, Mission.type), Mission.timeLeft, r, g, b, selectioncolor)
			else
				DT.tooltip:AddDoubleLine(Mission.name, GARRISON_MISSION_COMPLETE, r, g, b, 0, 1, 0)
			end
		end
		
		DT.tooltip:AddLine(" ")
	end

	-- Ship Missions
	local inProgressShipMissions = {};
	C_GarrisonGetInProgressMissions(inProgressShipMissions, LE_FOLLOWER_TYPE_SHIPYARD_6_2)
	local NumShipMissions = #inProgressShipMissions
	local AvailableShipMissions = {};
	C_GarrisonGetAvailableMissions(AvailableShipMissions, LE_FOLLOWER_TYPE_SHIPYARD_6_2);

	if (NumShipMissions > 0) then
		DT.tooltip:AddLine(format("%s (%s: %d)", SPLASH_NEW_6_2_FEATURE2_TITLE, AVAILABLE, #AvailableShipMissions), selectioncolor)
		tsort(inProgressShipMissions, sortFunction)
		for i = 1, NumShipMissions do
			local shipMission = inProgressShipMissions[i]
			local TimeLeft = shipMission.timeLeft:match("%d")
			local r, g, b = 1, 1, 1
			if (shipMission.isRare) then r, g, b = 0.09, 0.51, 0.81 end

			if (shipMission.inProgress and (TimeLeft ~= "0")) then
				if not (shipMission.isRare) then r, g, b = 0.7, 0.7, 0.7 end
				DT.tooltip:AddDoubleLine(format('%s |cffffffff(%s)|r', shipMission.name, shipMission.type), shipMission.timeLeft, r, g, b, selectioncolor)
			else
				DT.tooltip:AddDoubleLine(shipMission.name, GARRISON_MISSION_COMPLETE, r, g, b, 0, 1, 0)
			end
		end
		
		DT.tooltip:AddLine(" ")
	end

	local db = E.db.benikui.datatexts.garrison

	if db.currency then 
		local name, amount, tex = GetCurrencyInfo(GARRISON_CURRENCY)
		DT.tooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, amount, 1, 1, 1, selectioncolor)
	end

	if db.oil then
		local name, amount, tex = GetCurrencyInfo(GARRISON_CURRENCY_OIL)
		DT.tooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, amount, 1, 1, 1, selectioncolor)
		DT.tooltip:AddLine(" ")
	end
	DT.tooltip:AddLine(MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP, 0.7, 0.7, 1)

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayModifierString = join("", "%s: ", hex, "%d/%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('Garrison+ (BenikUI)', {'PLAYER_ENTERING_WORLD', 'GARRISON_MISSION_STARTED', 'GARRISON_MISSION_FINISHED', 'GARRISON_MISSION_COMPLETE_RESPONSE', 'ZONE_CHANGED_NEW_AREA'}, OnEvent, nil, OnClick, OnEnter)