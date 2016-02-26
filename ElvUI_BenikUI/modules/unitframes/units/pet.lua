local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

function UFB:ArrangePet()
	local frame = _G["ElvUF_Pet"]
	local db = E.db['unitframe']['units'].pet
	
	-- Portrait
	UFB:Configure_Portrait(frame)
	
	frame:UpdateAllElements()
end

function UFB:InitPet()
	hooksecurefunc(UF, 'Update_PetFrame', UFB.ArrangePet)
end