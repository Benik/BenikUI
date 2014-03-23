local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Misc');
local LSM = LibStub('LibSharedMedia-3.0')

local PANEL_HEIGHT = 19;
local SIDE_BUTTON_WIDTH = 16;
local SPACING = (E.PixelMode and 1 or 5)
local BUTTON_NUM = 4

local Bui_ldtp = CreateFrame('Frame', 'BuiLeftChatDTPanel', E.UIParent)
DT:RegisterPanel(BuiLeftChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

local Bui_rdtp = CreateFrame('Frame', 'BuiRightChatDTPanel', E.UIParent)
DT:RegisterPanel(BuiRightChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

local Bui_dchat = CreateFrame('Frame', 'BuiDummyChat', E.UIParent)
local Bui_dthreat = CreateFrame('Frame', 'BuiDummyThreat', E.UIParent)

-- How to appear in datatext options
--L['BuiMiddleDTPanel'] = L['Bui Middle Panel'];
L['BuiLeftChatDTPanel'] = BUI:cOption(L['BUI Left Chat Panel']);
L['BuiRightChatDTPanel'] = BUI:cOption(L['BUI Right Chat Panel']);

-- Setting default datatexts
P.datatexts.panels.BuiLeftChatDTPanel = {
	left = E.db.datatexts.panels.LeftChatDataPanel.left,
	middle = E.db.datatexts.panels.LeftChatDataPanel.middle,
	right = E.db.datatexts.panels.LeftChatDataPanel.right,
}

P.datatexts.panels.BuiRightChatDTPanel = {
	left = E.db.datatexts.panels.RightChatDataPanel.left,
	middle = E.db.datatexts.panels.RightChatDataPanel.middle,
	right = E.db.datatexts.panels.RightChatDataPanel.right,
}

local gsub = string.gsub
local upper = string.upper

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)
BuiGameClickMenu:Style('Outside')

local calendar_string = gsub(SLASH_CALENDAR1, '/', '')
calendar_string = gsub(calendar_string, '^%l', upper)

local menuList = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter('PaperDollFrame') end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
	{text = MOUNTS_AND_PETS,
	func = function()
		TogglePetJournal();
	end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end

		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end
		
		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = L['Farm Mode'],
	func = FarmMode},
	{text = TIMEMANAGER_TITLE,
	func = function() ToggleFrame(TimeManagerFrame) end},		
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame() end},
	{text = calendar_string,
	func = function() GameTimeFrame:Click() end},
	{text = PLAYER_V_PLAYER,
	func = function()
		if not PVPUIFrame then
			PVP_LoadUI()
		end	
		ToggleFrame(PVPUIFrame) 
	end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			if not LookingForGuildFrame then return end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = LFG_TITLE,
	func = function() PVEFrame_ToggleFrame(); end},
	{text = L['Raid Browser'],
	func = function() ToggleFrame(RaidBrowserFrame); end},
	{text = ENCOUNTER_JOURNAL, 
	func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
	{text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end}
}

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

local function BuiGameMenu_OnMouseUp()
	E:DropDown(menuList, menuFrame, -148, 304)
	GameTooltip:Hide()
end

local function tholderOnFade()
	tokenHolder:Hide()
end

local function DashboardOnFade()
	BuiDashboard:Hide()
end

local function ChatButton_OnClick(self)
	GameTooltip:Hide()

	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
	else
		E.db[self.parent:GetName()..'Faded'] = true
		UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
end

local bbuttons = {}

function BUI:ChangeLayout()
	
	LeftMiniPanel:SetHeight(PANEL_HEIGHT)
	RightMiniPanel:SetHeight(PANEL_HEIGHT)
	ElvConfigToggle:SetHeight(PANEL_HEIGHT)
	ElvConfigToggle.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	ElvConfigToggle.text:SetTextColor(unpackColor(E.db.general.valuecolor))

	LeftMiniPanel:Point('TOPLEFT', Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -SPACING, -(SPACING + PANEL_HEIGHT))
	
	RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
	RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
	
	ElvConfigToggle:Point('TOPLEFT', RightMiniPanel, 'TOPRIGHT', SPACING, 0)
	ElvConfigToggle:Point('BOTTOMLEFT', RightMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
	
	ElvUI_ConsolidatedBuffs:Point('TOPLEFT', Minimap.backdrop, 'TOPRIGHT', SPACING, 0)
	ElvUI_ConsolidatedBuffs:Point('BOTTOMLEFT', Minimap.backdrop, 'BOTTOMRIGHT', SPACING, 0)
	
	-- Left dt panel
	Bui_ldtp:SetTemplate('Transparent')
	Bui_ldtp:SetFrameStrata('BACKGROUND')
	Bui_ldtp:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', (SPACING + PANEL_HEIGHT), -SPACING)
	Bui_ldtp:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -(SPACING + PANEL_HEIGHT), -PANEL_HEIGHT-SPACING)
	
	-- Right dt panel
	Bui_rdtp:SetTemplate('Transparent')
	Bui_ldtp:SetFrameStrata('BACKGROUND')
	Bui_rdtp:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', (SPACING + PANEL_HEIGHT), -SPACING)
	Bui_rdtp:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING + PANEL_HEIGHT), -PANEL_HEIGHT-SPACING)

	-- dummy frame for chat/threat (left)
	Bui_dchat:SetFrameStrata('LOW')
	Bui_dchat:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	Bui_dchat:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT-SPACING)
	
	-- dummy frame for threat (right)
	Bui_dthreat:SetFrameStrata('LOW')
	Bui_dthreat:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	Bui_dthreat:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT-SPACING)
	
	-- Buttons
	for i = 1, BUTTON_NUM do
		bbuttons[i] = CreateFrame('Button', 'BuiButton_'..i, E.UIParent)
		bbuttons[i]:SetTemplate('Transparent')
		bbuttons[i]:SetFrameStrata('BACKGROUND')
		bbuttons[i]:CreateSoftGlow()
		bbuttons[i].sglow:Hide()
		bbuttons[i].text = bbuttons[i]:CreateFontString(nil, 'OVERLAY')
		bbuttons[i].text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		bbuttons[i].text:SetPoint('CENTER', 1, 0)
		bbuttons[i].text:SetJustifyH('CENTER')
		bbuttons[i].text:SetTextColor(unpackColor(E.db.general.valuecolor))
		
		-- Game menu button
		if i == 1 then
			bbuttons[i]:Point('TOPLEFT', Bui_rdtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_rdtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i].parent = RightChatPanel
			bbuttons[i].text:SetText('G')
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				bbuttons[i].sglow:Show()
				if IsShiftKeyDown() then
					bbuttons[i].text:SetText('>')
					bbuttons[i]:SetScript('OnClick', ChatButton_OnClick)
				else
					bbuttons[i]:SetScript('OnClick', BuiGameMenu_OnMouseUp)
				end
				GameTooltip:SetOwner(bbuttons[i], 'ANCHOR_TOP', -64, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Game Menu'], selectioncolor)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				bbuttons[i].text:SetText('G')
				bbuttons[i].sglow:Hide()
				GameTooltip:Hide()
			end)
		
		-- ElvUI Config
		elseif i == 2 then
			bbuttons[i]:Point('TOPRIGHT', Bui_rdtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_rdtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i].text:SetText('E')

			bbuttons[i]:SetScript('OnClick', function(self)
				E:ToggleConfig()
			end)
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				bbuttons[i].sglow:Show()
				GameTooltip:SetOwner(bbuttons[i], 'ANCHOR_TOP', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Toggle Configuration'], selectioncolor)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				bbuttons[i].sglow:Hide()
				GameTooltip:Hide()
			end)
			
		-- Tokens Button	
		elseif i == 3 then
			bbuttons[i]:Point('TOPRIGHT', Bui_ldtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_ldtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i].parent = LeftChatPanel
			bbuttons[i].text:SetText('T')
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				bbuttons[i].sglow:Show()
				if IsShiftKeyDown() then
					bbuttons[i].text:SetText('<')
					bbuttons[i]:SetScript('OnClick', ChatButton_OnClick)
				else
					bbuttons[i]:SetScript('OnClick', function(self)
						if not tokenHolder then return end
						if tokenHolder:IsVisible() then
							UIFrameFadeOut(tokenHolder, 0.2, tokenHolder:GetAlpha(), 0)
							tokenHolder.fadeInfo.finishedFunc = tholderOnFade
						else
							UIFrameFadeIn(tokenHolder, 0.2, tokenHolder:GetAlpha(), 1)
							tokenHolder:Show()
						end
					end)
				end
				GameTooltip:SetOwner(bbuttons[i], 'ANCHOR_TOP', 64, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Toggle Tokens'], selectioncolor)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				bbuttons[i].text:SetText('T')
				bbuttons[i].sglow:Hide()
				GameTooltip:Hide()
			end)
			
		-- Dashboard Button
		elseif i == 4 then
			bbuttons[i]:Point('TOPLEFT', Bui_ldtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_ldtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i].text:SetText('D')
			
			bbuttons[i]:SetScript('OnClick', function(self)
				if not BuiDashboard then return end
				if BuiDashboard:IsVisible() then
					UIFrameFadeOut(BuiDashboard, 0.2, BuiDashboard:GetAlpha(), 0)
					BuiDashboard.fadeInfo.finishedFunc = DashboardOnFade
				else
					UIFrameFadeIn(BuiDashboard, 0.2, BuiDashboard:GetAlpha(), 1)
					BuiDashboard:Show()
				end
			end)
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				bbuttons[i].sglow:Show()
				GameTooltip:SetOwner(bbuttons[i], 'ANCHOR_TOP', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Toggle Dashboard'], selectioncolor)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				bbuttons[i].sglow:Hide()
				GameTooltip:Hide()
			end)
		end
	end

	LeftChatPanel.backdrop:Style('Inside', 'LeftChatPanel_Bui') -- keeping the names. Maybe use them as rep or xp bars... dunno... yet
	RightChatPanel.backdrop:Style('Inside', 'RightChatPanel_Bui')
	
	-- Minimap elements styling
	Minimap.backdrop:StyleOnFrame()
	ElvUI_ConsolidatedBuffs:StyleOnFrame()
	
	--[[ Rep Bar
	local buirep = ElvUI_ReputationBar.statusBar
	buirep:SetParent(lchatdecor)
	buirep:SetInside()]]
end

-- Old Code (to be deleted)
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