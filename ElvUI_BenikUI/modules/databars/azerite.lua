local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DB = E:GetModule('DataBars');
local DT = E:GetModule('DataTexts');
local LSM = E.LSM;

local _G = _G
local floor = floor

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_AzeriteBar

function mod:ApplyAzeriteStyling()
	local bar = _G.ElvUI_AzeriteBar

	mod:ApplyStyle(bar, "azerite")
end

function mod:ToggleAzeriteBackdrop()
	if E.db.benikui.databars.azerite.enable ~= true then return end
	local bar = _G.ElvUI_AzeriteBar

	mod:ToggleBackdrop(bar, "azerite")
end

function mod:UpdateAzeriteNotifierPositions()
	local bar = _G.ElvUI_AzeriteBar

	mod:UpdateNotifierPositions(bar, "azerite")
end

function mod:UpdateAzeriteNotifier()
	local bar = _G.ElvUI_AzeriteBar

	local _, max = bar:GetMinMaxValues()
	if max == 0 then max = 1 end
	local value = bar:GetValue()
	bar.f.txt:SetFormattedText('%d%%', floor(value / max * 100))
end

function mod:LoadAzerite()
	local bar = _G.ElvUI_AzeriteBar
	local db = E.db.benikui.databars.azerite.notifiers

	if db.enable then
		mod:CreateNotifier(bar)
		mod:UpdateAzeriteNotifierPositions()
		mod:UpdateAzeriteNotifier()
		hooksecurefunc(DB, 'AzeriteBar_Update', mod.UpdateAzeriteNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifier)
	end

	if E.db.benikui.databars.azerite.enable ~= true then return end

	mod:StyleBar(bar)
	mod:ToggleAzeriteBackdrop()
	mod:ApplyAzeriteStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyAzeriteStyling)
end
