local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

function UFB:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	if E.db.bui.buiStyle == true then
		frame.Portrait.backdrop:Style('Outside')
		frame.Portrait.backdrop.style:Hide()
	end
	
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f
	
	self:ArrangeTarget()
	self:ToggleTargetBarTransparency()
end

function UFB:ToggleTargetBarTransparency()
	local frame = _G["ElvUF_Target"]
	if E.db.ufb.toggleTransparency then
		frame.EmptyBar:SetTemplate('Transparent')
	else
		frame.EmptyBar:SetTemplate('Default')
	end
end

function UFB:ToggleTargetBarShadow()
	local frame = _G["ElvUF_Target"]
	if E.db.ufb.toggleShadow then
		frame.EmptyBar.shadow:Show()
	else
		frame.EmptyBar.shadow:Hide()
	end
end

function UFB:ArrangeTarget()
	local frame = _G["ElvUF_Target"]
	local EMPTY_BARS_HEIGHT = E.db.ufb.barheight
	local TargetBar = frame.EmptyBar
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
	
	local SPACING = E.Spacing;
	local BORDER = E.Border;
	local SHADOW_SPACING = BORDER*4
	local USE_EMPTY_BAR = E.db.ufb.barshow
	local PORTRAIT_WIDTH = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitWidth or E.db.ufb.TargetPortraitWidth
	local PORTRAIT_HEIGHT = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitHeight or E.db.ufb.TargetPortraitHeight
	
	-- Empty Bar
	do
		local health = frame.Health
		local power = frame.Power
		local emptybar = frame.EmptyBar
		
		if USE_EMPTY_BAR then
			emptybar:Show()
			if USE_POWERBAR_OFFSET then
				emptybar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, BORDER - SPACING*3)
				emptybar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)			
			elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
				emptybar:Point('TOPLEFT', health, 'BOTTOMLEFT', -BORDER, BORDER - SPACING*3)
				emptybar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif POWERBAR_DETACHED or not USE_POWERBAR then
				emptybar:Point('TOPLEFT', health.backdrop, 'BOTTOMLEFT', 0, BORDER - SPACING*3)
				emptybar:Point('BOTTOMRIGHT', health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)		
			else
				emptybar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, BORDER - SPACING*3)
				emptybar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			end
		else
			emptybar:Hide()
		end
	end
	
	-- Portrait
	do	
		local portrait = frame.Portrait
		
		if USE_PORTRAIT then

			if not USE_PORTRAIT_OVERLAY then

				if E.db.ufb.TargetPortraitTransparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end

				if E.db.ufb.TargetPortraitShadow and PORTRAIT_DETACHED then
					portrait.backdrop.shadow:Show()
				else
					portrait.backdrop.shadow:Hide()
				end

				if PORTRAIT_DETACHED then
					frame.portraitmover:Width(PORTRAIT_WIDTH)
					frame.portraitmover:Height(PORTRAIT_HEIGHT)
					portrait.backdrop.SetPoint = nil
					portrait.backdrop:SetAllPoints(frame.portraitmover)
					portrait.backdrop.SetPoint = E.noop

					if portrait.backdrop.style then
						if E.db.ufb.TargetPortraitStyle then
							portrait.backdrop.style:Show()
						else
							portrait.backdrop.style:Hide()
						end
						portrait.backdrop.style:ClearAllPoints()
						portrait.backdrop.style:Point('TOPLEFT', portrait.backdrop, 'TOPLEFT', 0, E.db.ufb.TargetPortraitStyleHeight)
						portrait.backdrop.style:Point('BOTTOMRIGHT', portrait.backdrop, 'TOPRIGHT', 0, (E.PixelMode and -1 or 1))
					end
					
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
						portrait.backdrop:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMRIGHT", BORDER - SPACING*3, 0)
						portrait.backdrop.SetPoint = E.noop
					elseif USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or not USE_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED then
						portrait.backdrop.SetPoint = nil
						portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", BORDER - SPACING*3, 0)
						portrait.backdrop.SetPoint = E.noop
					else
						portrait.backdrop.SetPoint = nil
						portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", BORDER - SPACING*3, 0)
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
						threat.glow:Point("TOPLEFT", frame.EmptyBar, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("TOPRIGHT", frame.EmptyBar, "TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					else
						threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
						threat.glow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					end
				else
					threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
					threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
					threat.glow:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
					threat.glow:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
				end

				if USE_MINI_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED then
					if USE_EMPTY_BAR then
						threat.glow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
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
								threat.glow:SetOutside(frame.EmptyBar)
							else
								threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
								threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
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
	self:Construct_TargetFrame()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
end