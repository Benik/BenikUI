local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUIC = E:NewModule('BuiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');

--[[

	CREDIT:
	This module is based on Blazeflack's ElvUI_CastBarPowerOverlay ==> http://www.tukui.org/addons/index.php?act=view&id=62
	Edited for BenikUI under Blaze's permission. Many thanks :)

]]

-- Defaults
V['BUIC'] = {
	['warned'] = false,
}

-- Create compatibility warning popup
E.PopupDialogs['BUICCompatibility'] = {
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

-- Function to set the size of the castbar depending on various options
function BUIC:CastbarSetSize(unit, bar)
	local cdb = E.db.unitframe.units[unit].castbar;

	if unit == 'player' or unit == 'target' then
		if bar == _G['BUI_PlayerBar'] or bar == _G['BUI_TargetBar'] then
			local UnitUF = BuiUnits[unit][1];
			local Mover = BuiUnits[unit][2];
			local EmptyBar = bar;
			local ebw = EmptyBar:GetWidth();
			local ebh = EmptyBar:GetHeight() - 2;
			local origWidth, origHeight = UnitUF:GetWidth(), 18
			
			if E.db.ufb.barshow and E.db.ufb.attachCastbar then
				-- Set castbar height and width according to EmptyBars
				cdb.width, cdb.height = ebw, ebh

				if cdb.icon == true then
					UnitUF.Castbar.ButtonIcon.bg:Width(cdb.height + (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Height(cdb.height + (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Show()
					UnitUF.Castbar:Width(cdb.width - UnitUF.Castbar.ButtonIcon.bg:GetWidth() - (E.PixelMode and E:Scale(1) or E:Scale(5)))
				else
					UnitUF.Castbar:Width(cdb.width - (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Hide()
				end
			else
				--Reset size back to default
				cdb.width, cdb.height = origWidth, origHeight
				
				if cdb.icon == true then
					UnitUF.Castbar.ButtonIcon.bg:Width(cdb.height + (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Height(cdb.height + (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Show()
					UnitUF.Castbar:Width(cdb.width - UnitUF.Castbar.ButtonIcon.bg:GetWidth() - (E.PixelMode and E:Scale(1) or E:Scale(5)))
					Mover:Width(cdb.width)
				else
					UnitUF.Castbar:Width(cdb.width - (E.PixelMode and E:Scale(2) or E:Scale(4)))
					UnitUF.Castbar.ButtonIcon.bg:Hide()
					Mover:Width(cdb.width)
				end
			end
		end
	end
end

-- Function to position castbar and position and hide text
function BUIC:CastbarSetPosition(unit, bar)
	local cdb = E.db.unitframe.units[unit].castbar;

	if (unit == 'player' and bar == _G['BUI_PlayerBar']) or (unit == 'target' and bar == _G['BUI_TargetBar']) then
		local UnitUF = BuiUnits[unit][1];
		local Mover = BuiUnits[unit][2];
		local EmptyBar = bar;
		
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
			Mover:SetAllPoints(bar)
		else
			-- Reset text
			UnitUF.Castbar.Text:ClearAllPoints()
			UnitUF.Castbar.Text:SetPoint('LEFT', UnitUF.Castbar, 'LEFT', 4, 0)
			UnitUF.Castbar.Time:ClearAllPoints()
			UnitUF.Castbar.Time:SetPoint('RIGHT', UnitUF.Castbar, 'RIGHT', -4, 0)
			UnitUF.Castbar.Text:SetAlpha(1)
			UnitUF.Castbar.Time:SetAlpha(1)

			-- Revert castbar position to default
			Mover:ClearAllPoints()
			Mover:SetPoint('TOPRIGHT', UnitUF and EmptyBar or EmptyBar, 'BOTTOMRIGHT', 0, -(E.PixelMode and E:Scale(3) or E:Scale(6)))
		end
	end
end

-- Function to be called when registered events fire
function BUIC:SetSizeAndPosition()
	if IsAddOnLoaded('ElvUI_CastBarPowerOverlay') or IsAddOnLoaded('ElvUI_CastBarSnap') then
		if E.private.BUIC.warned ~= true then
			-- Warn user about Blaze's CastBarPowerOverlay and CastBarSnap
			E:StaticPopup_Show('BUICCompatibility')
		end
		E.db.ufb.attachCastbar = false
	elseif E.db.ufb.barshow and E.db.ufb.attachCastbar then
		self:UpdatePlayer()
		self:UpdateTarget()
	end

end

function BUIC:PLAYER_ENTERING_WORLD()
	self:ScheduleTimer('SetSizeAndPosition', 10)
end

function BUIC:ACTIVE_TALENT_GROUP_CHANGED()
	self:ScheduleTimer('SetSizeAndPosition', 3)
end

function BUIC:UpdatePlayer()
	self:CastbarSetSize('player', BUI_PlayerBar)
	self:CastbarSetPosition('player', BUI_PlayerBar)
end

function BUIC:UpdateTarget()
	self:CastbarSetSize('target', BUI_TargetBar)
	self:CastbarSetPosition('target', BUI_TargetBar)
end

function BUIC:OnInitialize()

	--ElvUI UnitFrames are not enabled, stop right here!
	if E.private.unitframe.enable ~= true then return end
	
	-- Only hooks if Blaze's ElvUI_CastBarPowerOverlay or ElvUI_CastBarSnap is not loaded
	if not IsAddOnLoaded('ElvUI_CastBarPowerOverlay') or not IsAddOnLoaded('ElvUI_CastBarSnap') then
		hooksecurefunc(UF,'Update_PlayerFrame',function(self)
			if E.db.ufb.barshow and E.db.ufb.attachCastbar then
				BUIC:ScheduleTimer('UpdatePlayer', 0.5)
			end
		end)
	
		-- Hook UF:Update_TargetFrame to also call BUIC:UpdateTarget() on updates
		hooksecurefunc(UF,'Update_TargetFrame',function(self)
			if E.db.ufb.barshow and E.db.ufb.attachCastbar then
				BUIC:ScheduleTimer('UpdateTarget', 0.5)
			end
		end)
	end
	
	--Register a few events we need
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end

E:RegisterModule(BUIC:GetName())