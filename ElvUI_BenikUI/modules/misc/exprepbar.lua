local E, L, V, P, G = unpack(ElvUI);
local BXR = E:NewModule('BUIExpRep', 'AceHook-3.0', 'AceEvent-3.0');
local M = E:GetModule('Misc');
local LO = E:GetModule('Layout');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');
local BUIL = E:GetModule('BuiLayout');

local CreateFrame = CreateFrame
local GetWatchedFactionInfo = GetWatchedFactionInfo
local GetPetExperience = GetPetExperience
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut

-- Style ElvUI default XP/Rep bars
local SPACING = (E.PixelMode and 1 or 3)

local function xprep_OnLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function ToggleXpRepBackdrop()
	if E.db.benikuiXprep.enable then
		if not E.db.benikui.datatexts.chat.backdrop then
			if ElvUI_ReputationBar.fb then
				ElvUI_ReputationBar.fb:StripTextures()
			end
			if ElvUI_ExperienceBar.fb then
				ElvUI_ExperienceBar.fb:StripTextures()
			end
		else
			if E.db.benikui.datatexts.chat.transparent then
				if ElvUI_ReputationBar.fb then
					ElvUI_ReputationBar.fb:SetTemplate('Transparent')
				end
				if ElvUI_ExperienceBar.fb then
					ElvUI_ExperienceBar.fb:SetTemplate('Transparent')
				end
			else
				if ElvUI_ReputationBar.fb then
					ElvUI_ReputationBar.fb:SetTemplate('Default', true)
				end
				if ElvUI_ExperienceBar.fb then
					ElvUI_ExperienceBar.fb:SetTemplate('Default', true)
				end
			end
		end
	end
end

local function StyleXpRepBars()
	-- Xp Bar
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
	
	xp.fb:SetScript('OnLeave', xprep_OnLeave)
	
	xp.fb:SetScript('OnClick', function(self)
		if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end
	end)
	
	-- Rep bar
	local rp = ElvUI_ReputationBar
	
	-- bottom decor/button	
	rp.fb = CreateFrame('Button', nil, rp)
	rp.fb:CreateSoftGlow()
	rp.fb.sglow:Hide()
	rp.fb:Point('TOPLEFT', rp, 'BOTTOMLEFT', 0, -SPACING)
	rp.fb:Point('BOTTOMRIGHT', rp, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))

	rp.fb:SetScript('OnEnter', function(self)
		self.sglow:Show()
		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(BINDING_NAME_TOGGLECHARACTER2, selectioncolor)
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)
	
	rp.fb:SetScript('OnLeave', xprep_OnLeave)

	rp.fb:SetScript('OnClick', function(self)
		ToggleCharacter("ReputationFrame")
	end)
	
	ToggleXpRepBackdrop()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end
	xp:Style('Outside')
	rp:Style('Outside')
end

function BXR:ApplyXpRepStyling()
	local xp = ElvUI_ExperienceBar
	if E.db.general.experience.enable then
		if E.db.general.experience.orientation == 'VERTICAL' then
			if E.db.benikui.datatexts.chat.enable then 
				xp.fb:Show()
			else
				xp.fb:Hide()
			end
		else
			xp.fb:Hide()
		end
	end	
	
	local rp = ElvUI_ReputationBar
	if E.db.general.reputation.enable then
		if E.db.general.reputation.orientation == 'VERTICAL' then
			if rp.ft then
				rp.ft:Show()
			end
			if E.db.benikui.datatexts.chat.enable then
				rp.fb:Show()
			else
				rp.fb:Hide()
			end
		else
			rp.fb:Hide()
		end
	end
	
	if E.db.benikuiXprep.buiStyle then
		if rp.style then
			rp.style:Show()
		end
		if xp.style then
			xp.style:Show()
		end
	else
		if rp.style then
			rp.style:Hide()
		end
		if xp.style then
			xp.style:Hide()	
		end
	end
end

function BXR:ChangeXPcolor()
	local db = E.db.benikuiXprep.color.experience
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

local backupColor = FACTION_BAR_COLORS[1]
function BXR:ChangeRepColor()
	local db = E.db.benikuiXprep.color.reputation
	local _, reaction = GetWatchedFactionInfo()
	local color = FACTION_BAR_COLORS[reaction] or backupColor
	local elvstatus = ElvUI_ReputationBar.statusBar
	
	if db.default then
		elvstatus:SetStatusBarColor(color.r, color.g, color.b)
	else 
		if reaction >= 5 then
			elvstatus:SetStatusBarColor(BUI:unpackColor(db.friendly))
		elseif reaction == 4 then
			elvstatus:SetStatusBarColor(BUI:unpackColor(db.neutral))
		elseif reaction == 3 then
			elvstatus:SetStatusBarColor(BUI:unpackColor(db.unfriendly))
		elseif reaction < 3 then
			elvstatus:SetStatusBarColor(BUI:unpackColor(db.hated))
		end
	end
end

function BXR:CreateNotifier(bar)
	bar.f = CreateFrame('Frame', nil, bar)
	bar.f:Size(2, 10)
	bar.f.txt = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow:SetFont(LSM:Fetch("font", 'Bui Visitor1'), 10, 'MONOCHROMEOUTLINE')
	
	if E.db.benikuiXprep.notifiers.combat then
		bar.f:RegisterEvent("PLAYER_REGEN_DISABLED")
		bar.f:RegisterEvent("PLAYER_REGEN_ENABLED")
		
		bar.f:SetScript("OnEvent",function(self, event)
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self:Hide()
			elseif event == "PLAYER_REGEN_ENABLED" then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end	
		end)
	end
end

function BXR:UpdateRepNotifierPositions()
	local bar = ElvUI_ReputationBar.statusBar
	
	local db = E.db.benikuiXprep.notifiers.reputation
	local arrow = ""
	
	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.general.reputation.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.general.reputation.reverseFill then
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

	if E.db.general.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function BXR:UpdateRepNotifier()
	local bar = ElvUI_ReputationBar.statusBar
	
	local name, _, min, max, value = GetWatchedFactionInfo()
	
	if not name or E.db.general.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		bar.f.txt:SetFormattedText('%d%%', ((value - min) / (max - min) * 100))
	end
end

function BXR:UpdateXpNotifierPositions()
	local bar = ElvUI_ExperienceBar.statusBar
	
	local db = E.db.benikuiXprep.notifiers.experience
	local arrow = ""
	
	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.general.experience.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.general.experience.reverseFill then
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
	
	if E.db.general.experience.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function BXR:GetXP(unit)
	if(unit == 'pet') then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

function BXR:UpdateXpNotifier()
	local bar = ElvUI_ExperienceBar.statusBar

	if(UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled() or E.db.general.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		local cur, max = BXR:GetXP('player')
		bar.f.txt:SetFormattedText('%d%%', cur / max * 100)
	end
end

function BXR:Initialize()
	self:ChangeXPcolor()
	self:ChangeRepColor()
	
	local db = E.db.benikuiXprep.notifiers
	
	if db.experience.enable and E.db.general.experience.orientation == 'VERTICAL' then
		self:CreateNotifier(ElvUI_ExperienceBar.statusBar)
		self:UpdateXpNotifierPositions()
		self:UpdateXpNotifier()
		hooksecurefunc(M, 'UpdateExperience', BXR.UpdateXpNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BXR.UpdateXpNotifierPositions)
		hooksecurefunc(M, 'UpdateExpRepDimensions', BXR.UpdateXpNotifierPositions)
	end
	
	if db.reputation.enable and E.db.general.reputation.orientation == 'VERTICAL' then
		self:CreateNotifier(ElvUI_ReputationBar.statusBar)
		self:UpdateRepNotifierPositions()
		self:UpdateRepNotifier()
		hooksecurefunc(M, 'UpdateReputation', BXR.UpdateRepNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BXR.UpdateRepNotifierPositions)
		hooksecurefunc(M, 'UpdateExpRepDimensions', BXR.UpdateRepNotifierPositions)
	end
	
	if E.db.benikuiXprep.enable ~= true then return end
	
	StyleXpRepBars()
	self:ApplyXpRepStyling()
	
	hooksecurefunc(BUIL, 'ToggleTransparency', ToggleXpRepBackdrop)
	hooksecurefunc(LO, 'ToggleChatPanels', BXR.ApplyXpRepStyling)
	hooksecurefunc(M, 'UpdateExpRepDimensions', BXR.ApplyXpRepStyling)
end

E:RegisterModule(BXR:GetName())