-- ============================================================================
-- BenikUI Custom Panels Module for ElvUI
--
-- This module creates, updates, and manages custom panels.
-- It enforces that one of the three display modes (Opaque, Transparent,
-- or Custom) is always active. In Custom mode, if the alpha equals the
-- default backdrop fade alpha, it is forced to 0.7.
--
-- ============================================================================
local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('CustomPanels')
local LSM = E.Libs.LSM

local _G = _G
local pairs = pairs

-- Standard API references
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local ReloadUI = ReloadUI
local UnitInVehicle = UnitInVehicle
local UnregisterStateDriver = UnregisterStateDriver

local classColor = E:ClassColor(E.myclass, true)

-- Retrieve default alpha from E.media.backdropfadecolor.
local _r, _g, _b, _a = unpack(E.media.backdropfadecolor)

-- Default settings for a new panel.
local PanelDefault = {
	enable = true,
	width = 200,
	height = 200,
	point = "CENTER",
	-- Display mode flags: one of the below 3 must always be true.
	opaque = true,       -- default mode is opaque
	transparent = false,
	custom = false,
	alpha = 0.7,
	style = false,
	stylePosition = 'TOP',
	shadow = true,
	clickThrough = false,
	strata = "LOW",
	combatHide = true,
	petHide = true,
	vehicleHide = true,
	tooltip = true,
	visibility = "",
	styleColor = 1,
	customStyleColor = { r = 0.9, g = 0.7, b = 0 },
	title = {
		enable = true,
		text = 'Title',
		height = 26,
		position = 'TOP',
		textPosition = 'CENTER',
		textXoffset = 0,
		textYoffset = 0,
		panelTexture = "BuiMelli",
		panelColor = { r = 0.9, g = 0.7, b = 0, a = 0.7 },
		useDTfont = true,
		font = E.db.datatexts.font,
		fontsize = E.db.datatexts.fontSize,
		fontflags = E.db.datatexts.fontOutline,
		fontColor = { r = 0.9, g = 0.9, b = 0.9 },
	},
}

-- ============================================================================
-- EnsureDisplayMode
-- Makes sure that one (and only one) display mode is active.
-- ============================================================================
local function EnsureDisplayMode(panelData)
	if not (panelData.opaque or panelData.transparent or panelData.custom) then
		panelData.opaque = true
	end
end

-- ============================================================================
-- InsertNewDefaults
-- Ensures every custom panel in the database has all required keys.
-- ============================================================================
local function InsertNewDefaults()
	for name in pairs(E.db.benikui.panels) do
		local data = E.db.benikui.panels[name]
		if data then
			if data.styleColor == nil then data.styleColor = 1 end
			if data.customStyleColor == nil then data.customStyleColor = { r = 0.9, g = 0.7, b = 0 } end
			if data.title == nil then
				data.title = {
					enable = true,
					text = 'Title',
					height = 26,
					position = 'TOP',
					textPosition = 'CENTER',
					textXoffset = 0,
					textYoffset = 0,
					panelTexture = "BuiMelli",
					panelColor = { r = 0.9, g = 0.7, b = 0, a = 0.7 },
					useDTfont = true,
					font = E.db.datatexts.font,
					fontsize = E.db.datatexts.fontSize,
					fontflags = E.db.datatexts.fontOutline,
					fontColor = { r = 0.9, g = 0.9, b = 0.9 },
				}
			end
			EnsureDisplayMode(data)
		end
	end
end

-- ============================================================================
-- Tooltip Functions
-- ============================================================================
local function OnEnter(self)
	local data = E.db.benikui.panels[self.Name]
	if data and data.tooltip then
		_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		_G.GameTooltip:AddLine(self.Name, 0.7, 0.7, 1)
		_G.GameTooltip:Show()
	end
end

local function OnLeave(self)
	local data = E.db.benikui.panels[self.Name]
	if data and data.tooltip then
		_G.GameTooltip:Hide()
	end
end

-- ============================================================================
-- InsertPanel
-- Creates a new panel entry.
-- ============================================================================
function mod:InsertPanel(name)
	if name == "" then return end
	name = "BenikUI_" .. name
	local db = E.db.benikui.panels
	if not db[name] then
		db[name] = PanelDefault
	else
		E:StaticPopup_Show("BUI_Panel_Name")
	end
end

-- ============================================================================
-- CreatePanel
-- Creates the frame for each custom panel.
-- ============================================================================
function mod:CreatePanel()
	if not E.db.benikui.panels then E.db.benikui.panels = {} end
	for name in pairs(E.db.benikui.panels) do
		if name and not _G[name] then
			local panel = CreateFrame("Frame", name, E.UIParent)
			local data = E.db.benikui.panels[name]
			panel:Width(data.width or 200)
			panel:Height(data.height or 200)
			panel:SetTemplate('Transparent')
			panel:Point('CENTER', E.UIParent, 'CENTER', -600, 0)
			panel:BuiStyle('Outside', nil, true, true)
			if BUI.ShadowMode then panel:CreateSoftShadow() end
			panel:SetScript("OnEnter", OnEnter)
			panel:SetScript("OnLeave", OnLeave)

			local moverName = name .. "_Mover"
			E:CreateMover(_G[name], moverName, name, nil, nil, nil, "ALL,MISC,BENIKUI", nil, 'benikui,panels')
			panel.moverName = moverName
			panel.Name = name

			local title = CreateFrame("Frame", nil, panel)
			title:SetTemplate('Transparent', false, true)
			title:Point('TOPLEFT', panel, 'TOPLEFT', 0, (E.PixelMode and 0 or 2))
			title:Point('BOTTOMRIGHT', panel, 'TOPRIGHT', 0, (E.PixelMode and -15 or -14))
			panel.title = title

			local titleText = title:CreateFontString(nil, 'OVERLAY')
			titleText:FontTemplate(nil, 14)
			titleText:SetText("Title")
			titleText:Point("CENTER")
			titleText:SetTextColor(1, 1, 0, 0.7)
			panel.titleText = titleText

			local tex = title:CreateTexture(nil, "BACKGROUND")
			tex:SetBlendMode("ADD")
			tex:SetAllPoints()
			tex:SetTexture(E.Media.Textures.White8x8)
			panel.tex = tex
		end
	end
end

-- ============================================================================
-- Resize
-- Resizes panels according to stored dimensions.
-- ============================================================================
function mod:Resize()
	if not E.db.benikui.panels then E.db.benikui.panels = {} end
	for name in pairs(E.db.benikui.panels) do
		if name and _G[name] then
			local data = E.db.benikui.panels[name]
			if data.width and data.height then
				_G[name]:Size(data.width, data.height)
			end
		end
	end
end

-- ============================================================================
-- UpdatePanelTitle
-- Updates the panel title text, position, and style.
-- ============================================================================
function mod:UpdatePanelTitle()
	for panel in pairs(E.db.benikui.panels) do
		if panel then
			local tData = E.db.benikui.panels[panel].title
			_G[panel].title:SetShown(tData.enable)
			_G[panel].titleText:SetText(tData.text or 'Title')
			_G[panel].titleText:ClearAllPoints()
			_G[panel].titleText:Point(tData.textPosition or "CENTER", tData.textXoffset or 0, tData.textYoffset or 0)
			_G[panel].title:ClearAllPoints()
			if tData.position == 'TOP' then
				_G[panel].title:Point('TOPLEFT', _G[panel], 'TOPLEFT', 0, (E.PixelMode and 0 or 2))
				_G[panel].title:Point('BOTTOMRIGHT', _G[panel], 'TOPRIGHT', 0, -(tData.height) or (E.PixelMode and -15 or -14))
			else
				_G[panel].title:Point('BOTTOMLEFT', _G[panel], 'BOTTOMLEFT', 0, (E.PixelMode and 0 or 2))
				_G[panel].title:Point('TOPRIGHT', _G[panel], 'BOTTOMRIGHT', 0, (tData.height) or (E.PixelMode and -15 or -14))
			end
			_G[panel].tex:SetTexture(LSM:Fetch('statusbar', tData.panelTexture))
			_G[panel].tex:SetVertexColor(BUI:unpackColor(tData.panelColor))
			if tData.useDTfont then
				_G[panel].titleText:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
			else
				_G[panel].titleText:FontTemplate(LSM:Fetch('font', tData.font), tData.fontsize, tData.fontflags)
			end
			_G[panel].titleText:SetTextColor(BUI:unpackColor(tData.fontColor))
		end
	end
end

-- ============================================================================
-- SetupPanels
-- Applies settings to each panel.
-- ============================================================================
function mod:SetupPanels()
	for panel in pairs(E.db.benikui.panels) do
		if panel then
			local data = E.db.benikui.panels[panel]
			local visibility = data.visibility and data.visibility:gsub('[\n\r]', '') or ""
			_G[panel]:EnableMouse(not data.clickThrough)
			if data.enable then
				_G[panel]:Show()
				E:EnableMover(_G[panel].moverName)
				RegisterStateDriver(_G[panel], "visibility", visibility)
			else
				_G[panel]:Hide()
				E:DisableMover(_G[panel].moverName)
				UnregisterStateDriver(_G[panel], "visibility")
			end

			_G[panel]:SetFrameStrata(data.strata or 'LOW')

			-- Apply display mode.
			if data.opaque then
				_G[panel]:SetTemplate("Default", true)
			elseif data.transparent then
				_G[panel]:SetTemplate("Transparent")
			elseif data.custom then
				_G[panel]:SetBackdropColor(_r, _g, _b, data.alpha or _a)
			else
				_G[panel]:SetTemplate("Default", true)
			end

			if BUI.ShadowMode then
				_G[panel].shadow:SetShown(data.shadow)
				_G[panel].style.styleShadow:SetShown(data.shadow)
			end

			if _G[panel].style then
				local r, g, b
				_G[panel].style:SetShown(data.style)
				if data.stylePosition == 'BOTTOM' then
					_G[panel].style:ClearAllPoints()
					if BUI.ShadowMode then _G[panel].style.styleShadow:Hide() end
					_G[panel].style:Point('TOPRIGHT', _G[panel], 'BOTTOMRIGHT', 0, (E.PixelMode and 5 or 7))
					_G[panel].style:Point('BOTTOMLEFT', _G[panel], 'BOTTOMLEFT', 0, (E.PixelMode and 0 or 1))
				else
					_G[panel].style:ClearAllPoints()
					if BUI.ShadowMode and data.shadow then _G[panel].style.styleShadow:Show() end
					_G[panel].style:Point('TOPLEFT', _G[panel], 'TOPLEFT', 0, (E.PixelMode and 4 or 7))
					_G[panel].style:Point('BOTTOMRIGHT', _G[panel], 'TOPRIGHT', 0, (E.PixelMode and -1 or 1))
				end
				if data.styleColor == 1 then
					r, g, b = classColor.r, classColor.g, classColor.b
				elseif data.styleColor == 2 then
					r, g, b = BUI:unpackColor(data.customStyleColor)
				elseif data.styleColor == 3 then
					r, g, b = BUI:unpackColor(E.db.general.valuecolor)
				else
					r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
				end
				_G[panel].style:SetBackdropColor(r, g, b, E.db.benikui.colors.styleAlpha or 1)
			end
		end
	end
end

-- ============================================================================
-- EmptyPanel: Clears a panel's scripts and state.
-- ============================================================================
function mod:EmptyPanel(panel)
	panel:Hide()
	panel:UnregisterAllEvents()
	panel:SetScript('OnEvent', nil)
	panel:SetScript('OnEnter', nil)
	panel:SetScript('OnLeave', nil)
	UnregisterStateDriver(panel, 'visibility')
	E:DisableMover(panel.moverName)
end

-- ============================================================================
-- DeletePanel: Removes a panel.
-- ============================================================================
function mod:DeletePanel(givenPanel)
	if givenPanel then
		local panel = _G[givenPanel]
		mod:EmptyPanel(panel)
		E.db.movers[panel.moverName] = nil
		E.db.benikui.panels[givenPanel] = nil
	end
end

-- ============================================================================
-- ClonePanel: Clones an existing panel.
-- ============================================================================
function mod:ClonePanel(from, to)
	if from == "" or to == "" then return end
	local db = E.db.benikui.panels
	if not db[to] then
		db[to] = db[from]
		mod:UpdatePanels()
	else
		E:StaticPopup_Show("BUI_Panel_Name")
	end
end

-- ============================================================================
-- OnEvent: Handles events (combat, vehicle, pet battle, etc.)
-- ============================================================================
function mod:OnEvent(event, unit)
	if unit and unit ~= "player" then return end
	local inCombat = (event == "PLAYER_REGEN_DISABLED") or InCombatLockdown()
	local inVehicle = (event == "UNIT_ENTERING_VEHICLE") or UnitInVehicle("player")
	for name in pairs(E.db.benikui.panels) do
		if name then
			local data = E.db.benikui.panels[name]
			if (not data.enable) or (inCombat and data.combatHide) or (inVehicle and data.vehicleHide) then
				_G[name]:Hide()
			else
				_G[name]:Show()
			end
			if event == "PET_BATTLE_CLOSE" then
				_G[name]:SetFrameStrata(data.strata or 'LOW')
			end
		end
	end
end

-- ============================================================================
-- RegisterHide: Sets up frame locks based on pet battle hide settings.
-- ============================================================================
function mod:RegisterHide()
	for name in pairs(E.db.benikui.panels) do
		if name then
			local data = E.db.benikui.panels[name]
			if data.petHide then
				E.FrameLocks[name] = { parent = E.UIParent }
			else
				E.FrameLocks[name] = nil
			end
		end
	end
end

-- ============================================================================
-- UpdatePanels: Rebuilds and applies all panel settings.
-- ============================================================================
function mod:UpdatePanels()
	InsertNewDefaults()
	mod:CreatePanel()
	mod:SetupPanels()
	mod:Resize()
	mod:RegisterHide()
	mod:UpdatePanelTitle()
end

-- ============================================================================
-- Initialize: Called on module load.
-- ============================================================================
function mod:Initialize()
	mod:UpdatePanels()
	mod:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
	mod:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
	mod:RegisterEvent("UNIT_ENTERING_VEHICLE", "OnEvent")
	mod:RegisterEvent("UNIT_EXITING_VEHICLE", "OnEvent")
	mod:RegisterEvent("PET_BATTLE_CLOSE", "OnEvent")
end

BUI:RegisterModule(mod:GetName())