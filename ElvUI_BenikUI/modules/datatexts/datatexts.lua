local BUI, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')
local mod = BUI:NewModule('DataTexts', 'AceEvent-3.0');
local LSM = E.LSM;
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");

local pairs, type, select, join = pairs, type, select, string.join

local GetBattlefieldScore = GetBattlefieldScore
local GetNumBattlefieldScores = GetNumBattlefieldScores
local IsInInstance = IsInInstance

DT.SetupTooltipBui = DT.SetupTooltip
function DT:SetupTooltip(panel)
	self:SetupTooltipBui(panel)
	self.tooltip:Style('Outside')
end

local lastPanel
local displayString = ''

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
	[10] = _G.DAMAGE,
	[5] = _G.HONOR,
	[2] = _G.KILLING_BLOWS,
	[4] = _G.DEATHS,
	[3] = _G.KILLS,
	[11] = _G.SHOW_COMBAT_HEALING,
}

function mod:UPDATE_BATTLEFIELD_SCORE()
	lastPanel = self
	local pointIndex = dataLayout[self:GetParent():GetName()][self.pointIndex]
	for i=1, GetNumBattlefieldScores() do
		local name = GetBattlefieldScore(i)
		if name == E.myname then
			local val = select(pointIndex, GetBattlefieldScore(i))
			self.text:SetFormattedText(displayString, dataStrings[pointIndex], E:ShortValue(val))
			break
		end
	end
end

function mod:HideBattlegroundTexts()
	DT.ForceHideBGStats = true
	mod:LoadDataTexts()
	E:Print(L["Battleground datatexts temporarily hidden, to show type /bgstats or right click the 'C' icon near the minimap."])
end

function DT:LoadDataTexts()
	for _, _ in LDB:DataObjectIterator() do
		LDB:UnregisterAllCallbacks(self)
	end

	local fontTemplate = LSM:Fetch("font", self.db.font)
	local inInstance, instanceType = IsInInstance()
	local isInPVP = inInstance and instanceType == "pvp"
	local pointIndex, isBGPanel, enableBGPanel
	for panelName, panel in pairs(DT.RegisteredPanels) do
		isBGPanel = isInPVP and (panelName == 'LeftChatDataPanel' or panelName == 'RightChatDataPanel' or panelName == 'BuiLeftChatDTPanel' or panelName == 'BuiRightChatDTPanel')
		enableBGPanel = isBGPanel and (not DT.ForceHideBGStats and E.db.datatexts.battleground)

		--Restore Panels
		for i=1, panel.numPoints do
			pointIndex = DT.PointLocation[i]
			local dt = panel.dataPanels[pointIndex]
			dt:UnregisterAllEvents()
			dt:SetScript('OnUpdate', nil)
			dt:SetScript('OnEnter', nil)
			dt:SetScript('OnLeave', nil)
			dt:SetScript('OnClick', nil)
			dt.text:FontTemplate(fontTemplate, self.db.fontSize, self.db.fontOutline)
			dt.text:SetWordWrap(self.db.wordWrap)
			dt.text:SetText('')
			dt.pointIndex = pointIndex

			if enableBGPanel then
				dt:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
				dt:SetScript('OnEvent', mod.UPDATE_BATTLEFIELD_SCORE)
				dt:SetScript('OnEnter', DT.BattlegroundStats)
				dt:SetScript('OnLeave', DT.Data_OnLeave)
				dt:SetScript('OnClick', mod.HideBattlegroundTexts)
				DT.UPDATE_BATTLEFIELD_SCORE(dt)
				DT.ShowingBGStats = true
			else
				-- we aren't showing BGStats anymore
				if (isBGPanel or not isInPVP) and DT.ShowingBGStats then
					DT.ShowingBGStats = nil
				end

				--Register Panel to Datatext
				for name, data in pairs(DT.RegisteredDataTexts) do
					for option, value in pairs(self.db.panels) do
						if value and type(value) == 'table' then
							if option == panelName and self.db.panels[option][pointIndex] and self.db.panels[option][pointIndex] == name then
								DT:AssignPanelToDataText(dt, data)
							end
						elseif value and type(value) == 'string' and value == name then
							if self.db.panels[option] == name and option == panelName then
								DT:AssignPanelToDataText(dt, data)
							end
						end
					end
				end
			end
		end
	end

	if DT.ForceHideBGStats then
		DT.ForceHideBGStats = nil
	end
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s: ", hex, "%s|r")

	if lastPanel ~= nil then
		mod.UPDATE_BATTLEFIELD_SCORE(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

function mod:Initialize()
	DT:LoadDataTexts()
end

BUI:RegisterModule(mod:GetName())