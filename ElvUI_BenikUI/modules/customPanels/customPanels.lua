local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('CustomPanels')
local LSM = E.Libs.LSM

local _G = _G
local pairs = pairs
local tcopy = table.copy

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local ReloadUI = ReloadUI
local UnitInVehicle = UnitInVehicle
local UnregisterStateDriver = UnregisterStateDriver

local classColor = E:ClassColor(E.myclass, true)

local PanelDefault = {
	['enable'] = true,
	['width'] = 200,
	['height'] = 200,
	['point'] = "CENTER",
	['transparency'] = true,
	['style'] = false,
	['stylePosition'] = 'TOP',
	['shadow'] = true,
	['clickThrough'] = false,
	['strata'] = "LOW",
	['combatHide'] = true,
	['petHide'] = true,
	['vehicleHide'] = true,
	['tooltip'] = true,
	['visibility'] = "",
	['styleColor'] = 1,
	['customStyleColor'] = {r = .9, g = .7, b = 0},
	['title'] = {
		['enable'] = true,
		['text'] = 'Title',
		['height'] = 26,
		['position'] = 'TOP',
		['textPosition'] = 'CENTER',
		['textXoffset'] = 0,
		['textYoffset'] = 0,
		['panelTexture'] = "BuiMelli",
		['panelColor'] = {r = .9, g = .7, b = 0, a = .7},
		['useDTfont'] = true,
		['font'] = E.db.datatexts.font,
		['fontsize'] = E.db.datatexts.fontSize,
		['fontflags'] = E.db.datatexts.fontOutline,
		['fontColor'] = {r = .9, g = .9, b = .9},
	}
}

local function InsertNewDefaults()
	for name in pairs(E.db.benikui.panels) do
		if name then
			if E.db.benikui.panels[name].styleColor == nil then E.db.benikui.panels[name].styleColor = 1 end
			if E.db.benikui.panels[name].customStyleColor == nil then E.db.benikui.panels[name].customStyleColor = {r = .9, g = .7, b = 0} end

			if E.db.benikui.panels[name].title == nil then
				E.db.benikui.panels[name].title = {	
					['enable'] = true,
					['text'] = 'Title',
					['height'] = 26,
					['position'] = 'TOP',
					['textPosition'] = 'CENTER',
					['textXoffset'] = 0,
					['textYoffset'] = 0,
					['panelTexture'] = "BuiMelli",
					['panelColor'] = {r = .9, g = .7, b = 0, a = .7},
					['useDTfont'] = true,
					['font'] = E.db.datatexts.font,
					['fontsize'] = E.db.datatexts.fontSize,
					['fontflags'] = E.db.datatexts.fontOutline,
					['fontColor'] = {r = .9, g = .9, b = .9},
				}
			end
		end
	end
end

local function OnEnter(self)
	if E.db.benikui.panels[self.Name].tooltip then
		_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		_G.GameTooltip:AddLine(self.Name, 0.7, 0.7, 1)
		_G.GameTooltip:Show()
	end
end

local function OnLeave(self)
	if E.db.benikui.panels[self.Name].tooltip then
		_G.GameTooltip:Hide()
	end
end

function mod:InsertPanel(name)
	if name == "" then return end

	name = "BenikUI_"..name
	local db = E.db.benikui.panels
	if not db[name] then
		db[name] = PanelDefault
	else
		E:StaticPopup_Show("BUI_Panel_Name")
	end
end

function mod:CreatePanel()
	if not E.db.benikui.panels then E.db.benikui.panels = {} end

	for name in pairs(E.db.benikui.panels) do
		if name and not _G[name] then
			local panel = CreateFrame("Frame", name, E.UIParent, 'BackdropTemplate')
			panel:Width(name.width or 200)
			panel:Height(name.height or 200)
			panel:SetTemplate('Transparent')
			panel:Point('CENTER', E.UIParent, 'CENTER', -600, 0)
			panel:BuiStyle('Outside', nil, true, true)
			if BUI.ShadowMode then panel:CreateSoftShadow() end
			panel:SetScript("OnEnter", OnEnter)
			panel:SetScript("OnLeave", OnLeave)

			local moverName = name.."_Mover"
			E:CreateMover(_G[name], moverName, name, nil, nil, nil, "ALL,MISC,BENIKUI", nil, 'benikui,panels')

			panel.moverName = moverName
			panel.Name = name
			
			local title = CreateFrame("Frame", nil, panel, 'BackdropTemplate')
			title:SetTemplate('Transparent', false, true)
			title:Point('TOPLEFT', panel, 'TOPLEFT', 0, (E.PixelMode and 0 or 2))
			title:Point('BOTTOMRIGHT', panel, 'TOPRIGHT', 0, (E.PixelMode and -15 or -14))
			panel.title = title

			local titleText = title:CreateFontString(nil, 'OVERLAY')
			titleText:FontTemplate(nil, 14)
			titleText:SetText("Title")
			titleText:Point("CENTER")
			titleText:SetTextColor(1, 1, 0, .7)
			panel.titleText = titleText
			
			local tex = title:CreateTexture(nil, "BACKGROUND")
			tex:SetBlendMode("ADD")
			tex:SetAllPoints()
			tex:SetTexture(E.Media.Textures.White8x8)
			panel.tex = tex
		end
	end
end

function mod:Resize()
	if not E.db.benikui.panels then E.db.benikui.panels = {} end

	for name in pairs(E.db.benikui.panels) do
		if name and _G[name] then
			local db = E.db.benikui.panels[name]
			if not db.width and not db.height then return end
			_G[name]:Size(db.width, db.height)
		end
	end
end

function mod:UpdatePanelTitle()
	for panel in pairs(E.db.benikui.panels) do
		if panel then
			local db = E.db.benikui.panels[panel].title

			-- Toggle
			_G[panel].title:SetShown(db.enable)

			-- Set Text
			_G[panel].titleText:SetText(db.text or 'Title')

			-- Text Position
			_G[panel].titleText:ClearAllPoints()
			_G[panel].titleText:Point(db.textPosition or "CENTER", db.textXoffset or 0, db.textYoffset or 0)

			-- Title bar position
			_G[panel].title:ClearAllPoints()
			if db.position == 'TOP' then
				_G[panel].title:Point('TOPLEFT', _G[panel], 'TOPLEFT', 0, (E.PixelMode and 0 or 2))
				_G[panel].title:Point('BOTTOMRIGHT', _G[panel], 'TOPRIGHT', 0, -(db.height) or (E.PixelMode and -15 or -14))
			else
				_G[panel].title:Point('BOTTOMLEFT', _G[panel], 'BOTTOMLEFT', 0, (E.PixelMode and 0 or 2))
				_G[panel].title:Point('TOPRIGHT', _G[panel], 'BOTTOMRIGHT', 0, (db.height) or (E.PixelMode and -15 or -14))
			end

			-- Texture
			_G[panel].tex:SetTexture(LSM:Fetch('statusbar', db.panelTexture))
			_G[panel].tex:SetVertexColor(BUI:unpackColor(db.panelColor))
			
			-- Fonts
			if db.useDTfont then
				_G[panel].titleText:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
			else
				_G[panel].titleText:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
			end
			
			_G[panel].titleText:SetTextColor(BUI:unpackColor(db.fontColor))
		end
	end
end

function mod:SetupPanels()
	for panel in pairs(E.db.benikui.panels) do
		if panel then
			local db = E.db.benikui.panels[panel]

			local visibility = db.visibility
			if visibility and visibility:match('[\n\r]') then
				visibility = visibility:gsub('[\n\r]','')
			end

			_G[panel]:EnableMouse(not db.clickThrough)

			if db.enable then
				_G[panel]:Show()
				E:EnableMover(_G[panel].moverName)
				RegisterStateDriver(_G[panel], "visibility", visibility)
			else
				_G[panel]:Hide()
				E:DisableMover(_G[panel].moverName)
				UnregisterStateDriver(_G[panel], "visibility")
			end

			_G[panel]:SetFrameStrata(db.strata or 'LOW')
			if db.transparency then
				_G[panel]:SetTemplate("Transparent")
			else
				_G[panel]:SetTemplate("Default", true)
			end

			if BUI.ShadowMode then
				_G[panel].shadow:SetShown(db.shadow)
				_G[panel].style.styleShadow:SetShown(db.shadow)
			end

			if _G[panel].style then
				local r, g, b
				_G[panel].style:SetShown(db.style)

				if db.stylePosition == 'BOTTOM' then
					_G[panel].style:ClearAllPoints()
					if BUI.ShadowMode then _G[panel].style.styleShadow:Hide() end
					_G[panel].style:Point('TOPRIGHT', _G[panel], 'BOTTOMRIGHT', 0, (E.PixelMode and 5 or 7))
					_G[panel].style:Point('BOTTOMLEFT', _G[panel], 'BOTTOMLEFT', 0, (E.PixelMode and 0 or 1))
				else
					_G[panel].style:ClearAllPoints()
					if BUI.ShadowMode and db.shadow then _G[panel].style.styleShadow:Show() end
					_G[panel].style:Point('TOPLEFT', _G[panel], 'TOPLEFT', 0, (E.PixelMode and 4 or 7))
					_G[panel].style:Point('BOTTOMRIGHT', _G[panel], 'TOPRIGHT', 0, (E.PixelMode and -1 or 1))
				end

				if db.styleColor == 1 then
					r, g, b = classColor.r, classColor.g, classColor.b
				elseif db.styleColor == 2 then
					r, g, b = BUI:unpackColor(db.customStyleColor)
				elseif db.styleColor == 3 then
					r, g, b = BUI:unpackColor(E.db.general.valuecolor)
				elseif db.styleColor == 5 then
					r, g, b = BUI:getCovenantColor()
				else
					r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
				end
				_G[panel].style:SetBackdropColor(r, g, b, E.db.benikui.colors.styleAlpha or 1)
			end
		end
	end
end

function mod:EmptyPanel(panel)
	panel:Hide()
	panel:UnregisterAllEvents()
	panel:SetScript('OnEvent', nil)
	panel:SetScript('OnEnter', nil)
	panel:SetScript('OnLeave', nil)

	UnregisterStateDriver(panel, 'visibility')
	E:DisableMover(panel.moverName)
end

function mod:DeletePanel(givenPanel)
	if givenPanel then
		local panel = _G[givenPanel]
		mod:EmptyPanel(panel)
		E.db.movers[panel.moverName] = nil
		E.db.benikui.panels[givenPanel] = nil
	end
end

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

function mod:OnEvent(event, unit)
	if unit and unit ~= "player" then return end

	local inCombat = (event == "PLAYER_REGEN_DISABLED" and true) or (event == "PLAYER_REGEN_ENABLED" and false) or InCombatLockdown()
	local inVehicle = (event == "UNIT_ENTERING_VEHICLE" and true) or (event == "UNIT_EXITING_VEHICLE" and false) or UnitInVehicle("player")
	for name in pairs(E.db.benikui.panels) do
		if name then
			local db = E.db.benikui.panels[name]
			if (db.enable ~= true) or (inCombat and db.combatHide) or (inVehicle and db.vehicleHide) then
				_G[name]:Hide()
			else
				_G[name]:Show()
			end
			if event == "PET_BATTLE_CLOSE" then
				_G[name]:SetFrameStrata(db.strata or 'LOW')
			end
		end
	end
end

function mod:RegisterHide()
	for name in pairs(E.db.benikui.panels) do
		if name then
			local db = E.db.benikui.panels[name]
			if db.petHide then
				E.FrameLocks[name] = { parent = E.UIParent }
			else
				E.FrameLocks[name] = nil
			end
		end
	end
end

function mod:UpdatePanels()
	InsertNewDefaults()
	mod:CreatePanel()
	mod:SetupPanels()
	mod:Resize()
	mod:RegisterHide()
	mod:UpdatePanelTitle()
end

function mod:Initialize()
	mod:UpdatePanels()
	mod:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
	mod:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
	mod:RegisterEvent("UNIT_ENTERING_VEHICLE", "OnEvent")
	mod:RegisterEvent("UNIT_EXITING_VEHICLE", "OnEvent")
	mod:RegisterEvent("PET_BATTLE_CLOSE", "OnEvent")
end

BUI:RegisterModule(mod:GetName())
