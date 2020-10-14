local BUI, E, L, V, P, G = unpack(select(2, ...))
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
	if E.db.benikuiDatabars.threat.enable ~= true then return end
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

function mod:ThreatTextOffset()
	local text = _G.ElvUI_ThreatBar.text
	text:Point('CENTER', 0, E.db.databars.threat.textYoffset or 0)
end

function mod:LoadThreat()
	local bar = _G.ElvUI_ThreatBar

	self:ThreatTextOffset()
	hooksecurefunc(DB, 'ThreatBar_Update', mod.ThreatTextOffset)

	local db = E.db.benikuiDatabars.threat.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateThreatNotifierPositions()
		self:UpdateThreatNotifier()
		hooksecurefunc(DB, 'ThreatBar_Update', mod.UpdateThreatNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateThreatNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateThreatNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateThreatNotifier)
	end

	if E.db.benikuiDatabars.threat.enable ~= true then return end

	self:StyleBar(bar)
	self:ToggleThreatBackdrop()
	self:ApplyThreatStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyThreatStyling)
end