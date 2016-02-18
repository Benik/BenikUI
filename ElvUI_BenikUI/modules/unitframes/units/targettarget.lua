local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

function UFB:Construct_TargetTargetFrame()
	local frame = _G["ElvUF_TargetTarget"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
	self:ArrangeTargetTarget()
end

function UFB:ArrangeTargetTarget()
	local frame = _G["ElvUF_TargetTarget"]
	local db = E.db['unitframe']['units'].targettarget;

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
	UFB:Configure_Portrait(frame)

	--Threat
	--UFB:Configure_Threat(frame)

	frame:UpdateAllElements()
end

function UFB:InitTargetTarget()
	--self:Construct_TargetTargetFrame()
	hooksecurefunc(UF, 'Update_TargetTargetFrame', UFB.ArrangeTargetTarget)
end