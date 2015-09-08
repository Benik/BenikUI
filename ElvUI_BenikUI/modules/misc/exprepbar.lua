local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BXR = E:NewModule('BUIExpRep', 'AceHook-3.0', 'AceEvent-3.0');
local M = E:GetModule('Misc');
local LO = E:GetModule('Layout');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');

-- Style ElvUI default XP/Rep bars
local SPACING = (E.PixelMode and 1 or 3)

local function xprep_OnLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function StyleXpRepBars()
	-- Xp Bar
	local xp = ElvUI_ExperienceBar
	
	-- bottom decor/button
	xp.fb = CreateFrame('Button', nil, xp)
	xp.fb:SetTemplate(E.db.bui.transparentDts and 'Transparent' or 'Default', true)
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
	rp:SetParent(RightChatPanel)
	
	-- bottom decor/button	
	rp.fb = CreateFrame('Button', nil, rp)
	rp.fb:SetTemplate(E.db.bui.transparentDts and 'Transparent' or 'Default', true)
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
	
	if E.db.bui.buiStyle ~= true then return end
	xp:Style('Outside')
	rp:Style('Outside')
end

function BXR:ApplyXpRepStyling()
	local xp = ElvUI_ExperienceBar
	if E.db.general.experience.enable then
		if E.db.general.experience.orientation == 'VERTICAL' then
			if E.db.bui.buiDts then 
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
			if E.db.bui.buiDts then
				rp.fb:Show()
			else
				rp.fb:Hide()
			end
		else
			rp.fb:Hide()
		end
	end
	
	if E.db.buixprep.buiStyle then
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

-- Custom color
local color = { r = 1, g = 1, b = 1, a = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b, color.a
end

function BXR:ChangeXPcolor()
	local db = E.db.buixprep.color.experience
	local elvxpstatus = ElvUI_ExperienceBar.statusBar
	local elvrestedstatus = ElvUI_ExperienceBar.rested
	
	if db.default then
		elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
		elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)
	else
		elvxpstatus:SetStatusBarColor(unpackColor(db.xp))
		elvrestedstatus:SetStatusBarColor(unpackColor(db.rested))
	end
end

local backupColor = FACTION_BAR_COLORS[1]
function BXR:ChangeRepColor()
	local db = E.db.buixprep.color.reputation
	local _, reaction = GetWatchedFactionInfo()
	local color = FACTION_BAR_COLORS[reaction] or backupColor
	local elvstatus = ElvUI_ReputationBar.statusBar
	
	if db.default then
		elvstatus:SetStatusBarColor(color.r, color.g, color.b)
	else 
		if reaction >= 5 then
			elvstatus:SetStatusBarColor(unpackColor(db.friendly))
		elseif reaction == 4 then
			elvstatus:SetStatusBarColor(unpackColor(db.neutral))
		elseif reaction == 3 then
			elvstatus:SetStatusBarColor(unpackColor(db.unfriendly))
		elseif reaction < 3 then
			elvstatus:SetStatusBarColor(unpackColor(db.hated))
		end
	end
end

function BXR:CreateNotifier(bar)
	bar.f = CreateFrame('Frame', nil, bar)
	bar.f:Size(2, 10)
	bar.f.txt = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow = bar.f:CreateFontString(nil, 'OVERLAY')
	bar.f.arrow:SetFont(LSM:Fetch("font", 'Bui Visitor1'), 10, 'MONOCHROMEOUTLINE')
	
	if E.db.buixprep.notifiers.combat then
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
	
	local db = E.db.buixprep.notifiers.reputation
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
		bar.f.txt:SetText(format('%d%%', ((value - min) / (max - min) * 100)))
	end
end

function BXR:UpdateXpNotifierPositions()
	local bar = ElvUI_ExperienceBar.statusBar
	
	local db = E.db.buixprep.notifiers.experience
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
		bar.f.txt:SetText(format('%d%%', cur / max * 100))
	end
end

-- Clear ElvUI database from deleted options
local function ClearDb()
	if E.db.buixprep.show then E.db.buixprep.show = nil end
	if E.db.buixprep.textFormat then E.db.buixprep.textFormat = nil end -- really old
	if E.db.buixprep.textStyle then E.db.buixprep.textStyle = nil end -- really old
	if E.db.buixprep.xpTextFormat then E.db.buixprep.xpTextFormat = nil end
	if E.db.buixprep.repTextFormat then E.db.buixprep.repTextFormat = nil end
	if E.db.buixprep.mouseOver then E.db.buixprep.mouseOver = nil end
	if E.db.buixprep.color.reputation.applyInElvUI then E.db.buixprep.color.reputation.applyInElvUI = nil end
	if E.db.buixprep.color.experience.applyInElvUI then E.db.buixprep.color.experience.applyInElvUI = nil end
end

function BXR:Initialize()
	ClearDb()
	self:ChangeXPcolor()
	self:ChangeRepColor()
	
	local db = E.db.buixprep.notifiers
	
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
	
	if E.db.buixprep.enable ~= true then return end
	
	StyleXpRepBars()
	self:ApplyXpRepStyling()
	
	hooksecurefunc(LO, 'ToggleChatPanels', BXR.ApplyXpRepStyling)
	hooksecurefunc(M, 'UpdateExpRepDimensions', BXR.ApplyXpRepStyling)
end

E:RegisterModule(BXR:GetName())