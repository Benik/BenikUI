local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

function BU:Configure_Portrait(frame, isPlayer)
	local db = frame.db
	frame.Portrait = (db.portrait.style == '3D' and frame.Portrait3D) or frame.Portrait2D
	local portrait = frame.Portrait

	if frame.USE_PORTRAIT then
		if frame.USE_PORTRAIT_OVERLAY then
			if db.portrait.style == '3D' then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel())
			else
				portrait:SetParent(frame.Health)
			end

			portrait:SetAlpha(db.portrait.overlayAlpha)
			portrait.backdrop:Hide()

			portrait:ClearAllPoints()
			if db.portrait.fullOverlay then
				portrait:SetAllPoints(frame.Health)
			else
				local healthTex = frame.Health:GetStatusBarTexture()
				if db.health.reverseFill then
					portrait:SetPoint("TOPLEFT", healthTex, "TOPLEFT")
					portrait:SetPoint("BOTTOMLEFT", healthTex, "BOTTOMLEFT")
					portrait:SetPoint("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT")
				else
					portrait:SetPoint("TOPLEFT", frame.Health, "TOPLEFT")
					portrait:SetPoint("BOTTOMRIGHT", healthTex, "BOTTOMRIGHT")
					portrait:SetPoint("BOTTOMLEFT", healthTex, "BOTTOMLEFT")
				end
			end
		else
			portrait:SetAlpha(1)
			portrait.backdrop:ClearAllPoints()
			portrait.backdrop:Show()

			if db.portrait.style == '3D' then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel())
			else
				portrait:SetParent(frame)
			end
			
			if frame.PORTRAIT_TRANSPARENCY then
				portrait.backdrop:SetTemplate('Transparent')
			else
				portrait.backdrop:SetTemplate('Default', true)
			end

			if portrait.backdrop.style then
				if frame.PORTRAIT_STYLING then
					portrait.backdrop.style:ClearAllPoints()
					portrait.backdrop.style:SetPoint('TOPLEFT', portrait, 'TOPLEFT', (E.PixelMode and -1 or -2), frame.PORTRAIT_STYLING_HEIGHT)
					portrait.backdrop.style:SetPoint('BOTTOMRIGHT', portrait, 'TOPRIGHT', (E.PixelMode and 1 or 2), (E.PixelMode and 0 or 2))
					portrait.backdrop.style:Show()
					
					if isPlayer then
						if frame.USE_POWERBAR then
							local r, g, b = frame.Power:GetStatusBarColor()
							portrait.backdrop.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
						end
					end
				else
					portrait.backdrop.style:Hide()
				end
			end

			if frame.PORTRAIT_DETACHED then
				frame.portraitmover:SetWidth(frame.DETACHED_PORTRAIT_WIDTH)
				frame.portraitmover:Height(frame.DETACHED_PORTRAIT_HEIGHT)
				portrait.backdrop:SetAllPoints(frame.portraitmover)
				
				if portrait.backdrop.shadow then
					if frame.PORTRAIT_SHADOW then
						portrait.backdrop.shadow:Show()
					else
						portrait.backdrop.shadow:Hide()
					end
				end

				if frame.PORTRAIT_BACKDROP then
					portrait.backdrop:Show()
				else
					portrait.backdrop:Hide()
				end

				if db.portrait.style == '3D' then
					portrait.backdrop:SetFrameStrata(frame.DETACHED_PORTRAIT_STRATA)
					portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
				end
				
				if not frame.portraitmover.mover then
					frame.portraitmover:ClearAllPoints()
					if frame.unit == "player" then
						frame.portraitmover:SetPoint('TOPRIGHT', frame, 'TOPLEFT', -frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PlayerPortraitMover', 'Player Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,player,generalGroup')
					elseif frame.unit == "target" then
						frame.portraitmover:SetPoint('TOPLEFT', frame, 'TOPRIGHT', frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetPortraitMover', 'Target Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,target,generalGroup')
					elseif frame.unit == "targettarget" then
						frame.portraitmover:SetPoint('TOPLEFT', frame, 'TOPRIGHT', frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetTargetPortraitMover', 'TargetTarget Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,targettarget,generalGroup')
					elseif frame.unit == "focus" then
						frame.portraitmover:SetPoint('TOPLEFT', frame, 'TOPRIGHT', frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'FocusPortraitMover', 'Focus Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,focus,generalGroup')
					elseif frame.unit == "pet" then
						frame.portraitmover:SetPoint('TOPLEFT', frame, 'TOPRIGHT', frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PetPortraitMover', 'Pet Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,pet,generalGroup')
					end
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
				else
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
				end
			else
				portrait:SetAlpha(1)
				portrait.backdrop:Show()
				if db.portrait.style == '3D' then
					portrait:SetFrameLevel(frame.Health:GetFrameLevel())
				else
					portrait:SetParent(frame)
				end

				if frame.ORIENTATION == "LEFT" then
					portrait.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", frame.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.PORTRAIT_AND_INFOPANEL then
						portrait.backdrop:SetPoint("BOTTOMRIGHT", frame.InfoPanel, "BOTTOMLEFT", - frame.SPACING*3, -frame.BORDER)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:SetPoint("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					else
						portrait.backdrop:SetPoint("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					end
				elseif frame.ORIENTATION == "RIGHT" then
					portrait.backdrop:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -frame.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.PORTRAIT_AND_INFOPANEL then
						portrait.backdrop:SetPoint("BOTTOMLEFT", frame.InfoPanel, "BOTTOMRIGHT", frame.SPACING*3, -frame.BORDER)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:SetPoint("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
					else
						portrait.backdrop:SetPoint("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
					end
				end
			end
			portrait:SetInside(portrait.backdrop, frame.BORDER)
		end
	end
end

local function ResetPostUpdate()
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub('t(arget)', 'T%1')

		local unitframe = _G['ElvUF_'..frameNameUnit]
		if unitframe then
			if unitframe.Portrait2D then unitframe.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if unitframe.Portrait3D then unitframe.Portrait3D.PostUpdate = UF.PortraitUpdate end
		end
	end

	for unit, unitgroup in pairs(UF.groupunits) do
		local frameNameUnit = E:StringTitle(unit)
		frameNameUnit = frameNameUnit:gsub('t(arget)', 'T%1')

		local unitframe = _G['ElvUF_'..frameNameUnit]
		if unitframe then
			if unitframe.Portrait2D then unitframe.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if unitframe.Portrait3D then unitframe.Portrait3D.PostUpdate = UF.PortraitUpdate end
		end
	end

	for _, header in pairs(UF.headers) do
		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			--group is Tank/Assist Frames, but for Party/Raid we need to go deeper
			if group.Portrait2D then group.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if group.Portrait3D then group.Portrait3D.PostUpdate = UF.PortraitUpdate end

			for j = 1, group:GetNumChildren() do
				--Party/Raid unitbutton
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.Portrait2D then unitbutton.Portrait2D.PostUpdate = UF.PortraitUpdate end
				if unitbutton.Portrait3D then unitbutton.Portrait3D.PostUpdate = UF.PortraitUpdate end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	ResetPostUpdate()
	hooksecurefunc(UF, "PortraitUpdate", BU.Configure_Portrait)
end) 