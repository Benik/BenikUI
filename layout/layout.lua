local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LO = E:GetModule('Layout');
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Misc');
local LSM = LibStub("LibSharedMedia-3.0")

local PANEL_HEIGHT = 19;
local SIDE_BUTTON_WIDTH = 16;
local SPACING = (E.PixelMode and 1 or 5)

local Benik_mdtp = CreateFrame('Frame', 'BenikMiddleDTPanel', E.UIParent)
DT:RegisterPanel(BenikMiddleDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

--[[local Benik_rdtp = CreateFrame('Frame', 'BenikRightDTPanel', E.UIParent)
DT:RegisterPanel(BenikRightDTPanel, 1, 'ANCHOR_BOTTOM', 0, -4)

local Benik_ldtp = CreateFrame('Frame', 'BenikLeftDTPanel', E.UIParent)
DT:RegisterPanel(BenikLeftDTPanel, 1, 'ANCHOR_BOTTOM', 0, -4)]]

-- How to appear in datatext options
L['BenikMiddleDTPanel'] = L["Benik Middle Panel"];
L['BenikRightDTPanel'] = L["Benik Right Panel"];
L['BenikLeftDTPanel'] = L["Benik Left Panel"];

-- Setting default datatexts
P.datatexts.panels.BenikMiddleDTPanel = {
	left = 'Spec Switch',
	middle = 'System',
	right = 'Bags',
}

--P.datatexts.panels.BenikRightDTPanel = 'Time'
--P.datatexts.panels.BenikLeftDTPanel = 'Durability'

--[[LO.ToggleChatPanelsBenik = LO.ToggleChatPanels
function LO:ToggleChatPanels()
	LO.ToggleChatPanelsBenik(self)
	
	if E.db.chat.panelBackdrop == 'SHOWBOTH' then
		LeftChatPanel.backdrop:Show()
		LeftChatTab:Show()
		RightChatPanel.backdrop:Show()
		RightChatTab:Show()
	elseif E.db.chat.panelBackdrop == 'HIDEBOTH' then
		LeftChatPanel.backdrop:Hide()
		LeftChatTab:Hide()
		RightChatPanel.backdrop:Hide()
		RightChatTab:Hide()		
	elseif E.db.chat.panelBackdrop == 'LEFT' then
		LeftChatPanel.backdrop:Show()
		LeftChatTab:Show()
		RightChatPanel.backdrop:Hide()
		RightChatTab:Hide()		
	else
		LeftChatPanel.backdrop:Hide()
		LeftChatTab:Hide()
		RightChatPanel.backdrop:Show()
		RightChatTab:Show()		
	end
	
	-- dt bars
	LeftChatDataPanel:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING + SIDE_BUTTON_WIDTH, SPACING)
	LeftChatDataPanel:Point('TOPRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -SPACING, (SPACING + PANEL_HEIGHT))
	RightChatDataPanel:Point('BOTTOMLEFT', RightChatPanel, 'BOTTOMLEFT', SPACING, SPACING)
	RightChatDataPanel:Point('TOPRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING + SIDE_BUTTON_WIDTH), SPACING + PANEL_HEIGHT)	

	-- chat toggle buttons
	LeftChatToggleButton:Point('TOPRIGHT', LeftChatDataPanel, 'TOPLEFT', -(E.PixelMode and -1 or 1), 0)
	LeftChatToggleButton:Point('BOTTOMLEFT', LeftChatPanel, 'BOTTOMLEFT', SPACING, SPACING)	
	RightChatToggleButton:Point('TOPLEFT', RightChatDataPanel, 'TOPRIGHT', (E.PixelMode and -1 or 1), 0)
	RightChatToggleButton:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -SPACING, SPACING)
	
	LeftChatTab:Point('TOPLEFT', LeftChatPanel, 'TOPLEFT', SPACING, -SPACING)
	LeftChatTab:Point('BOTTOMRIGHT', LeftChatPanel, 'TOPRIGHT', -SPACING, -(SPACING + 7))
	RightChatTab:Point('TOPRIGHT', RightChatPanel, 'TOPRIGHT', -SPACING, -SPACING)
	RightChatTab:Point('BOTTOMLEFT', RightChatPanel, 'TOPLEFT', SPACING, -(SPACING + 7))
end

LO.CreateChatPanelsBenik = LO.CreateChatPanels
function LO:CreateChatPanels()
	LO.CreateChatPanelsBenik(self)
	
	local BenikLoShadows = {LeftChatPanel.backdrop, LeftChatTab, RightChatPanel.backdrop, RightChatTab, LeftChatDataPanel, LeftChatToggleButton, RightChatDataPanel, RightChatToggleButton}
	for _, frame in pairs(BenikLoShadows) do
		frame:CreateSoftShadow('Default')
	end
end]]

--[[local function ExperienceBar_OnEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, SPACING + 8)
	
	local cur, max = M:GetXP('player')
	local rested = GetXPExhaustion()
	GameTooltip:AddLine(L['Experience'])
	GameTooltip:AddLine(' ')
	
	GameTooltip:AddDoubleLine(L['XP:'], string.format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine(L['Remaining:'], string.format(' %d (%d%% - %d '..L['Bars']..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)	
	
	if rested then
		GameTooltip:AddDoubleLine(L['Rested:'], string.format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)	
	end
	
	GameTooltip:Show()
end

local function ReputationBar_OnEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, SPACING + 8)
	
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	if name then
		GameTooltip:AddLine(name)
		GameTooltip:AddLine(' ')
		
		GameTooltip:AddDoubleLine(STANDING..':', _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
		GameTooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
	end
	GameTooltip:Show()
end

local function OnLeave(self)
	GameTooltip:Hide()
end]]

function BenikPanels()
	
	LeftMiniPanel:SetHeight(PANEL_HEIGHT)
	RightMiniPanel:SetHeight(PANEL_HEIGHT)
	ElvConfigToggle:SetHeight(PANEL_HEIGHT)
	ElvConfigToggle.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	LeftChatToggleButton.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	RightChatToggleButton.text:FontTemplate(LSM:Fetch("font", E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	-------
	-- Chat
	-------
	
	--[[ strip textures
	local BenikLoStrip = {LeftChatTab, RightChatTab, LeftChatDataPanel, LeftChatToggleButton, RightChatDataPanel, RightChatToggleButton}
	for _, frame in pairs(BenikLoStrip) do
		frame:StripTextures(frame)
		frame:CreateBackdrop('Default', true)
	end]]
	
	LeftMiniPanel:Point('TOPLEFT', Minimap, 'BOTTOMLEFT', -E.Border, (E.PixelMode and 0 or -3))
	LeftMiniPanel:Point('BOTTOMRIGHT', Minimap, 'BOTTOM', -E.Spacing, -((E.PixelMode and 0 or 3) + PANEL_HEIGHT))
	
	-- Middle dt panel
	--Benik_mdtp:CreateBackdrop('Default', true)
	--Benik_mdtp:SetTemplate('Transparent')
	Benik_mdtp:SetFrameStrata('LOW')
	Benik_mdtp:Width(400)
	Benik_mdtp:Height(PANEL_HEIGHT)
	Benik_mdtp:SetParent(ElvUI_BottomPanel)
	Benik_mdtp:Point('CENTER', ElvUI_BottomPanel, 'CENTER')
	--Benik_mdtp:Point('TOPLEFT', ElvUI_Bar2, 'BOTTOMLEFT', 0, -SPACING)
	--Benik_mdtp:Point('BOTTOMRIGHT', ElvUI_Bar2, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT-SPACING)
	
	--[[for panelName, panel in pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			panel.dataPanels[pointIndex].text:FontTemplate(E["media"].lpFont, E.db.locplus.lpfontsize, E.db.locplus.lpfontflags)
			panel.dataPanels[pointIndex].text:SetPoint("CENTER", 0, 1)
			panel.dataPanels[pointIndex].text:SetTextColor(1, 0.5, 0)
		end
	end]]
	
	-- Right dt Panel
	--[[Benik_rdtp:CreateBackdrop('Default', true)
	Benik_rdtp:SetTemplate('Transparent')
	Benik_rdtp:SetFrameStrata('LOW')
	Benik_rdtp:SetParent(ElvUI_Bar3)
	Benik_rdtp:Point('TOPLEFT', ElvUI_Bar3, 'BOTTOMLEFT', 0, -SPACING)
	Benik_rdtp:Point('BOTTOMRIGHT', ElvUI_Bar3, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT-SPACING)]]
	
	-- Left dt Panel
	--[[Benik_ldtp:CreateBackdrop('Default', true)
	Benik_ldtp:SetTemplate('Transparent')
	Benik_ldtp:SetFrameStrata('LOW')
	Benik_ldtp:SetParent(ElvUI_Bar5)
	Benik_ldtp:Point('TOPLEFT', ElvUI_Bar5, 'BOTTOMLEFT', 0, -SPACING)
	Benik_ldtp:Point('BOTTOMRIGHT', ElvUI_Bar5, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT-SPACING)]]
	
	--[[ MMHolder decor
	local BMMHolder = CreateFrame('Frame', 'BenikMMHolder', MMHolder)
	BMMHolder:CreateBackdrop('Default', true)
	BenikMMHolder:Point('TOPLEFT', MMHolder, 'TOPLEFT', SPACING + 1, 4 -SPACING)
	BenikMMHolder:Point('BOTTOMRIGHT', MMHolder, 'TOPRIGHT', -SPACING - 1, -SPACING)]]
	
end








