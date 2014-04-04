local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local SPACING = E.Spacing;
local BORDER = E.Border;

local frame = _G["ElvUF_Target"]

function UFB:ApplyTargetChanges()

	targetbar = _G["BUI_TargetBar"] or CreateFrame('Frame', 'BUI_TargetBar', E.UIParent)
	targetbar:SetTemplate('Transparent')
	targetbar:SetParent(frame)
	targetbar:SetFrameStrata('BACKGROUND')
	
	--Create a frame we can anchor portrait.backdrop to.
	--This frame is persistent regardless of portrait style and will fix the issue of portrait not following mover when changing style.
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangeTarget()
end

function UFB:ArrangeTarget()
	local EMPTY_BARS_HEIGHT = E.db.ufb.barheight
	local TargetBar = BUI_TargetBar
	local db = E.db['unitframe']['units'].target
	local UNIT_HEIGHT = db.height
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_DETACHED = E.db.ufb.detachTargetPortrait

	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local POWERBAR_DETACHED = db.power.detachFromFrame
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR and not POWERBAR_DETACHED
	
	local USE_EMPTY_BAR = E.db.ufb.barshow
	local PORTRAIT_WIDTH = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitWidth or E.db.ufb.TargetPortraitWidth
	local PORTRAIT_HEIGHT = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitHeight or E.db.ufb.TargetPortraitHeight
	
	-- Empty Bar
	do
		local health = frame.Health
		local power = frame.Power
		if USE_EMPTY_BAR then
			TargetBar:Show()
			if USE_POWERBAR_OFFSET then
				TargetBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, 0)
				TargetBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)			
			elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
				TargetBar:Point('TOPLEFT', health, 'BOTTOMLEFT', -BORDER, 0)
				TargetBar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif POWERBAR_DETACHED or not USE_POWERBAR then
				TargetBar:Point('TOPLEFT', health.backdrop, 'BOTTOMLEFT', 0, BORDER)
				TargetBar:Point('BOTTOMRIGHT', health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)		
			else
				TargetBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, BORDER)
				TargetBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			end
		else
			TargetBar:Hide()
		end
	end
	
	-- Portrait
	do	
		local portrait = frame.Portrait --Need to make them local here, since frame.Portrait changes whether you use 2D or 3D. It needs to update when executed.
		if USE_PORTRAIT then
			if not USE_PORTRAIT_OVERLAY then
				if not portrait.backdrop.shadow then
					portrait.backdrop:CreateSoftShadow()
					portrait.backdrop.shadow:SetAlpha(0)
				end

				if E.db.ufb.TargetPortraitTransparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end

				if E.db.ufb.TargetPortraitShadow and PORTRAIT_DETACHED then
					portrait.backdrop.shadow:SetAlpha(1)
				else
					portrait.backdrop.shadow:SetAlpha(0)
				end

				if PORTRAIT_DETACHED then
					frame.portraitmover:Width(PORTRAIT_WIDTH)
					frame.portraitmover:Height(PORTRAIT_HEIGHT)
					portrait.backdrop.SetPoint = nil
					portrait.backdrop:SetAllPoints(frame.portraitmover)
					portrait.backdrop.SetPoint = E.noop

					if not frame.portraitmover.mover then
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:Point('TOPLEFT', frame, 'TOPRIGHT', BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetPortraitMover', 'Target Portrait', nil, nil, nil, 'ALL,SOLO')
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
					else
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")	
					end
				else
					portrait.backdrop:ClearAllPoints()
					portrait.backdrop.SetPoint = nil
					portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", BORDER, 0)
					portrait.backdrop.SetPoint = E.noop

					if USE_EMPTY_BAR then
						portrait.backdrop.SetPoint = nil
						portrait.backdrop:Point("BOTTOMLEFT", TargetBar, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
						portrait.backdrop.SetPoint = E.noop
					elseif USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or not USE_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED then
						portrait.backdrop.SetPoint = nil
						portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
						portrait.backdrop.SetPoint = E.noop
					else
						portrait.backdrop.SetPoint = nil
						portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
						portrait.backdrop.SetPoint = E.noop
					end

					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameLevel(frame.Power:GetFrameLevel() + 1)
					end
				end
				portrait:ClearAllPoints()
				portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, E.PixelMode and BORDER*2 or BORDER)		
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and BORDER*2 or BORDER), -BORDER) --Fix portrait overlapping border when pixel mode and 3D style is enabled
			end
		end
	end
	frame:UpdateAllElements()
end

function UFB:InitTarget()
	self:ApplyTargetChanges()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
end