local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');

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
	if E.db.benikui.databars.reputation.enable ~= true then return end
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

function mod:LoadRep()
	local bar = _G.ElvUI_ReputationBar
	local db = E.db.benikui.databars.reputation.notifiers

	if db.enable then
		mod:CreateNotifier(bar)
		mod:UpdateRepNotifierPositions()
		mod:UpdateRepNotifier()

		hooksecurefunc(DB, 'ReputationBar_Update', mod.UpdateRepNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateRepNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateRepNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateRepNotifier)
	end

	if E.db.benikui.databars.reputation.enable ~= true then return end

	mod:StyleBar(bar, OnClick)
	mod:ToggleRepBackdrop()
	mod:ApplyRepStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyRepStyling)
end
