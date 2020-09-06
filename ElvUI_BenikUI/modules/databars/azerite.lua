local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DB = E:GetModule('DataBars');
local DT = E:GetModule('DataTexts');
local LSM = E.LSM;

local _G = _G
local floor = floor
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_AzeriteBar

function mod:ApplyAzeriteStyling()
	local bar = ElvUI_AzeriteBar
	if E.db.databars.azerite.enable then
		if bar.fb then
			if E.db.databars.azerite.orientation == 'VERTICAL' then
				bar.fb:Show()
			else
				bar.fb:Hide()
			end
		end
	end

	if E.db.benikuiDatabars.azerite.buiStyle then
		if bar.style then
			bar.style:Show()
		end
	else
		if bar.style then
			bar.style:Hide()
		end
	end
end

function mod:ToggleAzeriteBackdrop()
	if E.db.benikuiDatabars.azerite.enable ~= true then return end
	local bar = ElvUI_AzeriteBar
	local db = E.db.benikuiDatabars.azerite

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

function mod:UpdateAzeriteNotifierPositions()
	local bar = DB.StatusBars.Azerite

	local db = E.db.benikuiDatabars.azerite.notifiers
	local arrow = ""

	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.azerite.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.azerite.reverseFill then
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

	if E.db.databars.azerite.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function mod:UpdateAzeriteNotifier()
	local bar = DB.StatusBars.Azerite
	local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

	if not azeriteItemLocation or E.db.databars.azerite.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()

		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)

		bar.f.txt:SetFormattedText('%s%%', floor(xp / totalLevelXP * 100))

		mod.UpdateAzeriteNotifierPositions()
	end
end

function mod:AzeriteTextOffset()
	local text = DB.StatusBars.Azerite.text
	text:Point('CENTER', 0, E.db.databars.azerite.textYoffset or 0)
end

function mod:LoadAzerite()
	local bar = ElvUI_AzeriteBar

	self:AzeriteTextOffset()
	hooksecurefunc(DB, 'AzeriteBar_Update', mod.AzeriteTextOffset)

	local db = E.db.benikuiDatabars.azerite.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateAzeriteNotifierPositions()
		self:UpdateAzeriteNotifier()
		hooksecurefunc(DB, 'AzeriteBar_Update', mod.UpdateAzeriteNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifier)
	end

	if E.db.benikuiDatabars.azerite.enable ~= true then return end

	self:StyleBar(bar)
	self:ToggleAzeriteBackdrop()
	self:ApplyAzeriteStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyAzeriteStyling)
end