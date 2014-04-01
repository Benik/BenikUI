local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local SPACING = E.Spacing;
local BORDER = E.Border;

local frame = _G["ElvUF_Target"]
local health = frame.Health
local power = frame.Power
local portrait = frame.Portrait

function UFB:ApplyTargetChanges()

	targetbar = CreateFrame('Frame', 'BUI_TargetBar', E.UIParent)
	targetbar:SetTemplate('Transparent')
	targetbar:SetParent(frame)
	targetbar:SetFrameStrata('BACKGROUND')
	
	if not portrait.backdrop.shadow then
		portrait.backdrop:CreateSoftShadow()
		portrait.backdrop.shadow:Hide()
	end

	self:ArrangeTarget()
end

function UFB:ArrangeTarget()
	local EMPTY_BARS_HEIGHT = E.db.ufb.barheight
	local TargetBar = BUI_TargetBar
	local db = E.db['unitframe']['units'].target
	local UNIT_HEIGHT = db.height
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT

	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local POWERBAR_DETACHED = db.power.detachFromFrame
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR and not POWERBAR_DETACHED
	local PORTRAIT_WIDTH = db.portrait.width
	
	local USE_EMPTY_BAR = E.db.ufb.barshow
	local TARGET_PORTRAIT_WIDTH = E.db.ufb.TargetPortraitWidth
	local TARGET_PORTRAIT_HEIGHT = E.db.ufb.TargetPortraitHeight
	local TARGET_PORTRAIT_DETACHED = E.db.ufb.detachTargetPortrait
	local PLAYER_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
	local PLAYER_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
	
	-- Empty Bar
	do
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
	
	-- portrait
	do
		if USE_PORTRAIT then
			portrait:ClearAllPoints()
			if USE_PORTRAIT_OVERLAY then
				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(health:GetFrameLevel() + 1)
				end
				portrait:SetAllPoints(health)
				portrait:SetAlpha(0.3)
				portrait:Show()		
				portrait.backdrop:Hide()
			else				
				portrait:SetAlpha(1)
				portrait:Show()
				portrait.backdrop:Show()
				portrait.backdrop:ClearAllPoints()
				portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", E.PixelMode and -1 or 0, 0)

				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame:GetFrameLevel() + 5)
				end	
				
				if TARGET_PORTRAIT_DETACHED then
					portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, BORDER)		
					portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -BORDER-BORDER, -BORDER)
					if E.db.ufb.TargetPortraitShadow then
						portrait.backdrop.shadow:Show()
					else
						portrait.backdrop.shadow:Hide()
					end
					if E.db.ufb.getPlayerPortraitSize then
						portrait.backdrop:Width(PLAYER_PORTRAIT_WIDTH)
						portrait.backdrop:Height(PLAYER_PORTRAIT_HEIGHT)					
					else
						portrait.backdrop:Width(TARGET_PORTRAIT_WIDTH)
						portrait.backdrop:Height(TARGET_PORTRAIT_HEIGHT)
					end
					
					if not portrait.backdrop.mover then
						portrait.backdrop:ClearAllPoints()
						portrait.backdrop:Point('TOPLEFT', frame, 'TOPRIGHT')
						portrait.backdrop:SetFrameLevel(power:GetFrameLevel() + 1)
						E:CreateMover(portrait.backdrop, 'TargetPortraitMover', 'Target Portrait', nil, nil, nil, 'ALL,SOLO')
					else
						portrait.backdrop:ClearAllPoints()
						portrait.backdrop:SetPoint("BOTTOMLEFT", portrait.backdrop.mover, "BOTTOMLEFT")
						portrait.backdrop.mover:SetScale(1)
						portrait.backdrop.mover:SetAlpha(1)					
					end

				elseif USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or not USE_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED or USE_EMPTY_BAR then
					portrait.backdrop:Point("BOTTOMLEFT", TargetBar, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)
				else
					portrait.backdrop:Point("BOTTOMLEFT", power, "BOTTOMRIGHT", E.PixelMode and -1 or SPACING, 0)	
				end
				portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, BORDER)		
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -BORDER-BORDER, -BORDER)
			end	
		end
	end
	frame:UpdateAllElements()
end

function UFB:InitTarget()
	self:ApplyTargetChanges()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
end