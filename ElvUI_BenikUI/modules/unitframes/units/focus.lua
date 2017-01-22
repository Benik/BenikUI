local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

-- GLOBALS: hooksecurefunc

function UFB:Construct_FocusFrame()
	local frame = _G["ElvUF_Focus"]
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end
	
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f
	
	self:ArrangeFocus()
end

function UFB:ArrangeFocus()
	local frame = _G["ElvUF_Focus"]
	local db = E.db['unitframe']['units'].focus

	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.focus.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.focus.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.focus.portraitShadow
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.focus.portraitFrameStrata

		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.focus.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.focus.portraitHeight	
	end
	
	-- Portrait
	UFB:Configure_Portrait(frame)
	
	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitFocus()
	if not E.db.unitframe.units.focus.enable then return end
	self:Construct_FocusFrame()
	hooksecurefunc(UF, 'Update_FocusFrame', UFB.ArrangeFocus)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "focus" then
			UFB:Configure_Portrait(frame, false)
		end
	end)
end