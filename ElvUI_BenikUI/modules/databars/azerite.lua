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

function mod:AzeriteTextOffset()
	local text = _G.ElvUI_AzeriteBar.text
	text:Point('CENTER', 0, E.db.databars.azerite.textYoffset or 0)
end

function mod:LoadAzerite()
	local bar = _G.ElvUI_AzeriteBar

	self:AzeriteTextOffset()
	hooksecurefunc(DB, 'AzeriteBar_Update', mod.AzeriteTextOffset)

	local db = E.db.benikui.databars.azerite.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateAzeriteNotifierPositions()
		self:UpdateAzeriteNotifier()
		hooksecurefunc(DB, 'AzeriteBar_Update', mod.UpdateAzeriteNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifier)
	end

	if E.db.benikui.databars.azerite.enable ~= true then return end

	self:StyleBar(bar)
	self:ToggleAzeriteBackdrop()
	self:ApplyAzeriteStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyAzeriteStyling)
end
