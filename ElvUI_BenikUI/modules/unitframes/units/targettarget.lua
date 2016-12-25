local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame
-- GLOBALS: hooksecurefunc

function UFB:Construct_TargetTargetFrame()
	local frame = _G["ElvUF_TargetTarget"]
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end
	
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f
	
	self:ArrangeTargetTarget()
end

function UFB:ArrangeTargetTarget()
	local frame = _G["ElvUF_TargetTarget"]
	local db = E.db['unitframe']['units'].targettarget;
	
	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.targettarget.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.targettarget.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.targettarget.portraitShadow
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.targettarget.portraitFrameStrata

		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.targettarget.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.targettarget.portraitHeight	
	end
	
	-- Portrait
	UFB:Configure_Portrait(frame, false)

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitTargetTarget()
	if not E.db.unitframe.units.targettarget.enable then return end
	self:Construct_TargetTargetFrame()
	hooksecurefunc(UF, 'Update_TargetTargetFrame', UFB.ArrangeTargetTarget)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "targettarget" then
			UFB:Configure_Portrait(frame, false)
		end
	end)
end