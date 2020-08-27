local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');

function BU:Configure_ClassBar(frame)
	if not BUI.ShadowMode then return end

	local db = E.db.benikui.general
	local bars = frame[frame.ClassBar]
	if not bars then return end

	if not bars.backdrop.shadow then
		bars.backdrop:CreateSoftShadow()
	end

	if frame.shadow then
		frame.shadow:ClearAllPoints()
		if frame.USE_MINI_CLASSBAR and not frame.CLASSBAR_DETACHED then
			frame.shadow:SetPoint('TOPLEFT', frame.Health.backdrop, 'TOPLEFT', -(db.shadowSize -1) or -2, (db.shadowSize -1) or 2)
			frame.shadow:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', (db.shadowSize -1) or 2, -(db.shadowSize -1) or -2)
			bars.backdrop.shadow:Show()
		elseif not frame.CLASSBAR_DETACHED then
			frame.shadow:SetOutside(frame, (db.shadowSize - 1) or 2, (db.shadowSize - 1) or 2)
			bars.backdrop.shadow:Hide()
		else
			frame.shadow:SetOutside(frame, (db.shadowSize - 1) or 2, (db.shadowSize - 1) or 2)
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

