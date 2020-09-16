local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DB = E:GetModule('DataBars');
local DT = E:GetModule('DataTexts');
local LSM = E.LSM;

local _G = _G
local floor = floor
local C_AzeriteItem_FindActiveAzeriteItem = C_AzeriteItem.FindActiveAzeriteItem
local C_AzeriteItem_GetAzeriteItemXPInfo = C_AzeriteItem.GetAzeriteItemXPInfo

-- GLOBALS: hooksecurefunc, selectioncolor, ElvUI_AzeriteBar

function mod:ApplyAzeriteStyling()
	local bar = _G.ElvUI_AzeriteBar

	mod:ApplyStyle(bar, "azerite")
end

function mod:ToggleAzeriteBackdrop()
	if E.db.benikuiDatabars.azerite.enable ~= true then return end
	local bar = _G.ElvUI_AzeriteBar

	mod:ToggleBackdrop(bar, "azerite")
end

function mod:UpdateAzeriteNotifierPositions()
	local bar = DB.StatusBars.Azerite

	mod:UpdateNotifierPositions(bar, "azerite")
end

function mod:UpdateAzeriteNotifier()
	local bar = DB.StatusBars.Azerite
	local azeriteItemLocation = C_AzeriteItem_FindActiveAzeriteItem()

	if not azeriteItemLocation or E.db.databars.azerite.orientation ~= 'VERTICAL' then
		bar.f:Hide()
	else
		bar.f:Show()

		local xp, totalLevelXP = C_AzeriteItem_GetAzeriteItemXPInfo(azeriteItemLocation)

		bar.f.txt:SetFormattedText('%s%%', floor(xp / totalLevelXP * 100))

		mod.UpdateAzeriteNotifierPositions()
	end
end

function mod:AzeriteTextOffset()
	local text = DB.StatusBars.Azerite.text
	text:Point('CENTER', 0, E.db.databars.azerite.textYoffset or 0)
end

function mod:LoadAzerite()
	local bar = ElvUI_AzeriteBar

	self:AzeriteTextOffset()
	hooksecurefunc(DB, 'AzeriteBar_Update', mod.AzeriteTextOffset)

	local db = E.db.benikuiDatabars.azerite.notifiers

	if db.enable then
		self:CreateNotifier(bar)
		self:UpdateAzeriteNotifierPositions()
		self:UpdateAzeriteNotifier()
		hooksecurefunc(DB, 'AzeriteBar_Update', mod.UpdateAzeriteNotifier)
		hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifierPositions)
		hooksecurefunc(DB, 'UpdateAll', mod.UpdateAzeriteNotifier)
	end

	if E.db.benikuiDatabars.azerite.enable ~= true then return end

	self:StyleBar(bar)
	self:ToggleAzeriteBackdrop()
	self:ApplyAzeriteStyling()

	hooksecurefunc(DB, 'UpdateAll', mod.ApplyAzeriteStyling)
end