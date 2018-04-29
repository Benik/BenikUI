local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G
local CreateFrame = CreateFrame

-- GLOBALS: hooksecurefunc

function UFB:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]

	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateSoftShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	if E.db.benikui.general.benikuiStyle == true then
		frame.Portrait.backdrop:Style('Outside')
		frame.Portrait.backdrop.style:Hide()
	end

	if BUI.ShadowMode then
		frame.Power.backdrop:CreateSoftShadow()
		frame.Power.backdrop.shadow:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangePlayer()
end

function UFB:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db['unitframe']['units'].player

	do
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.player.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.player.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.player.portraitShadow

		frame.PORTRAIT_STYLING = E.db.benikui.unitframes.player.portraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.benikui.unitframes.player.portraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.player.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.player.portraitHeight
		frame.DETACHED_PORTRAIT_STRATA = E.db.benikui.unitframes.player.portraitFrameStrata

		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
		frame.POWER_VERTICAL = db.power.vertical
	end

	-- Power
	UFB:Configure_Power(frame)

	-- InfoPanel
	UFB:Configure_Infopanel(frame)

	-- Portrait
	UFB:Configure_Portrait(frame, true)

	-- Rest Icon
	UFB:Configure_RestingIndicator(frame)

	-- AuraBars shadows
	UFB:Configure_AuraBars(frame)

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitPlayer()
	if not E.db.unitframe.units.player.enable then return end
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "player" then
			UFB:Configure_Portrait(frame, true)
		end
	end)
end