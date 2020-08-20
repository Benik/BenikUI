local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');

function BU:Configure_TargetGlow(frame)
	local SHADOW_SPACING = frame.SHADOW_SPACING
	local tGlow = frame.TargetGlow
	tGlow:ClearAllPoints()

	if frame.PORTRAIT_HEIGHT > 0 then
		if frame.ORIENTATION == "RIGHT" then
			tGlow:SetPoint("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", frame.SHADOW_SPACING, frame.SHADOW_SPACING)
		else
			tGlow:SetPoint("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -frame.SHADOW_SPACING, frame.SHADOW_SPACING)
		end
	else
		tGlow:SetPoint("TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
		tGlow:SetPoint("TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
	end

	if frame.USE_MINI_POWERBAR then
		tGlow:SetPoint("BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
		tGlow:SetPoint("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
	else
		tGlow:SetPoint("BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
		tGlow:SetPoint("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
	end

	if frame.USE_POWERBAR_OFFSET then
		tGlow:SetPoint("TOPLEFT", -SHADOW_SPACING+frame.POWERBAR_OFFSET, SHADOW_SPACING)
		tGlow:SetPoint("TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)
		tGlow:SetPoint("BOTTOMLEFT", -SHADOW_SPACING+frame.POWERBAR_OFFSET, -SHADOW_SPACING+frame.POWERBAR_OFFSET)
		tGlow:SetPoint("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING+frame.POWERBAR_OFFSET)
	end
end