local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame
-- GLOBALS: hooksecurefunc

function UFB:Construct_PetFrame()
	local frame = _G["ElvUF_Pet"]
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end
	
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f
	
	self:ArrangePet()
end

function UFB:ArrangePet()
	local frame = _G["ElvUF_Pet"]
	local db = E.db['unitframe']['units'].pet
	
	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.pet.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.pet.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.pet.portraitShadow
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.pet.portraitFrameStrata

		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.pet.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.pet.portraitHeight	
	end
	
	-- Portrait
	UFB:Configure_Portrait(frame, false)
	
	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitPet()
	if not E.db.unitframe.units.pet.enable then return end
	self:Construct_PetFrame()
	hooksecurefunc(UF, 'Update_PetFrame', UFB.ArrangePet)
	
	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "pet" then
			UFB:Configure_Portrait(frame, false)
		end
	end)
end