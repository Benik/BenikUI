local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

-- GLOBALS: hooksecurefunc

function UFB:Update_Raid40Frames(frame, db)
	frame.db = db

	do

	end

	frame:UpdateAllElements()
end

function UFB:InitRaid40()
	--hooksecurefunc(UF, 'Update_Raid40Frames', UFB.Update_Raid40Frames)
end
