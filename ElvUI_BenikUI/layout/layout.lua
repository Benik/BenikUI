local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Layout')
local LO = E:GetModule('Layout')
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Minimap')
local LSM = E.LSM

local _G = _G
local tinsert = table.insert
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local ShowUIPanel = ShowUIPanel
local GameTooltip = GameTooltip
local PlaySound = PlaySound
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local EncounterJournal_LoadUI = EncounterJournal_LoadUI
local C_TimerAfter = C_Timer.After
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded

local MAINMENU_BUTTON = MAINMENU_BUTTON
local LFG_TITLE = LFG_TITLE
local ADVENTURE_JOURNAL = ADVENTURE_JOURNAL

local dtButtons = {}

local PANEL_HEIGHT = 19;
local SPACING = (E.PixelMode and 1 or 3)
local NUM_BUTTONS = 4

local menuIcon = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\menu.tga'
local lfgIcon = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\buttons\\eye.tga'
local optionsIcon = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\buttons\\options.tga'
local addonsIcon = 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\buttons\\plugin.tga'

local dummyChatFrame = CreateFrame('Frame', 'BuiDummyChat', E.UIParent)
local dummyEditBoxHolder = CreateFrame('Frame', 'BuiDummyEditBoxHolder', E.UIParent)

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent)
menuFrame:SetTemplate('Transparent', true)
menuFrame:SetFrameStrata('DIALOG')

local function GameMenu_OnMouseUp()
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end

	local buiButton2 = _G.BuiButton_2
	GameTooltip:Hide()
	BUI:Dropmenu(BUI.MenuList, menuFrame, buiButton2, 'tLeft', -SPACING, SPACING, 4)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
end

local function ChatButton_OnClick(self)
	GameTooltip:Hide()

	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		E:UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
	else
		E.db[self.parent:GetName()..'Faded'] = true
		E:UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
end

function mod:ToggleBuiDts()
	local db = E.db.benikui.datatexts.chat
	local edb = E.db.datatexts
	local buiRightDT = _G.BuiRightChatDTPanel
	local buiLeftDT = _G.BuiLeftChatDTPanel

	if edb.leftChatPanel or edb.rightChatPanel then
		db.enable = false
		buiLeftDT:Hide()
		buiRightDT:Hide()
	end

	if db.enable then
		if db.showChatDt == 'SHOWBOTH' then
			buiLeftDT:Show()
			buiRightDT:Show()
		elseif db.showChatDt == 'LEFT' then
			if not edb.leftChatPanel then
				buiLeftDT:Show()
			end
			buiRightDT:Hide()
		elseif db.showChatDt == 'RIGHT' then
			buiLeftDT:Hide()
			if not edb.rightChatPanel then
				buiRightDT:Show()
			end
		end
	else
		buiLeftDT:Hide()
		buiRightDT:Hide()
	end
end

function mod:ResizeMinimapPanels()
	local elvuiMinimapPanel = _G.MinimapPanel
	local elvuiMinimap = _G.Minimap

	elvuiMinimapPanel:Point('TOPLEFT', elvuiMinimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	elvuiMinimapPanel:Point('BOTTOMRIGHT', elvuiMinimap.backdrop, 'BOTTOMRIGHT', 0, -(SPACING + PANEL_HEIGHT))
end

function mod:ToggleTransparency()
	local db = E.db.benikui.datatexts.chat
	local shadows = E.db.benikui.general.shadows 
	local buiLeftDT = _G.BuiLeftChatDTPanel
	local buiRightDT = _G.BuiRightChatDTPanel

	if not db.backdrop then
		buiLeftDT:SetTemplate('NoBackdrop')
		buiRightDT:SetTemplate('NoBackdrop')
		for i = 1, NUM_BUTTONS do
			dtButtons[i]:SetTemplate('NoBackdrop')
			if shadows then
				dtButtons[i].shadow:Hide()
			end
		end
		if shadows then
			buiLeftDT.shadow:Hide()
			buiRightDT.shadow:Hide()
		end
	else
		if db.transparent then
			buiLeftDT:SetTemplate('Transparent')
			buiRightDT:SetTemplate('Transparent')
			for i = 1, NUM_BUTTONS do
				dtButtons[i]:SetTemplate('Transparent')
			end
		else
			buiLeftDT:SetTemplate('Default', true)
			buiRightDT:SetTemplate('Default', true)
			for i = 1, NUM_BUTTONS do
				dtButtons[i]:SetTemplate('Default', true)
			end
		end
		if shadows then
			buiLeftDT.shadow:Show()
			buiRightDT.shadow:Show()
			for i = 1, NUM_BUTTONS do
				dtButtons[i].shadow:Show()
			end
		end
	end

	if not shadows then return end

	local leftChatDataPanel = _G.LeftChatDataPanel
	local rightChatDataPanel = _G.RightChatDataPanel
	local leftChatToggleButton = _G.LeftChatToggleButton
	local rightChatToggleButton = _G.RightChatToggleButton

	local lchatToggle = E.db.datatexts.panels.LeftChatDataPanel.backdrop

	leftChatDataPanel.shadow:SetShown(lchatToggle)
	leftChatToggleButton.shadow:SetShown(lchatToggle)

	local rchatToggle = E.db.datatexts.panels.RightChatDataPanel.backdrop
	rightChatDataPanel.shadow:SetShown(rchatToggle)
	rightChatToggleButton.shadow:SetShown(rchatToggle)
end

local function ChatDT_StyleDelay()
	local showConditions = E.db.benikui.datatexts.chat.styled and E.db.chat.panelBackdrop == 'HIDEBOTH'

	_G.BuiLeftChatDTPanel.style:SetShown(showConditions)
	_G.BuiRightChatDTPanel.style:SetShown(showConditions)
end

function mod:ChatStyles()
	if not E.db.benikui.general.benikuiStyle then return end

	C_TimerAfter(0.1, ChatDT_StyleDelay)
	C_TimerAfter(0.1, ChatDT_StyleDelay)

	for i = 1, NUM_BUTTONS do
		dtButtons[i].style:SetShown(E.db.benikui.datatexts.chat.styled and E.db.chat.panelBackdrop == 'HIDEBOTH')
	end
end

function mod:PositionEditBoxHolder(bar)
	dummyEditBoxHolder:ClearAllPoints()
	dummyEditBoxHolder:Point('TOPLEFT', bar.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	dummyEditBoxHolder:Point('BOTTOMRIGHT', bar.backdrop, 'BOTTOMRIGHT', 0, -(PANEL_HEIGHT + 6))
end

local function updateButtonFont()
	local db = E.db.datatexts

	local dts = {BuiLeftChatDTPanel, BuiRightChatDTPanel}
	for panelName, panel in pairs(dts) do
		for i = 1, panel.numPoints do
			if panel.dataPanels[i] then
				panel.dataPanels[i].text:FontTemplate(LSM:Fetch('font', db.font), db.fontSize, db.fontOutline)
			end
		end
		DT:UpdatePanelInfo(panelName, panel)
	end
end

local function updateButtonColor()
	for i = 1, NUM_BUTTONS do
		if dtButtons[i].btn then
			dtButtons[i].btn:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end
end

local function updateButtons()
	updateButtonFont()
	updateButtonColor()
end

local function Panel_OnShow(self)
	self:SetFrameLevel(0)
	self:SetFrameStrata('BACKGROUND')
end

function mod:CreateLayout()
	local elvuiMinimapPanel = _G.MinimapPanel
	local elvuiMinimap = _G.Minimap
	local elvuiBottomPanel = _G.ElvUI_BottomPanel
	local elvuiTopPanel = _G.ElvUI_TopPanel

	local elvuiLeftChatPanel = _G.LeftChatPanel
	local elvuiRightChatPanel = _G.RightChatPanel

	local leftChatDataPanel = _G.LeftChatDataPanel
	local rightChatDataPanel = _G.RightChatDataPanel
	local leftChatToggleButton = _G.LeftChatToggleButton
	local rightChatToggleButton = _G.RightChatToggleButton

	-- Left dt panel
	local buiLeftDT = CreateFrame('Frame', 'BuiLeftChatDTPanel', E.UIParent)
	buiLeftDT:SetTemplate('Default', true)
	buiLeftDT:SetFrameStrata('BACKGROUND')
	buiLeftDT:Point('TOPLEFT', elvuiLeftChatPanel, 'BOTTOMLEFT', (SPACING +PANEL_HEIGHT), -SPACING)
	buiLeftDT:Point('BOTTOMRIGHT', elvuiLeftChatPanel, 'BOTTOMRIGHT', -(SPACING +PANEL_HEIGHT), -PANEL_HEIGHT -SPACING)
	buiLeftDT:BuiStyle('Outside', nil, false, true)
	DT:RegisterPanel(BuiLeftChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

	-- Right dt panel
	local buiRightDT = CreateFrame('Frame', 'BuiRightChatDTPanel', E.UIParent)
	buiRightDT:SetTemplate('Default', true)
	buiRightDT:SetFrameStrata('BACKGROUND')
	buiRightDT:Point('TOPLEFT', elvuiRightChatPanel, 'BOTTOMLEFT', (SPACING +PANEL_HEIGHT), -SPACING)
	buiRightDT:Point('BOTTOMRIGHT', elvuiRightChatPanel, 'BOTTOMRIGHT', -(SPACING +PANEL_HEIGHT), -PANEL_HEIGHT -SPACING)
	buiRightDT:BuiStyle('Outside', nil, false, true)
	DT:RegisterPanel(BuiRightChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

	-- dummy frame for chat/threat (left)
	dummyChatFrame:SetFrameStrata('LOW')
	dummyChatFrame:Point('TOPLEFT', elvuiLeftChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	dummyChatFrame:Point('BOTTOMRIGHT', elvuiLeftChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT -SPACING)

	-- Buttons
	for i = 1, NUM_BUTTONS do
		dtButtons[i] = CreateFrame('Button', 'BuiButton_'..i, E.UIParent)
		dtButtons[i]:RegisterForClicks('AnyUp')
		dtButtons[i]:SetFrameStrata('BACKGROUND')
		dtButtons[i]:BuiStyle('Outside', nil, false, true)
		dtButtons[i].btn = dtButtons[i]:CreateTexture(nil, 'OVERLAY')
		dtButtons[i].btn:ClearAllPoints()
		dtButtons[i].btn:Point('CENTER')
		dtButtons[i].btn:Size(14, 14)
		dtButtons[i].btn:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		dtButtons[i].btn:Show()
		dtButtons[i].arrow = dtButtons[i]:CreateTexture(nil, 'OVERLAY')
		dtButtons[i].arrow:SetTexture(E.Media.Textures.ArrowUp)
		dtButtons[i].arrow:ClearAllPoints()
		dtButtons[i].arrow:Point('CENTER')
		dtButtons[i].arrow:Size(12, 12)
		dtButtons[i].arrow:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		dtButtons[i].arrow:Hide()

		-- ElvUI Config
		if i == 1 then
			dtButtons[i]:Point('TOPLEFT', buiRightDT, 'TOPRIGHT', SPACING, 0)
			dtButtons[i]:Point('BOTTOMRIGHT', buiRightDT, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			dtButtons[i]:SetParent(buiRightDT)
			dtButtons[i].btn:SetTexture(optionsIcon)
			dtButtons[i].arrow:SetRotation(E.Skins.ArrowRotation.right)
			dtButtons[i].parent = elvuiRightChatPanel

			dtButtons[i]:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['LeftClick: Toggle Configuration'], 0.7, 0.7, 1)
				if BUI.AS then
					GameTooltip:AddLine(L['RightClick: Toggle Embedded Addon'], 0.7, 0.7, 1)
				end
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)

				self.btn:SetVertexColor(1, 1, 1, .7)

				if IsShiftKeyDown() then
					self.btn:Hide()
					self.arrow:Show()
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self.arrow:Hide()
					self.btn:Show()
					self:SetScript('OnClick', function(self, btn)
						if btn == 'LeftButton' then
							E:ToggleOptions()
						else
							if BUI.AS then
								local AS = unpack(AddOnSkins) or nil
								if AS:CheckOption('EmbedRightChat') and EmbedSystem_MainWindow then
									if EmbedSystem_MainWindow:IsShown() then
										AS:SetOption('EmbedIsHidden', true)
										EmbedSystem_MainWindow:Hide()
									else
										AS:SetOption('EmbedIsHidden', false)
										EmbedSystem_MainWindow:Show()
									end
								end
							else
								DT:ToggleBattleStats()
							end
						end
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
					end)
				end

				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			dtButtons[i]:SetScript('OnLeave', function(self)
				self.btn:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
				self.arrow:Hide()
				self.btn:Show()
				GameTooltip:Hide()
			end)

		-- Game menu button
		elseif i == 2 then
			dtButtons[i]:Point('TOPRIGHT', buiRightDT, 'TOPLEFT', -SPACING, 0)
			dtButtons[i]:Point('BOTTOMLEFT', buiRightDT, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			dtButtons[i]:SetParent(buiRightDT)
			dtButtons[i].btn:SetTexture(menuIcon)

			dtButtons[i]:SetScript('OnClick', GameMenu_OnMouseUp)

			dtButtons[i]:SetScript('OnEnter', function(self)
				self.btn:SetVertexColor(1, 1, 1, .7)
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(MAINMENU_BUTTON, 1, 1, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			dtButtons[i]:SetScript('OnLeave', function(self)
				self.btn:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
				GameTooltip:Hide()
			end)

		-- AddOns Button
		elseif i == 3 then
			dtButtons[i]:Point('TOPRIGHT', buiLeftDT, 'TOPLEFT', -SPACING, 0)
			dtButtons[i]:Point('BOTTOMLEFT', buiLeftDT, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			dtButtons[i]:SetParent(buiLeftDT)
			dtButtons[i].btn:SetTexture(addonsIcon)
			dtButtons[i].arrow:SetRotation(E.Skins.ArrowRotation.left)
			dtButtons[i].parent = elvuiLeftChatPanel

			dtButtons[i]:SetScript('OnEnter', function(self)
				self.btn:SetVertexColor(1, 1, 1, .7)
				if IsShiftKeyDown() then
					self.arrow:Show()
					self.btn:Hide()
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self:SetScript('OnClick', function(self)
						ShowUIPanel(_G.AddonList)
					end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 64, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Click to show the Addon List'], 0.7, 0.7, 1)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			dtButtons[i]:SetScript('OnLeave', function(self)
				self.btn:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
				self.btn:Show()
				self.arrow:Hide()
				GameTooltip:Hide()
			end)

		-- LFG Button
		elseif i == 4 then
			dtButtons[i]:Point('TOPLEFT', buiLeftDT, 'TOPRIGHT', SPACING, 0)
			dtButtons[i]:Point('BOTTOMRIGHT', buiLeftDT, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			dtButtons[i]:SetParent(buiLeftDT)
			dtButtons[i].btn:SetTexture(lfgIcon)

			dtButtons[i]:SetScript('OnClick', function(self, btn)
				if btn == "LeftButton" then
					PVEFrame_ToggleFrame()
				elseif btn == "RightButton" then
					if not IsAddOnLoaded('Blizzard_EncounterJournal') then
						EncounterJournal_LoadUI();
					end
					ToggleFrame(_G.EncounterJournal)
				end
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
			end)

			dtButtons[i]:SetScript('OnEnter', function(self)
				self.btn:SetVertexColor(1, 1, 1, .7)
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(L['Click :'], LFG_TITLE, 0.7, 0.7, 1)
				GameTooltip:AddDoubleLine(L['RightClick :'], ADVENTURE_JOURNAL, 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			dtButtons[i]:SetScript('OnLeave', function(self)
				self.btn:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
				GameTooltip:Hide()
			end)
		end
	end

	elvuiMinimapPanel:Height(PANEL_HEIGHT)
	elvuiBottomPanel:SetScript('OnShow', Panel_OnShow)
	elvuiBottomPanel:SetFrameLevel(0)
	elvuiBottomPanel:SetFrameStrata('BACKGROUND')
	elvuiTopPanel:SetScript('OnShow', Panel_OnShow)
	elvuiTopPanel:SetFrameLevel(0)
	elvuiTopPanel:SetFrameStrata('BACKGROUND')

	elvuiLeftChatPanel.backdrop:BuiStyle()
	elvuiRightChatPanel.backdrop:BuiStyle()

	if E.db.benikui.general.shadows then
		elvuiMinimapPanel:CreateSoftShadow()
		leftChatDataPanel:CreateSoftShadow()
		leftChatToggleButton:CreateSoftShadow()
		rightChatDataPanel:CreateSoftShadow()
		rightChatToggleButton:CreateSoftShadow()
	end

	-- Minimap elements styling
	if E.private.general.minimap.enable then
		local elvuiMinimapRightClickMenu = _G.MinimapRightClickMenu
		elvuiMinimap.backdrop:BuiStyle()
		elvuiMinimapRightClickMenu:BuiStyle()
		mod:ResizeMinimapPanels()
	end

	local elvuiCopyChatFrame = _G.ElvUI_CopyChatFrame
	if elvuiCopyChatFrame then elvuiCopyChatFrame:BuiStyle() end

	self:ToggleTransparency()
end

-- Add minimap styling option in ElvUI minimap options
local function InjectMinimapOption()
	E.Options.args.maps.args.minimap.args.benikuiStyle = {
		order = 3,
		type = "toggle",
		name = BUI:cOption(L['BenikUI Style'], "blue"),
		disabled = function() return not E.private.general.minimap.enable or not E.db.benikui.general.benikuiStyle end,
		get = function(info) return E.db.general.minimap.benikuiStyle end,
		set = function(info, value) E.db.general.minimap.benikuiStyle = value; mod:ToggleMinimapStyle(); end,
	}
end
tinsert(BUI.Config, InjectMinimapOption)

function mod:CreateMiddlePanel(forceReset)
	if not DT:FetchFrame("BuiMiddleDTPanel") then	
		DT:BuildPanelFrame("BuiMiddleDTPanel")
		DT:UpdatePanelInfo("BuiMiddleDTPanel")
	end

	E.db["datatexts"]["panels"]["BuiMiddleDTPanel"] = E.db["datatexts"]["panels"]["BuiMiddleDTPanel"] or {}
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"] or {}
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipYOffset"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipYOffset"] or 4
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["numPoints"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["numPoints"] or 3
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipAnchor"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipAnchor"] or "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] or 416
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["height"] = PANEL_HEIGHT
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipXOffset"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipXOffset"] or 3
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["panelTransparency"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["panelTransparency"] or false
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["benikuiStyle"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["benikuiStyle"] or false
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["textJustify"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["textJustify"] or 'CENTER'
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["growth"] = 'HORIZONTAL'

	if E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][1] == '' and E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][2] == '' and E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][3] == '' then
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"] = {
			[1] = "Haste",
			[2] = "Mastery",
			[3] = "Crit",
			["enable"] = true,
		}
	end

	if forceReset then
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"] = E.db["datatexts"]["panels"]["BuiMiddleDTPanel"] or {}
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["enable"] = true

		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"] = E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"] or {}
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["border"] = true
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipYOffset"] = 4
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["numPoints"] = 3
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["backdrop"] = true
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = 416
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["height"] = PANEL_HEIGHT
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipXOffset"] = 3
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["panelTransparency"] = false
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["benikuiStyle"] = false
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["textJustify"] = 'CENTER'
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["growth"] = 'HORIZONTAL'

		if E.db["movers"] == nil then E.db["movers"] = {} end

		local dt = DT:FetchFrame("BuiMiddleDTPanel")
		dt.mover:ClearAllPoints()
		dt.mover:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 2)
		dt:SetPoint("CENTER", dt.mover, "CENTER", 0, 0) -- just in case
		E.db["movers"]["DTPanelBuiMiddleDTPanelMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E:SaveMoverPosition("DTPanelBuiMiddleDTPanelMover")

		DT:BuildPanelFrame('BuiMiddleDTPanel')
	end
end

function mod:ToggleMinimapStyle()
	local elvuiMinimap = _G.Minimap
	if E.private.general.minimap.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end

	if elvuiMinimap.backdrop.style then
		elvuiMinimap.backdrop.style:SetShown(E.db.general.minimap.benikuiStyle)
	end
end

function mod:regEvents()
	mod:ToggleTransparency()
end

function mod:LoadDataTexts(...)
	DT:UpdatePanelInfo('BuiLeftChatDTPanel')
	DT:UpdatePanelInfo('BuiRightChatDTPanel')
	DT:UpdatePanelInfo('BuiMiddleDTPanel')
	updateButtonFont()
end

function mod:PLAYER_ENTERING_WORLD(...)
	mod:ToggleBuiDts()
	mod:regEvents()

	mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	mod:CreateLayout()
	mod:CreateMiddlePanel()
	mod:ToggleMinimapStyle()
	C_TimerAfter(0.5, mod.ChatStyles)

	hooksecurefunc(LO, 'ToggleChatPanels', mod.ToggleBuiDts)
	hooksecurefunc(LO, 'ToggleChatPanels', mod.ResizeMinimapPanels)
	hooksecurefunc(LO, 'ToggleChatPanels', mod.ChatStyles)
	hooksecurefunc(M, 'UpdateSettings', mod.ResizeMinimapPanels)
	hooksecurefunc(DT, 'UpdatePanelInfo', mod.ToggleTransparency)
	hooksecurefunc(DT, 'LoadDataTexts', mod.LoadDataTexts)
	hooksecurefunc(E, 'UpdateMedia', updateButtons)

	mod:RegisterEvent('PLAYER_ENTERING_WORLD')
	mod:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'regEvents')
end

BUI:RegisterModule(mod:GetName())
