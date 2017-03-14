local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIC = E:NewModule('BuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

--[[

	CREDIT:
	This module is based on Blazeflack's ElvUI_CastBarPowerOverlay ==> http://www.tukui.org/addons/index.php?act=view&id=62
	Edited for BenikUI under Blaze's permission. Many thanks :)
]]

local _G = _G

-- GLOBALS: hooksecurefunc

--Configure castbar text position and alpha
local function ConfigureText(unit, castbar)
	local db = E.db.benikui.unitframes.castbar.text

	if db.castText then
		castbar.Text:Show()
		castbar.Time:Show()
	else
		if (unit == 'target' and db.forceTargetText) then
			castbar.Text:Show()
			castbar.Time:Show()
		else
			castbar.Text:Hide()
			castbar.Time:Hide()
		end
	end

	-- Set position of castbar text according to chosen offsets
	castbar.Text:ClearAllPoints()
	castbar.Time:ClearAllPoints()
	if db.yOffset ~= 0 then
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.yOffset)
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.yOffset)
	else
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
	end
end

--Reset castbar text position and alpha
local function ResetText(castbar)
	castbar.Text:ClearAllPoints()
	castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
	castbar.Time:ClearAllPoints()
	castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
	castbar.Text:Show()
	castbar.Time:Show()
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
		if unitframe.USE_INFO_PANEL and db.insideInfoPanel then
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

--Castbar texture
function BUIC:PostCast(unit, unitframe)
	local castTexture = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.castbar)
	local r, g, b, a = BUI:unpackColor(E.db.benikui.unitframes.castbar.text.textColor)
	if not self.isTransparent then
		self:SetStatusBarTexture(castTexture)
	end
	self.Text:SetTextColor(r, g, b, a)
	self.Time:SetTextColor(r, g, b, a)
end

function BUIC:CastBarHooks()
	local units = {"Player", "Target", "Focus", "Pet"}
	for _, unit in pairs(units) do
		local unitframe = _G["ElvUF_"..unit];
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			if E.db.benikui.general.shadows then
				castbar:CreateShadow('Default')
				castbar.ButtonIcon.bg:CreateShadow('Default')
			end
			hooksecurefunc(castbar, "PostCastStart", BUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", BUIC.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", BUIC.PostCast)
		end
	end

	for i = 1, 5 do
		local castbar = _G["ElvUF_Arena"..i].Castbar
		if castbar then
			if E.db.benikui.general.shadows then
				castbar:CreateShadow('Default')
				castbar.ButtonIcon.bg:CreateShadow('Default')
			end
			hooksecurefunc(castbar, "PostCastStart", BUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", BUIC.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", BUIC.PostCast)
		end
	end

	for i = 1, MAX_BOSS_FRAMES do
		local castbar = _G["ElvUF_Boss"..i].Castbar
		if castbar then
			if E.db.benikui.general.shadows then
				castbar:CreateShadow('Default')
				castbar.ButtonIcon.bg:CreateShadow('Default')
			end
			hooksecurefunc(castbar, "PostCastStart", BUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", BUIC.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", BUIC.PostCast)
		end
	end
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

	BUIC:CastBarHooks()
end

E:RegisterModule(BUIC:GetName())