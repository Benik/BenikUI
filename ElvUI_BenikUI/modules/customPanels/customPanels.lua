--[[
  File: modules/customPanels.lua
  Manages creation, configuration, and lifecycle of custom panels for BenikUI/ElvUI.
]]

local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('CustomPanels')
local LSM = E.Libs.LSM

local _G = _G
local pairs, type = pairs, type
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local UnitInVehicle = UnitInVehicle

local classColor = E:ClassColor(E.myclass, true)
local dR, dG, dB, dA = unpack(E.media.backdropfadecolor)

-- Default config for a new panel
local PanelDefault = {
	enable             = true,
	width              = 200,
	height             = 200,
	point              = "CENTER",
	opaque             = true,
	transparent        = false,
	custom             = false,
	alpha              = 0.7, -- old alpha, used if customBackdropColor isn't set
	customBackdropColor= { r = 0, g = 0, b = 0, a = 0.7 },
	style              = false,
	stylePosition      = 'TOP',
	shadow             = true,
	clickThrough       = false,
	strata             = "LOW",
	combatHide         = true,
	petHide            = true,
	vehicleHide        = true,
	tooltip            = true,
	visibility         = "",
	styleColor         = 1,
	customStyleColor   = { r = 0.9, g = 0.7, b = 0 },
	title = {
		enable       = true,
		text         = 'Title',
		height       = 26,
		position     = 'TOP',
		textPosition = 'CENTER',
		textXoffset  = 0,
		textYoffset  = 0,
		panelTexture = "BuiMelli",
		panelColor   = { r = 0.9, g = 0.7, b = 0, a = 0.7 },
		useDTfont    = true,
		font         = E.db.datatexts.font,
		fontsize     = E.db.datatexts.fontSize,
		fontflags    = E.db.datatexts.fontOutline,
		fontColor    = { r = 0.9, g = 0.9, b = 0.9 },
	},
}

local function DeepCopy(orig)
	if type(orig) ~= 'table' then
		return orig
	end
	local copy = {}
	for k, v in pairs(orig) do
		copy[DeepCopy(k)] = DeepCopy(v)
	end
	setmetatable(copy, DeepCopy(getmetatable(orig)))
	return copy
end

local function EnsureDisplayMode(panelData)
	if not (panelData.opaque or panelData.transparent or panelData.custom) then
		panelData.opaque = true
	end
end

-- Adds missing fields, migrates old alpha to customBackdropColor
local function InsertNewDefaults()
	for _, data in pairs(E.db.benikui.panels) do
		if data then
			if data.styleColor == nil then
				data.styleColor = PanelDefault.styleColor
			end
			if data.customStyleColor == nil then
				data.customStyleColor = DeepCopy(PanelDefault.customStyleColor)
			end
			if data.title == nil then
				data.title = DeepCopy(PanelDefault.title)
			end
			if data.customBackdropColor == nil then
				data.customBackdropColor = DeepCopy(PanelDefault.customBackdropColor)
				if data.alpha then
					data.customBackdropColor.a = data.alpha
				end
			end
			EnsureDisplayMode(data)
		end
	end
end

-- Shows panel name when hovered, minus "BenikUI_"
local function OnEnter(self)
	local data = E.db.benikui.panels[self.Name]
	if data and data.tooltip then
		_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		local shortName = self.Name:gsub("^BenikUI_", "")
		_G.GameTooltip:AddLine(shortName, 0.7, 0.7, 1)
		_G.GameTooltip:Show()
	end
end

-- Hides panel tooltip
local function OnLeave(self)
	local data = E.db.benikui.panels[self.Name]
	if data and data.tooltip then
		_G.GameTooltip:Hide()
	end
end

-- Creates a DB entry for a new panel
function mod:InsertPanel(name)
	if name == "" then return end
	name = "BenikUI_" .. name
	if not E.db.benikui.panels[name] then
		E.db.benikui.panels[name] = DeepCopy(PanelDefault)
	else
		E:StaticPopup_Show("BUI_Panel_Name")
	end
end

-- Instantiates frames for each custom panel
function mod:CreatePanel()
	if not E.db.benikui.panels then
		E.db.benikui.panels = {}
	end

	for name, data in pairs(E.db.benikui.panels) do
		if name and not _G[name] then
			local panel = CreateFrame("Frame", name, E.UIParent)
			panel:Size(E:Scale(data.width or 200), E:Scale(data.height or 200))
			panel:SetTemplate('Transparent')
			panel:Point('CENTER', E.UIParent, 'CENTER', -600, 0)
			panel:BuiStyle('Outside', nil, true, true)

			if BUI.ShadowMode then
				panel:CreateSoftShadow()
			end

			panel:SetScript("OnEnter", OnEnter)
			panel:SetScript("OnLeave", OnLeave)
			panel.Name = name

			local moverName = name .. "_Mover"
			E:CreateMover(panel, moverName, name, nil, nil, nil, "ALL,MISC,BENIKUI", nil, 'benikui,panels')
			panel.moverName = moverName

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

-- Adjusts panel dimensions
function mod:Resize()
	if not E.db.benikui.panels then
		E.db.benikui.panels = {}
	end

	for name, data in pairs(E.db.benikui.panels) do
		local panel = _G[name]
		if panel and data.width and data.height then
			panel:Size(E:Scale(data.width), E:Scale(data.height))
		end
	end
end

-- Updates panel title text, position, etc.
function mod:UpdatePanelTitle()
	for panelName, panelData in pairs(E.db.benikui.panels) do
		local panel = _G[panelName]
		if panel then
			local tData = panelData.title
			panel.title:SetShown(tData.enable)
			panel.titleText:SetText(tData.text or 'Title')
			panel.titleText:ClearAllPoints()
			panel.titleText:Point(tData.textPosition or "CENTER", tData.textXoffset or 0, tData.textYoffset or 0)

			panel.title:ClearAllPoints()
			if tData.position == 'TOP' then
				panel.title:Point('TOPLEFT', panel, 'TOPLEFT', 0, (E.PixelMode and 0 or 2))
				panel.title:Point('BOTTOMRIGHT', panel, 'TOPRIGHT', 0, -(tData.height) or -14)
			else
				panel.title:Point('BOTTOMLEFT', panel, 'BOTTOMLEFT', 0, (E.PixelMode and 0 or 2))
				panel.title:Point('TOPRIGHT', panel, 'BOTTOMRIGHT', 0, tData.height or 14)
			end

			panel.tex:SetTexture(LSM:Fetch('statusbar', tData.panelTexture))
			panel.tex:SetVertexColor(BUI:unpackColor(tData.panelColor))

			if tData.useDTfont then
				panel.titleText:FontTemplate(
						LSM:Fetch('font', E.db.datatexts.font),
						E.db.datatexts.fontSize,
						E.db.datatexts.fontOutline
				)
			else
				panel.titleText:FontTemplate(
						LSM:Fetch('font', tData.font),
						tData.fontsize,
						tData.fontflags
				)
			end
			panel.titleText:SetTextColor(BUI:unpackColor(tData.fontColor))
		end
	end
end

-- Applies settings: visibility, templates, shadows, styles
function mod:SetupPanels()
	for panelName, data in pairs(E.db.benikui.panels) do
		local panel = _G[panelName]
		if panel then
			local vis = (data.visibility and data.visibility:gsub('[\n\r]', '')) or ""
			panel:EnableMouse(not data.clickThrough)

			if data.enable then
				panel:Show()
				E:EnableMover(panel.moverName)
				RegisterStateDriver(panel, "visibility", vis)
			else
				panel:Hide()
				E:DisableMover(panel.moverName)
				UnregisterStateDriver(panel, "visibility")
			end

			panel:SetFrameStrata(data.strata or 'LOW')

			if data.opaque then
				panel:SetTemplate("Default", true)
			elseif data.transparent then
				panel:SetTemplate("Transparent")
			elseif data.custom then
				local c = data.customBackdropColor
				panel:SetBackdropColor(c.r, c.g, c.b, c.a or dA)
			else
				panel:SetTemplate("Default", true)
			end

			if BUI.ShadowMode and panel.shadow and panel.style and panel.style.styleShadow then
				panel.shadow:SetShown(data.shadow)
				panel.style.styleShadow:SetShown(data.shadow)
			end

			if panel.style then
				panel.style:SetShown(data.style)
				if data.stylePosition == 'BOTTOM' then
					panel.style:ClearAllPoints()
					if BUI.ShadowMode and panel.style.styleShadow then
						panel.style.styleShadow:Hide()
					end
					panel.style:Point('TOPRIGHT', panel, 'BOTTOMRIGHT', 0, (E.PixelMode and 5 or 7))
					panel.style:Point('BOTTOMLEFT', panel, 'BOTTOMLEFT', 0, 1)
				else
					panel.style:ClearAllPoints()
					if BUI.ShadowMode and data.shadow and panel.style.styleShadow then
						panel.style.styleShadow:Show()
					end
					panel.style:Point('TOPLEFT', panel, 'TOPLEFT', 0, (E.PixelMode and 4 or 7))
					panel.style:Point('BOTTOMRIGHT', panel, 'TOPRIGHT', 0, 1)
				end

				local r, g, b
				if data.styleColor == 1 then
					r, g, b = classColor.r, classColor.g, classColor.b
				elseif data.styleColor == 2 then
					r, g, b = BUI:unpackColor(data.customStyleColor)
				elseif data.styleColor == 3 then
					r, g, b = BUI:unpackColor(E.db.general.valuecolor)
				else
					r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
				end
				panel.style:SetBackdropColor(r, g, b, E.db.benikui.colors.styleAlpha or 1)
			end
		end
	end
end

-- Clears everything from a panel
function mod:EmptyPanel(panel)
	if not panel then return end
	panel:Hide()
	panel:UnregisterAllEvents()
	panel:SetScript('OnEvent', nil)
	panel:SetScript('OnEnter', nil)
	panel:SetScript('OnLeave', nil)
	UnregisterStateDriver(panel, 'visibility')
	E:DisableMover(panel.moverName)
end

-- Removes a panel and its entry
function mod:DeletePanel(givenPanel)
	if givenPanel then
		local panel = _G[givenPanel]
		mod:EmptyPanel(panel)
		E.db.movers[panel.moverName] = nil
		E.db.benikui.panels[givenPanel] = nil
	end
end

-- Duplicates a panel's configuration
function mod:ClonePanel(from, to)
	if from == "" or to == "" then return end
	local db = E.db.benikui.panels
	if not db[to] then
		db[to] = DeepCopy(db[from])
		mod:UpdatePanels()
	else
		E:StaticPopup_Show("BUI_Panel_Name")
	end
end

-- Handles pet-battle, combat, vehicle hide
function mod:OnEvent(event, unit)
	if unit and unit ~= "player" then return end
	local inCombat = (event == "PLAYER_REGEN_DISABLED") or InCombatLockdown()
	local inVehicle = (event == "UNIT_ENTERING_VEHICLE") or UnitInVehicle("player")

	for name, data in pairs(E.db.benikui.panels) do
		local panel = _G[name]
		if panel then
			if (not data.enable)
					or (inCombat and data.combatHide)
					or (inVehicle and data.vehicleHide) then
				panel:Hide()
			else
				panel:Show()
			end
			if event == "PET_BATTLE_CLOSE" then
				panel:SetFrameStrata(data.strata or 'LOW')
			end
		end
	end
end

-- Maintains frame locks if petHide is set
function mod:RegisterHide()
	for name, data in pairs(E.db.benikui.panels) do
		if data.petHide then
			E.FrameLocks[name] = { parent = E.UIParent }
		else
			E.FrameLocks[name] = nil
		end
	end
end

-- Applies all updates: defaults, creation, setup, resizing, etc.
function mod:UpdatePanels()
	InsertNewDefaults()
	mod:CreatePanel()
	mod:SetupPanels()
	mod:Resize()
	mod:RegisterHide()
	mod:UpdatePanelTitle()
end

-- Initializes the module
function mod:Initialize()
	mod:UpdatePanels()
	mod:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
	mod:RegisterEvent("PLAYER_REGEN_ENABLED",  "OnEvent")
	mod:RegisterEvent("UNIT_ENTERING_VEHICLE", "OnEvent")
	mod:RegisterEvent("UNIT_EXITING_VEHICLE",  "OnEvent")
	mod:RegisterEvent("PET_BATTLE_CLOSE",      "OnEvent")
end

BUI:RegisterModule(mod:GetName())
