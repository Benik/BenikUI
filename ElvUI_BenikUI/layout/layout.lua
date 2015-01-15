local E, L, V, P, G, _ = unpack(ElvUI);
local BUIL = E:NewModule('BuiLayout', 'AceHook-3.0', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Minimap');
local LSM = LibStub('LibSharedMedia-3.0')

local PANEL_HEIGHT = 19;
local SIDE_BUTTON_WIDTH = 16;
local SPACING = (E.PixelMode and 1 or 3)
local BUTTON_NUM = 4

local Bui_ldtp = CreateFrame('Frame', 'BuiLeftChatDTPanel', E.UIParent)
local Bui_rdtp = CreateFrame('Frame', 'BuiRightChatDTPanel', E.UIParent)
local Bui_mdtp = CreateFrame('Frame', 'BuiMiddleDTPanel', E.UIParent)

local function RegBuiDataTexts()
	DT:RegisterPanel(BuiLeftChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)
	DT:RegisterPanel(BuiRightChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)
	DT:RegisterPanel(BuiMiddleDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)
	
	L['BuiLeftChatDTPanel'] = BUI.Title..BUI:cOption(L['Left Chat Panel']);
	L['BuiRightChatDTPanel'] = BUI.Title..BUI:cOption(L['Right Chat Panel']);
	L['BuiMiddleDTPanel'] = BUI.Title..BUI:cOption(L['Middle Panel']);
end

local Bui_dchat = CreateFrame('Frame', 'BuiDummyChat', E.UIParent)
local Bui_dthreat = CreateFrame('Frame', 'BuiDummyThreat', E.UIParent)

local gsub = string.gsub
local upper = string.upper
local tinsert = table.insert

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)

-- as in ElvUI
local menuList = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
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
	{text = MOUNTS,
	func = function()
		TogglePetJournal(1);
	end},
	{text = PETS,
	func = function()
		TogglePetJournal(2)
	end},
	{text = TOY_BOX,
	func = function() 
		TogglePetJournal(3)
	end},
	{text = L["Farm Mode"],
	func = FarmMode},
	{text = TIMEMANAGER_TITLE,
	func = function() ToggleFrame(TimeManagerFrame) end},		
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame() end},
	{text = L["Calendar"],
	func = function() GameTimeFrame:Click() end},
	{text = GARRISON_LANDING_PAGE_TITLE,
	func = function() GarrisonLandingPageMinimapButton_OnClick() end},
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
	--[[{text = L["Raid Browser"],
	func = function() ToggleFrame(RaidBrowserFrame); end},]]
	{text = ENCOUNTER_JOURNAL,
	func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end}
}

--if(C_StorePublic.IsEnabled()) then
	tinsert(menuList, {text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end})
--end
tinsert(menuList, 	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end})

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

local function BuiGameMenu_OnMouseUp()
	GameTooltip:Hide()
	BUI:Dropmenu(menuList, menuFrame, BuiButton_2, 'tLeft', -SPACING, SPACING)
	PlaySound("igMainMenuOptionCheckBoxOff");
end

local function tholderOnFade()
	tokenHolder:Hide()
end

local function DashboardOnFade()
	sysHolder:Hide()
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
	PlaySound("igMainMenuOptionCheckBoxOff");
end

local bbuttons = {}

function BUIL:ToggleBuiDts()
	if not E.db.bui.buiDts or E.db.datatexts.leftChatPanel then
		BuiLeftChatDTPanel:Hide()
		for i = 3, 4 do
			bbuttons[i]:Hide()
		end
	else
		BuiLeftChatDTPanel:Show()
		for i = 3, 4 do
			bbuttons[i]:Show()
		end
	end
	
	if not E.db.bui.buiDts or E.db.datatexts.rightChatPanel then
		BuiRightChatDTPanel:Hide()
		for i = 1, 2 do
			bbuttons[i]:Hide()
		end
	else
		BuiRightChatDTPanel:Show()
		for i = 1, 2 do
			bbuttons[i]:Show()
		end
	end
end

function BUIL:ResizeMinimapPanels()
	
	LeftMiniPanel:Point('TOPLEFT', Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	if E.db.auras.consolidatedBuffs.enable and E.db.datatexts.minimapPanels and E.private.general.minimap.enable and E.private.auras.disableBlizzard then
		if E.db.bui.buiDts then
			LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', (E.ConsolidatedBuffsWidth/2)-SPACING, -(SPACING + PANEL_HEIGHT))
			RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', E.ConsolidatedBuffsWidth + SPACING, -SPACING)
			ElvConfigToggle:Hide()
		else
			LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -SPACING, -(SPACING + PANEL_HEIGHT))
			RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
			ElvConfigToggle:Show()
		end
	else
		LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -SPACING, -(SPACING + PANEL_HEIGHT))
		RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
	end
	RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
	
end

function BUIL:ToggleTransparency()
	if E.db.bui.transparentDts then
		Bui_ldtp:SetTemplate('Transparent')
		Bui_rdtp:SetTemplate('Transparent')	
		for i = 1, BUTTON_NUM do
			bbuttons[i]:SetTemplate('Transparent')
		end
	else
		Bui_ldtp:SetTemplate('Default', true)
		Bui_rdtp:SetTemplate('Default', true)
		for i = 1, BUTTON_NUM do
			bbuttons[i]:SetTemplate('Default', true)
		end	
	end
end

function BUIL:MiddleDatatextLayout()
	local db = E.db.bui.middleDatatext
	
	if db.enable then
		Bui_mdtp:Show()
	else
		Bui_mdtp:Hide()
	end
	
	if not db.backdrop then
		Bui_mdtp:StripTextures()
	else
		if db.transparency then
			Bui_mdtp:SetTemplate('Transparent')
		else
			Bui_mdtp:SetTemplate('Default', true)
		end
	end
	
	if db.styled and db.backdrop then
		Bui_mdtp.style:Show()
	else
		Bui_mdtp.style:Hide()
	end
end

function BUIL:MiddleDatatextDimensions()
	Bui_mdtp:Width(E.db.bui.middleDatatext.width)
	Bui_mdtp:Height(E.db.bui.middleDatatext.height)
end

function BUIL:ChangeLayout()
	
	LeftMiniPanel:SetHeight(PANEL_HEIGHT)
	RightMiniPanel:SetHeight(PANEL_HEIGHT)
	
	ElvUI_ConsolidatedBuffs:Point('TOPLEFT', Minimap.backdrop, 'TOPRIGHT', SPACING, 0)
	ElvUI_ConsolidatedBuffs:Point('BOTTOMLEFT', Minimap.backdrop, 'BOTTOMRIGHT', SPACING, 0)

	ElvConfigToggle:Point('TOPLEFT', RightMiniPanel, 'TOPRIGHT', SPACING, 0)
	ElvConfigToggle:Point('BOTTOMLEFT', RightMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
	ElvConfigToggle:SetHeight(PANEL_HEIGHT)
	ElvConfigToggle.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
	ElvConfigToggle.text:SetTextColor(unpackColor(E.db.general.valuecolor))	

	-- Left dt panel
	Bui_ldtp:SetFrameStrata('BACKGROUND')
	Bui_ldtp:SetTemplate(E.db.bui.transparentDts and 'Transparent' or 'Default', true)
	Bui_ldtp:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', (SPACING + PANEL_HEIGHT), -SPACING)
	Bui_ldtp:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -(SPACING + PANEL_HEIGHT), -PANEL_HEIGHT-SPACING)
	
	-- Right dt panel
	Bui_rdtp:SetFrameStrata('BACKGROUND')
	Bui_rdtp:SetTemplate(E.db.bui.transparentDts and 'Transparent' or 'Default', true)
	Bui_rdtp:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', (SPACING + PANEL_HEIGHT), -SPACING)
	Bui_rdtp:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING + PANEL_HEIGHT), -PANEL_HEIGHT-SPACING)
	
	-- Middle dt panel
	Bui_mdtp:SetFrameStrata('BACKGROUND')
	Bui_mdtp:SetTemplate(E.db.bui.middleDatatext.transparency and 'Transparent' or 'Default', true)
	Bui_mdtp:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 2)
	Bui_mdtp:Width(E.db.bui.middleDatatext.width or 400)
	Bui_mdtp:Height(E.db.bui.middleDatatext.height or PANEL_HEIGHT)
	Bui_mdtp:Style('Outside')
	Bui_mdtp.style:Hide()
	E:CreateMover(Bui_mdtp, "BuiMiddleDtMover", L['BenikUI Middle DataText'])

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
		bbuttons[i]:SetTemplate(E.db.bui.transparentDts and 'Transparent' or 'Default', true)
		bbuttons[i]:RegisterForClicks('AnyUp')
		bbuttons[i]:SetFrameStrata('BACKGROUND')
		bbuttons[i]:CreateSoftGlow()
		bbuttons[i].sglow:Hide()
		bbuttons[i].text = bbuttons[i]:CreateFontString(nil, 'OVERLAY')
		bbuttons[i].text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		bbuttons[i].text:SetPoint('CENTER', 1, 0)
		bbuttons[i].text:SetJustifyH('CENTER')
		bbuttons[i].text:SetTextColor(unpackColor(E.db.general.valuecolor))
		
		-- ElvUI Config
		if i == 1 then
			bbuttons[i]:Point('TOPLEFT', Bui_rdtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_rdtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i].parent = RightChatPanel
			bbuttons[i].text:SetText('C')
			
			bbuttons[i]:SetScript('OnClick', function(self, btn)
				if btn == 'LeftButton' then
					E:ToggleConfig()
					PlaySound("igMainMenuOptionCheckBoxOff");
				else
					--E:BGStats() --will enable when (and if) I could adopt the bg dataTexts
				end
			end)

			bbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				if IsShiftKeyDown() then
					self.text:SetText('>')
					self:SetScript('OnClick', ChatButton_OnClick)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Toggle Configuration'], selectioncolor)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('C')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
		
		-- Game menu button
		elseif i == 2 then
			bbuttons[i]:Point('TOPRIGHT', Bui_rdtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_rdtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i].text:SetText('G')

			bbuttons[i]:SetScript('OnClick', BuiGameMenu_OnMouseUp)
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Game Menu'], selectioncolor)
				GameTooltip:Show()
				if InCombatLockdown() or BuiGameClickMenu:IsShown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
	
		-- Tokens Button	
		elseif i == 3 then
			bbuttons[i]:Point('TOPRIGHT', Bui_ldtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_ldtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i].parent = LeftChatPanel
			bbuttons[i].text:SetText('T')
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				if IsShiftKeyDown() then
					self.text:SetText('<')
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self:SetScript('OnClick', function(self)
						if not tokenHolder then return end
						if tokenHolder:IsVisible() then
							UIFrameFadeOut(tokenHolder, 0.2, tokenHolder:GetAlpha(), 0)
							tokenHolder.fadeInfo.finishedFunc = tholderOnFade
						else
							UIFrameFadeIn(tokenHolder, 0.2, tokenHolder:GetAlpha(), 1)
							tokenHolder:Show()
						end
						PlaySound("igMainMenuOptionCheckBoxOff");
					end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 64, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Toggle Tokens'], selectioncolor)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('T')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
			
		-- Dashboard Button
		elseif i == 4 then
			bbuttons[i]:Point('TOPLEFT', Bui_ldtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_ldtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i].text:SetText('D')
			
			bbuttons[i]:SetScript('OnClick', function(self)
				if not sysHolder then return end
				if sysHolder:IsVisible() then
					UIFrameFadeOut(sysHolder, 0.2, sysHolder:GetAlpha(), 0)
					sysHolder.fadeInfo.finishedFunc = DashboardOnFade
				else
					UIFrameFadeIn(sysHolder, 0.2, sysHolder:GetAlpha(), 1)
					sysHolder:Show()
				end
				PlaySound("igMainMenuOptionCheckBoxOff");
			end)
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				self.sglow:Show()
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Toggle Dashboard'], selectioncolor)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
		end
	end

	LeftChatPanel.backdrop:Style('Inside', 'LeftChatPanel_Bui') -- keeping the names. Maybe use them as rep or xp bars... dunno... yet
	RightChatPanel.backdrop:Style('Inside', 'RightChatPanel_Bui')
	
	-- Minimap elements styling
	if E.private.general.minimap.enable then Minimap.backdrop:Style('Outside') end
	ElvUI_ConsolidatedBuffs:Style('Outside')
	CopyChatFrame:Style('Inside')
	self:ResizeMinimapPanels()

end

function BUIL:PLAYER_ENTERING_WORLD(...)
	self:ToggleTransparency()
	self:ToggleBuiDts()
	self:MiddleDatatextLayout()
	self:MiddleDatatextDimensions()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function BUIL:Initialize()
	RegBuiDataTexts()
	self:ChangeLayout()
	hooksecurefunc(LO, 'ToggleChatPanels', BUIL.ToggleBuiDts)
	hooksecurefunc(LO, 'ToggleChatPanels', BUIL.ResizeMinimapPanels)
	hooksecurefunc(M, 'UpdateSettings', BUIL.ResizeMinimapPanels)
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

E:RegisterModule(BUIL:GetName())

