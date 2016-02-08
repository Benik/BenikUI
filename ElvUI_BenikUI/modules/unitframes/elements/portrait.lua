local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Configure_SimplePortrait(frame)
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
			
			if frame.ORIENTATION == "LEFT" then
				portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", frame.SPACING, frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
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
				portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", -frame.SPACING, frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
				if frame.USE_EMPTY_BAR and not frame.USE_POWERBAR_OFFSET then
					portrait.backdrop:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)						
				else
					if frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
					else
						portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
					end
				end
			end	

			-- ElvUI setting
			portrait:SetInside(portrait.backdrop, frame.BORDER)
			
			-- Keeping BenikUI setting in case of impelementation
			--portrait:ClearAllPoints()
			--portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', frame.BORDER, frame.BORDER)		
			--portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and frame.BORDER*2 or frame.BORDER), -frame.BORDER)
		end
	end
end

function UFB:Configure_Portrait(frame, detached, isPlayer, isTarget)
	local portrait = frame.Portrait
	local db = frame.db
	
	if frame.USE_PORTRAIT then
		if frame.USE_PORTRAIT_OVERLAY then
			if db.portrait.style == '3D' then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
			end

			portrait:SetAllPoints(frame.Health)
			portrait:SetAlpha(0.3)
			--[[if not dontHide then
				portrait:Show()
			end]]
			portrait.backdrop:Hide()			
		else
			if frame.PORTRAIT_TRANSPARENCY then
				portrait.backdrop:SetTemplate('Transparent')
			else
				portrait.backdrop:SetTemplate('Default', true)
			end

			if frame.PORTRAIT_SHADOW and E.db.detachPlayerPortrait then
				portrait.backdrop.shadow:Show()
			else
				portrait.backdrop.shadow:Hide()
			end
		
			local rIcon = frame.Resting
			local power = frame.Power
			
			if portrait.backdrop.style then
				if E.db.ufb.PlayerPortraitStyle then
					portrait.backdrop.style:ClearAllPoints()
					portrait.backdrop.style:Point('TOPLEFT', portrait.backdrop, 'TOPLEFT', 0, frame.DETACHED_PORTRAIT_HEIGHT)
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
			
			if E.db.detachPlayerPortrait then
				print("Portrait Detached")
				frame.portraitmover:Width(frame.DETACHED_PORTRAIT_WIDTH)
				frame.portraitmover:Height(frame.DETACHED_PORTRAIT_HEIGHT)
				portrait.backdrop:SetAllPoints(frame.portraitmover)
				
				
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
					if db.portrait.benikuiStyle and portrait.backdrop.style then
						rIcon:SetParent(portrait.backdrop.style)
						rIcon:Point('CENTER', portrait.backdrop.style, 'TOPLEFT')					
					else
						rIcon:SetParent(portrait)
						rIcon:Point('CENTER', portrait, 'TOPLEFT')
					end
				end
			else
				print("Portrait NOT Detached")
				portrait:SetAlpha(1)
				--if not dontHide then
					--portrait:Show()
				--end
				
				portrait.backdrop:ClearAllPoints()

				portrait.backdrop:Show()
				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame.Health:GetFrameLevel() -4) --Make sure portrait is behind Health and Power
				end
				
				if frame.ORIENTATION == "LEFT" then
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", frame.SPACING, frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
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
					portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", -frame.SPACING, frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.USE_EMPTY_BAR and not frame.USE_POWERBAR_OFFSET then
						portrait.backdrop:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)						
					else
						if frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
							portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
						else
							portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
						end
					end
				end	
			end
			-- ElvUI setting
			portrait:SetInside(portrait.backdrop, frame.BORDER)
			
			-- Keeping BenikUI setting in case of impelementation
			--portrait:ClearAllPoints()
			--portrait:Point('BOTTOMLEFT', portrait.backdrop, 'BOTTOMLEFT', frame.BORDER, frame.BORDER)		
			--portrait:Point('TOPRIGHT', portrait.backdrop, 'TOPRIGHT', -(E.PixelMode and db.portrait.style == '3D' and frame.BORDER*2 or frame.BORDER), -frame.BORDER)
		end
	end
end
