local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIC = E:NewModule('BuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');
local LSM = LibStub("LibSharedMedia-3.0");

--[[
	CREDIT:
	This module is based on Blazeflack's ElvUI_CastBarPowerOverlay
	Castbar Backdrop Color. Credit: Blazeflack - Taken from ElvUI CustomTweaks
	Edited for BenikUI under Blaze's permission. Many thanks :)
]]

local _G = _G

local units = {"Player", "Target", "Focus", "Pet"}

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
		if unit == 'player' then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.player.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.player.yOffset)
		elseif unit == 'target' then
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.target.yOffset)
			castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.target.yOffset)
		end
	else
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
	end
end

local function changeCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("LOW")
	unitframe.Castbar:SetFrameLevel(unitframe.InfoPanel:GetFrameLevel() + 10)
end

local function resetCastbarLevel(unit, unitframe)
	unitframe.Castbar:SetFrameStrata("HIGH")
	unitframe.Castbar:SetFrameLevel(6)
end

local function ConfigureCastbarShadow(unit, unitframe)
	if not BUI.ShadowMode then return end

	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar

	if unitframe.USE_INFO_PANEL and db.insideInfoPanel then
		castbar.backdrop.shadow:Hide()
		castbar.ButtonIcon.bg.shadow:Hide()
	else
		castbar.backdrop.shadow:Show()
		castbar.ButtonIcon.bg.shadow:Show()
	end
end

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar

	if unit == 'player' or unit == 'target' then
		ConfigureText(unit, castbar)
		ConfigureCastbarShadow(unit, unitframe)
		if unitframe.USE_INFO_PANEL and db.insideInfoPanel then
			if E.db.benikui.unitframes.castbar.text.ShowInfoText then
				changeCastbarLevel(unit, unitframe)
			else
				resetCastbarLevel(unit, unitframe)
			end
		else
			resetCastbarLevel(unit, unitframe)
		end
	elseif unit == "focus" or unit == "pet" then
		ConfigureCastbarShadow(unit, unitframe)
	elseif unit == "arena" then
		for i = 1, 5 do
			local unitframe = _G["ElvUF_Arena"..i]
			ConfigureCastbarShadow(unit, unitframe)
		end
	elseif unit == "boss" then
		for i = 1, 5 do
			local unitframe = _G["ElvUF_Boss"..i]
			ConfigureCastbarShadow(unit, unitframe)
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
	BUIC:UpdateSettings("focus")
	BUIC:UpdateSettings("pet")
	BUIC:UpdateSettings("arena")
	BUIC:UpdateSettings("boss")
end

--Castbar texture
function BUIC:PostCast(unit, unitframe)
	local db = E.db.benikui.unitframes.castbar.text

	local castTexture = LSM:Fetch("statusbar", E.db.benikui.unitframes.textures.castbar)
	local pr, pg, pb, pa = BUI:unpackColor(db.player.textColor)
	local tr, tg, tb, ta = BUI:unpackColor(db.target.textColor)

	if not self.isTransparent then
		self:SetStatusBarTexture(castTexture)
	end

	if unit == 'player' then
		self.Text:SetTextColor(pr, pg, pb, pa)
		self.Time:SetTextColor(pr, pg, pb, pa)
	elseif unit == 'target' then
		self.Text:SetTextColor(tr, tg, tb, ta)
		self.Time:SetTextColor(tr, tg, tb, ta)	
	end
end

function BUIC:CastBarHooks()
	--local units = {"Player", "Target", "Focus", "Pet"}
	for _, unit in pairs(units) do
		local unitframe = _G["ElvUF_"..unit];
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			if BUI.ShadowMode then
				castbar.backdrop:CreateSoftShadow()
				castbar.ButtonIcon.bg:CreateSoftShadow()
			end
			hooksecurefunc(castbar, "PostCastStart", BUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", BUIC.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", BUIC.PostCast)
		end
	end

	for i = 1, 5 do
		local castbar = _G["ElvUF_Arena"..i].Castbar
		if castbar then
			if BUI.ShadowMode then
				castbar.backdrop:CreateSoftShadow()
				castbar.ButtonIcon.bg:CreateSoftShadow()
			end
			hooksecurefunc(castbar, "PostCastStart", BUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", BUIC.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", BUIC.PostCast)
		end
	end

	for i = 1, MAX_BOSS_FRAMES do
		local castbar = _G["ElvUF_Boss"..i].Castbar
		if castbar then
			if BUI.ShadowMode then
				castbar.backdrop:CreateSoftShadow()
				castbar.ButtonIcon.bg:CreateSoftShadow()
			end
			hooksecurefunc(castbar, "PostCastStart", BUIC.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", BUIC.PostCast)
			hooksecurefunc(castbar, "PostChannelStart", BUIC.PostCast)
		end
	end
end

local function PostCastChannelStart(self, unit)
	local db = self:GetParent().db
	if not db or not db.castbar then return; end

	local color = E.db.benikui.unitframes.castbarColor.castbarBackdropColor
	local r, g, b, a = color.r, color.g, color.b, color.a

	if self.bg and self.bg:IsShown() then
		self.bg:SetColorTexture(r, g, b)
	else
		if self.backdrop then
			if self.backdrop.backdropTexture then
				self.backdrop.backdropTexture:SetVertexColor(r, g, b)
				self.backdrop.backdropTexture:SetAlpha(a)
			end
			r, g, b = self.backdrop:GetBackdropColor()
			self.backdrop:SetBackdropColor(r, g, b, a)
		end
	end
end

local function PostCastInterruptible(self, unit)
	if unit == "vehicle" or unit == "player" then return end
	
	local color = E.db.benikui.unitframes.castbarColor.castbarBackdropColor
	local r, g, b, a = color.r, color.g, color.b, color.a
	
	if self.bg and self.bg:IsShown() then
		self.bg:SetColorTexture(r, g, b)
	else
		if self.backdrop then
			if self.backdrop.backdropTexture then
				self.backdrop.backdropTexture:SetVertexColor(r, g, b)
				self.backdrop.backdropTexture:SetAlpha(a)
			end
			r, g, b = self.backdrop:GetBackdropColor()
			self.backdrop:SetBackdropColor(r, g, b, a)
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
		if unit and (unit == 'player' or unit == 'target') then
			BUIC:UpdateSettings(unit)
		end
	end)

	BUIC:CastBarHooks()

	-- Castbar Backdrop Color
	local ctEnabled = E.private["CustomTweaks"] and E.private["CustomTweaks"]["CastbarCustomBackdrop"]and true or false
	if ctEnabled then return; end -- if CustomTweaks module is enabled then stop here
	if not E.db.benikui.unitframes.castbarColor.enable then return; end

	for _, unit in pairs(units) do
		local unitframe = _G["ElvUF_"..unit];
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", PostCastChannelStart)
			hooksecurefunc(castbar, "PostCastInterruptible", PostCastInterruptible)
			hooksecurefunc(castbar, "PostChannelStart", PostCastChannelStart)
		end
	end

	for i = 1, 5 do
		local castbar = _G["ElvUF_Arena"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", PostCastChannelStart)
			hooksecurefunc(castbar, "PostCastInterruptible", PostCastInterruptible)
			hooksecurefunc(castbar, "PostChannelStart", PostCastChannelStart)
		end
	end

	for i = 1, MAX_BOSS_FRAMES do
		local castbar = _G["ElvUF_Boss"..i].Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", PostCastChannelStart)
			hooksecurefunc(castbar, "PostCastInterruptible", PostCastInterruptible)
			hooksecurefunc(castbar, "PostChannelStart", PostCastChannelStart)
		end
	end
end

local function InitializeCallback()
	BUIC:Initialize()
end

E:RegisterModule(BUIC:GetName(), InitializeCallback)