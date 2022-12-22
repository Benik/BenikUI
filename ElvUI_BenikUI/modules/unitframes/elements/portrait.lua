local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

function BU:Configure_Portrait(frame, isPlayer)
	local db = frame.db
	local portrait = (db.portrait.style == '3D' and frame.Portrait3D) or frame.Portrait2D
	portrait.db = db.portrait

	if frame.USE_PORTRAIT then
		if not frame.USE_PORTRAIT_OVERLAY then
			if frame.PORTRAIT_TRANSPARENCY then
				portrait.backdrop:SetTemplate('Transparent')
			else
				portrait.backdrop:SetTemplate('Default', true)
			end

			if portrait.backdrop.style then
				if frame.PORTRAIT_STYLING then
					portrait.backdrop.style:ClearAllPoints()
					portrait.backdrop.style:Point('TOPLEFT', portrait, 'TOPLEFT', (E.PixelMode and -1 or -2), frame.PORTRAIT_STYLING_HEIGHT)
					portrait.backdrop.style:Point('BOTTOMRIGHT', portrait, 'TOPRIGHT', (E.PixelMode and 1 or 2), (E.PixelMode and 0 or 2))
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
				frame.portraitmover:Width(frame.DETACHED_PORTRAIT_WIDTH)
				frame.portraitmover:Height(frame.DETACHED_PORTRAIT_HEIGHT)
				portrait.backdrop:SetAllPoints(frame.portraitmover)

				if portrait.backdrop.shadow then
					if frame.PORTRAIT_SHADOW then
						portrait.backdrop.shadow:Show()
					else
						portrait.backdrop.shadow:Hide()
					end
				end

				portrait.backdrop:SetFrameStrata(frame.DETACHED_PORTRAIT_STRATA)
				if db.portrait.style == '3D' then
					portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
				else
					portrait:SetParent(portrait.backdrop)
				end

				if frame.PORTRAIT_BACKDROP then
					portrait.backdrop:Show()
				else
					portrait.backdrop:Hide()
				end

				if not frame.portraitmover.mover then
					frame.portraitmover:ClearAllPoints()
					if frame.unit == "player" then
						frame.portraitmover:Point('TOPRIGHT', frame, 'TOPLEFT', -UF.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PlayerPortraitMover', 'Player Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,player,generalGroup')
					elseif frame.unit == "target" then
						frame.portraitmover:Point('TOPLEFT', frame, 'TOPRIGHT', UF.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetPortraitMover', 'Target Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,target,generalGroup')
					elseif frame.unit == "targettarget" then
						frame.portraitmover:Point('TOPLEFT', frame, 'TOPRIGHT', UF.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'TargetTargetPortraitMover', 'TargetTarget Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,targettarget,generalGroup')
					elseif frame.unit == "focus" then
						frame.portraitmover:Point('TOPLEFT', frame, 'TOPRIGHT', UF.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'FocusPortraitMover', 'Focus Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,focus,generalGroup')
					elseif frame.unit == "pet" then
						frame.portraitmover:Point('TOPLEFT', frame, 'TOPRIGHT', UF.BORDER, 0)
						E:CreateMover(frame.portraitmover, 'PetPortraitMover', 'Pet Portrait', nil, nil, nil, 'ALL,SOLO,BENIKUI', nil, 'unitframe,pet,generalGroup')
					end
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:Point("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
				else
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:Point("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
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
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", UF.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+UF.SPACING) or -UF.SPACING)
					if frame.PORTRAIT_AND_INFOPANEL then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.InfoPanel, "BOTTOMLEFT", - UF.SPACING*3, -UF.BORDER)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", UF.BORDER - UF.SPACING*3, 0)
					else
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", UF.BORDER - UF.SPACING*3, 0)
					end
				elseif frame.ORIENTATION == "RIGHT" then
					portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", -UF.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+UF.SPACING) or -UF.SPACING)
					if frame.PORTRAIT_AND_INFOPANEL then
						portrait.backdrop:Point("BOTTOMLEFT", frame.InfoPanel, "BOTTOMRIGHT", UF.SPACING*3, -UF.BORDER)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", -UF.BORDER + UF.SPACING*3, 0)
					else
						portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", -UF.BORDER + UF.SPACING*3, 0)
					end
				end
			end
			portrait:SetInside(portrait.backdrop, UF.BORDER, UF.BORDER)
		end
	end
end

local function ResetPostUpdate()
	for _, frame in pairs(UF.units) do
		if frame then
			if frame.Portrait2D then frame.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if frame.Portrait3D then frame.Portrait3D.PostUpdate = UF.PortraitUpdate end
		end
	end

	for unit in pairs(UF.groupunits) do
		local frame = UF[unit]
		if frame then
			if frame.Portrait2D then frame.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if frame.Portrait3D then frame.Portrait3D.PostUpdate = UF.PortraitUpdate end
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