local E, L, V, P, G, _ =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

-- Missions are based on TukUI Garrison DataText. Credits: Hydra, Tukz

local displayModifierString = ''
local lastPanel;
local GARRISON_CURRENCY = 824
local join = string.join
local format = string.format

local OnEvent = function(self, event)
	
	local Missions = C_Garrison.GetInProgressMissions()
	local CountInProgress = 0
	local CountCompleted = 0
	
	for i = 1, #Missions do
		if Missions[i].inProgress then
			local TimeLeft = Missions[i].timeLeft:match("%d")
			
			if (TimeLeft ~= "0") then
				CountInProgress = CountInProgress + 1
			else
				CountCompleted = CountCompleted + 1
			end
		end
	end

	if (CountInProgress > 0) then
		self.text:SetFormattedText(displayModifierString, GARRISON_MISSIONS, CountCompleted, #Missions)
	else
		self.text:SetFormattedText(GARRISON_LOCATION_TOOLTIP..'+')
	end
	
	lastPanel = self
end

local function SortMissions(missionlist)
    local comparison = function(mission1, mission2)

        if ( mission1.timeLeft ~= mission2.timeLeft ) then
            return mission1.timeLeft < mission2.timeLeft;
        end		

        return mission1.name < mission2.name
    end
 
    table.sort(missionlist, comparison);
end

local OnEnter = function(self)
	DT:SetupTooltip(self)

	if (not GarrisonMissionFrame) then
		LoadAddOn("Blizzard_GarrisonUI")
	end

	-- Work Orders
	C_Garrison.RequestLandingPageShipmentInfo()
	local buildings = C_Garrison.GetBuildings();
	local NumBuildings = #buildings
		
	if NumBuildings > 0 then
		DT.tooltip:AddLine(CAPACITANCE_WORK_ORDERS, selectioncolor)
		for i = 1, NumBuildings do
			local buildingID = buildings[i].buildingID;
			if (buildingID) then
				local name, _, shipmentCapacity, shipmentsReady, shipmentsTotal, _, _, timeleftString = C_Garrison.GetLandingPageShipmentInfo(buildingID);
				if (name) then
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

	-- Missions
	local Missions = C_Garrison.GetInProgressMissions()
	local NumMissions = #Missions

	if (NumMissions > 0) then
		DT.tooltip:AddLine(format(GARRISON_MISSIONS_TITLE), selectioncolor)
		SortMissions(Missions)
		for i = 1, NumMissions do
			local Mission = Missions[i]
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

	local Available = GarrisonMissionFrame.MissionTab.MissionList.availableMissions
	local NumAvailable = #Available
	
	if (NumAvailable > 0) then
		DT.tooltip:AddLine(format(GARRISON_LANDING_AVAILABLE, NumAvailable))
		DT.tooltip:AddLine(" ")
	end
	
	if E.db.bui.garrisonCurrency then 
		local name, amount, tex = GetCurrencyInfo(GARRISON_CURRENCY)
		DT.tooltip:AddDoubleLine("\124T" .. tex .. ":12\124t " .. name, amount, 1, 1, 1, selectioncolor)
		DT.tooltip:AddLine(" ")
	end
	DT.tooltip:AddLine(MINIMAP_GARRISON_LANDING_PAGE_TOOLTIP, 0.7, 0.7, 1)
	
	DT.tooltip:Show()
end

local function ValueColorUpdate(hex, r, g, b)
	displayModifierString = join("", "%s: ", hex, "%d/%d|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('Garrison+ (BenikUI)', {'PLAYER_ENTERING_WORLD', 'GARRISON_MISSION_LIST_UPDATE', 'CURRENCY_DISPLAY_UPDATE', 'GARRISON_MISSION_STARTED', 'PLAYER_LOGIN','GARRISON_MISSION_FINISHED', 'GET_ITEM_INFO_RECEIVED', 'GARRISON_MISSION_COMPLETE_RESPONSE'}, OnEvent, nil, GarrisonLandingPage_Toggle, OnEnter)