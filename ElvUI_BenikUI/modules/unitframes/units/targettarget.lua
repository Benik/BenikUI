local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

function UFB:ArrangeTargetTarget()
	local frame = _G["ElvUF_TargetTarget"]
	local db = E.db['unitframe']['units'].targettarget;
	
	-- Portrait
	UFB:Configure_Portrait(frame)

	frame:UpdateAllElements()
end

function UFB:InitTargetTarget()
	hooksecurefunc(UF, 'Update_TargetTargetFrame', UFB.ArrangeTargetTarget)
end