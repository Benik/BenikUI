local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

local CAN_HAVE_CLASSBAR = (E.myclass == "PALADIN" or E.myclass == "DRUID" or E.myclass == "DEATHKNIGHT" or E.myclass == "WARLOCK" or E.myclass == "PRIEST" or E.myclass == "MONK" or E.myclass == 'MAGE' or E.myclass == 'ROGUE')

function UFB:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]
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
	
	self:ArrangePlayer()
	self:TogglePlayerBarTransparency()
end

function UFB:TogglePlayerBarTransparency()
	local frame = _G["ElvUF_Player"]
	if E.db.ufb.toggleTransparency then
		frame.EmptyBar:SetTemplate('Transparent')
	else
		frame.EmptyBar:SetTemplate('Default')
	end
end

function UFB:TogglePlayerBarShadow()
	local frame = _G["ElvUF_Player"]
	if E.db.ufb.toggleShadow then
		frame.EmptyBar.shadow:Show()
	else
		frame.EmptyBar.shadow:Hide()
	end
end

function UFB:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db['unitframe']['units'].player

	do
		frame.ORIENTATION = db.orientation --allow this value to change when unitframes position changes on screen?
		frame.BORDER = E.Border
		frame.SPACING = E.Spacing
		frame.SHADOW_SPACING = (frame.BORDER*3 - frame.SPACING*3)
		frame.UNIT_WIDTH = db.width
		frame.UNIT_HEIGHT = db.height

		frame.USE_POWERBAR = db.power.enable
		frame.POWERBAR_DETACHED = db.power.detachFromFrame
		frame.USE_INSET_POWERBAR = not frame.POWERBAR_DETACHED and db.power.width == 'inset' and frame.USE_POWERBAR
		frame.USE_MINI_POWERBAR = (not frame.POWERBAR_DETACHED and db.power.width == 'spaced' and frame.USE_POWERBAR)
		frame.USE_POWERBAR_OFFSET = db.power.offset ~= 0 and frame.USE_POWERBAR and not frame.POWERBAR_DETACHED
		frame.POWERBAR_OFFSET_DIRECTION = db.power.offsetDirection
		frame.POWERBAR_OFFSET = frame.USE_POWERBAR_OFFSET and db.power.offset or 0

		frame.POWERBAR_HEIGHT = not frame.USE_POWERBAR and 0 or db.power.height
		frame.POWERBAR_WIDTH = frame.USE_MINI_POWERBAR and (frame.UNIT_WIDTH - (frame.BORDER*2))/2 or (frame.POWERBAR_DETACHED and db.power.detachedWidth or (frame.UNIT_WIDTH - ((frame.BORDER+frame.SPACING)*2)))

		frame.USE_PORTRAIT = db.portrait and db.portrait.enable
		frame.USE_PORTRAIT_OVERLAY = frame.USE_PORTRAIT and (db.portrait.overlay or frame.ORIENTATION == "MIDDLE")
		frame.PORTRAIT_WIDTH = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.width
		frame.PORTRAIT_DETACHED = E.db.ufb.detachPlayerPortrait
		
		frame.CAN_HAVE_CLASSBAR = CAN_HAVE_CLASSBAR
		frame.MAX_CLASS_BAR = frame.MAX_CLASS_BAR or UF.classMaxResourceBar[E.myclass] or 0 --only set this initially
		frame.USE_CLASSBAR = db.classbar.enable and frame.CAN_HAVE_CLASSBAR
		frame.CLASSBAR_SHOWN = frame.CAN_HAVE_CLASSBAR and frame[frame.ClassBar]:IsShown()
		frame.CLASSBAR_DETACHED = db.classbar.detachFromFrame
		frame.USE_MINI_CLASSBAR = db.classbar.fill == "spaced" and frame.USE_CLASSBAR
		frame.CLASSBAR_HEIGHT = frame.USE_CLASSBAR and db.classbar.height or 0
		frame.CLASSBAR_WIDTH = frame.UNIT_WIDTH - ((frame.BORDER+frame.SPACING)*2) - frame.PORTRAIT_WIDTH  - frame.POWERBAR_OFFSET
		frame.CLASSBAR_YOFFSET = (not frame.USE_CLASSBAR or not frame.CLASSBAR_SHOWN or frame.CLASSBAR_DETACHED) and 0 or (frame.USE_MINI_CLASSBAR and (frame.SPACING+(frame.CLASSBAR_HEIGHT/2)) or (frame.CLASSBAR_HEIGHT + frame.SPACING))

		frame.STAGGER_SHOWN = frame.Stagger and frame.Stagger:IsShown()
		frame.STAGGER_WIDTH = frame.STAGGER_SHOWN and (db.stagger.width + (frame.BORDER*2)) or 0;
		
		frame.USE_EMPTY_BAR = E.db.ufb.barshow
		frame.EMPTY_BARS_HEIGHT = E.db.ufb.barheight
		frame.PLAYER_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
		frame.PLAYER_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
	end

	-- Empty Bar
	do
		local health = frame.Health
		local power = frame.Power
		local emptybar = frame.EmptyBar
		
		if frame.USE_EMPTY_BAR then
			emptybar:Show()
			
			if frame.USE_STAGGER then
				stagger:Point('BOTTOMLEFT', emptybar, 'BOTTOMRIGHT', frame.BORDER*2 + (E.PixelMode and 0 or frame.SPACING), frame.BORDER)
				stagger:Point('TOPRIGHT', health, 'TOPRIGHT', frame.STAGGER_WIDTH, 0)
			end
			
			if frame.USE_POWERBAR_OFFSET then
				emptybar:Point('TOPLEFT', power, 'BOTTOMLEFT', -frame.BORDER, 0)
				emptybar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)
			elseif frame.USE_MINI_POWERBAR or frame.USE_INSET_POWERBAR then
				emptybar:Point('TOPLEFT', health, 'BOTTOMLEFT', -frame.BORDER, 0)
				emptybar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)
			elseif frame.POWERBAR_DETACHED or not frame.USE_POWERBAR then
				emptybar:Point('TOPLEFT', health, 'BOTTOMLEFT', -frame.BORDER, 0)
				emptybar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)
			else
				emptybar:Point('TOPLEFT', power, 'BOTTOMLEFT', -frame.BORDER, 0)
				emptybar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', frame.BORDER, -frame.EMPTY_BARS_HEIGHT)
			end
		else
			emptybar:Hide()
		end
	end
	
	-- Portrait
	do	
		local portrait = frame.Portrait
		if frame.USE_PORTRAIT then
			if not frame.USE_PORTRAIT_OVERLAY then
				if E.db.ufb.PlayerPortraitTransparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end

				if E.db.ufb.PlayerPortraitShadow and frame.PORTRAIT_DETACHED then
					portrait.backdrop.shadow:Show()
				else
					portrait.backdrop.shadow:Hide()
				end
				
				local rIcon = frame.Resting
				local power = frame.Power
				
				if frame.PORTRAIT_DETACHED then
					frame.portraitmover:Width(frame.PLAYER_PORTRAIT_WIDTH)
					frame.portraitmover:Height(frame.PLAYER_PORTRAIT_HEIGHT)
					portrait.backdrop:SetAllPoints(frame.portraitmover)

					if portrait.backdrop.style then
						if E.db.ufb.PlayerPortraitStyle then
							portrait.backdrop.style:ClearAllPoints()
							portrait.backdrop.style:Point('TOPLEFT', portrait.backdrop, 'TOPLEFT', 0, E.db.ufb.PlayerPortraitStyleHeight)
							portrait.backdrop.style:Point('BOTTOMRIGHT', portrait.backdrop, 'TOPRIGHT', 0, (E.PixelMode and -1 or 1))
							portrait.backdrop.style:Show()
							if frame.USE_POWERBAR then
								local r, g, b = power:GetStatusBarColor()
								portrait.backdrop.style.color:SetVertexColor(r, g, b)
							end
						else
							portrait.backdrop.style:Hide()
						end
					end

					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameStrata(frame:GetFrameStrata())
						portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
					end
					if not frame.portraitmover.mover then
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:Point('TOPRIGHT', frame, 'TOPLEFT', -frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PlayerPortraitMover', 'Player Portrait', nil, nil, nil, 'ALL,SOLO')
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
					else
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")		
					end
					
					if db.restIcon then
						rIcon:ClearAllPoints()
						if E.db.ufb.PlayerPortraitStyle and portrait.backdrop.style then
							rIcon:SetParent(portrait.backdrop.style)
							rIcon:Point('CENTER', portrait.backdrop.style, 'TOPLEFT')					
						else
							rIcon:SetParent(portrait)
							rIcon:Point('CENTER', portrait, 'TOPLEFT')
						end
					end
				else
					portrait.backdrop:ClearAllPoints()
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", frame.BORDER, 0)

					if frame.USE_EMPTY_BAR then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					else
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					end
					
					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameLevel(frame.Power:GetFrameLevel() + 1)
					end
					
					if db.restIcon then
						rIcon:ClearAllPoints()
						rIcon:SetParent(frame)
						rIcon:Point('CENTER', frame, 'TOPLEFT')
					end
				end
				portrait:ClearAllPoints()
				portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', frame.BORDER, frame.BORDER)		
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and frame.BORDER*2 or frame.BORDER), -frame.BORDER) --Fix portrait overlapping border when pixel mode and 3D style is enabled
			end
		end
	end
	
	--Threat
	do
		local threat = frame.Threat

		if db.threatStyle ~= 'NONE' and db.threatStyle ~= nil then
			if db.threatStyle == "GLOW" then
				threat:SetFrameStrata('MEDIUM')
				threat.glow:SetFrameStrata('MEDIUM')
				threat.glow:ClearAllPoints()

				if frame.USE_EMPTY_BAR then
					threat.glow:SetBackdropBorderColor(0, 0, 0, 0)
					if E.db.ufb.threat then
						threat.glow:Point("TOPLEFT", frame.EmptyBar, "TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING)
					else
						threat.glow:Point("TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))						
					end
					
					threat.glow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
					threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
				else -- ElvUI settings
					if frame.USE_POWERBAR_OFFSET then
						if frame.ORIENTATION == "LEFT" then
							threat.glow:Point("TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))
							threat.glow:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
						elseif frame.ORIENTATION == "RIGHT" then
							threat.glow:Point("TOPRIGHT", frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))
							threat.glow:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
						else
							threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", frame.SHADOW_SPACING, frame.SHADOW_SPACING)
							threat.glow:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
						end
					else
						threat.glow:SetBackdropBorderColor(0, 0, 0, 0)
						threat.glow:Point("TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))

						if frame.USE_MINI_POWERBAR then
							threat.glow:Point("BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
							threat.glow:Point("BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
						else
							threat.glow:Point("BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
							threat.glow:Point("BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
						end
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
end

function UFB:InitPlayer()
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
end
