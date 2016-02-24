local E, L, V, P, G, _ = unpack(ElvUI);
local DT = E:GetModule('DataTexts')
local BDT = E:NewModule('BuiDataTexts', 'AceEvent-3.0');
local LSM = LibStub("LibSharedMedia-3.0");
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");

local pairs, type, join = pairs, type, string.join

local IsInInstance = IsInInstance

DT.SetupTooltipBui = DT.SetupTooltip
function DT:SetupTooltip(panel)
	self:SetupTooltipBui(panel)
	self.tooltip:Style('Outside')
end

local lastPanel
local displayString = ''
local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local dataLayout = {
	['LeftChatDataPanel'] = {
		['left'] = 10,
		['middle'] = 5,
		['right'] = 2,
	},
	['RightChatDataPanel'] = {
		['left'] = 4,
		['middle'] = 3,
		['right'] = 11,
	},
	['BuiLeftChatDTPanel'] = {
		['left'] = 10,
		['middle'] = 5,
		['right'] = 2,
	},
	['BuiRightChatDTPanel'] = {
		['left'] = 4,
		['middle'] = 3,
		['right'] = 11,
	},
}

local dataStrings = {
	[10] = DAMAGE,
	[5] = HONOR,
	[2] = KILLING_BLOWS,
	[4] = DEATHS,
	[3] = HONORABLE_KILLS,
	[11] = SHOW_COMBAT_HEALING,
}

function BDT:UPDATE_BATTLEFIELD_SCORE()
	lastPanel = self
	local pointIndex = dataLayout[self:GetParent():GetName()][self.pointIndex]
	for i=1, GetNumBattlefieldScores() do
		name = GetBattlefieldScore(i)
		if name == E.myname then
			self.text:SetFormattedText(displayString, dataStrings[pointIndex], E:ShortValue(select(pointIndex, GetBattlefieldScore(i))))
			break
		end
	end
end

function BDT:HideBattlegroundTexts()
	DT.ForceHideBGStats = true
	BDT:LoadDataTexts()
	E:Print(L["Battleground datatexts temporarily hidden, to show type /bgstats or right click the 'C' icon near the minimap."])
end

function DT:LoadDataTexts()
	self.db = E.db.datatexts
	for name, obj in LDB:DataObjectIterator() do
		LDB:UnregisterAllCallbacks(self)
	end

	local inInstance, instanceType = IsInInstance()
	local fontTemplate = LSM:Fetch("font", self.db.font)
	for panelName, panel in pairs(DT.RegisteredPanels) do
		--Restore Panels
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			panel.dataPanels[pointIndex]:UnregisterAllEvents()
			panel.dataPanels[pointIndex]:SetScript('OnUpdate', nil)
			panel.dataPanels[pointIndex]:SetScript('OnEnter', nil)
			panel.dataPanels[pointIndex]:SetScript('OnLeave', nil)
			panel.dataPanels[pointIndex]:SetScript('OnClick', nil)
			panel.dataPanels[pointIndex].text:FontTemplate(fontTemplate, self.db.fontSize, self.db.fontOutline)
			panel.dataPanels[pointIndex].text:SetWordWrap(self.db.wordWrap)
			panel.dataPanels[pointIndex].text:SetText(nil)
			panel.dataPanels[pointIndex].pointIndex = pointIndex

			if (panelName == 'LeftChatDataPanel' or panelName == 'RightChatDataPanel' or panelName == 'BuiLeftChatDTPanel' or panelName == 'BuiRightChatDTPanel') and (inInstance and (instanceType == "pvp")) and not DT.ForceHideBGStats and E.db.datatexts.battleground then
				panel.dataPanels[pointIndex]:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
				panel.dataPanels[pointIndex]:SetScript('OnEvent', BDT.UPDATE_BATTLEFIELD_SCORE)
				panel.dataPanels[pointIndex]:SetScript('OnEnter', DT.BattlegroundStats)
				panel.dataPanels[pointIndex]:SetScript('OnLeave', DT.Data_OnLeave)
				panel.dataPanels[pointIndex]:SetScript('OnClick', BDT.HideBattlegroundTexts)
				BDT.UPDATE_BATTLEFIELD_SCORE(panel.dataPanels[pointIndex])
			else
				--Register Panel to Datatext
				for name, data in pairs(DT.RegisteredDataTexts) do
					for option, value in pairs(self.db.panels) do
						if value and type(value) == 'table' then
							if option == panelName and self.db.panels[option][pointIndex] and self.db.panels[option][pointIndex] == name then
								DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
							end
						elseif value and type(value) == 'string' and value == name then
							if self.db.panels[option] == name and option == panelName then
								DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
							end
						end
					end
				end
			end
		end
	end

	if DT.ForceHideBGStats then
		DT.ForceHideBGStats = nil;
	end
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "%s: ", hex, "%s|r")

	if lastPanel ~= nil then
		BDT.UPDATE_BATTLEFIELD_SCORE(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

E:RegisterModule(BDT:GetName())