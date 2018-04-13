local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

function UFB:Configure_ClassBar(frame)
	if E.db.benikui.general.benikuiStyle ~= true and E.db.benikui.general.shadows ~= true then return end

	if not frame.VARIABLES_SET then return end
	local bars = frame[frame.ClassBar]
	if not bars then return end

	if not bars.backdrop.shadow then
		bars.backdrop:CreateSoftShadow()
	end

	if (frame.ClassBar == 'ClassIcons' or frame.ClassBar == 'Runes') then
		local maxClassBarButtons = max(UF.classMaxResourceBar[E.myclass] or 0, MAX_COMBO_POINTS)
		for i = 1, maxClassBarButtons do
			if not bars[i].backdrop.shadow then
				bars[i].backdrop:CreateSoftShadow()
			end
		end
	end
end
hooksecurefunc(UF, "Configure_ClassBar", UFB.Configure_ClassBar)