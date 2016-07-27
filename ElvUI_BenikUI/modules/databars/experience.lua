local E, L, V, P, G = unpack(ElvUI);
local BDB = E:GetModule('BenikUI_databars');
local BUI = E:GetModule('BenikUI');
local M = E:GetModule('DataBars');
local LO = E:GetModule('Layout');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');
local BUIL = E:GetModule('BuiLayout');

local _G = _G

local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local GetPetExperience = GetPetExperience
local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel
local InCombatLockdown = InCombatLockdown
local IsXPUserDisabled = IsXPUserDisabled
local UnitLevel = UnitLevel
local UnitXP, UnitXPMax = UnitXP, UnitXPMax
local ToggleCharacter = ToggleCharacter

local SPELLBOOK_ABILITIES_BUTTON, MAX_PLAYER_LEVEL_TABLE = SPELLBOOK_ABILITIES_BUTTON, MAX_PLAYER_LEVEL_TABLE

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ReputationBar, ElvUI_ExperienceBar, SpellBookFrame

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function ToggleBackdrop()
	if E.db.benikuiDatabars.enable then
		if not E.db.benikui.datatexts.chat.backdrop then
			if ElvUI_ExperienceBar.fb then
				ElvUI_ExperienceBar.fb:SetTemplate('NoBackdrop')
			end
		else
			if E.db.benikui.datatexts.chat.transparent then
				if ElvUI_ExperienceBar.fb then
					ElvUI_ExperienceBar.fb:SetTemplate('Transparent')
				end
			else
				if ElvUI_ExperienceBar.fb then
					ElvUI_ExperienceBar.fb:SetTemplate('Default', true)
				end
			end
		end
	end
end

local function StyleBar()
	local xp = ElvUI_ExperienceBar
	
	-- bottom decor/button
	xp.fb = CreateFrame('Button', nil, xp)
	xp.fb:CreateSoftGlow()
	xp.fb.sglow:Hide()
	xp.fb:Point('TOPLEFT', xp, 'BOTTOMLEFT', 0, -SPACING)
	xp.fb:Point('BOTTOMRIGHT', xp, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))
	xp.fb:SetScript('OnEnter', function(self)
		self.sglow:Show()
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(SPELLBOOK_ABILITIES_BUTTON, selectioncolor)
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)
	
	xp.fb:SetScript('OnLeave', onLeave)
	
	xp.fb:SetScript('OnClick', function(self)
		if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end
	end)
	
	ToggleBackdrop()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end
	xp:Style('Outside')
end

function BDB:ApplyXpStyling()
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
	
	if E.db.benikuiDatabars.buiStyle then
		if xp.style then
			xp.style:Show()
		end
	else
		if xp.style then
			xp.style:Hide()	
		end
	end
end

function BDB:ChangeXPcolor()
	local db = E.db.benikuiDatabars.experience.color
	local elvxpstatus = ElvUI_ExperienceBar.statusBar
	local elvrestedstatus = ElvUI_ExperienceBar.rested
	
	if db.default then
		elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
		elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)
	else
		elvxpstatus:SetStatusBarColor(BUI:unpackColor(db.xp))
		elvrestedstatus:SetStatusBarColor(BUI:unpackColor(db.rested))
	end
end

function BDB:UpdateXpNotifierPositions()
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

function BDB:GetXP(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

function BDB:UpdateXpNotifier()
	local bar = ElvUI_ExperienceBar.statusBar
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()];
	if(UnitLevel('player') == maxLevel) or IsXPUserDisabled() or E.db.databars.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		local cur, max = BDB:GetXP('player')
		bar.f.txt:SetFormattedText('%d%%', cur / max * 100)
	end
end

function BDB:LoadXP()
	self:ChangeXPcolor()
	
	local db = E.db.benikuiDatabars.experience.notifiers
	
	if db.enable and E.db.databars.experience.orientation == 'VERTICAL' then
		self:CreateNotifier(ElvUI_ExperienceBar.statusBar)
		self:UpdateXpNotifierPositions()
		self:UpdateXpNotifier()
		hooksecurefunc(M, 'UpdateExperience', BDB.UpdateXpNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BDB.UpdateXpNotifierPositions)
		hooksecurefunc(M, 'UpdateExperienceDimensions', BDB.UpdateXpNotifierPositions)
	end
	
	if E.db.benikuiDatabars.enable ~= true then return end
	
	StyleBar()
	self:ApplyXpStyling()
	
	hooksecurefunc(BUIL, 'ToggleTransparency', ToggleBackdrop)
	hooksecurefunc(LO, 'ToggleChatPanels', BDB.ApplyXpStyling)
	hooksecurefunc(M, 'UpdateExperienceDimensions', BDB.ApplyXpStyling)
end