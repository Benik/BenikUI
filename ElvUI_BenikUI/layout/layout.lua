local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Layout')
local LO = E:GetModule('Layout')
local DT = E:GetModule('DataTexts')
local M = E:GetModule('Minimap')
local LSM = E.LSM

local _G = _G
local unpack = unpack
local tinsert = table.insert
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local PlaySound = PlaySound
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local GameMenuButtonAddons = GameMenuButtonAddons

-- GLOBALS: hooksecurefunc, selectioncolor
-- GLOBALS: AddOnSkins, MAINMENU_BUTTON, LFG_TITLE, BuiLeftChatDTPanel
-- GLOBALS: BuiMiddleDTPanel, BuiRightChatDTPanel, BuiGameClickMenu
-- GLOBALS: EncounterJournal_LoadUI, EncounterJournal
-- GLOBALS: MinimapPanel, Minimap
-- GLOBALS: LeftChatPanel, RightChatPanel, CopyChatFrame

local PANEL_HEIGHT = 19;
local SPACING = (E.PixelMode and 1 or 3)
local BUTTON_NUM = 4

local Bui_dchat = CreateFrame('Frame', 'BuiDummyChat', E.UIParent, 'BackdropTemplate')
local Bui_deb = CreateFrame('Frame', 'BuiDummyEditBoxHolder', E.UIParent, 'BackdropTemplate')

local menuFrame = CreateFrame('Frame', 'BuiGameClickMenu', E.UIParent, 'BackdropTemplate')
menuFrame:SetTemplate('Transparent', true)

function BuiGameMenu_OnMouseUp(self)
	if InCombatLockdown() then return end
	GameTooltip:Hide()
	BUI:Dropmenu(BUI.MenuList, menuFrame, self:GetName(), 'tLeft', -SPACING, SPACING, 4)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
end

local function ChatButton_OnClick(self)
	_G.GameTooltip:Hide()

	if E.db[self.parent:GetName()..'Faded'] then
		E.db[self.parent:GetName()..'Faded'] = nil
		E:UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
		if BUI.AS then
			local AS = unpack(AddOnSkins) or nil
			if AS.db.EmbedSystem or AS.db.EmbedSystemDual then AS:Embed_Show() end
		end
	else
		E.db[self.parent:GetName()..'Faded'] = true
		E:UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
		self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
	end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
end

local bbuttons = {}

function mod:ToggleBuiDts()
	local db = E.db.benikui.datatexts.chat
	local edb = E.db.datatexts

	if edb.leftChatPanel or edb.rightChatPanel then
		db.enable = false
		BuiLeftChatDTPanel:Hide()
		BuiRightChatDTPanel:Hide()
	end

	if db.enable then
		if db.showChatDt == 'SHOWBOTH' then
			BuiLeftChatDTPanel:Show()
			BuiRightChatDTPanel:Show()
		elseif db.showChatDt == 'LEFT' then
			if not edb.leftChatPanel then
				BuiLeftChatDTPanel:Show()
			end
			BuiRightChatDTPanel:Hide()
		elseif db.showChatDt == 'RIGHT' then
			BuiLeftChatDTPanel:Hide()
			if not edb.rightChatPanel then
				BuiRightChatDTPanel:Show()
			end
		end
	else
		BuiLeftChatDTPanel:Hide()
		BuiRightChatDTPanel:Hide()
	end
end

function mod:ResizeMinimapPanels()
	_G.MinimapPanel:Point('TOPLEFT', _G.Minimap.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	_G.MinimapPanel:Point('BOTTOMRIGHT', _G.Minimap.backdrop, 'BOTTOMRIGHT', 0, -(SPACING + PANEL_HEIGHT))
end

function mod:ToggleTransparency()
	local db = E.db.benikui.datatexts.chat
	local Bui_ldtp = _G.BuiLeftChatDTPanel
	local Bui_rdtp = _G.BuiRightChatDTPanel

	if not db.backdrop then
		Bui_ldtp:SetTemplate('NoBackdrop')
		Bui_rdtp:SetTemplate('NoBackdrop')
		for i = 1, BUTTON_NUM do
			bbuttons[i]:SetTemplate('NoBackdrop')
			if BUI.ShadowMode then
				bbuttons[i].shadow:Hide()
			end
		end
		if BUI.ShadowMode then
			Bui_ldtp.shadow:Hide()
			Bui_rdtp.shadow:Hide()
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
		if BUI.ShadowMode then
			Bui_ldtp.shadow:Show()
			Bui_rdtp.shadow:Show()
			for i = 1, BUTTON_NUM do
				bbuttons[i].shadow:Show()
			end
		end
	end
end

function mod:ChatStyles()
	if not E.db.benikui.general.benikuiStyle then return end
	local Bui_ldtp = _G.BuiLeftChatDTPanel
	local Bui_rdtp = _G.BuiRightChatDTPanel

	if E.db.benikui.datatexts.chat.styled and E.db.chat.panelBackdrop == 'HIDEBOTH' then
		Bui_rdtp.style:Show()
		Bui_ldtp.style:Show()
		for i = 1, BUTTON_NUM do
			bbuttons[i].style:Show()
		end
	else
		if Bui_rdtp.style then Bui_rdtp.style:Hide() end
		if Bui_ldtp.style then Bui_ldtp.style:Hide() end
		for i = 1, BUTTON_NUM do
			if bbuttons[i].style then bbuttons[i].style:Hide() end
		end
	end
end

function mod:PositionEditBoxHolder(bar)
	Bui_deb:ClearAllPoints()
	Bui_deb:Point('TOPLEFT', bar.backdrop, 'BOTTOMLEFT', 0, -SPACING)
	Bui_deb:Point('BOTTOMRIGHT', bar.backdrop, 'BOTTOMRIGHT', 0, -(PANEL_HEIGHT + 6))
end

local function updateButtonFont()
	local db = E.db.datatexts
	for i = 1, BUTTON_NUM do
		if bbuttons[i].text then
			bbuttons[i].text:SetFont(LSM:Fetch('font', db.font), db.fontSize, db.fontOutline)
			bbuttons[i].text:SetTextColor(BUI:unpackColor(E.db.general.valuecolor))
		end
	end

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

local function Panel_OnShow(self)
	self:SetFrameLevel(0)
end

function mod:CreateLayout()

	-- Left dt panel
	local Bui_ldtp = CreateFrame('Frame', 'BuiLeftChatDTPanel', E.UIParent, 'BackdropTemplate')
	Bui_ldtp:SetTemplate('Default', true)
	Bui_ldtp:SetFrameStrata('BACKGROUND')
	Bui_ldtp:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', (SPACING +PANEL_HEIGHT), -SPACING)
	Bui_ldtp:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', -(SPACING +PANEL_HEIGHT), -PANEL_HEIGHT -SPACING)
	Bui_ldtp:Style('Outside', nil, false, true)
	DT:RegisterPanel(BuiLeftChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

	-- Right dt panel
	local Bui_rdtp = CreateFrame('Frame', 'BuiRightChatDTPanel', E.UIParent, 'BackdropTemplate')
	Bui_rdtp:SetTemplate('Default', true)
	Bui_rdtp:SetFrameStrata('BACKGROUND')
	Bui_rdtp:Point('TOPLEFT', RightChatPanel, 'BOTTOMLEFT', (SPACING +PANEL_HEIGHT), -SPACING)
	Bui_rdtp:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', -(SPACING +PANEL_HEIGHT), -PANEL_HEIGHT -SPACING)
	Bui_rdtp:Style('Outside', nil, false, true)
	DT:RegisterPanel(BuiRightChatDTPanel, 3, 'ANCHOR_BOTTOM', 0, -4)

	-- dummy frame for chat/threat (left)
	Bui_dchat:SetFrameStrata('LOW')
	Bui_dchat:Point('TOPLEFT', LeftChatPanel, 'BOTTOMLEFT', 0, -SPACING)
	Bui_dchat:Point('BOTTOMRIGHT', LeftChatPanel, 'BOTTOMRIGHT', 0, -PANEL_HEIGHT -SPACING)

	-- Buttons
	for i = 1, BUTTON_NUM do
		bbuttons[i] = CreateFrame('Button', 'BuiButton_'..i, E.UIParent, 'BackdropTemplate')
		bbuttons[i]:RegisterForClicks('AnyUp')
		bbuttons[i]:SetFrameStrata('BACKGROUND')
		bbuttons[i]:CreateSoftGlow()
		bbuttons[i].sglow:Hide()
		bbuttons[i]:Style('Outside', nil, false, true)
		bbuttons[i].text = bbuttons[i]:CreateFontString(nil, 'OVERLAY')
		bbuttons[i].text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		bbuttons[i].text:Point('CENTER', 1, 0)
		bbuttons[i].text:SetJustifyH('CENTER')
		bbuttons[i].text:SetTextColor(BUI:unpackColor(E.db.general.valuecolor))
		bbuttons[i].arrow = bbuttons[i]:CreateTexture(nil, 'OVERLAY')
		bbuttons[i].arrow:SetTexture(E.Media.Textures.ArrowUp)
		bbuttons[i].arrow:ClearAllPoints()
		bbuttons[i].arrow:Point('CENTER')
		bbuttons[i].arrow:Size(12, 12)
		bbuttons[i].arrow:SetVertexColor(BUI:unpackColor(E.db.general.valuecolor))
		bbuttons[i].arrow:Hide()

		-- ElvUI Config
		if i == 1 then
			bbuttons[i]:Point('TOPLEFT', Bui_rdtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_rdtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i]:SetParent(Bui_rdtp)
			bbuttons[i].text:SetText('C')
			bbuttons[i].arrow:SetRotation(E.Skins.ArrowRotation.right)
			bbuttons[i].parent = _G.RightChatPanel

			bbuttons[i]:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['LeftClick: Toggle Configuration'], 0.7, 0.7, 1)
				if BUI.AS then
					GameTooltip:AddLine(L['RightClick: Toggle Embedded Addon'], 0.7, 0.7, 1)
				end
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)

				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end

				if IsShiftKeyDown() then
					self.text:SetText('')
					self.arrow:Show()
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self.arrow:Hide()
					self.text:SetText('C')
					self:SetScript('OnClick', function(self, btn)
						if btn == 'LeftButton' then
							E:ToggleOptionsUI()
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

			bbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('C')
				self.sglow:Hide()
				GameTooltip:Hide()
			end)

		-- Game menu button
		elseif i == 2 then
			bbuttons[i]:Point('TOPRIGHT', Bui_rdtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_rdtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i]:SetParent(Bui_rdtp)
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
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			bbuttons[i]:SetScript('OnLeave', function(self)
				self.sglow:Hide()
				GameTooltip:Hide()
			end)

		-- AddOns Button
		elseif i == 3 then
			bbuttons[i]:Point('TOPRIGHT', Bui_ldtp, 'TOPLEFT', -SPACING, 0)
			bbuttons[i]:Point('BOTTOMLEFT', Bui_ldtp, 'BOTTOMLEFT', -(PANEL_HEIGHT + SPACING), 0)
			bbuttons[i]:SetParent(Bui_ldtp)
			bbuttons[i].text:SetText('A')
			bbuttons[i].arrow:SetRotation(E.Skins.ArrowRotation.left)
			bbuttons[i].parent = _G.LeftChatPanel

			bbuttons[i]:SetScript('OnEnter', function(self)
				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end
				if IsShiftKeyDown() then
					self.arrow:Show()
					self.text:SetText('')
					self:SetScript('OnClick', ChatButton_OnClick)
				else
					self:SetScript('OnClick', function(self)
						GameMenuButtonAddons:Click()
					end)
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 64, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddLine(L['Click to show the Addon List'], 0.7, 0.7, 1)
				GameTooltip:AddLine(L['ShiftClick to toggle chat'], 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			bbuttons[i]:SetScript('OnLeave', function(self)
				self.text:SetText('A')
				self.arrow:Hide()
				self.sglow:Hide()
				GameTooltip:Hide()
			end)

		-- LFG Button
		elseif i == 4 then
			bbuttons[i]:Point('TOPLEFT', Bui_ldtp, 'TOPRIGHT', SPACING, 0)
			bbuttons[i]:Point('BOTTOMRIGHT', Bui_ldtp, 'BOTTOMRIGHT', PANEL_HEIGHT + SPACING, 0)
			bbuttons[i]:SetParent(Bui_ldtp)
			bbuttons[i].text:SetText('L')

			bbuttons[i]:SetScript('OnClick', function(self, btn)
				if btn == "LeftButton" then
					PVEFrame_ToggleFrame()
				elseif btn == "RightButton" then
					if not IsAddOnLoaded('Blizzard_EncounterJournal') then
						EncounterJournal_LoadUI();
					end
					ToggleFrame(EncounterJournal)
				end
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
			end)

			bbuttons[i]:SetScript('OnEnter', function(self)
				if not E.db.benikui.datatexts.chat.styled then
					self.sglow:Show()
				end
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2 )
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(L['Click :'], LFG_TITLE, 0.7, 0.7, 1)
				GameTooltip:AddDoubleLine(L['RightClick :'], ADVENTURE_JOURNAL, 0.7, 0.7, 1)
				GameTooltip:Show()
				if InCombatLockdown() then GameTooltip:Hide() end
			end)

			bbuttons[i]:SetScript('OnLeave', function(self)
				self.sglow:Hide()
				GameTooltip:Hide()
			end)
		end
	end

	MinimapPanel:Height(PANEL_HEIGHT)
	ElvUI_BottomPanel:SetScript('OnShow', Panel_OnShow)
	ElvUI_BottomPanel:SetFrameLevel(0)
	ElvUI_TopPanel:SetScript('OnShow', Panel_OnShow)
	ElvUI_TopPanel:SetFrameLevel(0)

	LeftChatPanel.backdrop:Style('Outside')
	RightChatPanel.backdrop:Style('Outside')

	if BUI.ShadowMode then
		MinimapPanel:CreateSoftShadow()
		LeftChatDataPanel:CreateSoftShadow()
		LeftChatToggleButton:CreateSoftShadow()
		RightChatDataPanel:CreateSoftShadow()
		RightChatToggleButton:CreateSoftShadow()
	end

	-- Minimap elements styling
	if E.private.general.minimap.enable then
		Minimap.backdrop:Style('Outside')
		mod:ResizeMinimapPanels()
	end

	if CopyChatFrame then CopyChatFrame:Style('Outside') end

	self:ToggleTransparency()
end

-- Add minimap styling option in ElvUI minimap options
local function InjectMinimapOption()
	E.Options.args.maps.args.minimap.args.generalGroup.args.benikuiStyle = {
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
	if forceReset and E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"] or not E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"] then
		DT:BuildPanelFrame("BuiMiddleDTPanel")
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["enable"] = true
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["border"] = true
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipYOffset"] = 4
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["numPoints"] = 3
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["backdrop"] = true
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = 414
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["height"] = PANEL_HEIGHT
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["tooltipXOffset"] = 3
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["panelTransparency"] = false
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["benikuiStyle"] = false
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["growth"] = 'HORIZONTAL'

		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"] = {
			[1] = "Haste",
			[2] = "Mastery",
			[3] = "Crit",
			["enable"] = true,
		}

		if E.db["movers"] == nil then E.db["movers"] = {} end

		local dt = DT:FetchFrame("BuiMiddleDTPanel")
		dt.mover:ClearAllPoints()
		dt.mover:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 2)
		dt:SetPoint("CENTER", dt.mover, "CENTER", 0, 0) -- just in case
		E.db["movers"]["DTPanelBuiMiddleDTPanelMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E:SaveMoverPosition("DTPanelBuiMiddleDTPanelMover")
	end
end

function mod:ToggleMinimapStyle()
	if E.private.general.minimap.enable ~= true or E.db.benikui.general.benikuiStyle ~= true then return end
	if E.db.general.minimap.benikuiStyle then
		Minimap.backdrop.style:Show()
	else
		Minimap.backdrop.style:Hide()
	end
end

function mod:regEvents()
	mod:ToggleTransparency()
end

function mod:PLAYER_ENTERING_WORLD(...)
	mod:ToggleBuiDts()
	mod:regEvents()

	DT:UpdatePanelInfo('BuiLeftChatDTPanel')
	DT:UpdatePanelInfo('BuiRightChatDTPanel')
	DT:UpdatePanelInfo('BuiMiddleDTPanel')

	mod:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function InjectDatatextOptions()
	E.Options.args.datatexts.args.panels.args.BuiLeftChatDTPanel.name = BUI.Title..BUI:cOption(L['Left Chat Panel'], "blue")
	E.Options.args.datatexts.args.panels.args.BuiLeftChatDTPanel.order = 1001

	E.Options.args.datatexts.args.panels.args.BuiRightChatDTPanel.name = BUI.Title..BUI:cOption(L['Right Chat Panel'], "blue")
	E.Options.args.datatexts.args.panels.args.BuiRightChatDTPanel.order = 1002

	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.name = BUI.Title..BUI:cOption(L['Middle Panel'], "blue")
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.order = 1003
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.args.panelOptions.args.delete.hidden = true
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.args.panelOptions.args.height.hidden = true
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.args.panelOptions.args.growth.hidden = true
end

function mod:Initialize()
	mod:CreateLayout()
	mod:CreateMiddlePanel()
	mod:ChatStyles()
	mod:ToggleMinimapStyle()
	tinsert(BUI.Config, InjectDatatextOptions)

	hooksecurefunc(LO, 'ToggleChatPanels', mod.ToggleBuiDts)
	hooksecurefunc(LO, 'ToggleChatPanels', mod.ResizeMinimapPanels)
	hooksecurefunc(LO, 'ToggleChatPanels', mod.ChatStyles)
	hooksecurefunc(M, 'UpdateSettings', mod.ResizeMinimapPanels)
	hooksecurefunc(DT, 'UpdatePanelInfo', mod.ToggleTransparency)
	hooksecurefunc(DT, 'LoadDataTexts', updateButtonFont)
	hooksecurefunc(E, 'UpdateMedia', updateButtonFont)

	mod:RegisterEvent('PLAYER_ENTERING_WORLD')
	mod:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', 'regEvents')
end

BUI:RegisterModule(mod:GetName())
