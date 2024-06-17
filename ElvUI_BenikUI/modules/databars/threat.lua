local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Databars');
local DB = E:GetModule('DataBars');
local DT = E:GetModule('DataTexts');

local _G = _G

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ThreatBar

function mod:ApplyThreatStyling()
	local bar = _G.ElvUI_ThreatBar

	mod:ApplyStyle(bar, "threat")
end

function mod:ToggleThreatBackdrop()
	if E.db.benikui.databars.threat.enable ~= true then return end
	local bar = _G.ElvUI_ThreatBar

	mod:ToggleBackdrop(bar, "threat")
end

function mod:UpdateThreatNotifierPositions()
	local bar = _G.ElvUI_ThreatBar

	mod:UpdateNotifierPositions(bar, "threat")
end

function mod:UpdateThreatNotifier()
	local bar = _G.ElvUI_ThreatBar

	local _, max = bar:GetMinMaxValues()
	if max == 0 then max = 1 end
	local value = bar:GetValue()
	bar.f.txt:SetFormattedText('%d%%', value / max * 100)
end

function mod:LoadThreat()
	local bar = _G.ElvUI_ThreatBar
	local db = E.db.benikui.databars.threat.notifiers

	if db.enable then
		mod:CreateNotifier(bar)
		mod:UpdateThreatNotifierPositions()
		mod:UpdateThreatNotifier()
		hooksecurefunc(DB, 'ThreatBar_Update', mod.UpdateThreatNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateThreatNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateThreatNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateThreatNotifier)
	end

	if E.db.benikui.databars.threat.enable ~= true then return end

	mod:StyleBar(bar)
	mod:ToggleThreatBackdrop()
	mod:ApplyThreatStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyThreatStyling)
end
