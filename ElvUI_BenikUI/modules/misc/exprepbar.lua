local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BXR = E:NewModule('BUIExpRep', 'AceHook-3.0', 'AceEvent-3.0');
local M = E:GetModule('Misc');
local LO = E:GetModule('Layout');

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
	xp.fb:SetTemplate('Default', true)
	xp.fb:CreateSoftGlow()
	xp.fb.sglow:Hide()
	xp.fb:Point('TOPLEFT', xp, 'BOTTOMLEFT', 0, -SPACING)
	xp.fb:Point('BOTTOMRIGHT', xp, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -21))
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
	rp.fb:SetTemplate('Default', true)
	rp.fb:CreateSoftGlow()
	rp.fb.sglow:Hide()
	rp.fb:Point('TOPLEFT', rp, 'BOTTOMLEFT', 0, -SPACING)
	rp.fb:Point('BOTTOMRIGHT', rp, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -21))

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
		if db.applyInElvUI then
			elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
			elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)
		end
	else
		if db.applyInElvUI then
			elvxpstatus:SetStatusBarColor(unpackColor(db.xp))
			elvrestedstatus:SetStatusBarColor(unpackColor(db.rested))
		else
			elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
			elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)		
		end
	end
end

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
	if E.db.buixprep.enable ~= true then return end
	StyleXpRepBars()
	self:ApplyXpRepStyling()
	ClearDb()
	hooksecurefunc(LO, 'ToggleChatPanels', BXR.ApplyXpRepStyling)
	hooksecurefunc(M, 'UpdateExpRepDimensions', BXR.ApplyXpRepStyling)
end

E:RegisterModule(BXR:GetName())