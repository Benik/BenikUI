local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

function UFB:Configure_ClassBar(frame)
	if not BUI.ShadowMode then return end

	if not frame.VARIABLES_SET then return end
	local bars = frame[frame.ClassBar]
	if not bars then return end

	if not bars.backdrop.shadow then
		bars.backdrop:CreateSoftShadow()
	end

	if frame.shadow then
		frame.shadow:ClearAllPoints()
		if frame.USE_MINI_CLASSBAR and not frame.CLASSBAR_DETACHED then
			frame.shadow:Point('TOPLEFT', frame.Health.backdrop, 'TOPLEFT', -2, 2)
			frame.shadow:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 2, -2)
			bars.backdrop.shadow:Show()
		elseif not frame.CLASSBAR_DETACHED then
			frame.shadow:SetOutside(frame, 2, 2)
			bars.backdrop.shadow:Hide()
		else
			frame.shadow:SetOutside(frame, 2, 2)
			bars.backdrop.shadow:Show()
		end
	end

	if (frame.ClassBar == 'ClassPower' or frame.ClassBar == 'Runes') then
		local maxBars = max(UF['classMaxResourceBar'][E.myclass] or 0, MAX_COMBO_POINTS)
		for i = 1, maxBars do
			if not bars[i].backdrop.shadow then
				bars[i].backdrop:CreateSoftShadow()
			end
		end
	end
end
hooksecurefunc(UF, "Configure_ClassBar", UFB.Configure_ClassBar)

