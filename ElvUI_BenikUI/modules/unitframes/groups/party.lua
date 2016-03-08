local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Update_PartyFrames(frame, db)
	frame.db = db

	do
		frame.PORTRAIT_HEIGHT = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.height
		frame.PORTRAIT_TRANSPARENCY = db.portrait.transparent
		
		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
	end

	if not frame.isChild then

		-- InfoPanel
		UFB:Configure_Infopanel(frame)

		-- Portrait
		UFB:Configure_Portrait(frame)
		
		-- Threat
		UFB:Configure_Threat(frame)
		
		-- Target Glow
		UFB:Configure_TargetGlow(frame)

	end
	
	frame:UpdateAllElements()
end

function UFB:InitParty()
	hooksecurefunc(UF, 'Update_PartyFrames', UFB.Update_PartyFrames)
end

