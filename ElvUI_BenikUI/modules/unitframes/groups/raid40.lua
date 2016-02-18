local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

function UFB:Update_Raid40Frames(frame, db)
	frame.db = db

	do
		--frame.USE_EMPTY_BAR = db.emptybar.enable
		--frame.EMPTY_BARS_HEIGHT = db.emptybar.height
		--frame.EMPTY_BARS_TRANSPARENCY = db.emptybar.transparent
		--frame.EMPTY_BARS_SHADOW = db.emptybar.shadow
		--frame.EMPTY_BAR_THREAT = db.emptybar.threat
	end

	-- EmptyBar
	--UFB:Configure_EmptyBar(frame)
	
	-- Portrait
	--UFB:Configure_Portrait(frame)

	-- Threat
	--UFB:Configure_Threat(frame)
	
	-- Target Glow
	--UFB:Configure_TargetGlow(frame)
	
	-- Role Icon
	UFB:Configure_RoleIcons(frame)

	frame:UpdateAllElements()
end

function UFB:InitRaid40()
	hooksecurefunc(UF, 'Update_Raid40Frames', UFB.Update_Raid40Frames)
end
