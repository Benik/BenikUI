local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local tinsert, twipe, getn, pairs, ipairs = table.insert, table.wipe, getn, pairs, ipairs
local _G = _G
-- GLOBALS: hooksecurefunc

local CreateFrame = CreateFrame

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1
local systemDB = mod.SystemDB

local boards = {"FPS", "MS", "Durability", "Bags", "Volume"}

function mod:CreateSystem()
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard

	if(systemDB[1]) then
		for i = 1, getn(systemDB) do
			systemDB[i]:Kill()
		end
		twipe(systemDB)
		holder:Hide()
	end

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	for _, name in pairs(boards) do
		if db.chooseSystem[name] == true then
			holder:Show()

			local bar = CreateFrame('Frame', 'BUI_'..name, holder)
			bar:Height(DASH_HEIGHT)
			bar:Width(db.width or 150)
			bar:Point('TOPLEFT', holder, 'TOPLEFT', SPACING, -SPACING)
			bar:EnableMouse(true)

			bar.dummy = CreateFrame('Frame', nil, bar)
			bar.dummy:SetTemplate('Transparent', nil, true, true)
			bar.dummy:SetBackdropBorderColor(0, 0, 0, 0)
			bar.dummy:SetBackdropColor(1, 1, 1, .2)
			bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, 0)
			bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -4 or -8), 0)
			bar.dummy:Height(db.barHeight or (E.PixelMode and 1 or 3))

			bar.Status = CreateFrame('StatusBar', nil, bar.dummy)
			bar.Status:SetStatusBarTexture(E.Media.Textures.White8x8)
			bar.Status:SetMinMaxValues(0, 100)
			bar.Status:SetAllPoints()

			bar.spark = bar.Status:CreateTexture(nil, 'OVERLAY', nil);
			bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
			bar.spark:Size(12, ((db.barHeight + 5) or 6))
			bar.spark:SetBlendMode('ADD')
			bar.spark:Point('CENTER', bar.Status:GetStatusBarTexture(), 'RIGHT')

			bar.Text = bar.Status:CreateFontString(nil, 'OVERLAY')
			bar.Text:FontTemplate()
			bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and name == "Volume" and -20) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
			bar.Text:SetJustifyH(db.textAlign)

			bar:SetScript('OnEnter', function(self)
				if db.mouseover then
					E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
				end
			end)

			bar:SetScript('OnLeave', function(self)
				if db.mouseover then
					E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
				end
			end)

			tinsert(systemDB, bar)
		end
	end
end

function mod:UpdateSystemSettings()
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard

	mod:FontStyle(systemDB)
	mod:FontColor(systemDB)
	mod:BarColor(systemDB)
	mod:BarHeight('system', systemDB)

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end
end

function mod:UpdateSystemTextAlignment()
	local db = E.db.benikui.dashboards.system

	for _, name in pairs(boards) do
		if db.chooseSystem[name] == true then
			local bar = _G['BUI_'..name]
			if bar then
				bar.Text:ClearAllPoints()
				bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and name == "Volume" and -20) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
				bar.Text:SetJustifyH(db.textAlign)
			end
		end
	end
end

function mod:UpdateOrientation()
	local db = E.db.benikui.dashboards.system
	local holder = _G.BUI_SystemDashboard

	if db.orientation == 'BOTTOM' then
		holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#systemDB)) + DASH_SPACING)
		holder:Width(db.width)
	else
		holder:Height(DASH_HEIGHT + (DASH_SPACING))
		holder:Width(db.width * (#systemDB) + ((#systemDB -1) *db.spacing))
	end

	for key, frame in ipairs(systemDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( 'TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			if db.orientation == 'BOTTOM' then
				frame:Point('TOP', systemDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
			else
				frame:Point('LEFT', systemDB[key - 1], 'RIGHT', db.spacing +(E.PixelMode and 0 or 2), 0)
			end
		end
	end
end

function mod:CreateSystemDashboard()
	local db = E.db.benikui.dashboards.system
	local holder = self:CreateDashboardHolder('BUI_SystemDashboard', 'system')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -8)
	holder:Width(db.width or 150)

	mod:UpdateHolderDimensions(holder, 'system', systemDB)
	mod:ToggleStyle(holder, 'system')
	mod:ToggleTransparency(holder, 'system')
	mod:CreateSystem()
	mod:UpdateOrientation()

	holder:SetScript('OnEnter', function()
		if db.mouseover then
			E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
		end
	end)

	holder:SetScript('OnLeave', function()
		if db.mouseover then
			E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
		end
	end)

	E:CreateMover(_G.BUI_SystemDashboard, 'BuiDashboardMover', L['System'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,system')
end

function mod:LoadSystem()
	if E.db.benikui.dashboards.system.enable ~= true then return end
	local db = E.db.benikui.dashboards.system.chooseSystem

	if (db.FPS ~= true and db.MS ~= true and db.Bags ~= true and db.Durability ~= true and db.Volume ~= true) then return end

	mod:CreateSystemDashboard()
	mod:UpdateSystemSettings()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateSystemSettings)

	if db.FPS then mod:CreateFps() end
	if db.MS then mod:CreateMs() end
	if db.Bags then mod:CreateBags() end
	if db.Durability then mod:CreateDurability() end
	if db.Volume then mod:CreateVolume() end
end
