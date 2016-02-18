local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

function UFB:ArrangeFocus()
	local frame = _G["ElvUF_Focus"]
	local db = E.db['unitframe']['units'].focus

	do

	end
	
	-- Portrait
	UFB:Configure_Portrait(frame)
	
	frame:UpdateAllElements()
end

function UFB:InitFocus()
	hooksecurefunc(UF, 'Update_FocusFrame', UFB.ArrangeFocus)
end