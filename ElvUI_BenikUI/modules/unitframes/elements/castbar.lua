local E, L, V, P, G = unpack(ElvUI);
local BUIC = E:NewModule('BuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

--[[

	CREDIT:
	This module is based on Blazeflack's ElvUI_CastBarPowerOverlay ==> http://www.tukui.org/addons/index.php?act=view&id=62
	Edited for BenikUI under Blaze's permission. Many thanks :)
]]


local pairs = pairs
local _G = _G
local IsAddOnLoaded, StaticPopup_Show = IsAddOnLoaded, StaticPopup_Show

--Configure castbar text position and alpha
local function ConfigureText(unit, castbar)
	local db = E.db.ufb;

	if db.castText then
		castbar.Text:SetAlpha(1)
		castbar.Time:SetAlpha(1)
	else
		castbar.Text:SetAlpha(0)
		castbar.Time:SetAlpha(0)
	end

	-- Set position of castbar text according to chosen offsets
	castbar.Text:ClearAllPoints()
	castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, db.yOffsetText)
	castbar.Time:ClearAllPoints()
	castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, db.yOffsetText)
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

-- Show InfoPanel text when casting
local function ToggleCastbarText(unit, unitframe)
	if unit == 'player' or unit == 'target' then
		if E.db.unitframe.units[unit].customTexts == nil then E.db.unitframe.units[unit].customTexts = {} end
		
		if E.db.ufb.ShowInfoText then
			unitframe.Castbar:SetFrameStrata(unitframe.InfoPanel:GetFrameStrata())
			unitframe.Castbar:SetFrameLevel(unitframe.InfoPanel:GetFrameLevel() + 5)
			
			unitframe.Castbar:SetScript('OnShow', function(self)
				if E.db.unitframe.units[unit].health.attachTextTo == 'InfoPanel' then
					unitframe.Health.value:Show()
				end
				
				if E.db.unitframe.units[unit].power.attachTextTo == 'InfoPanel' then
					unitframe.Power.value:Show()
				end

				if E.db.unitframe.units[unit].name.attachTextTo == 'InfoPanel' then
					unitframe.Name:Show()
				end	
				
				for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
					if E.db.unitframe.units[unit].customTexts[objectName].attachTextTo == 'InfoPanel' then
						unitframe.customTexts[objectName]:Show()
					end
				end
			end)
		else
			unitframe.Castbar:SetScript('OnShow', function(self)
				if E.db.unitframe.units[unit].health.attachTextTo == 'InfoPanel' then
					unitframe.Health.value:Hide()
				end
				
				if E.db.unitframe.units[unit].power.attachTextTo == 'InfoPanel' then
					unitframe.Power.value:Hide()
				end

				if E.db.unitframe.units[unit].name.attachTextTo == 'InfoPanel' then
					unitframe.Name:Hide()
				end	
				
				for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
					if E.db.unitframe.units[unit].customTexts[objectName].attachTextTo == 'InfoPanel' then
						unitframe.customTexts[objectName]:Hide()
					end
				end
			end)
			
			unitframe.Castbar:SetScript('OnHide', function(self)
				if E.db.unitframe.units[unit].health.attachTextTo == 'InfoPanel' then
					unitframe.Health.value:Show()
				end
				
				if E.db.unitframe.units[unit].power.attachTextTo == 'InfoPanel' then
					unitframe.Power.value:Show()
				end

				if E.db.unitframe.units[unit].name.attachTextTo == 'InfoPanel' then
					unitframe.Name:Show()
				end	
				
				for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
					if E.db.unitframe.units[unit].customTexts[objectName].attachTextTo == 'InfoPanel' then
						unitframe.customTexts[objectName]:Show()
					end
				end
			end)
		end
	end
end

--[[Detach Castbar Icon
local function DetachIcon(unit, unitframe)
	local cdb = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	
	if cdb.icon == true then
		castbar.ButtonIcon.bg:ClearAllPoints()
		if cdb.detachCastbarIcon then
			castbar.ButtonIcon.bg:Point("TOP", castbar, "BOTTOM", cdb.xOffset, cdb.yOffset)
			castbar.ButtonIcon.bg:Size(cdb.detachediconSize)
			castbar:Width(cdb.width - ((unitframe.BORDER + unitframe.SPACING)*2))
		else
			castbar.ButtonIcon.bg:Width(cdb.height)
			castbar.ButtonIcon.bg:Height(cdb.height)
			if unit == 'player' then
				castbar.ButtonIcon.bg:Point("RIGHT", castbar, "LEFT", -E.Spacing*3, 0)
			elseif unit == 'target' then
				castbar.ButtonIcon.bg:Point("LEFT", castbar, "RIGHT", E.Spacing*3, 0)
			end
			castbar:Width(cdb.width - castbar.ButtonIcon.bg:GetWidth() - (unitframe.BORDER + unitframe.SPACING*5))
		end
	else
		castbar:Width(cdb.width - ((unitframe.BORDER + unitframe.SPACING)*2))
	end
end]]

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	
	if unit == 'player' or unit == 'target' then
		if db.insideInfoPanel then
			ConfigureText(unit, castbar)
			--DetachIcon(unit, unitframe)
		else
			ResetText(castbar)
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

	ToggleCastbarText('player', _G['ElvUF_Player'])
	ToggleCastbarText('target', _G['ElvUF_Target'])

	--Profile changed, update castbar overlay settings
	hooksecurefunc(E, "UpdateAll", function()
		--Delay it a bit to allow all db changes to take effect before we update
		self:ScheduleTimer('UpdateAllCastbars', 0.5)
	end)

	--Castbar was modified, re-apply settings
	hooksecurefunc(UF, "Configure_Castbar", function(self, frame, preventLoop)
		if preventLoop then return; end

		local unit = frame.unitframeType
		if unit and (unit == 'player' or unit == 'target' or unit == 'focus') and E.db.unitframe.units[unit].castbar.insideInfoPanel then
			BUIC:UpdateSettings(unit)
		end
	end)
end

E:RegisterModule(BUIC:GetName())