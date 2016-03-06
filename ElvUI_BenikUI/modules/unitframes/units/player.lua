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

	if E.db.benikui.general.benikuiStyle == true then
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
		frame.PORTRAIT_DETACHED = E.db.benikui.unitframes.player.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.benikui.unitframes.player.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.benikui.unitframes.player.portraitShadow
		
		frame.PORTRAIT_STYLING = E.db.benikui.unitframes.player.portraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.benikui.unitframes.player.portraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.benikui.unitframes.player.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.benikui.unitframes.player.portraitHeight
		
		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
	end
	
	-- InfoPanel
	UFB:Configure_Infopanel(frame)
	
	-- Portrait
	UFB:Configure_Portrait(frame, true)

	frame:UpdateAllElements()
end

local function ToggleResourceBar(bars)
	local frame = bars.origParent or bars:GetParent()
	local db = frame.db
	if not db then return end
	frame.CLASSBAR_SHOWN = bars:IsShown()
	
	local height
	if db.classbar then
		height = db.classbar.height
	elseif db.combobar then
		height = db.combobar.height
	elseif frame.AltPowerBar then
		height = db.power.height
	end
	
	if bars.text then
		if frame.CLASSBAR_SHOWN then
			bars.text:SetAlpha(1)
		else
			bars.text:SetAlpha(0)
		end
	end
	
	frame.CLASSBAR_HEIGHT = frame.USE_CLASSBAR and frame.CLASSBAR_SHOWN and height or 0
	frame.CLASSBAR_YOFFSET = (not frame.USE_CLASSBAR or not frame.CLASSBAR_SHOWN or frame.CLASSBAR_DETACHED) and 0 or (frame.USE_MINI_CLASSBAR and ((frame.SPACING+(frame.CLASSBAR_HEIGHT/2))) or (frame.CLASSBAR_HEIGHT - (frame.BORDER-frame.SPACING)))

	if not frame.CLASSBAR_DETACHED then --Only update when necessary
		UF:Configure_HealthBar(frame)
		UF:Configure_Portrait(frame, true) --running :Hide on portrait makes the frame all funky
		UFB:Configure_Portrait(frame, true)
		UF:Configure_Threat(frame)
	end
end
UF.ToggleResourceBar = ToggleResourceBar --Make available to combobar

function UFB:InitPlayer()
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, 'Update_PlayerFrame', UFB.ArrangePlayer)
	hooksecurefunc(UF, 'EclipsePostUpdateVisibility', ToggleResourceBar)
	hooksecurefunc(UF, 'DruidManaPostUpdateVisibility', ToggleResourceBar)
end
