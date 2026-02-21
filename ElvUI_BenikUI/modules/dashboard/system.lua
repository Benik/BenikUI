local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local _G = _G
local tinsert, twipe, next = table.insert, table.wipe, next
local hooksecurefunc = hooksecurefunc

local CreateFrame = CreateFrame

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1
local systemDB = mod.SystemDB

mod.systemBoards = {}

local function barOnEnter(self)
	local db = E.db.benikui.dashboards.system
	local holder = self:GetParent()

	if db.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function barOnLeave(self)
	local db = E.db.benikui.dashboards.system
	local holder = self:GetParent()

	if db.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

local function holderOnEnter(self)
	local db = E.db.benikui.dashboards.system

	if db.mouseover then
		E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
	end
end

local function holderOnLeave(self)
	local db = E.db.benikui.dashboards.system

	if db.mouseover then
		E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
	end
end

function mod.CommonOnUpdate(self, elapsed) -- this needs a dot
    self.elapsed = self.elapsed + elapsed
    if self.elapsed >= (self.db.updateThrottle or 1) then
        self.elapsed = 0
        self:OnUpdate()
    end
end

function mod:UpdateSystemSettings()
	local db = E.db.benikui.dashboards.system
	local holder = mod.systemHolder

	mod:FontStyle(systemDB)
	mod:FontColor(systemDB)
	mod:BarColor(systemDB)
	mod:BarHeight('system', systemDB)

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end
end

function mod:UpdateSystemTextAlignment()
	local db = E.db.benikui.dashboards.system

	for _, board in next, mod.systemBoards do
		if db.chooseSystem[board.name] == true then
			local bar = _G['BUI_'..board.name]
			if bar then
				bar.Text:ClearAllPoints()
				bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and board.name == "Volume" and -20) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
				bar.Text:SetJustifyH(db.textAlign)
			end
		end
	end
end

function mod:UpdateOrientation()
	local db = E.db.benikui.dashboards.system
	local holder = mod.systemHolder

	if db.orientation == 'BOTTOM' then
		holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#systemDB)) + DASH_SPACING)
		holder:Width(db.width)
	else
		holder:Height(DASH_HEIGHT + (DASH_SPACING))
		holder:Width(db.width * (#systemDB) + ((#systemDB -1) *db.spacing))
	end

	for key, frame in next, systemDB do
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

function mod:CreateSystemBar(name, onEnter, onLeave, onClick)
	local db = E.db.benikui.dashboards.system
	local holder = mod.systemHolder

	local bar = CreateFrame('Frame', 'BUI_'..name, holder)
	bar:Height(DASH_HEIGHT)
	bar:Width(db.width or 150)
	bar:EnableMouse(true)
	bar.db = db

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

	bar.spark = bar.Status:CreateTexture(nil, 'OVERLAY', nil)
	bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.spark:Size(12, ((db.barHeight + 5) or 6))
	bar.spark:SetBlendMode('ADD')
	bar.spark:Point('CENTER', bar.Status:GetStatusBarTexture(), 'RIGHT')

	bar.Text = bar.Status:CreateFontString(nil, 'OVERLAY')
	bar.Text:FontTemplate()
	bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and name == 'Volume' and -20) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
	bar.Text:SetJustifyH(db.textAlign)

	bar:SetScript('OnEnter', onEnter or barOnEnter)
	bar:SetScript('OnLeave', onLeave or barOnLeave)
	if onClick then
		bar:SetScript('OnMouseDown', onClick)
	end

	tinsert(systemDB, bar)

	return bar
end

function mod:CreateSystemDashboard()
	local db = E.db.benikui.dashboards.system
	local holder = mod:CreateDashboardHolder('BUI_SystemDashboard', 'system')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -8)
	holder:Width(db.width or 150)

	mod.systemHolder = holder

	mod:UpdateHolderDimensions(holder, 'system', systemDB)
	mod:ToggleStyle(holder, 'system')
	mod:ToggleTransparency(holder, 'system')
	mod:UpdateOrientation()
	mod:UpdateSystemSettings()

	holder:SetScript('OnEnter', holderOnEnter)
	holder:SetScript('OnLeave', holderOnLeave)

	E:CreateMover(holder, 'BuiDashboardMover', L['System'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,system')
end

function mod:RegisterSystemBoard(name, createFunc)
    self.systemBoards[#self.systemBoards + 1] = {
        name = name,
        create = createFunc,
    }
end

function mod:LoadSystem()
	if E.db.benikui.dashboards.system.enable ~= true then return end

	local db = E.db.benikui.dashboards.system.chooseSystem

	local anyEnabled = false
	for _, board in next, mod.systemBoards do
		if db[board.name] then
			anyEnabled = true
			break
		end
	end
	if not anyEnabled then return end

	mod:CreateSystemDashboard()

	for _, board in next, mod.systemBoards do
		if db[board.name] then
			board.create()
		end
	end

	local holder = mod.systemHolder
	if #systemDB > 0 then
		holder:Show()
	end

	mod:UpdateHolderDimensions(holder, 'system', systemDB)
	mod:ToggleStyle(holder, 'system')
	mod:ToggleTransparency(holder, 'system')
	mod:UpdateOrientation()
	mod:UpdateSystemSettings()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateSystemSettings)
end
