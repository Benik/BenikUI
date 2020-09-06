local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');
local LSM = E.LSM;

local _G = _G

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_HonorBar

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	TogglePVPUI()
end

function mod:ApplyHonorStyling()
	local bar = ElvUI_HonorBar
	if E.db.databars.honor.enable then
		if bar.fb then
			if E.db.databars.honor.orientation == 'VERTICAL' then
				bar.fb:Show()
			else
				bar.fb:Hide()
			end
		end
	end

	if E.db.benikuiDatabars.honor.buiStyle then
		if bar.backdrop.style then
			bar.backdrop.style:Show()
		end
	else
		if bar.backdrop.style then
			bar.backdrop.style:Hide()
		end
	end
end

function mod:ToggleHonorBackdrop()
	if E.db.benikuiDatabars.honor.enable ~= true then return end
	local bar = ElvUI_HonorBar
	local db = E.db.benikuiDatabars.honor

	if bar.fb then
		if db.buttonStyle == 'DEFAULT' then
			bar.fb:SetTemplate('Default', true)
			if bar.fb.shadow then
				bar.fb.shadow:Show()
			end
		elseif db.buttonStyle == 'TRANSPARENT' then
			bar.fb:SetTemplate('Transparent')
			if bar.fb.shadow then
				bar.fb.shadow:Show()
			end
		else
			bar.fb:SetTemplate('NoBackdrop')
			if bar.fb.shadow then
				bar.fb.shadow:Hide()
			end
		end
	end
end

function mod:UpdateHonorNotifierPositions()
	local bar = DB.StatusBars.Honor

	local db = E.db.benikuiDatabars.honor.notifiers
	local arrow = ""

	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.honor.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.honor.reverseFill then
			bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'TOPRIGHT', E.PixelMode and 2 or 4, 1)
		else
			bar.f.arrow:Point('LEFT', bar:GetStatusBarTexture(), 'BOTTOMRIGHT', E.PixelMode and 2 or 4, 1)
		end
		bar.f:Point('LEFT', bar.f.arrow, 'RIGHT')
		bar.f.txt:Point('LEFT', bar.f, 'RIGHT')
		arrow = "<"
	end

	bar.f.arrow:SetText(arrow)
	bar.f.txt:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)

	if E.db.databars.honor.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function mod:UpdateHonorNotifier()
	local bar = DB.StatusBars.Honor

	if E.db.databars.honor.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		local text = ''
		local current = UnitHonor("player");
		local max = UnitHonorMax("player");

		if max == 0 then max = 1 end

		text = format('%d%%', current / max * 100)

		bar.f.txt:SetText(text)
	end
end

function mod:HonorTextOffset()
	local text = DB.StatusBars.Honor.text
	text:Point('CENTER', 0, E.db.databars.honor.textYoffset or 0)
end

function mod:LoadHonor()
	local bar = ElvUI_HonorBar

	self:HonorTextOffset()
	hooksecurefunc(DB, 'HonorBar_Update', mod.HonorTextOffset)

	local db = E.db.benikuiDatabars.honor.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateHonorNotifierPositions()
		self:UpdateHonorNotifier()
		hooksecurefunc(DB, 'HonorBar_Update', mod.UpdateHonorNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateHonorNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateHonorNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateHonorNotifier)
	end

	if E.db.benikuiDatabars.honor.enable ~= true then return end

	self:StyleBar(bar, OnClick)
	self:ToggleHonorBackdrop()
	self:ApplyHonorStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyHonorStyling)
end