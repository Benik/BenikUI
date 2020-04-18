local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local tinsert, twipe, getn, pairs, ipairs = table.insert, table.wipe, getn, pairs, ipairs
local _G = _G
-- GLOBALS: hooksecurefunc

local CreateFrame = CreateFrame

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local boards = {"FPS", "MS", "Durability", "Bags", "Volume"}

function mod:UpdateSystem()
	local db = E.db.dashboards.system
	local holder = _G.BUI_SystemDashboard

	if(BUI.SystemDB[1]) then
		for i = 1, getn(BUI.SystemDB) do
			BUI.SystemDB[i]:Kill()
		end
		twipe(BUI.SystemDB)
		holder:Hide()
	end

	for _, name in pairs(boards) do
		if db.chooseSystem[name] == true then
			holder:Show()
			holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.SystemDB + 1)) + DASH_SPACING)

			local sysFrame = CreateFrame('Frame', 'BUI_'..name, holder)
			sysFrame:Height(DASH_HEIGHT)
			sysFrame:Width(E.db.dashboards.system.width or 150)
			sysFrame:Point('TOPLEFT', holder, 'TOPLEFT', SPACING, -SPACING)
			sysFrame:EnableMouse(true)

			sysFrame.dummy = CreateFrame('Frame', nil, sysFrame)
			sysFrame.dummy:Point('BOTTOMLEFT', sysFrame, 'BOTTOMLEFT', 2, 2)
			sysFrame.dummy:Point('BOTTOMRIGHT', sysFrame, 'BOTTOMRIGHT', (E.PixelMode and -4 or -8), 0)
			sysFrame.dummy:Height(E.PixelMode and 3 or 5)

			sysFrame.dummy.dummyStatus = sysFrame.dummy:CreateTexture(nil, 'OVERLAY')
			sysFrame.dummy.dummyStatus:SetInside()
			sysFrame.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
			sysFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

			sysFrame.Status = CreateFrame('StatusBar', nil, sysFrame.dummy)
			sysFrame.Status:SetStatusBarTexture(E['media'].BuiFlat)
			sysFrame.Status:SetMinMaxValues(0, 100)
			sysFrame.Status:SetInside()

			sysFrame.spark = sysFrame.Status:CreateTexture(nil, 'OVERLAY', nil);
			sysFrame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
			sysFrame.spark:SetSize(12, 6);
			sysFrame.spark:SetBlendMode('ADD');
			sysFrame.spark:SetPoint('CENTER', sysFrame.Status:GetStatusBarTexture(), 'RIGHT')

			sysFrame.Text = sysFrame.Status:CreateFontString(nil, 'OVERLAY')
			sysFrame.Text:Point('LEFT', sysFrame, 'LEFT', 6, (E.PixelMode and 2 or 3))
			sysFrame.Text:SetJustifyH('LEFT')

			tinsert(BUI.SystemDB, sysFrame)
		end
	end

	for key, frame in ipairs(BUI.SystemDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( 'TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:Point('TOP', BUI.SystemDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end
end

function mod:UpdateSystemSettings()
	mod:FontStyle(BUI.SystemDB)
	mod:FontColor(BUI.SystemDB)
	mod:BarColor(BUI.SystemDB)
end

function mod:CreateSystemDashboard()
	self.sysHolder = self:CreateDashboardHolder('BUI_SystemDashboard', 'system')
	self.sysHolder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -8)
	self.sysHolder:Width(E.db.dashboards.system.width or 150)

	mod:UpdateSystem()
	mod:UpdateHolderDimensions(self.sysHolder, 'system', BUI.SystemDB)
	mod:ToggleStyle(self.sysHolder, 'system')
	mod:ToggleTransparency(self.sysHolder, 'system')

	E:CreateMover(_G.BUI_SystemDashboard, 'BuiDashboardMover', L['System'], nil, nil, nil, 'ALL,BENIKUI')
end

function mod:LoadSystem()
	if E.db.dashboards.system.enableSystem ~= true then return end
	local db = E.db.dashboards.system.chooseSystem

	if (db.FPS ~= true and db.MS ~= true and db.Bags ~= true and db.Durability ~= true and db.Volume ~= true) then return end

	mod:CreateSystemDashboard()
	mod:UpdateSystemSettings()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateSystemSettings)

	if db.FPS then self:CreateFps() end
	if db.MS then self:CreateMs() end
	if db.Bags then self:CreateBags() end
	if db.Durability then self:CreateDurability() end
	if db.Volume then self:CreateVolume() end
end