local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

function UFB:Update_PartyFrames(frame, db)
	frame.db = db

	do
		--frame.USE_EMPTY_BAR = db.emptybar.enable
		--frame.EMPTY_BARS_HEIGHT = db.emptybar.height
		--frame.EMPTY_BARS_TRANSPARENCY = db.emptybar.transparent
		--frame.EMPTY_BARS_SHADOW = db.emptybar.shadow
		--frame.EMPTY_BAR_THREAT = db.emptybar.threat

		frame.PORTRAIT_HEIGHT = db.portrait.height
		frame.PORTRAIT_TRANSPARENCY = db.portrait.transparent
	end
	
	if not frame.isChild then
		-- EmptyBar
		--UFB:Configure_EmptyBar(frame)
	
		-- Portrait
		--UFB:Configure_Portrait(frame)

		--Threat
		--UFB:Configure_Threat(frame)
	
		-- Target Glow
		--UFB:Configure_TargetGlow(frame)
	
		-- Role Icon
		UFB:Configure_RoleIcons(frame)
	end
	
	frame:UpdateAllElements()
end

function UFB:InitParty()
	hooksecurefunc(UF, 'Update_PartyFrames', UFB.Update_PartyFrames)
end

