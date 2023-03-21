local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');

local _G = _G

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_HonorBar

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	TogglePVPUI()
end

function mod:ApplyHonorStyling()
	local bar = _G.ElvUI_HonorBar
	
	mod:ApplyStyle(bar, "honor")
end

function mod:ToggleHonorBackdrop()
	if E.db.benikui.databars.honor.enable ~= true then return end
	local bar = _G.ElvUI_HonorBar

	mod:ToggleBackdrop(bar, "honor")
end

function mod:UpdateHonorNotifierPositions()
	local bar = _G.ElvUI_HonorBar

	mod:UpdateNotifierPositions(bar, "honor")
end

function mod:UpdateHonorNotifier()
	local bar = _G.ElvUI_HonorBar

	local _, max = bar:GetMinMaxValues()
	if max == 0 then max = 1 end
	local value = bar:GetValue()
	bar.f.txt:SetFormattedText('%d%%', value / max * 100)
end

function mod:LoadHonor()
	local bar = _G.ElvUI_HonorBar
	local db = E.db.benikui.databars.honor.notifiers

	if db.enable then
		mod:CreateNotifier(bar)
		mod:UpdateHonorNotifierPositions()
		mod:UpdateHonorNotifier()
		hooksecurefunc(DB, 'HonorBar_Update', mod.UpdateHonorNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateHonorNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateHonorNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateHonorNotifier)
	end

	if E.db.benikui.databars.honor.enable ~= true then return end

	mod:StyleBar(bar, OnClick)
	mod:ToggleHonorBackdrop()
	mod:ApplyHonorStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyHonorStyling)
end
