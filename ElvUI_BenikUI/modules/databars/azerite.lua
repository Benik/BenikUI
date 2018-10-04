local E, L, V, P, G = unpack(ElvUI);
local mod = E:GetModule('BenikUI_databars');
local BUI = E:GetModule('BenikUI');
local M = E:GetModule('DataBars');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');

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
	local bar = ElvUI_AzeriteBar.statusBar

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
	local bar = ElvUI_AzeriteBar.statusBar
	local db = E.db.benikuiDatabars.azerite.notifiers
	local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

	if not azeriteItemLocation or E.db.databars.azerite.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()

		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		local xpToNextLevel = totalLevelXP - xp

		bar.f.txt:SetFormattedText('%s%%', floor(xp / totalLevelXP * 100))

		mod.UpdateAzeriteNotifierPositions()
	end
end

function mod:AzeriteTextOffset()
	local text = ElvUI_AzeriteBar.text
	text:Point('CENTER', 0, E.db.databars.azerite.textYoffset or 0)
end

function mod:LoadAzerite()
	local bar = ElvUI_AzeriteBar

	self:AzeriteTextOffset()
	hooksecurefunc(M, 'UpdateAzerite', mod.AzeriteTextOffset)

	local db = E.db.benikuiDatabars.azerite.notifiers

	if db.enable then
		self:CreateNotifier(bar.statusBar)
		self:UpdateAzeriteNotifierPositions()
		self:UpdateAzeriteNotifier()
		hooksecurefunc(M, 'UpdateAzerite', mod.UpdateAzeriteNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(M, 'UpdateAzeriteDimensions', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(M, 'UpdateAzeriteDimensions', mod.UpdateAzeriteNotifier)
	end

	if E.db.benikuiDatabars.azerite.enable ~= true then return end

	self:StyleBar(bar)
	self:ToggleAzeriteBackdrop()
	self:ApplyAzeriteStyling()

	hooksecurefunc(M, 'UpdateAzeriteDimensions', mod.ApplyAzeriteStyling)
end