local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local M = E:GetModule('DataBars');
local LSM = E.LSM;

local _G = _G

local find, gsub = string.find, string.gsub

local incpat = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local changedpat = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local decpat = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_TimerAfter = C_Timer.After

local GetWatchedFactionInfo = GetWatchedFactionInfo
local SetWatchedFactionIndex = SetWatchedFactionIndex
local GetNumFactions = GetNumFactions
local GetGuildInfo = GetGuildInfo
local GetFactionInfo = GetFactionInfo

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ReputationBar, SpellBookFrame, ToggleCharacter

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	ToggleCharacter("ReputationFrame")
end

function mod:ApplyRepStyling()
	local bar = ElvUI_ReputationBar
	if E.db.databars.reputation.enable then
		if bar.fb then
			if E.db.databars.reputation.orientation == 'VERTICAL' then
				bar.fb:Show()
			else
				bar.fb:Hide()
			end
		end
	end

	if E.db.benikuiDatabars.reputation.buiStyle then
		if bar.style then
			bar.style:Show()
		end
	else
		if bar.style then
			bar.style:Hide()
		end
	end
end

function mod:ToggleRepBackdrop()
	if E.db.benikuiDatabars.reputation.enable ~= true then return end
	local bar = ElvUI_ReputationBar
	local db = E.db.benikuiDatabars.reputation

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

function mod:UpdateRepNotifierPositions()
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

function mod:UpdateRepNotifier()
	local bar = ElvUI_ReputationBar.statusBar
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()

	if (C_Reputation_IsFactionParagon(factionID)) then
		local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
		if currentValue and threshold then
			min, max = 0, threshold
			value = currentValue % threshold
			if hasRewardPending then
				value = value + threshold
			end
		end
	end

	if not name or E.db.databars.reputation.orientation ~= 'VERTICAL' or (reaction == MAX_REPUTATION_REACTION and not C_Reputation_IsFactionParagon(factionID)) then
		bar.f:Hide()
	else
		bar.f:Show()
		bar.f.txt:SetFormattedText('%d%%', ((value - min) / ((max - min == 0) and max or (max - min)) * 100))
	end
end

function mod:RepTextOffset()
	local text = ElvUI_ReputationBar.text
	text:Point('CENTER', 0, E.db.databars.reputation.textYoffset or 0)
end

function mod:LoadRep()
	local bar = ElvUI_ReputationBar

	self:RepTextOffset()
	hooksecurefunc(M, 'UpdateReputation', mod.RepTextOffset)

	local db = E.db.benikuiDatabars.reputation.notifiers

	if db.enable then
		self:CreateNotifier(bar.statusBar)
		self:UpdateRepNotifierPositions()

		hooksecurefunc(M, 'UpdateReputation', mod.UpdateRepNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateRepNotifierPositions)
		hooksecurefunc(M, 'UpdateReputationDimensions', mod.UpdateRepNotifierPositions)
		hooksecurefunc(M, 'UpdateReputationDimensions', mod.UpdateRepNotifier)

		C_TimerAfter(1, mod.UpdateRepNotifier)
	end

	if E.db.benikuiDatabars.reputation.enable ~= true then return end

	self:StyleBar(bar, OnClick)
	self:ToggleRepBackdrop()
	self:ApplyRepStyling()

	hooksecurefunc(M, 'UpdateReputationDimensions', mod.ApplyRepStyling)
end