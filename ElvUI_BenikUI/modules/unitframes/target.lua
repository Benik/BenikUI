local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local SPACING = E.Spacing;
local BORDER = E.Border;

local frame = _G["ElvUF_Target"]

function UFB:ApplyTargetChanges()

	local targetbar = _G["BUI_TargetBar"] or CreateFrame('Frame', 'BUI_TargetBar', E.UIParent)
	targetbar:SetTemplate('Transparent')
	targetbar:SetParent(frame)
	targetbar:SetFrameStrata('BACKGROUND')
	
	--Create a frame we can anchor portrait.backdrop to.
	--This frame is persistent regardless of portrait style and will fix the issue of portrait not following mover when changing style.
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ToggleTargetBarTransparency()
	self:ArrangeTarget()
end

function UFB:ToggleTargetBarTransparency()
	if E.db.ufb.toggleTransparency then
		BUI_TargetBar:SetTemplate('Transparent')
	else
		BUI_TargetBar:SetTemplate('Default')
	end
end

function UFB:ArrangeTarget()
	local EMPTY_BARS_HEIGHT = E.db.ufb.barheight
	local TargetBar = BUI_TargetBar
	local db = E.db['unitframe']['units'].target
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_DETACHED = E.db.ufb.detachTargetPortrait

	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local POWERBAR_DETACHED = db.power.detachFromFrame
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR and not POWERBAR_DETACHED
	local POWERBAR_OFFSET = db.power.offset
	
	local SHADOW_SPACING = E.PixelMode and 3 or 4
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
				TargetBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				TargetBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)			
			elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
				TargetBar:Point('TOPLEFT', health, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				TargetBar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif POWERBAR_DETACHED or not USE_POWERBAR then
				TargetBar:Point('TOPLEFT', health.backdrop, 'BOTTOMLEFT', 0, E.PixelMode and BORDER or -1)
				TargetBar:Point('BOTTOMRIGHT', health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)		
			else
				TargetBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				TargetBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			end
		else
			TargetBar:Hide()
		end
	end
	
	-- Portrait
	do	
		local portrait = frame.Portrait
		
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
					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameStrata(frame:GetFrameStrata())
						portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
					end

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
				portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, BORDER)		
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -BORDER, -BORDER)	
			end
		end
	end
	
	--Threat
	do
		local threat = frame.Threat

		if db.threatStyle ~= 'NONE' and db.threatStyle ~= nil then
			if db.threatStyle == "GLOW" then
				threat:SetFrameStrata('BACKGROUND')
				threat.glow:ClearAllPoints()
				threat.glow:SetBackdropBorderColor(0, 0, 0, 0)
				
				if USE_EMPTY_BAR then
					if E.db.ufb.threat then
						threat.glow:SetOutside(TargetBar)
					else
						threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("BOTTOMLEFT", TargetBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", TargetBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					end
				else
					threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
					threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
					threat.glow:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
					threat.glow:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
				end

				if USE_MINI_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED then
					if USE_EMPTY_BAR then
						threat.glow:Point("BOTTOMLEFT", TargetBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", TargetBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					else
						threat.glow:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					end
				end
				
				if USE_POWERBAR_OFFSET then
					if USE_PORTRAIT and not USE_PORTRAIT_OVERLAY then
						threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("TOPRIGHT", frame.Health.backdrop,"TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)				
						threat.glow:Point("BOTTOMLEFT", frame.Health.backdrop,"BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING+POWERBAR_OFFSET)
					else
						threat.glow:Point("TOPLEFT", -SHADOW_SPACING+POWERBAR_OFFSET, SHADOW_SPACING)
						threat.glow:Point("TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("BOTTOMLEFT", -SHADOW_SPACING+POWERBAR_OFFSET, -SHADOW_SPACING+POWERBAR_OFFSET)
						threat.glow:Point("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING+POWERBAR_OFFSET)
					end
				end

				if USE_PORTRAIT and not USE_PORTRAIT_OVERLAY then
					if PORTRAIT_DETACHED then
						if USE_EMPTY_BAR then
							if E.db.ufb.threat and USE_POWERBAR_OFFSET then
								threat.glow:SetOutside(TargetBar)
							else
								threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
								threat.glow:Point("BOTTOMRIGHT", TargetBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
							end
						else
							threat.glow:Point("TOPRIGHT", frame.Portrait.backdrop, "TOPRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
							threat.glow:Point("BOTTOMRIGHT", frame.Portrait.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)					
						end
					else
						threat.glow:Point("TOPRIGHT", frame.Portrait.backdrop, "TOPRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					end
				end
			elseif db.threatStyle == "ICONTOPLEFT" or db.threatStyle == "ICONTOPRIGHT" or db.threatStyle == "ICONBOTTOMLEFT" or db.threatStyle == "ICONBOTTOMRIGHT" or db.threatStyle == "ICONTOP" or db.threatStyle == "ICONBOTTOM" or db.threatStyle == "ICONLEFT" or db.threatStyle == "ICONRIGHT" then
				threat:SetFrameStrata('HIGH')
				local point = db.threatStyle
				point = point:gsub("ICON", "")

				threat.texIcon:ClearAllPoints()
				threat.texIcon:SetPoint(point, frame.Health, point)
			end
		end
	end
	
	frame:UpdateAllElements()
end

function UFB:InitTarget()
	self:ApplyTargetChanges()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
end