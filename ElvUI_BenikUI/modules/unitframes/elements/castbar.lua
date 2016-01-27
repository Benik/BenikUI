local E, L, V, P, G, _ = unpack(ElvUI);
local BUIC = E:NewModule('BuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');

--[[

	CREDIT:
	This module is based on Blazeflack's ElvUI_CastBarPowerOverlay ==> http://www.tukui.org/addons/index.php?act=view&id=62
	Edited for BenikUI under Blaze's permission. Many thanks :)

]]

local pairs = pairs
local _G = _G
local IsAddOnLoaded = IsAddOnLoaded

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

local BuiUnits = {
	['player'] = {ElvUF_Player, ElvUF_PlayerCastbarMover},
	['target'] = {ElvUF_Target, ElvUF_TargetCastbarMover},
}

local min_yOffset = -15

-- Hide Emptybar text when casting
function BUIC:ToggleCastbarText(unit, bar)

	if E.db.ufb.hideText ~= true then return; end
	if unit == 'player' or unit == 'target' then
		if bar == _G['ElvUF_Player'].EmptyBar or bar == _G['ElvUF_Target'].EmptyBar then
			local UnitUF = BuiUnits[unit][1];
			if E.db.unitframe.units[unit].customTexts == nil then E.db.unitframe.units[unit].customTexts = {} end
			
			UnitUF.Castbar:SetScript('OnShow', function(self)
				if E.db.unitframe.units[unit].health.yOffset < min_yOffset then
					UnitUF.Health.value:Hide()
				end
				
				if E.db.unitframe.units[unit].power.yOffset < min_yOffset then
					UnitUF.Power.value:Hide()
				end

				if E.db.unitframe.units[unit].name.yOffset < min_yOffset then
					UnitUF.Name:Hide()
				end	
				
				for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
					E.db.unitframe.units[unit].customTexts[objectName].yOffset = E.db.unitframe.units[unit].customTexts[objectName].yOffset or 0
					if E.db.unitframe.units[unit].customTexts[objectName].yOffset < min_yOffset then
						UnitUF.customTexts[objectName]:Hide()
					end
				end
			end)

			UnitUF.Castbar:SetScript('OnHide', function(self)
				if E.db.unitframe.units[unit].health.yOffset < min_yOffset then
					UnitUF.Health.value:Show()
				end
				
				if E.db.unitframe.units[unit].power.yOffset < min_yOffset then
					UnitUF.Power.value:Show()
				end

				if E.db.unitframe.units[unit].name.yOffset < min_yOffset then
					UnitUF.Name:Show()
				end	
				
				for objectName, _ in pairs(E.db.unitframe.units[unit].customTexts) do
					if E.db.unitframe.units[unit].customTexts[objectName].yOffset < min_yOffset then
						UnitUF.customTexts[objectName]:Show()
					end
				end
			end)
		end
	end
end

-- Function to set the size of the castbar depending on various options
function BUIC:CastbarSetSize(unit, bar)
	local cdb = E.db.unitframe.units[unit].castbar;

	if unit == 'player' or unit == 'target' then
		if bar == _G['ElvUF_Player'].EmptyBar or bar == _G['ElvUF_Target'].EmptyBar then
			local UnitUF = BuiUnits[unit][1];
			local emptybar = UnitUF.EmptyBar;
			
			if E.db.ufb.barshow and E.db.ufb.attachCastbar then
				-- Set castbar height and width according to EmptyBars
				local ebw = emptybar:GetWidth();
				local ebh = emptybar:GetHeight() +(E.PixelMode and -2 or -4);
				cdb.width, cdb.height = ebw, ebh

				if cdb.icon == true then
					UnitUF.Castbar.ButtonIcon.bg:Width(cdb.height)
					UnitUF.Castbar.ButtonIcon.bg:Height(cdb.height)
					UnitUF.Castbar.ButtonIcon.bg:Show()
					UnitUF.Castbar:Width(cdb.width - UnitUF.Castbar.ButtonIcon.bg:GetWidth() - (E.PixelMode and E:Scale(1) or E:Scale(5)))
				else
					UnitUF.Castbar:Width(cdb.width - (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Hide()
				end
				UnitUF.Castbar:Height(cdb.height)
			else
				--Reset size back to default
				cdb.width, cdb.height = UnitUF:GetWidth(), 18
				
				if cdb.icon == true then
					UnitUF.Castbar.ButtonIcon.bg:Width(cdb.height + (E.Border * 2))
					UnitUF.Castbar.ButtonIcon.bg:Height(cdb.height + (E.Border * 2))
					UnitUF.Castbar.ButtonIcon.bg:Show()
					UnitUF.Castbar:Width(cdb.width - UnitUF.Castbar.ButtonIcon.bg:GetWidth() - (E.PixelMode and E:Scale(1) or E:Scale(5)))
				else
					UnitUF.Castbar:Width(cdb.width - (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Hide()
				end
				
				--Make sure the mover resizes accordingly
				UnitUF.Castbar.Holder:Width(cdb.width)
				UnitUF.Castbar.Holder:Height(cdb.height + (E.Border * 2))
				UnitUF.Castbar.Holder:GetScript('OnSizeChanged')(UnitUF.Castbar.Holder)
			end
		end
	end
end

-- Function to position castbar and position
function BUIC:CastbarSetPosition(unit, bar)
	if (unit == 'player' and bar == _G['ElvUF_Player'].EmptyBar) or (unit == 'target' and bar == _G['ElvUF_Target'].EmptyBar) then
		local UnitUF = BuiUnits[unit][1];
		local Mover = BuiUnits[unit][2];
		local emptybar = UnitUF.EmptyBar;
		
		if E.db.ufb.barshow and E.db.ufb.attachCastbar then
			if E.db.ufb.castText then
				UnitUF.Castbar.Text:SetAlpha(1)
				UnitUF.Castbar.Time:SetAlpha(1)
			else
				UnitUF.Castbar.Text:SetAlpha(0)
				UnitUF.Castbar.Time:SetAlpha(0)
			end
		
			-- Set position of castbar text according to chosen y offset
			UnitUF.Castbar.Text:ClearAllPoints()
			UnitUF.Castbar.Text:SetPoint('LEFT', UnitUF.Castbar, 'LEFT', 4, E.db.ufb.yOffsetText)
			UnitUF.Castbar.Time:ClearAllPoints()
			UnitUF.Castbar.Time:SetPoint('RIGHT', UnitUF.Castbar, 'RIGHT', -4, E.db.ufb.yOffsetText)

			-- Position the castbar on top of the EmptyBar
			Mover:ClearAllPoints()
			Mover:Point("TOPLEFT", emptybar, "TOPLEFT", 0, -1) -- Have to use new ElvUI spacings here ****************
		else
			-- Reset text
			UnitUF.Castbar.Text:ClearAllPoints()
			UnitUF.Castbar.Text:SetPoint('LEFT', UnitUF.Castbar, 'LEFT', 4, 0)
			UnitUF.Castbar.Time:ClearAllPoints()
			UnitUF.Castbar.Time:SetPoint('RIGHT', UnitUF.Castbar, 'RIGHT', -4, 0)
			UnitUF.Castbar.Text:SetAlpha(1)
			UnitUF.Castbar.Time:SetAlpha(1)

			-- Revert castbar position to default
			local moverName = Mover.textString
			if moverName ~= "" and moverName ~= nil then
				E:ResetMovers(moverName)
			else
				Mover:ClearAllPoints()
				Mover:SetPoint("TOPLEFT", UnitUF, "BOTTOMLEFT", 0, -(E.PixelMode and E:Scale(1) or E:Scale(3)))
			end
		end
	end
end

-- Function to be called when registered events fire
function BUIC:SetSizeAndPosition()
	if IsAddOnLoaded('ElvUI_CastBarPowerOverlay') or IsAddOnLoaded('ElvUI_CastBarSnap') then
		if E.private.BUIC.warned ~= true then
			-- Warn user about Blaze's CastBarPowerOverlay and CastBarSnap
			StaticPopup_Show('BUICCompatibility')
		end
		E.db.ufb.attachCastbar = false
	elseif E.db.ufb.barshow and E.db.ufb.attachCastbar then
		self:UpdatePlayer()
		self:UpdateTarget()
	end
end

function BUIC:PLAYER_ENTERING_WORLD()
	self:ScheduleTimer('SetSizeAndPosition', 3)
end

function BUIC:ACTIVE_TALENT_GROUP_CHANGED()
	self:ScheduleTimer('SetSizeAndPosition', 3)
end

function BUIC:UpdatePlayer()
	self:CastbarSetSize('player', ElvUF_Player.EmptyBar)
	self:CastbarSetPosition('player', ElvUF_Player.EmptyBar)
end

function BUIC:UpdateTarget()
	self:CastbarSetSize('target', ElvUF_Target.EmptyBar)
	self:CastbarSetPosition('target', ElvUF_Target.EmptyBar)
end

function BUIC:OnInitialize()

	--ElvUI UnitFrames are not enabled, stop right here!
	if E.private.unitframe.enable ~= true then return end
	
	-- Only hooks if Blaze's ElvUI_CastBarPowerOverlay or ElvUI_CastBarSnap is not loaded
	if not IsAddOnLoaded('ElvUI_CastBarPowerOverlay') or not IsAddOnLoaded('ElvUI_CastBarSnap') then
		hooksecurefunc(UF,'Update_PlayerFrame',function(self)
			if E.db.ufb.barshow and E.db.ufb.attachCastbar then
				BUIC:ScheduleTimer('UpdatePlayer', 0.01)
			end
		end)
	
		-- Hook UF:Update_TargetFrame to also call BUIC:UpdateTarget() on updates
		hooksecurefunc(UF,'Update_TargetFrame',function(self)
			if E.db.ufb.barshow and E.db.ufb.attachCastbar then
				BUIC:ScheduleTimer('UpdateTarget', 0.01)
			end
		end)
		self:ToggleCastbarText('player', ElvUF_Player.EmptyBar)
		self:ToggleCastbarText('target', ElvUF_Target.EmptyBar)
	end

	--Register a few events we need
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end

E:RegisterModule(BUIC:GetName())