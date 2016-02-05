local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

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
	self:ToggleEmptyBarTransparency(frame)
	self:ToggleEmptyBarShadow(frame)
end

function UFB:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db['unitframe']['units'].player

	do
		frame.PORTRAIT_DETACHED = E.db.ufb.detachPlayerPortrait
		frame.USE_EMPTY_BAR = E.db.ufb.barshow
		frame.EMPTY_BARS_HEIGHT = E.db.ufb.barheight
		frame.PLAYER_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
		frame.PLAYER_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
	end

	-- Empty Bar
	do
		UFB:Configure_EmptyBar(frame)
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
				portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and frame.BORDER*2 or frame.BORDER), -frame.BORDER)
			end
		end
	end
	
	--Threat
	do
		UFB:Configure_Threat(frame)
	end
end

function UFB:InitPlayer()
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
end
