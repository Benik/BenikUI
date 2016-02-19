local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Update_PartyFrames(frame, db)
	frame.db = db

	do
		frame.PORTRAIT_HEIGHT = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.height
		frame.PORTRAIT_TRANSPARENCY = db.portrait.transparent
	end
	
	if not frame.isChild then
		-- Portrait
		UFB:Configure_Portrait(frame)
		
		-- Threat
		UFB:Configure_Threat(frame)
		
		-- Target Glow
		UFB:Configure_TargetGlow(frame)

		-- Role Icon
		UFB:Configure_RoleIcons(frame)
	end
	
	frame:UpdateAllElements()
end

function UFB:InitParty()
	hooksecurefunc(UF, 'Update_PartyFrames', UFB.Update_PartyFrames)
end

