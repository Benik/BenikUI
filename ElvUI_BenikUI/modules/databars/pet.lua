local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Databars');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');

local _G = _G

local HideUIPanel, ShowUIPanel = HideUIPanel, ShowUIPanel

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_ExperienceBar, SpellBookFrame

local function OnClick(self)
	if self.template == 'NoBackdrop' then return end
	if InCombatLockdown() then return end
	ToggleCharacter("PetPaperDollFrame")
end

function mod:ApplyPetXpStyling()
	local bar = _G.ElvUI_PetExperienceBar
	
	mod:ApplyStyle(bar, "petExperience")
end

function mod:TogglePetXPBackdrop()
	if E.db.benikui.Databars.petExperience.enable ~= true then return end
	local bar = _G.ElvUI_PetExperienceBar

	mod:ToggleBackdrop(bar, "petExperience")
end

function mod:UpdatePetXpNotifierPositions()
	local bar = _G.ElvUI_PetExperienceBar

	mod:UpdateNotifierPositions(bar, "petExperience")
end

function mod:UpdatePetXpNotifier()
	local bar = _G.ElvUI_PetExperienceBar

	local _, max = bar:GetMinMaxValues()
	if max == 0 then max = 1 end
	local value = bar:GetValue()
	bar.f.txt:SetFormattedText('%d%%', value / max * 100)
end

function mod:LoadPetXP()
	local bar = _G.ElvUI_PetExperienceBar

	local db = E.db.benikui.Databars.petExperience.notifiers

	if db.enable then
		mod:CreateNotifier(bar)
		mod:UpdatePetXpNotifierPositions()
		mod:UpdatePetXpNotifier()
		hooksecurefunc(DB, 'PetExperienceBar_Update', mod.UpdatePetXpNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdatePetXpNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdatePetXpNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdatePetXpNotifier)
	end

	if E.db.benikui.Databars.petExperience.enable ~= true then return end

	mod:StyleBar(bar, OnClick)
	mod:TogglePetXPBackdrop()
	mod:ApplyPetXpStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyPetXpStyling)
end