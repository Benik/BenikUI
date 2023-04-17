local BUI, E, L, V, P, G = unpack((select(2, ...)))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame
-- GLOBALS: hooksecurefunc

function BU:Construct_TargetTargetFrame()
	local frame = _G["ElvUF_TargetTarget"]

	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangeTargetTarget()
end

function BU:ArrangeTargetTarget()
	local frame = _G["ElvUF_TargetTarget"]

	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.targettarget.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.targettarget.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.targettarget.portraitShadow
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.targettarget.portraitFrameStrata
		frame.PORTRAIT_BACKDROP = E.db.benikui.unitframes.targettarget.portraitBackdrop

		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.targettarget.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.targettarget.portraitHeight

		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH
	end

	-- Portrait
	BU:Configure_Portrait(frame, false)

	-- InfoPanel
	BU:Configure_Infopanel(frame)

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function BU:InitTargetTarget()
	if not E.db.unitframe.units.targettarget.enable then return end
	self:Construct_TargetTargetFrame()
	hooksecurefunc(UF, 'Update_TargetTargetFrame', BU.ArrangeTargetTarget)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "targettarget" then
			BU:Configure_Portrait(frame, false)
		end
	end)
end