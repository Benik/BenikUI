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

-- Defaults
V['BUIC'] = {
	['warned'] = false,
}

-- Create compatibility warning popup
StaticPopupDialogs['BUICCompatibility'] = {
	text = L['CONFLICT_WARNING'],
	button1 = L['I understand'],
	OnAccept = function() E.private.BUIC.warned = true end,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

--Set size of castbar and position on chosen frame
local function SetCastbarSizeAndPosition(unit, unitframe, bar)
	local cdb = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar

	local frameStrata = bar:GetFrameStrata()
	local frameLevel = bar:GetFrameLevel() + 2

	--Store original frame strata and level
	castbar.origFrameStrata = castbar.origFrameStrata or castbar:GetFrameStrata()
	castbar.origFrameLevel = castbar.origFrameLevel or castbar:GetFrameLevel()

	local barWidth = unitframe:GetWidth() -- using unitframe to get the width when the user types it
	local barHeight = bar:GetHeight()

	-- Set castbar height and width according to chosen overlay panel
	cdb.width, cdb.height = barWidth, barHeight

	-- Update internal settings
	UF:Configure_Castbar(unitframe, true) --2nd argument is to prevent loop

	-- Raise FrameStrata and FrameLevel so castbar stays on top of power bar
	-- If offset is used, the castbar will still stay on top of power bar while staying below health bar.
	castbar:SetFrameStrata(frameStrata)
	castbar:SetFrameLevel(frameLevel)

	-- Position the castbar on overLayFrame
	if castbar.Holder.mover then
		castbar.Holder.mover:ClearAllPoints()
		castbar.Holder.mover:SetPoint("TOPLEFT", bar, "TOPLEFT", -unitframe.SPACING, unitframe.SPACING)
	else
		castbar.Holder:ClearAllPoints()
		castbar.Holder:SetPoint("TOPLEFT", bar, "TOPLEFT", -unitframe.SPACING, unitframe.SPACING)
		castbar.Holder:GetScript('OnSizeChanged')(unitframe.Castbar.Holder)
	end

	castbar.isOverlayed = true
end

--Reset castbar size and position
local function ResetCastbarSizeAndPosition(unit, unitframe)
	local cdb = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	local mover = castbar.Holder.mover

	--Reset size back to default
	cdb.width, cdb.height = E.db.unitframe.units[unit].width, P.unitframe.units[unit].castbar.height

	-- Reset frame strata and level
	castbar:SetFrameStrata(castbar.origFrameStrata)
	castbar:SetFrameLevel(castbar.origFrameLevel)

	-- Update internal settings
	UF:Configure_Castbar(unitframe, true) --2nd argument is to prevent loop

	-- Revert castbar position to default
	if mover then
		local moverName = mover and mover.textString
		if moverName ~= "" and moverName ~= nil then
			E:ResetMovers(moverName)
		end
	end

	castbar.isOverlayed = false
end

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

local min_yOffset = -15

-- Hide Emptybar text when casting
local function ToggleCastbarText(unit, unitframe)

	if E.db.ufb.hideText ~= true then return; end
	if unit == 'player' or unit == 'target' then
	
		unitframe.Castbar:SetScript('OnShow', function(self)
			if E.db.unitframe.units[unit].customTexts == nil then E.db.unitframe.units[unit].customTexts = {} end
			if E.db.unitframe.units[unit].health.yOffset < min_yOffset then
				unitframe.Health.value:Hide()
			end
			
			if E.db.unitframe.units[unit].power.yOffset < min_yOffset then
				unitframe.Power.value:Hide()
			end

			if E.db.unitframe.units[unit].name.yOffset < min_yOffset then
				unitframe.Name:Hide()
			end	
			
			for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
				E.db.unitframe.units[unit].customTexts[objectName].yOffset = E.db.unitframe.units[unit].customTexts[objectName].yOffset or 0
				if E.db.unitframe.units[unit].customTexts[objectName].yOffset < min_yOffset then
					unitframe.customTexts[objectName]:Hide()
				end
			end
		end)

		unitframe.Castbar:SetScript('OnHide', function(self)
			if E.db.unitframe.units[unit].customTexts == nil then E.db.unitframe.units[unit].customTexts = {} end
			if E.db.unitframe.units[unit].health.yOffset < min_yOffset then
				unitframe.Health.value:Show()
			end
			
			if E.db.unitframe.units[unit].power.yOffset < min_yOffset then
				unitframe.Power.value:Show()
			end

			if E.db.unitframe.units[unit].name.yOffset < min_yOffset then
				unitframe.Name:Show()
			end	
			
			for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
				if E.db.unitframe.units[unit].customTexts[objectName].yOffset < min_yOffset then
					unitframe.customTexts[objectName]:Show()
				end
			end
		end)

	end
end

--Detach Castbar Icon
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
end

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.ufb;
	local cdb = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	local bar = unitframe.EmptyBar
	
	if unit == 'player' or unit == 'target' then
		if db.barshow and db.attachCastbar then
			SetCastbarSizeAndPosition(unit, unitframe, bar)
			ConfigureText(unit, castbar)
			DetachIcon(unit, unitframe)
		elseif castbar.isOverlayed then
			ResetCastbarSizeAndPosition(unit, unitframe)
			ResetText(castbar)
		end
	end
end

--Initiate update of unit
function BUIC:UpdateSettings(unit)
	local db = E.db.ufb;
	local cdb = E.db.unitframe.units[unit].castbar;

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

	if IsAddOnLoaded('ElvUI_CastBarPowerOverlay') or IsAddOnLoaded('ElvUI_CastBarSnap') then
		if E.private.BUIC.warned ~= true then
			-- Warn user about Blaze's CastBarPowerOverlay and CastBarSnap
			StaticPopup_Show('BUICCompatibility')
		end
		E.db.ufb.attachCastbar = false
	else
		E.private.BUIC.warned = false
		ToggleCastbarText('player', _G['ElvUF_Player'])
		ToggleCastbarText('target', _G['ElvUF_Target'])
	end

	--Profile changed, update castbar overlay settings
	hooksecurefunc(E, "UpdateAll", function()
		--Delay it a bit to allow all db changes to take effect before we update
		self:ScheduleTimer('UpdateAllCastbars', 0.5)
	end)

	--Castbar was modified, re-apply settings
	hooksecurefunc(UF, "Configure_Castbar", function(self, frame, preventLoop)
		if preventLoop then return; end --I call Configure_Castbar with "true" as 2nd argument

		local unit = frame.unitframeType
		if unit and (unit == 'player' or unit == 'target' or unit == 'focus') and E.db.ufb.barshow and E.db.ufb.attachCastbar then
			BUIC:UpdateSettings(unit)
		end
	end)
end

E:RegisterModule(BUIC:GetName())