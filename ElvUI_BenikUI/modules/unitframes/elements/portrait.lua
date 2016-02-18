local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Configure_Portrait(frame, isPlayer)
	local portrait = frame.Portrait
	local db = frame.db
	
	local portrait = frame.Portrait
	if frame.USE_PORTRAIT then
		if frame.USE_PORTRAIT_OVERLAY then
			if db.portrait.style == '3D' then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
			end

			portrait:SetAllPoints(frame.Health)
			portrait:SetAlpha(0.3)
			portrait.backdrop:Hide()			
		else		
			portrait:SetAlpha(1)
			portrait.backdrop:ClearAllPoints()
			portrait.backdrop:Show()

			if db.portrait.style == '3D' then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel() -4) --Make sure portrait is behind Health and Power
			end
			
			if frame.PORTRAIT_TRANSPARENCY then
				portrait.backdrop:SetTemplate('Transparent')
			else
				portrait.backdrop:SetTemplate('Default', true)
			end

			if portrait.backdrop.style then
				if frame.PORTRAIT_STYLING then
					portrait.backdrop.style:ClearAllPoints()
					portrait.backdrop.style:Point('TOPLEFT', portrait.backdrop, 'TOPLEFT', 0, frame.PORTRAIT_STYLING_HEIGHT)
					portrait.backdrop.style:Point('BOTTOMRIGHT', portrait.backdrop, 'TOPRIGHT', 0, (E.PixelMode and -1 or 1))
					portrait.backdrop.style:Show()
					
					if isPlayer then
						if frame.USE_POWERBAR then
							local r, g, b = frame.Power:GetStatusBarColor()
							portrait.backdrop.style.color:SetVertexColor(r, g, b)
						end
					end
				else
					portrait.backdrop.style:Hide()
				end
			end

			if frame.PORTRAIT_DETACHED then
				frame.portraitmover:Width(frame.DETACHED_PORTRAIT_WIDTH)
				frame.portraitmover:Height(frame.DETACHED_PORTRAIT_HEIGHT)
				portrait.backdrop:SetAllPoints(frame.portraitmover)
				
				if frame.PORTRAIT_SHADOW then
					portrait.backdrop.shadow:Show()
				else
					portrait.backdrop.shadow:Hide()
				end

				if db.portrait.style == '3D' then
					portrait.backdrop:SetFrameStrata(frame:GetFrameStrata())
					portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
				end
				
				if not frame.portraitmover.mover then
					frame.portraitmover:ClearAllPoints()
					if frame.unit == "player" then
						frame.portraitmover:Point('TOPRIGHT', frame, 'TOPLEFT', -frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PlayerPortraitMover', 'Player Portrait', nil, nil, nil, 'ALL,SOLO')
					elseif frame.unit == "target" then
						frame.portraitmover:Point('TOPLEFT', frame, 'TOPRIGHT', frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetPortraitMover', 'Target Portrait', nil, nil, nil, 'ALL,SOLO')					
					end
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
				else
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")		
				end
				
				if isPlayer then
					local rIcon = frame.Resting
					if db.restIcon then
						rIcon:ClearAllPoints()
						if frame.PORTRAIT_STYLING and portrait.backdrop.style then
							rIcon:SetParent(portrait.backdrop.style)
							rIcon:Point('CENTER', portrait.backdrop.style, 'TOPLEFT')					
						else
							rIcon:SetParent(portrait)
							rIcon:Point('CENTER', portrait, 'TOPLEFT')
						end
					end
				end
			--[[else
				portrait:SetAlpha(1)
				portrait.backdrop:ClearAllPoints()
				portrait.backdrop:Show()

				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame.Health:GetFrameLevel() -4) --Make sure portrait is behind Health and Power
				end
				
				if frame.ORIENTATION == "LEFT" then
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", frame.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.USE_EMPTY_BAR and not frame.USE_POWERBAR_OFFSET then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)						
					else
						if frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
							portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
						else
							portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
						end
					end
				elseif frame.ORIENTATION == "RIGHT" then
					portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", -frame.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.USE_EMPTY_BAR and not frame.USE_POWERBAR_OFFSET then
						portrait.backdrop:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)						
					else
						if frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
							portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
						else
							portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
						end
					end
				end	]]
			end
			-- ElvUI setting
			--portrait:SetInside(portrait.backdrop, frame.BORDER)
			
			-- Keeping BenikUI setting in case of impelementation
			--portrait:ClearAllPoints()
			--portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', frame.BORDER, frame.BORDER)		
			--portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and frame.BORDER*2 or frame.BORDER), -frame.BORDER)
		end
	end
end
