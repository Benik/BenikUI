local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

function UFB:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]
	
	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	if E.db.bui.buiStyle == true then
		frame.Portrait.backdrop:Style('Outside')
		frame.Portrait.backdrop.style:Hide()
	end
	
	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f
	
	self:ArrangePlayer()
end

function UFB:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db['unitframe']['units'].player

	do
		frame.PORTRAIT_DETACHED = E.db.ufb.detachPlayerPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.ufb.PlayerPortraitTransparent
		frame.PORTRAIT_SHADOW = E.db.ufb.PlayerPortraitShadow
		
		frame.PORTRAIT_STYLING = E.db.ufb.PlayerPortraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.ufb.PlayerPortraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
		
		frame.PORTRAIT_AND_INFOPANEL = E.db.ufb.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
	end
	
	-- InfoPanel
	UFB:Configure_Infopanel(frame)
	
	-- Portrait
	UFB:Configure_Portrait(frame, true)

	frame:UpdateAllElements()
end

function UFB:InitPlayer()
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
end
