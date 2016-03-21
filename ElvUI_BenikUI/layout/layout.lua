local E, L, V, P, G = unpack(ElvUI);
local BUIL = E:NewModule('BuiLayout', 'AceHook-3.0', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Minimap');
local LSM = LibStub('LibSharedMedia-3.0')

local _G = _G
local unpack = unpack
local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local ToggleCharacter = ToggleCharacter
local ToggleFriendsFrame = ToggleFriendsFrame
local ToggleHelpFrame = ToggleHelpFrame
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel
local PlaySound = PlaySound
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local IsInGuild = IsInGuild
local IsAddOnLoaded = IsAddOnLoaded
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local ToggleLFDParentFrame = ToggleLFDParentFrame
local ToggleAchievementFrame = ToggleAchievementFrame
local ToggleCollectionsJournal = ToggleCollectionsJournal
local GameMenuButtonMacros = GameMenuButtonMacros
local ToggleFrame = ToggleFrame
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local GameMenuButtonAddons = GameMenuButtonAddons

-- GLOBALS: hooksecurefunc, GarrisonLandingPageMinimapButton_OnClick, CloseMenus, CloseAllWindows, selectioncolor
-- GLOBALS: MainMenuMicroButton_SetNormal, AddOnSkins, MAINMENU_BUTTON, ADDONS, LFG_TITLE, BuiLeftChatDTPanel
-- GLOBALS: BuiMiddleDTPanel, BuiRightChatDTPanel, BuiGameClickMenu
-- GLOBALS: SpellBookFrame, PlayerTalentFrame, TalentFrame_LoadUI
-- GLOBALS: GlyphFrame, GlyphFrame_LoadUI, PlayerTalentFrame, TimeManagerFrame
-- GLOBALS: GameTimeFrame, GuildFrame, GuildFrame_LoadUI, EncounterJournal_LoadUI, EncounterJournal
-- GLOBALS: FarmModeMap, LookingForGuildFrame, LookingForGuildFrame_LoadUI, LookingForGuildFrame_Toggle
-- GLOBALS: GameMenuFrame, VideoOptionsFrame, VideoOptionsFrameCancel, AudioOptionsFrame, AudioOptionsFrameCancel
-- GLOBALS: InterfaceOptionsFrame, InterfaceOptionsFrameCancel, GuildFrame_Toggle
-- GLOBALS: LibStub, StoreMicroButton, ElvConfigToggle
-- GLOBALS: LeftMiniPanel, RightMiniPanel, Minimap, ElvUI_ConsolidatedBuffs
-- GLOBALS: LeftChatPanel, RightChatPanel, CopyChatFrame

local PANEL_HEIGHT = 19;
local SIDE_BUTTON_WIDTH = 16;
local SPACING = (E.PixelMode and 1 or 3)
local BUTTON_NUM = 4

local Bui_ldtp = CreateFrame('Frame', 'BuiLeftChatDTPanel', E.UIParent)
local Bui_rdtp = CreateFrame('Frame', 'BuiRightChatDTPanel', E.UIParent)
local Bui_mdtp = CreateFrame('Frame', 'BuiMiddleDTPanel', E.UIParent)

local function RegBuiDataTexts()
	DT:RegisterPanel(BuiLeftChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)
	DT:RegisterPanel(BuiMiddleDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)
	DT:RegisterPanel(BuiRightChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)
	
	L['BuiLeftChatDTPanel'] = BUI.Title..BUI:cOption(L['Left Chat Panel']);
	L['BuiRightChatDTPanel'] = BUI.Title..BUI:cOption(L['Right Chat Panel']);
	L['BuiMiddleDTPanel'] = BUI.Title..BUI:cOption(L['Middle Panel']);
	E.FrameLocks['BuiMiddleDTPanel'] = true;
end

local Bui_dchat = CreateFrame('Frame', 'BuiDummyChat', E.UIParent)
local Bui_dthreat = CreateFrame('Frame', 'BuiDummyThreat', E.UIParent)

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)

local menuList = {
	{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON, func = function() if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end end},
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
	{text = LFG_TITLE, func = function() ToggleLFDParentFrame(); end},
	{text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end},
	{text = REPUTATION, func = function() ToggleCharacter('ReputationFrame') end},
	{text = GARRISON_LANDING_PAGE_TITLE, func = function() GarrisonLandingPageMinimapButton_OnClick() end},
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
	{text = L["Calendar"], func = function() GameTimeFrame:Click() end},
	{text = MOUNTS, func = function() ToggleCollectionsJournal(1) end},
	{text = PET_JOURNAL, func = function() ToggleCollectionsJournal(2) end},
	{text = TOY_BOX, func = function() ToggleCollectionsJournal(3) end},
	{text = HEIRLOOMS, func = function() ToggleCollectionsJournal(4) end},
	{text = L["Farm Mode"], func = FarmMode},
	{text = MACROS, func = function() GameMenuButtonMacros:Click() end},
	{text = TIMEMANAGER_TITLE, func = function() ToggleFrame(TimeManagerFrame) end},
	{text = ENCOUNTER_JOURNAL, func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then EncounterJournal_LoadUI(); end ToggleFrame(EncounterJournal) end},
	{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame() end},
	{text = MAINMENU_BUTTON,
	func = function()
		if ( not GameMenuFrame:IsShown() ) then
			if ( VideoOptionsFrame:IsShown() ) then
					VideoOptionsFrameCancel:Click();
			elseif ( AudioOptionsFrame:IsShown() ) then
					AudioOptionsFrameCancel:Click();
			elseif ( InterfaceOptionsFrame:IsShown() ) then
					InterfaceOptionsFrameCancel:Click();
			end
			CloseMenus();
			CloseAllWindows()
			PlaySound("igMainMenuOpen");
			ShowUIPanel(GameMenuFrame);
		else
			PlaySound("igMainMenuQuit");
			HideUIPanel(GameMenuFrame);
			MainMenuMicroButton_SetNormal();
		end
	end},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end},
	{text = BLIZZARD_STORE, func = function() StoreMicroButton:Click() end}
}

local function BuiGameMenu_OnMouseUp(self)
	GameTooltip:Hide()
	BUI:Dropmenu(menuList, menuFrame, self:GetName(), 'tLeft', -SPACING, SPACING, 4)
	PlaySound("igMainMenuOptionCheckBoxOff");
end

local function ChatButton_OnClick(self)
	GameTooltip:Hide()

	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
		if IsAddOnLoaded('AddOnSkins') then
			local AS = unpack(AddOnSkins) or nil			
			if E.private.addonskins.EmbedSystem or E.private.addonskins.EmbedSystemDual then AS:Embed_Show() end
		end
	else
		E.db[self.parent:GetName()..'Faded'] = true
		UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
	PlaySound("igMainMenuOptionCheckBoxOff");
end

local bbuttons = {}

function BUIL:ToggleBuiDts()
	if not E.db.benikui.datatexts.chat.enable or E.db.datatexts.leftChatPanel then
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
	
	if not E.db.benikui.datatexts.chat.enable or E.db.datatexts.rightChatPanel then
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

	if E.db.auras.consolidatedBuffs.enable then
		if E.db.benikui.datatexts.chat.enable then
			if E.db.auras.consolidatedBuffs.position == "LEFT" then
				LeftMiniPanel:Point('TOPLEFT', ElvUI_ConsolidatedBuffs, 'BOTTOMLEFT', 0, -SPACING)
				LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -(E.ConsolidatedBuffsWidth/2)-SPACING, -(SPACING + PANEL_HEIGHT))
				RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
				RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)					
			else
				LeftMiniPanel:Point('TOPLEFT', Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
				LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', (E.ConsolidatedBuffsWidth/2)-SPACING, -(SPACING + PANEL_HEIGHT))
				RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', E.ConsolidatedBuffsWidth + SPACING, -SPACING)
				RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
			end
			ElvConfigToggle:Hide()
		else
			LeftMiniPanel:Point('TOPLEFT', Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
			LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -SPACING, -(SPACING + PANEL_HEIGHT))
			RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
			RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
			ElvConfigToggle:Show()			
		end
	else
		LeftMiniPanel:Point('TOPLEFT', Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
		LeftMiniPanel:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOM', -SPACING, -(SPACING + PANEL_HEIGHT))
		RightMiniPanel:Point('TOPRIGHT', Minimap.backdrop, 'BOTTOMRIGHT', 0, -SPACING)
		RightMiniPanel:Point('BOTTOMLEFT', LeftMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
	end
	
	if E.db.datatexts.minimapPanels == false then ElvConfigToggle:Hide() end
	
	-- Stop here to support ElvUI_CustomTweaks CBEnhanced
	if IsAddOnLoaded('ElvUI_CustomTweaks') and E.private["CustomTweaks"] and E.private["CustomTweaks"]["CBEnhanced"] then return end
	
	if E.db.auras.consolidatedBuffs.position == "LEFT" then
		ElvUI_ConsolidatedBuffs:Point('TOPRIGHT', Minimap.backdrop, 'TOPLEFT', -SPACING, 0)
		ElvUI_ConsolidatedBuffs:Point('BOTTOMRIGHT', Minimap.backdrop, 'BOTTOMLEFT', -SPACING, 0)
		ElvConfigToggle:Point('TOPRIGHT', LeftMiniPanel, 'TOPLEFT', -SPACING, 0)
		ElvConfigToggle:Point('BOTTOMRIGHT', LeftMiniPanel, 'BOTTOMLEFT', -SPACING, 0)		
	else
		ElvUI_ConsolidatedBuffs:Point('TOPLEFT', Minimap.backdrop, 'TOPRIGHT', SPACING, 0)
		ElvUI_ConsolidatedBuffs:Point('BOTTOMLEFT', Minimap.backdrop, 'BOTTOMRIGHT', SPACING, 0)
		ElvConfigToggle:Point('TOPLEFT', RightMiniPanel, 'TOPRIGHT', SPACING, 0)
		ElvConfigToggle:Point('BOTTOMLEFT', RightMiniPanel, 'BOTTOMRIGHT', SPACING, 0)
	end
end

function BUIL:ToggleTransparency()
	local db = E.db.benikui.datatexts.chat
	if not db.backdrop then
		Bui_ldtp:StripTextures()
		Bui_rdtp:StripTextures()
		for i = 1, BUTTON_NUM do
			bbuttons[i]:StripTextures()
		end
	else
		if db.transparent then
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
end

function BUIL:MiddleDatatextLayout()
	local db = E.db.benikui.datatexts.middle
	
	if db.enable then
		Bui_mdtp:Show()
	else
		Bui_mdtp:Hide()
	end
	
	if not db.backdrop then
		Bui_mdtp:StripTextures()
	else
		if db.transparent then
			Bui_mdtp:SetTemplate('Transparent')
		else
			Bui_mdtp:SetTemplate('Default', true)
		end
	end
	
	if Bui_mdtp.style then 
		if db.styled and db.backdrop then
			Bui_mdtp.style:Show()
		else
			Bui_mdtp.style:Hide()
		end
	end
end

function BUIL:ChatStyles()
	if not E.db.benikui.general.benikuiStyle then return end
	if E.db.benikui.datatexts.chat.styled and E.db.chat.panelBackdrop == 'HIDEBOTH' then
		Bui_rdtp.style:Show()
		Bui_ldtp.style:Show()
		for i = 1, BUTTON_NUM do
			bbuttons[i].style:Show()
		end	
	else
		Bui_rdtp.style:Hide()
		Bui_ldtp.style:Hide()
		for i = 1, BUTTON_NUM do
			bbuttons[i].style:Hide()
		end
	end
end

function BUIL:MiddleDatatextDimensions()
	local db = E.db.benikui.datatexts.middle
	Bui_mdtp:Width(db.width)
	Bui_mdtp:Height(db.height)
	DT:UpdateAllDimensions()
end

local function updateButtonFont()
	for i = 1, BUTTON_NUM do
		if bbuttons[i].text then
			bbuttons[i].text:SetFont(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		end
	end
end

function BUIL:ChangeLayout()
	
	LeftMiniPanel:Height(PANEL_HEIGHT)
	RightMiniPanel:Height(PANEL_HEIGHT)
	
	ElvConfigToggle:Height(PANEL_HEIGHT)

	-- Left dt panel
	Bui_ldtp:SetFrameStrata('BACKGROUND')
	Bui_ldtp:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', (SPACING + PANEL_HEIGHT), -SPACING)
	Bui_ldtp:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -(SPACING + PANEL_HEIGHT), -PANEL_HEIGHT-SPACING)
	Bui_ldtp:Style('Outside')
	
	-- Right dt panel
	Bui_rdtp:SetFrameStrata('BACKGROUND')
	Bui_rdtp:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', (SPACING + PANEL_HEIGHT), -SPACING)
	Bui_rdtp:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING + PANEL_HEIGHT), -PANEL_HEIGHT-SPACING)
	Bui_rdtp:Style('Outside')
	
	-- Middle dt panel
	Bui_mdtp:SetFrameStrata('BACKGROUND')
	Bui_mdtp:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 2)
	Bui_mdtp:Width(E.db.benikui.datatexts.middle.width or 400)
	Bui_mdtp:Height(E.db.benikui.datatexts.middle.height or PANEL_HEIGHT)
	Bui_mdtp:Style('Outside')

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
		bbuttons[i]:RegisterForClicks('AnyUp')
		bbuttons[i]:SetFrameStrata('BACKGROUND')
		bbuttons[i]:CreateSoftGlow()
		bbuttons[i].sglow:Hide()
		bbuttons[i]:Style('Outside')
		bbuttons[i].text = bbuttons[i]:CreateFontString(nil, 'OVERLAY')
		bbuttons[i].text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		bbuttons[i].text:SetPoint('CENTER', 1, 0)
		bbuttons[i].text:SetJustifyH('CENTER')
		bbuttons[i].text:SetTextColor(BUI:unpackColor(E.db.general.valuecolor))
		
		-- ElvUI Config
		if i == 1 then
			bbuttons[i]:Point('TOPLEFT', Bui_rdtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_rdtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i].parent = RightChatPanel
			bbuttons[i].text:SetText('C')

			bbuttons[i]:SetScript('OnEnter', function(self)
				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end
				if IsShiftKeyDown() then
					self.text:SetText('>')
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self.text:SetText('C')
					self:SetScript('OnClick', function(self, btn)
						if btn == 'LeftButton' then
							E:ToggleConfig()
						else
							E:BGStats()
						end
						PlaySound("igMainMenuOptionCheckBoxOff");
					end)
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
				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(MAINMENU_BUTTON, selectioncolor)
				GameTooltip:Show()
				if InCombatLockdown() or BuiGameClickMenu:IsShown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
	
		-- AddOns Button	
		elseif i == 3 then
			bbuttons[i]:Point('TOPRIGHT', Bui_ldtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_ldtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i].parent = LeftChatPanel
			bbuttons[i].text:SetText('A')
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end
				if IsShiftKeyDown() then
					self.text:SetText('<')
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self:SetScript('OnClick', function(self)
						GameMenuButtonAddons:Click()
						PlaySound("igMainMenuOptionCheckBoxOff");
					end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 64, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(ADDONS, selectioncolor)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('A')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
			
		-- LFG Button
		elseif i == 4 then
			bbuttons[i]:Point('TOPLEFT', Bui_ldtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_ldtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i].text:SetText('L')
			
			bbuttons[i]:SetScript('OnClick', function(self)
				PVEFrame_ToggleFrame()
				PlaySound("igMainMenuOptionCheckBoxOff");
			end)
			
			bbuttons[i]:SetScript('OnEnter', function(self)
				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(LFG_TITLE, selectioncolor)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)
			
			bbuttons[i]:SetScript('OnLeave', function(self)
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
		end
	end

	LeftChatPanel.backdrop:Style('Outside', 'LeftChatPanel_Bui') -- keeping the names. Maybe use them as rep or xp bars... dunno... yet
	RightChatPanel.backdrop:Style('Outside', 'RightChatPanel_Bui')
	
	-- Minimap elements styling
	if E.private.general.minimap.enable then Minimap.backdrop:Style('Outside') end
	
	-- Support for ElvUI_CustomTweaks CBEnhanced
	if IsAddOnLoaded('ElvUI_CustomTweaks') and E.private["CustomTweaks"] and E.private["CustomTweaks"]["CBEnhanced"] then
		ElvUI_ConsolidatedBuffs.backdrop:Style('Outside')
	else
		ElvUI_ConsolidatedBuffs:Style('Outside')
	end
	
	if CopyChatFrame then CopyChatFrame:Style('Outside') end
	
	if FarmModeMap then FarmModeMap.backdrop:Style('Outside') end
	
	self:ResizeMinimapPanels()
	self:ToggleTransparency()
end

function BUIL:regEvents()
	self:MiddleDatatextLayout()
	self:MiddleDatatextDimensions()
	self:ToggleTransparency()
end

function BUIL:PLAYER_ENTERING_WORLD(...)
	self:ToggleBuiDts()
	self:regEvents()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function BUIL:Initialize()
	RegBuiDataTexts()
	self:ChangeLayout()
	self:ChatStyles()
	hooksecurefunc(LO, 'ToggleChatPanels', BUIL.ToggleBuiDts)
	hooksecurefunc(LO, 'ToggleChatPanels', BUIL.ResizeMinimapPanels)
	hooksecurefunc(LO, 'ToggleChatPanels', BUIL.ChatStyles)
	hooksecurefunc(M, 'UpdateSettings', BUIL.ResizeMinimapPanels)
	hooksecurefunc(DT, 'LoadDataTexts', updateButtonFont)
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'regEvents')
end

E:RegisterModule(BUIL:GetName())

