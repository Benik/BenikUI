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
local GetWatchedFactionInfo = GetWatchedFactionInfo
local InCombatLockdown = InCombatLockdown
local ToggleCharacter = ToggleCharacter

local FACTION_BAR_COLORS, BINDING_NAME_TOGGLECHARACTER2 = FACTION_BAR_COLORS, BINDING_NAME_TOGGLECHARACTER2

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ReputationBar, ElvUI_ExperienceBar, SpellBookFrame

local SPACING = (E.PixelMode and 1 or 3)

local function onLeave(self)
	self.sglow:Hide()
	GameTooltip:Hide()
end

local function ToggleBackdrop()
	if E.db.benikuiDatabars.enable then
		if not E.db.benikui.datatexts.chat.backdrop then
			if ElvUI_ReputationBar.fb then
				ElvUI_ReputationBar.fb:SetTemplate('NoBackdrop')
			end
		else
			if E.db.benikui.datatexts.chat.transparent then
				if ElvUI_ReputationBar.fb then
					ElvUI_ReputationBar.fb:SetTemplate('Transparent')
				end
			else
				if ElvUI_ReputationBar.fb then
					ElvUI_ReputationBar.fb:SetTemplate('Default', true)
				end
			end
		end
	end
end

local function StyleBar()
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
	
	rp.fb:SetScript('OnLeave', onLeave)

	rp.fb:SetScript('OnClick', function(self)
		ToggleCharacter("ReputationFrame")
	end)
	
	ToggleBackdrop()
	
	if E.db.benikui.general.benikuiStyle ~= true then return end
	rp:Style('Outside')
end

function BDB:ApplyRepStyling()
	local rp = ElvUI_ReputationBar
	if E.db.databars.reputation.enable then
		if rp.fb then
			if E.db.databars.reputation.orientation == 'VERTICAL' then
				if E.db.benikui.datatexts.chat.enable then
					rp.fb:Show()
				else
					rp.fb:Hide()
				end
			else
				rp.fb:Hide()
			end
		end
	end
	
	if E.db.benikuiDatabars.buiStyle then
		if rp.style then
			rp.style:Show()
		end
	else
		if rp.style then
			rp.style:Hide()
		end
	end
end

local backupColor = FACTION_BAR_COLORS[1]
function BDB:ChangeRepColor()
	local db = E.db.benikuiDatabars.reputation.color
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

function BDB:UpdateRepNotifierPositions()
	local bar = ElvUI_ReputationBar.statusBar
	
	local db = E.db.benikuiDatabars.reputation.notifiers
	local arrow = ""
	
	bar.f:ClearAllPoints()
	bar.f.arrow:ClearAllPoints()
	bar.f.txt:ClearAllPoints()

	if db.position == 'LEFT' then
		if not E.db.databars.reputation.reverseFill then
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'TOPLEFT', E.PixelMode and 2 or 0, 1)
		else
			bar.f.arrow:Point('RIGHT', bar:GetStatusBarTexture(), 'BOTTOMLEFT', E.PixelMode and 2 or 0, 1)
		end
		bar.f:Point('RIGHT', bar.f.arrow, 'LEFT')
		bar.f.txt:Point('RIGHT', bar.f, 'LEFT')
		arrow = ">"
	else
		if not E.db.databars.reputation.reverseFill then
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

	if E.db.databars.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
	end
end

function BDB:UpdateRepNotifier()
	local bar = ElvUI_ReputationBar.statusBar
	
	local name, _, min, max, value = GetWatchedFactionInfo()
	
	if not name or E.db.databars.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		bar.f.txt:SetFormattedText('%d%%', ((value - min) / (max - min) * 100))
	end
end

function BDB:LoadRep()
	self:ChangeRepColor()
	
	local db = E.db.benikuiDatabars.reputation.notifiers
	
	if db.enable and E.db.databars.reputation.orientation == 'VERTICAL' then
		self:CreateNotifier(ElvUI_ReputationBar.statusBar)
		self:UpdateRepNotifierPositions()
		self:UpdateRepNotifier()
		hooksecurefunc(M, 'UpdateReputation', BDB.UpdateRepNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BDB.UpdateRepNotifierPositions)
		hooksecurefunc(M, 'UpdateReputationDimensions', BDB.UpdateRepNotifierPositions)
	end
	
	if E.db.benikuiDatabars.enable ~= true then return end
	
	StyleBar()
	self:ApplyRepStyling()
	
	hooksecurefunc(BUIL, 'ToggleTransparency', ToggleBackdrop)
	hooksecurefunc(LO, 'ToggleChatPanels', BDB.ApplyRepStyling)
	hooksecurefunc(M, 'UpdateReputationDimensions', BDB.ApplyRepStyling)
	hooksecurefunc(M, 'UpdateReputation', BDB.ChangeRepColor)
end
