local E, L, V, P, G, _ = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local select = select
local CreateFrame = CreateFrame
local UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction = UnitClass, UnitPowerMax, UnitPowerType, UnitIsPlayer, UnitReaction
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

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
	self:ToggleEmptyBarTransparency(frame)
	self:ToggleEmptyBarShadow(frame)
end

function UFB:RecolorTargetDetachedPortraitStyle()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target
	
	if E.db.ufb.TargetPortraitStyle ~= true or db.portrait.overlay == true then return end
	
	local USE_PORTRAIT = db.portrait.enable
	local targetClass = select(2, UnitClass("target"));

	do
		local portrait = frame.Portrait
		local power = frame.Power

		if USE_PORTRAIT and portrait.backdrop.style and E.db.ufb.TargetPortraitStyle then
			local maxValue = UnitPowerMax("target")
			local pType, pToken, altR, altG, altB = UnitPowerType("target")
			local mu = power.bg.multiplier or 1
			local color = ElvUF['colors'].power[pToken]
			local isPlayer = UnitIsPlayer("target")
			local classColor = RAID_CLASS_COLORS[targetClass]

			if not power.colorClass then
				if maxValue > 0 then
					if color then
						portrait.backdrop.style.color:SetVertexColor(color[1], color[2], color[3])
					else
						portrait.backdrop.style.color:SetVertexColor(altR, altG, altB)
					end
				else
					if color then
						portrait.backdrop.style.color:SetVertexColor(color[1] * mu, color[2] * mu, color[3] * mu)
					end
				end
			else
				local reaction = UnitReaction('target', 'player')
				if maxValue > 0 then
					if isPlayer then
						portrait.backdrop.style.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
					else
						if reaction then
							local tpet = ElvUF.colors.reaction[reaction]
							portrait.backdrop.style.color:SetVertexColor(tpet[1], tpet[2], tpet[3])
						end
					end
				else
					if reaction then
						local t = ElvUF.colors.reaction[reaction]
						portrait.backdrop.style.color:SetVertexColor(t[1] * mu, t[2] * mu, t[3] * mu)
					end
				end
			end	
		end
	end
end

function UFB:ArrangeTarget()
	local frame = _G["ElvUF_Target"]
	local db = E.db['unitframe']['units'].target

	do
		frame.PORTRAIT_DETACHED = E.db.ufb.detachTargetPortrait
		frame.USE_EMPTY_BAR = E.db.ufb.barshow
		frame.EMPTY_BARS_HEIGHT = E.db.ufb.barheight
		frame.TARGET_PORTRAIT_WIDTH = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitWidth or E.db.ufb.TargetPortraitWidth
		frame.TARGET_PORTRAIT_HEIGHT = E.db.ufb.getPlayerPortraitSize and E.db.ufb.PlayerPortraitHeight or E.db.ufb.TargetPortraitHeight
	end
	
	-- Empty Bar
	do
		UFB:Configure_EmptyBar(frame)
	end
	
	--[[ Portrait
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
							portrait.backdrop.style:ClearAllPoints()
							portrait.backdrop.style:Point('TOPLEFT', portrait.backdrop, 'TOPLEFT', 0, E.db.ufb.TargetPortraitStyleHeight)
							portrait.backdrop.style:Point('BOTTOMRIGHT', portrait.backdrop, 'TOPRIGHT', 0, (E.PixelMode and -1 or 1))
							portrait.backdrop.style:Show()
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
	end]]
	
	-- Portrait
	do	
		local portrait = frame.Portrait
		if frame.USE_PORTRAIT then
			if frame.USE_PORTRAIT_OVERLAY then
				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame.Health:GetFrameLevel() + 1)
				end

				portrait:SetAllPoints(frame.Health)
				portrait:SetAlpha(0.3)
				if not dontHide then
					portrait:Show()
				end
				portrait.backdrop:Hide()			
			else
				if E.db.ufb.TargetPortraitTransparent then
					portrait.backdrop:SetTemplate('Transparent')
				else
					portrait.backdrop:SetTemplate('Default', true)
				end

				if E.db.ufb.TargetPortraitShadow and frame.PORTRAIT_DETACHED then
					portrait.backdrop.shadow:Show()
				else
					portrait.backdrop.shadow:Hide()
				end
			
				local rIcon = frame.Resting
				local power = frame.Power
				
				if portrait.backdrop.style then
					if E.db.ufb.TargetPortraitStyle then
						portrait.backdrop.style:ClearAllPoints()
						portrait.backdrop.style:Point('TOPLEFT', portrait.backdrop, 'TOPLEFT', 0, E.db.ufb.TargetPortraitStyleHeight)
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
				
				if frame.PORTRAIT_DETACHED then
					frame.portraitmover:Width(frame.TARGET_PORTRAIT_WIDTH)
					frame.portraitmover:Height(frame.TARGET_PORTRAIT_HEIGHT)
					portrait.backdrop:SetAllPoints(frame.portraitmover)

					if db.portrait.style == '3D' then
						portrait.backdrop:SetFrameStrata(frame:GetFrameStrata())
						portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
					end

					if not frame.portraitmover.mover then
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:Point('TOPRIGHT', frame, 'TOPLEFT', -frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetPortraitMover', 'Target Portrait', nil, nil, nil, 'ALL,SOLO')
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
					else
						frame.portraitmover:ClearAllPoints()
						frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")		
					end				
				else
					portrait:SetAlpha(1)
					if not dontHide then
						portrait:Show()
					end

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
	
	--Threat
	do
		UFB:Configure_Threat(frame)
	end
end

function UFB:PLAYER_TARGET_CHANGED()
	self:ScheduleTimer('RecolorTargetDetachedPortraitStyle', 0.02)
end

function UFB:InitTarget()
	self:Construct_TargetFrame()
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.ArrangeTarget)
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
	hooksecurefunc(UF, 'Update_TargetFrame', UFB.RecolorTargetDetachedPortraitStyle)
end