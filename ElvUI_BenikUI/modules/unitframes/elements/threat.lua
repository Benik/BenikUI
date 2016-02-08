local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Configure_Threat(frame)
	local threat = frame.Threat
	local db = frame.db
	
	if db.threatStyle ~= 'NONE' and db.threatStyle ~= nil then
		if db.threatStyle == "GLOW" then
			threat:SetFrameStrata('MEDIUM')
			threat.glow:SetFrameStrata('MEDIUM')
			threat.glow:ClearAllPoints()

			if frame.USE_EMPTY_BAR then
				threat.glow:SetBackdropBorderColor(0, 0, 0, 0)
				if E.db.ufb.threat or frame.EMPTY_BAR_THREAT then
					threat.glow:Point("TOPLEFT", frame.EmptyBar, "TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING)
				else
					threat.glow:Point("TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))						
				end
				if frame.ORIENTATION == "RIGHT" and frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY and not frame.PORTRAIT_DETACHED then
					threat.glow:Point("BOTTOMLEFT", frame.Portrait.backdrop, "BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
					threat.glow:Point("BOTTOMRIGHT", frame.Portrait.backdrop, "BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING)				
				else
					threat.glow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
					threat.glow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
				end
			else
				if frame.USE_POWERBAR_OFFSET then
					if frame.ORIENTATION == "LEFT" then
						threat.glow:Point("TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))
						threat.glow:Point("BOTTOMRIGHT", frame.Health, "BOTTOMRIGHT", frame.SHADOW_SPACING + frame.BORDER + frame.SPACING, -frame.SHADOW_SPACING - frame.BORDER - frame.SPACING)
					elseif frame.ORIENTATION == "RIGHT" then
						threat.glow:Point("TOPRIGHT", frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))
						threat.glow:Point("BOTTOMLEFT", frame.Health, "BOTTOMLEFT", -frame.SHADOW_SPACING -frame.BORDER - frame.SPACING, -frame.SHADOW_SPACING -frame.BORDER - frame.SPACING)
					else
						threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", frame.SHADOW_SPACING +frame.SPACING, frame.SHADOW_SPACING +frame.SPACING)
						threat.glow:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMLEFT", -frame.SHADOW_SPACING -frame.SPACING, -frame.SHADOW_SPACING -frame.SPACING)
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