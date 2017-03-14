local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');

-- GLOBALS: hooksecurefunc

function UFB:Update_Raid40Frames(frame, db)
	frame.db = db

	do

	end

	if E.db.benikui.general.shadows then
		frame:CreateShadow('Default')
	end

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitRaid40()
	--hooksecurefunc(UF, 'Update_Raid40Frames', UFB.Update_Raid40Frames)
end
