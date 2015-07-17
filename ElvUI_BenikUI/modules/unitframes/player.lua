local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local SPACING = E.Spacing;
local BORDER = E.Border;

local frame = _G["ElvUF_Player"]

function UFB:ApplyPlayerChanges()

	local playerbar = _G["BUI_PlayerBar"] or CreateFrame('Frame', 'BUI_PlayerBar', E.UIParent)
	playerbar:SetTemplate('Transparent')
	playerbar:SetParent(frame)
	playerbar:SetFrameStrata('BACKGROUND')

	--Create a frame we can anchor portrait.backdrop to.
	--This frame is persistent regardless of portrait style and will fix the issue of portrait not following mover when changing style.
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:TogglePlayerBarTransparency()
	self:ArrangePlayer()
end

function UFB:TogglePlayerBarTransparency()
	if E.db.ufb.toggleTransparency then
		BUI_PlayerBar:SetTemplate('Transparent')
	else
		BUI_PlayerBar:SetTemplate('Default')
	end
end

function UFB:ArrangePlayer()
	local EMPTY_BARS_HEIGHT = E.db.ufb.barheight
	local PlayerBar = BUI_PlayerBar
	local db = E.db['unitframe']['units'].player
	local stagger = frame.Stagger
	local USE_PORTRAIT = db.portrait.enable
	local USE_PORTRAIT_OVERLAY = db.portrait.overlay and USE_PORTRAIT
	local PORTRAIT_DETACHED = E.db.ufb.detachPlayerPortrait

	local USE_POWERBAR = db.power.enable
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local POWERBAR_DETACHED = db.power.detachFromFrame
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR and not POWERBAR_DETACHED
	
	local USE_EMPTY_BAR = E.db.ufb.barshow
	local PLAYER_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
	local PLAYER_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
	local USE_STAGGER = stagger and stagger:IsShown();
	local STAGGER_WIDTH = USE_STAGGER and (db.stagger.width + (BORDER*2)) or 0;

	-- Empty Bar
	do
		local health = frame.Health
		local power = frame.Power
		if USE_EMPTY_BAR then
			PlayerBar:Show()
			
			if USE_STAGGER then
				stagger:Point('BOTTOMLEFT', PlayerBar, 'BOTTOMRIGHT', BORDER*2 + (E.PixelMode and 0 or SPACING), BORDER)
				stagger:Point('TOPRIGHT', health, 'TOPRIGHT', STAGGER_WIDTH, 0)
			end
			
			if USE_POWERBAR_OFFSET then
				PlayerBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				PlayerBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
				PlayerBar:Point('TOPLEFT', health, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				PlayerBar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			elseif POWERBAR_DETACHED or not USE_POWERBAR then
				PlayerBar:Point('TOPLEFT', health.backdrop, 'BOTTOMLEFT', 0, E.PixelMode and BORDER or -1)
				PlayerBar:Point('BOTTOMRIGHT', health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)
			else
				PlayerBar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, E.PixelMode and 0 or -3)
				PlayerBar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
			end
		else
			PlayerBar:Hide()
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
				
				if E.db.ufb.PlayerPortraitTransparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end

				if E.db.ufb.PlayerPortraitShadow and PORTRAIT_DETACHED then
					portrait.backdrop.shadow:SetAlpha(1)
				else
					portrait.backdrop.shadow:SetAlpha(0)
				end

				if PORTRAIT_DETACHED then
					frame.portraitmover:Width(PLAYER_PORTRAIT_WIDTH)
					frame.portraitmover:Height(PLAYER_PORTRAIT_HEIGHT)
					portrait.backdrop:SetAllPoints(frame.portraitmover)
					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameStrata(frame:GetFrameStrata())
						portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
					end
					if not frame.portraitmover.mover then
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:Point('TOPRIGHT', frame, 'TOPLEFT', -BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PlayerPortraitMover', 'Player Portrait', nil, nil, nil, 'ALL,SOLO')
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
					else
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")		
					end
				else
					portrait.backdrop:ClearAllPoints()
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", BORDER, 0)

					if USE_EMPTY_BAR then
						portrait.backdrop:Point("BOTTOMRIGHT", PlayerBar, "BOTTOMLEFT", E.PixelMode and 1 or -SPACING, 0)
					elseif USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or not USE_POWERBAR or USE_INSET_POWERBAR or POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", E.PixelMode and 1 or -SPACING, 0)
					else
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", E.PixelMode and 1 or -SPACING, 0)
					end
					
					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameLevel(frame.Power:GetFrameLevel() + 1)
					end
				end
				portrait:ClearAllPoints()
				portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', BORDER, BORDER)		
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and BORDER*2 or BORDER), -BORDER) --Fix portrait overlapping border when pixel mode and 3D style is enabled
			end
		end
	end
end

function UFB:InitPlayer()
	self:ApplyPlayerChanges()
	hooksecurefunc(UF, 'UpdatePlayerFrameAnchors', UFB.ArrangePlayer) -- class portrait issue fix
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
end