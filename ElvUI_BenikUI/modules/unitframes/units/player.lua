local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

function UFB:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]
	frame.EmptyBar = self:CreateEmptyBar(frame)
	
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
	
	if E.myclass == "MONK" then
		frame.Stagger.PostUpdate = UFB.PostUpdateStagger
	end
	
	self:ArrangePlayer()
end

function UFB:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db['unitframe']['units'].player

	do
		frame.USE_EMPTY_BAR = E.db.ufb.barshow
		frame.EMPTY_BARS_HEIGHT = E.db.ufb.barheight
		frame.EMPTY_BARS_TRANSPARENCY = E.db.ufb.toggleTransparency
		frame.EMPTY_BARS_SHADOW = E.db.ufb.toggleShadow
		
		frame.PORTRAIT_DETACHED = E.db.ufb.detachPlayerPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.ufb.PlayerPortraitTransparent
		frame.PORTRAIT_SHADOW = E.db.ufb.PlayerPortraitShadow
		
		frame.PORTRAIT_STYLING = E.db.ufb.PlayerPortraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.ufb.PlayerPortraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.ufb.PlayerPortraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.ufb.PlayerPortraitHeight
	end

	-- Empty Bar
	UFB:Configure_EmptyBar(frame)
	
	-- Portrait
	UFB:Configure_Portrait(frame, true)
	
	--Threat
	UFB:Configure_Threat(frame)
	
	-- Stagger
	if E.myclass == "MONK" then
		UFB:Configure_Stagger(frame)
	end

	frame:UpdateAllElements()
end

function UFB:PostUpdateStagger()
	local frame = self:GetParent()
	local db = frame.db

	local stateChanged = false
	local isShown = self:IsShown()

	--Check if Stagger has changed to be either shown or hidden
	if (frame.STAGGER_SHOWN and not isShown) or (not frame.STAGGER_SHOWN and isShown) then
		stateChanged = true
	end

	frame.STAGGER_SHOWN = isShown

	--[[
		--Use this to force it to show for testing purposes
		self.Hide = self.Show
		self:SetMinMaxValues(0, 100)
		self:SetValue(50)
		self.SetValue = function() end
		self:Show()
		frame.STAGGER_SHOWN = true
	--]]

	--Only update when necessary
	if stateChanged then
		UF:Configure_Stagger(frame)
		UF:Configure_HealthBar(frame)
		UF:Configure_Power(frame)
		UFB:Configure_Stagger(frame)
	end
end

function UFB:InitPlayer()
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
end
