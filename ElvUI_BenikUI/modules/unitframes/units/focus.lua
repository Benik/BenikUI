local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

-- GLOBALS: hooksecurefunc

function BU:Construct_FocusFrame()
	local frame = UF.focus

	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangeFocus(frame, frame.db)
end

function BU:ArrangeFocus(frame, db)
	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.focus.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.focus.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.focus.portraitShadow
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.focus.portraitFrameStrata

		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.focus.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.focus.portraitHeight
	end

	-- Portrait
	BU:Configure_Portrait(frame)

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function BU:InitFocus()
	if not E.db.unitframe.units.focus.enable then return end
	self:Construct_FocusFrame()
	hooksecurefunc(UF, 'Update_FocusFrame', BU.ArrangeFocus)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "focus" then
			BU:Configure_Portrait(frame, false)
		end
	end)
end
