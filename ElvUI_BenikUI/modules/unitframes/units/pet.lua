local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

-- GLOBALS: hooksecurefunc

function UFB:ArrangePet()
	local frame = _G["ElvUF_Pet"]
	local db = E.db['unitframe']['units'].pet
	
	-- Portrait
	UFB:Configure_Portrait(frame)
	
	frame:UpdateAllElements()
end

function UFB:InitPet()
	if not E.db.unitframe.units.pet.enable then return end
	hooksecurefunc(UF, 'Update_PetFrame', UFB.ArrangePet)
end