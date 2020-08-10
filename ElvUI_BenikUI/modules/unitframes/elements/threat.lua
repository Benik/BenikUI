local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');

function BU:Configure_Threat(frame)
	local threat = frame.ThreatIndicator
	local db = frame.db

	if db.threatStyle ~= 'NONE' and db.threatStyle ~= nil then
		threat:SetFrameStrata('MEDIUM')
		threat.MainGlow:SetFrameStrata('MEDIUM')

		if db.threatStyle == "GLOW" then
			threat:SetFrameStrata('LOW')
			threat.MainGlow:SetFrameStrata('LOW')
			threat.MainGlow:ClearAllPoints()
			if frame.USE_POWERBAR_OFFSET then
				if frame.ORIENTATION == "RIGHT" then
					threat.MainGlow:SetPoint("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -frame.SHADOW_SPACING - frame.SPACING, frame.SHADOW_SPACING + frame.SPACING + (frame.USE_CLASSBAR and (frame.USE_MINI_CLASSBAR and 0 or frame.CLASSBAR_HEIGHT)))
					threat.MainGlow:SetPoint("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", frame.SHADOW_SPACING + frame.SPACING, -frame.SHADOW_SPACING - frame.SPACING)
				else
					threat.MainGlow:SetPoint("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -frame.SHADOW_SPACING - frame.SPACING, frame.SHADOW_SPACING + frame.SPACING + (frame.USE_CLASSBAR and (frame.USE_MINI_CLASSBAR and 0 or frame.CLASSBAR_HEIGHT) or 0))
					threat.MainGlow:SetPoint("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", frame.SHADOW_SPACING + frame.SPACING, -frame.SHADOW_SPACING - frame.SPACING)
				end

				threat.PowerGlow:ClearAllPoints()
				threat.PowerGlow:SetPoint("TOPLEFT", frame.Power.backdrop, "TOPLEFT", -frame.SHADOW_SPACING - frame.SPACING, frame.SHADOW_SPACING + frame.SPACING)
				threat.PowerGlow:SetPoint("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", frame.SHADOW_SPACING + frame.SPACING, -frame.SHADOW_SPACING - frame.SPACING)
			else
				if frame.PORTRAIT_HEIGHT > 0 then
					threat:SetFrameStrata('MEDIUM')
					threat.MainGlow:SetFrameStrata('MEDIUM')
					if frame.ORIENTATION == "RIGHT" then
						threat.MainGlow:SetPoint("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", frame.SHADOW_SPACING, frame.SHADOW_SPACING)
					else
						threat.MainGlow:SetPoint("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING)
					end
				else
					threat.MainGlow:SetPoint("TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING-(frame.USE_MINI_CLASSBAR and frame.CLASSBAR_YOFFSET or 0))
				end
				
				if frame.USE_MINI_POWERBAR then
					threat.MainGlow:SetPoint("BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
					threat.MainGlow:SetPoint("BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
				else
					threat.MainGlow:SetPoint("BOTTOMLEFT", -frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
					threat.MainGlow:SetPoint("BOTTOMRIGHT", frame.SHADOW_SPACING, -frame.SHADOW_SPACING)
				end
			end
		elseif db.threatStyle == "ICONTOPLEFT" or db.threatStyle == "ICONTOPRIGHT" or db.threatStyle == "ICONBOTTOMLEFT" or db.threatStyle == "ICONBOTTOMRIGHT" or db.threatStyle == "ICONTOP" or db.threatStyle == "ICONBOTTOM" or db.threatStyle == "ICONLEFT" or db.threatStyle == "ICONRIGHT" then
			threat:SetFrameStrata('HIGH')
			local point = db.threatStyle
			point = point:gsub("ICON", "")

			threat.TextureIcon:ClearAllPoints()
			threat.TextureIcon:SetPoint(point, frame.Health, point)
		end
	end
end