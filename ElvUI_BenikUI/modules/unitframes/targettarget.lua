local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local SPACING = E.Spacing;
local BORDER = E.Border;

function UFB:Construct_TargetTargetFrame()
	local frame = _G["ElvUF_TargetTarget"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
	self:ArrangeTargetTarget()
end

function UFB:ArrangeTargetTarget()
	local frame = _G["ElvUF_TargetTarget"]
	local db = E.db.unitframe.units.targettarget;
	local BORDER = E.Border;
	local SPACING = E.Spacing;
	local SHADOW_SPACING = E.PixelMode and 3 or 4
	
	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR
	local POWERBAR_OFFSET = db.power.offset
	local POWERBAR_HEIGHT = db.power.height

	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_WIDTH = db.portrait.width
	
	local USE_EMPTY_BAR = db.emptybar.enable
	local EMPTY_BARS_HEIGHT = db.emptybar.height

	-- EmptyBar
	do
		local emptybar = frame.EmptyBar
		
		if USE_EMPTY_BAR then
			emptybar:Show()
			
			if db.emptybar.transparent then
				emptybar:SetTemplate('Transparent')
			else
				emptybar:SetTemplate('Default')
			end
			
			if USE_POWERBAR_OFFSET then
				emptybar:Point('TOPLEFT', frame.Power, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				emptybar:Point('BOTTOMRIGHT', frame.Power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
				emptybar:Point('TOPLEFT', frame.Health, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				emptybar:Point('BOTTOMRIGHT', frame.Health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif not USE_POWERBAR then
				emptybar:Point('TOPLEFT', frame.Health.backdrop, 'BOTTOMLEFT', 0, E.PixelMode and BORDER or -1)
				emptybar:Point('BOTTOMRIGHT', frame.Health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)
			else
				emptybar:Point('TOPLEFT', frame.Power, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				emptybar:Point('BOTTOMRIGHT', frame.Power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			end
		else
			emptybar:Hide()
		end
	end
	
	-- Portrait
	do
		local portrait = frame.Portrait

		if USE_PORTRAIT then
			portrait:ClearAllPoints()

			if USE_PORTRAIT_OVERLAY then
				portrait:SetAllPoints(frame.Health)
				portrait:SetAlpha(0.3)
				portrait:Show()
				portrait.backdrop:Hide()				
			else
				portrait:SetAlpha(1)
				portrait:Show()
				portrait.backdrop:Show()
				portrait.backdrop:ClearAllPoints()
				portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", POWERBAR_OFFSET, 0)
				
				if db.portrait.transparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end
				
				if USE_EMPTY_BAR then
					if USE_POWERBAR_OFFSET then
						portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
					else
						portrait.backdrop:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMRIGHT", E.PixelMode and -1 or -SPACING, 0)
					end
				elseif USE_MINI_POWERBAR or not USE_POWERBAR or USE_INSET_POWERBAR then
					portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
				else
					portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
				end

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
					if db.emptybar.threat then
						threat.glow:SetOutside(frame.EmptyBar)
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
				
				if USE_MINI_POWERBAR or USE_INSET_POWERBAR then
					if USE_EMPTY_BAR then
						threat.glow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					else
						threat.glow:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
						threat.glow:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
					end
				end
				
				if USE_POWERBAR_OFFSET then
					if USE_EMPTY_BAR and db.emptybar.threat then
						threat.glow:SetOutside(frame.EmptyBar)
					else
						if USE_PORTRAIT and not USE_PORTRAIT_OVERLAY then
							threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
							threat.glow:Point("TOPRIGHT", frame.Health.backdrop,"TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)				
							threat.glow:Point("BOTTOMLEFT", frame.Health.backdrop,"BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
							threat.glow:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
						else
							threat.glow:Point("TOPLEFT", -SHADOW_SPACING+POWERBAR_OFFSET, SHADOW_SPACING)
							threat.glow:Point("TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
							threat.glow:Point("BOTTOMLEFT", -SHADOW_SPACING+POWERBAR_OFFSET, -SHADOW_SPACING+POWERBAR_OFFSET)
							threat.glow:Point("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING+POWERBAR_OFFSET)
						end
					end
				end
			end
		end
	end

	frame:UpdateAllElements()
end

function UFB:InitTargetTarget()
	self:Construct_TargetTargetFrame()
	hooksecurefunc(UF, 'Update_TargetTargetFrame', UFB.ArrangeTargetTarget)
end