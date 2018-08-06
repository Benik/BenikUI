local E, L, V, P, G = unpack(ElvUI);
local BDB = E:GetModule('BenikUI_databars');
local BUI = E:GetModule('BenikUI');
local M = E:GetModule('DataBars');
local LSM = LibStub('LibSharedMedia-3.0');
local DT = E:GetModule('DataTexts');

local _G = _G

local find, gsub = string.find, string.gsub

local incpat = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local changedpat = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local decpat = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon

local CreateFrame = CreateFrame
local GameTooltip = _G["GameTooltip"]
local GetWatchedFactionInfo = GetWatchedFactionInfo
local InCombatLockdown = InCombatLockdown
local SetWatchedFactionIndex = SetWatchedFactionIndex
local GetNumFactions = GetNumFactions
local GetGuildInfo = GetGuildInfo
local GetFactionInfo = GetFactionInfo

local FACTION_BAR_COLORS, BINDING_NAME_TOGGLECHARACTER2 = FACTION_BAR_COLORS, BINDING_NAME_TOGGLECHARACTER2

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ReputationBar, SpellBookFrame, ToggleCharacter

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
	GameTooltip:AddLine(BINDING_NAME_TOGGLECHARACTER2, selectioncolor)
	GameTooltip:Show()
	if InCombatLockdown() then GameTooltip:Hide() end
end

local function StyleBar()
	local rp = ElvUI_ReputationBar

	-- bottom decor/button
	rp.fb = CreateFrame('Button', nil, rp)
	rp.fb:CreateSoftGlow()
	rp.fb.sglow:Hide()
	if BUI.ShadowMode then
		rp.fb:CreateSoftShadow()
	end
	rp.fb:Point('TOPLEFT', rp, 'BOTTOMLEFT', 0, -SPACING)
	rp.fb:Point('BOTTOMRIGHT', rp, 'BOTTOMRIGHT', 0, (E.PixelMode and -20 or -22))

	rp.fb:SetScript('OnEnter', onEnter)
	rp.fb:SetScript('OnLeave', onLeave)

	rp.fb:SetScript('OnClick', function(self)
		ToggleCharacter("ReputationFrame")
	end)

	BDB:ToggleRepBackdrop()

	if E.db.benikui.general.benikuiStyle ~= true then return end
	rp:Style('Outside', nil, false, true)
end

function BDB:ApplyRepStyling()
	local rp = ElvUI_ReputationBar
	if E.db.databars.reputation.enable then
		if rp.fb then
			if E.db.databars.reputation.orientation == 'VERTICAL' then
				rp.fb:Show()
			else
				rp.fb:Hide()
			end
		end
	end

	if E.db.benikuiDatabars.reputation.buiStyle then
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

function BDB:ToggleRepBackdrop()
	if E.db.benikuiDatabars.reputation.enable ~= true then return end
	local bar = ElvUI_ReputationBar
	local db = E.db.benikuiDatabars.reputation

	if bar.fb then
		if db.buttonStyle == 'DEFAULT' then
			bar.fb:SetTemplate('Default', true)
		elseif db.buttonStyle == 'TRANSPARENT' then
			bar.fb:SetTemplate('Transparent')
		else
			bar.fb:SetTemplate('NoBackdrop')
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
	local name, _, min, max, value, factionID = GetWatchedFactionInfo()

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

	if not name or E.db.databars.reputation.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()
		bar.f.txt:SetFormattedText('%d%%', ((value - min) / ((max - min == 0) and max or (max - min)) * 100))
	end
end

function BDB:RepTextOffset()
	local text = ElvUI_ReputationBar.text
	text:Point('CENTER', 0, E.db.databars.reputation.textYoffset or 0)
end

-- Credit: Feraldin, ElvUI Enhanced (Legion)
function BDB:SetWatchedFactionOnReputationBar(event, msg)
	if not E.db.benikuiDatabars.reputation.autotrack then return end

	local _, _, faction, amount = find(msg, incpat)
	if not faction then _, _, faction, amount = find(msg, changedpat) or find(msg, decpat) end
	if faction then
		if faction == GUILD_REPUTATION then
			faction = GetGuildInfo("player")
		end

		local active = GetWatchedFactionInfo()
		for factionIndex = 1, GetNumFactions() do
			local name = GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				SetWatchedFactionIndex(factionIndex)
				break
			end
		end
	end
end

function BDB:ToggleRepAutotrack()
	if E.db.benikuiDatabars.reputation.autotrack then
		self:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE', 'SetWatchedFactionOnReputationBar')
	else
		self:UnregisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE')
	end
end

function BDB:LoadRep()
	local bar = ElvUI_ReputationBar
	self:ChangeRepColor()
	self:RepTextOffset()
	hooksecurefunc(M, 'UpdateReputation', BDB.ChangeRepColor)
	hooksecurefunc(M, 'UpdateReputation', BDB.RepTextOffset)
	self:ToggleRepAutotrack()

	local db = E.db.benikuiDatabars.reputation.notifiers

	if db.enable and E.db.databars.reputation.orientation == 'VERTICAL' then
		self:CreateNotifier(bar.statusBar)
		self:UpdateRepNotifierPositions()
		self:UpdateRepNotifier()
		hooksecurefunc(M, 'UpdateReputation', BDB.UpdateRepNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', BDB.UpdateRepNotifierPositions)
		hooksecurefunc(M, 'UpdateReputationDimensions', BDB.UpdateRepNotifierPositions)
	end

	if BUI.ShadowMode then
		if not bar.style then
			bar:CreateSoftShadow()
		end
	end

	if E.db.benikuiDatabars.reputation.enable ~= true then return end

	StyleBar()
	self:ApplyRepStyling()

	hooksecurefunc(M, 'UpdateReputationDimensions', BDB.ApplyRepStyling)
end