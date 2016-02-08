local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

function UFB:Construct_FocusFrame(frame)
	local frame = _G["ElvUF_Focus"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
	self:ArrangeFocus()
end

function UFB:ArrangeFocus()
	local frame = _G["ElvUF_Focus"]
	local db = E.db.unitframe.units.focus

	do
		frame.USE_EMPTY_BAR = db.emptybar.enable
		frame.EMPTY_BARS_HEIGHT = db.emptybar.height
		frame.EMPTY_BARS_TRANSPARENCY = db.emptybar.transparent
		frame.EMPTY_BARS_SHADOW = db.emptybar.shadow
		frame.EMPTY_BAR_THREAT = db.emptybar.threat
	end

	-- EmptyBar
	do
		UFB:Configure_EmptyBar(frame)
	end
	
	-- Portrait
	do
		UFB:Configure_SimplePortrait(frame)
	end

	--Threat
	do
		UFB:Configure_Threat(frame)
	end
	
	frame:UpdateAllElements()
end

function UFB:InitFocus()
	self:Construct_FocusFrame()
	hooksecurefunc(UF, 'Update_FocusFrame', UFB.ArrangeFocus)
end