local E, L, V, P, G = unpack(ElvUI);
local BUIC = E:NewModule('BuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

--[[

	CREDIT:
	This module is based on Blazeflack's ElvUI_CastBarPowerOverlay ==> http://www.tukui.org/addons/index.php?act=view&id=62
	Edited for BenikUI under Blaze's permission. Many thanks :)
]]


local _G = _G

--Configure castbar text position and alpha
local function ConfigureText(unit, castbar)
	local db = E.db.benikui.unitframes.castbar.text
	local dbe = E.db.unitframe.units[unit];
	
	if db.castText then
		castbar.Text:SetAlpha(1)
		castbar.Time:SetAlpha(1)
	else
		castbar.Text:SetAlpha(0)
		castbar.Time:SetAlpha(0)
	end

	-- Set position of castbar text according to chosen offsets
	castbar.Text:ClearAllPoints()
	castbar.Time:ClearAllPoints()
	if dbe.infoPanel.enable and dbe.castbar.insideInfoPanel and dbe.castbar.icon and dbe.castbar.iconAttached then
		if dbe.orientation == "LEFT" or dbe.orientation == "MIDDLE" and db.infoPanel.enable then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", -castbar.ButtonIcon.bg:GetWidth() + 4, db.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.yOffset)
		else
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", castbar.ButtonIcon.bg:GetWidth() -4, db.yOffset)
		end
	else
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.yOffset)
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.yOffset)
	end
end

--Reset castbar text position and alpha
local function ResetText(castbar)
	castbar.Text:ClearAllPoints()
	castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
	castbar.Time:ClearAllPoints()
	castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
	castbar.Text:SetAlpha(1)
	castbar.Time:SetAlpha(1)
end

local function changeCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("LOW")
	unitframe.Castbar:SetFrameLevel(unitframe.InfoPanel:GetFrameLevel() + 10)
end

local function resetCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("HIGH")
	unitframe.Castbar:SetFrameLevel(6)
end

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	
	if unit == 'player' or unit == 'target' then
		if db.insideInfoPanel and unitframe.USE_INFO_PANEL then
			ConfigureText(unit, castbar)
			if E.db.benikui.unitframes.castbar.text.ShowInfoText then
				changeCastbarLevel(unit, unitframe)
			else
				resetCastbarLevel(unit, unitframe)
			end
		else
			ResetText(castbar)
			resetCastbarLevel(unit, unitframe)
		end
	end
end

--Initiate update of unit
function BUIC:UpdateSettings(unit)
	if unit == 'player' or unit == 'target' then
		local unitFrameName = "ElvUF_"..E:StringTitle(unit)
		local unitframe = _G[unitFrameName]
		ConfigureCastbar(unit, unitframe)
	end
end

-- Function to be called when registered events fire
function BUIC:UpdateAllCastbars()
	BUIC:UpdateSettings("player")
	BUIC:UpdateSettings("target")
end

function BUIC:Initialize()

	--ElvUI UnitFrames are not enabled, stop right here!
	if E.private.unitframe.enable ~= true then return end

	--Profile changed, update castbar overlay settings
	hooksecurefunc(E, "UpdateAll", function()
		--Delay it a bit to allow all db changes to take effect before we update
		self:ScheduleTimer('UpdateAllCastbars', 0.5)
	end)

	--Castbar was modified, re-apply settings
	hooksecurefunc(UF, "Configure_Castbar", function(self, frame, preventLoop)
		if preventLoop then return; end

		local unit = frame.unitframeType
		if unit and (unit == 'player' or unit == 'target') and E.db.unitframe.units[unit].castbar.insideInfoPanel then
			BUIC:UpdateSettings(unit)
		end
	end)
end

E:RegisterModule(BUIC:GetName())