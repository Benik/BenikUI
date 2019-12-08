local BUI, E, L, V, P, G = unpack(select(2, ...))
local BU = BUI:GetModule('Units');
local UF = E:GetModule('UnitFrames');

-- GLOBALS: hooksecurefunc

function BU:Update_PartyFrames(frame, db)
	frame.db = db

	do
		frame.PORTRAIT_HEIGHT = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.height
		frame.PORTRAIT_TRANSPARENCY = db.portrait.transparent
		frame.PORTRAIT_AND_INFOPANEL = E.db.benikui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
	end

	if not frame.isChild then
		-- InfoPanel
		BU:Configure_Infopanel(frame)

		-- Portrait
		BU:Configure_Portrait(frame)

		-- Threat
		BU:Configure_Threat(frame)

		-- Target Glow
		BU:Configure_TargetGlow(frame)
	end

	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function BU:InitParty()
	if not E.db.unitframe.units.party.enable then return end
	hooksecurefunc(UF, 'Update_PartyFrames', BU.Update_PartyFrames)
end