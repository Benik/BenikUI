local E, L, V, P, G = unpack(ElvUI);
local BDB = E:GetModule('BenikUI_databars');
local BUI = E:GetModule('BenikUI');
local M = E:GetModule('DataBars');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');

local _G = _G
local floor = floor
local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local InCombatLockdown = InCombatLockdown
local ARTIFACT_POWER = ARTIFACT_POWER
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_AzeriteBar, ArtifactFrame

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function onEnter(self)
	if self.template == 'NoBackdrop' then return end
	self.sglow:Show()
	GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(ARTIFACT_POWER, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local bar = ElvUI_AzeriteBar

	-- bottom decor/button
	bar.fb = CreateFrame('Button', nil, bar)
	bar.fb:CreateSoftGlow()
	bar.fb.sglow:Hide()
	if BUI.ShadowMode then
		bar.fb:CreateSoftShadow()
	end
	bar.fb:Point('TOPLEFT', bar, 'BOTTOMLEFT', 0, -SPACING)
	bar.fb:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))
	bar.fb:SetScript('OnEnter', onEnter)
	bar.fb:SetScript('OnLeave', onLeave)

	bar.fb:SetScript('OnClick', function(self)

	end)

	BDB:ToggleAFBackdrop()

	if E.db.benikui.general.benikuiStyle ~= true then return end
	bar:Style('Outside', nil, false, true)
end

function BDB:ApplyAfStyling()
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

function BDB:ChangeAzeriteColor()
	local bar = ElvUI_AzeriteBar
	local db = E.db.benikuiDatabars.azerite.color

	if db.default then
		bar.statusBar:SetStatusBarColor(.901, .8, .601, .8)
	else
		bar.statusBar:SetStatusBarColor(BUI:unpackColor(db.af))
	end
end

function BDB:ToggleAFBackdrop()
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

function BDB:UpdateAzeriteNotifierPositions()
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

function BDB:UpdateAzeriteNotifier()
	local bar = ElvUI_AzeriteBar.statusBar
	local db = E.db.benikuiDatabars.azerite.notifiers
	local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()
	if not azeriteItemLocation then
		bar.f:Hide()
	else
		bar.f:Show()

		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)
		local xpToNextLevel = totalLevelXP - xp

		bar.f.txt:SetFormattedText('%s%%', floor(xp / totalLevelXP * 100))

		BDB.UpdateAzeriteNotifierPositions()
	end
end

function BDB:AzeriteTextOffset()
	local text = ElvUI_AzeriteBar.text
	text:Point('CENTER', 0, E.db.databars.azerite.textYoffset or 0)
end

function BDB:LoadAzerite()
	local bar = ElvUI_AzeriteBar
	self:ChangeAzeriteColor()
	self:AzeriteTextOffset()
	hooksecurefunc(M, 'UpdateAzerite', BDB.ChangeAzeriteColor)
	hooksecurefunc(M, 'UpdateAzerite', BDB.AzeriteTextOffset)

	local db = E.db.benikuiDatabars.azerite.notifiers

	if db.enable and E.db.databars.azerite.orientation == 'VERTICAL' then
		self:CreateNotifier(bar.statusBar)
		self:UpdateAzeriteNotifierPositions()
		self:UpdateAzeriteNotifier()
		hooksecurefunc(M, 'UpdateAzerite', BDB.UpdateAzeriteNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BDB.UpdateAzeriteNotifierPositions)
		hooksecurefunc(M, 'UpdateAzeriteDimensions', BDB.UpdateAzeriteNotifierPositions)
	end

	if BUI.ShadowMode then
		if not bar.style then
			bar:CreateSoftShadow()
		end
	end

	if E.db.benikuiDatabars.azerite.enable ~= true then return end

	StyleBar()
	self:ApplyAfStyling()

	hooksecurefunc(M, 'UpdateAzeriteDimensions', BDB.ApplyAfStyling)
end