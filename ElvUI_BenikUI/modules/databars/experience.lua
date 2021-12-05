local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');

local _G = _G

local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ExperienceBar, SpellBookFrame

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end
end

function mod:ApplyXpStyling()
	local bar = _G.ElvUI_ExperienceBar
	
	mod:ApplyStyle(bar, "experience")
end

function mod:ToggleXPBackdrop()
	if E.db.benikui.benikuiDatabars.experience.enable ~= true then return end
	local bar = _G.ElvUI_ExperienceBar

	mod:ToggleBackdrop(bar, "experience")
end

function mod:UpdateXpNotifierPositions()
	local bar = _G.ElvUI_ExperienceBar

	mod:UpdateNotifierPositions(bar, "experience")
end

function mod:UpdateXpNotifier()
	local bar = _G.ElvUI_ExperienceBar

	local _, max = bar:GetMinMaxValues()
	if max == 0 then max = 1 end
	local value = bar:GetValue()
	bar.f.txt:SetFormattedText('%d%%', value / max * 100)
end

function mod:XpTextOffset()
	local text = _G.ElvUI_ExperienceBar.text
	text:Point('CENTER', 0, E.db.databars.experience.textYoffset or 0)
end

function mod:LoadXP()
	local bar = _G.ElvUI_ExperienceBar

	self:XpTextOffset()
	hooksecurefunc(DB, 'ExperienceBar_Update', mod.XpTextOffset)

	local db = E.db.benikui.benikuiDatabars.experience.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateXpNotifierPositions()
		self:UpdateXpNotifier()
		hooksecurefunc(DB, 'ExperienceBar_Update', mod.UpdateXpNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateXpNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateXpNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateXpNotifier)
	end

	if E.db.benikui.benikuiDatabars.experience.enable ~= true then return end

	self:StyleBar(bar, OnClick)
	self:ToggleXPBackdrop()
	self:ApplyXpStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyXpStyling)
end
