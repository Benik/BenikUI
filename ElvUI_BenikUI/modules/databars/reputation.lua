local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');
local LSM = E.LSM;

local _G = _G
-- GLOBALS: hooksecurefunc, ElvUI_ReputationBar, ToggleCharacter

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	ToggleCharacter("ReputationFrame")
end

function mod:ApplyRepStyling()
	local bar = _G.ElvUI_ReputationBar

	mod:ApplyStyle(bar, "reputation")
end

function mod:ToggleRepBackdrop()
	if E.db.benikuiDatabars.reputation.enable ~= true then return end
	local bar = _G.ElvUI_ReputationBar
	
	mod:ToggleBackdrop(bar, "reputation")
end

function mod:UpdateRepNotifierPositions()
	local bar = _G.ElvUI_ReputationBar
	
	mod:UpdateNotifierPositions(bar, "reputation")
end

function mod:UpdateRepNotifier()
	local bar = _G.ElvUI_ReputationBar

	local min, max = bar:GetMinMaxValues()
	if max == 0 then max = 1 end
	local value = bar:GetValue()
	bar.f.txt:SetFormattedText('%d%%', ((value - min) / ((max - min == 0) and max or (max - min)) * 100))
end

function mod:RepTextOffset()
	local text = _G.ElvUI_ReputationBar.text
	text:Point('CENTER', 0, E.db.databars.reputation.textYoffset or 0)
end

function mod:LoadRep()
	local bar = _G.ElvUI_ReputationBar

	self:RepTextOffset()
	hooksecurefunc(DB, 'ReputationBar_Update', mod.RepTextOffset)

	local db = E.db.benikuiDatabars.reputation.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateRepNotifierPositions()
		self:UpdateRepNotifier()

		hooksecurefunc(DB, 'ReputationBar_Update', mod.UpdateRepNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateRepNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateRepNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateRepNotifier)
	end

	if E.db.benikuiDatabars.reputation.enable ~= true then return end

	self:StyleBar(bar, OnClick)
	self:ToggleRepBackdrop()
	self:ApplyRepStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyRepStyling)
end