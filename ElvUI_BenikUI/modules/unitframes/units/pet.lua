local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

function UFB:Construct_PetFrame()
	local frame = _G["ElvUF_Pet"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
	self:ArrangePet()
end

function UFB:ArrangePet()
	local frame = _G["ElvUF_Pet"]
	local db = E.db['unitframe']['units'].pet
	
	do
		frame.USE_EMPTY_BAR = db.emptybar.enable
		frame.EMPTY_BARS_HEIGHT = db.emptybar.height
		frame.EMPTY_BARS_TRANSPARENCY = db.emptybar.transparent
		frame.EMPTY_BARS_SHADOW = db.emptybar.shadow
		frame.EMPTY_BAR_THREAT = db.emptybar.threat
	end

	-- EmptyBar
	UFB:Configure_EmptyBar(frame)
	
	-- Portrait
	UFB:Configure_Portrait(frame)

	--Threat
	UFB:Configure_Threat(frame)
	
	frame:UpdateAllElements()
end

function UFB:InitPet()
	self:Construct_PetFrame()
	hooksecurefunc(UF, 'Update_PetFrame', UFB.ArrangePet)
end