local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');

-- GLOBALS: hooksecurefunc

function BU:Update_Raid40Frames(frame, db)
	frame.db = db

	do

	end

	if BUI.ShadowMode then
		frame:CreateSoftShadow()
	end

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function BU:InitRaid40()
	--hooksecurefunc(UF, 'Update_Raid40Frames', BU.Update_Raid40Frames)
end