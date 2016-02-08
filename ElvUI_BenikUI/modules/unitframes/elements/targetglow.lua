local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Configure_TargetGlow(frame)
	local SHADOW_SPACING = frame.SHADOW_SPACING
	local tGlow = frame.TargetGlow
	tGlow:ClearAllPoints()

	tGlow:Point("TOPLEFT", -SHADOW_SPACING, SHADOW_SPACING)
	tGlow:Point("TOPRIGHT", SHADOW_SPACING, SHADOW_SPACING)

	if frame.USE_MINI_POWERBAR then
		if frame.USE_EMPTY_BAR then
			tGlow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
			tGlow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)					
		else
			tGlow:Point("BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
			tGlow:Point("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING + (frame.POWERBAR_HEIGHT/2))
		end
	else
		if frame.USE_EMPTY_BAR then
			tGlow:Point("BOTTOMLEFT", frame.EmptyBar, "BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
			tGlow:Point("BOTTOMRIGHT", frame.EmptyBar, "BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)					
		else
			tGlow:Point("BOTTOMLEFT", -SHADOW_SPACING, -SHADOW_SPACING)
			tGlow:Point("BOTTOMRIGHT", SHADOW_SPACING, -SHADOW_SPACING)
		end
	end
end