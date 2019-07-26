local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('BuiDatabars');
local DT = E:GetModule('DataTexts');
local M = E:GetModule('DataBars');
local LSM = E.LSM;


local _G = _G

local GetPetExperience = GetPetExperience
local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel
local InCombatLockdown = InCombatLockdown
local IsXPUserDisabled = IsXPUserDisabled
local UnitLevel = UnitLevel
local UnitXP, UnitXPMax = UnitXP, UnitXPMax

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ExperienceBar, SpellBookFrame

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end
end

function mod:ApplyXpStyling()
	local xp = ElvUI_ExperienceBar
	if E.db.databars.experience.enable then
		if xp.fb then
			if E.db.databars.experience.orientation == 'VERTICAL' then
				if E.db.benikui.datatexts.chat.enable then
					xp.fb:Show()
				else
					xp.fb:Hide()
				end
			else
				xp.fb:Hide()
			end
		end
	end

	if E.db.benikuiDatabars.experience.buiStyle then
		if xp.style then
			xp.style:Show()
		end
	else
		if xp.style then
			xp.style:Hide()
		end
	end
end

function mod:ToggleXPBackdrop()
	if E.db.benikuiDatabars.experience.enable ~= true then return end
	local bar = ElvUI_ExperienceBar
	local db = E.db.benikuiDatabars.experience

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

function mod:UpdateXpNotifierPositions()
	local bar = ElvUI_ExperienceBar.statusBar

	local db = E.db.benikuiDatabars.experience.notifiers
	local arrow = ""

	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.experience.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.experience.reverseFill then
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

	if E.db.databars.experience.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function mod:GetXP(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

function mod:UpdateXpNotifier()
	local bar = ElvUI_ExperienceBar.statusBar

	if E.db.databars.experience.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		local cur, max = mod:GetXP('player')
		if max == 0 then max = 1 end
		bar.f.txt:SetFormattedText('%d%%', cur / max * 100)
	end
end

function mod:XpTextOffset()
	local text = ElvUI_ExperienceBar.text
	text:Point('CENTER', 0, E.db.databars.experience.textYoffset or 0)
end

function mod:LoadXP()
	local bar = ElvUI_ExperienceBar

	self:XpTextOffset()
	hooksecurefunc(M, 'UpdateExperience', mod.XpTextOffset)

	local db = E.db.benikuiDatabars.experience.notifiers

	if db.enable then
		self:CreateNotifier(bar.statusBar)
		self:UpdateXpNotifierPositions()
		self:UpdateXpNotifier()
		hooksecurefunc(M, 'UpdateExperience', mod.UpdateXpNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateXpNotifierPositions)
		hooksecurefunc(M, 'UpdateExperienceDimensions', mod.UpdateXpNotifierPositions)
		hooksecurefunc(M, 'UpdateExperienceDimensions', mod.UpdateXpNotifier)
	end

	if E.db.benikuiDatabars.experience.enable ~= true then return end

	self:StyleBar(bar, OnClick)
	self:ToggleXPBackdrop()
	self:ApplyXpStyling()

	hooksecurefunc(M, 'UpdateExperienceDimensions', mod.ApplyXpStyling)
end