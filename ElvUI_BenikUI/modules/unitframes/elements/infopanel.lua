local BUI, E, L, V, P, G = unpack((select(2, ...)))
local UF = E:GetModule('UnitFrames')
local BU = BUI:GetModule('Units')
local LSM = E.LSM

function BU:Configure_Infopanel(frame)
	if frame.IS_ELTREUM then return end

	if frame.ORIENTATION == "RIGHT" and not (frame.unitframeType == "arena") then
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.PORTRAIT_WIDTH -UF.BORDER - UF.SPACING, UF.BORDER + UF.SPACING)
		else
			frame.InfoPanel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -UF.BORDER - UF.SPACING, UF.BORDER + UF.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:Point("TOPLEFT", frame.Power.backdrop, "BOTTOMLEFT", UF.BORDER, -(UF.SPACING*3))
		else
			frame.InfoPanel:Point("TOPLEFT", frame.Health.backdrop, "BOTTOMLEFT", UF.BORDER, -(UF.SPACING*3))
		end
	else
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.PORTRAIT_WIDTH +UF.BORDER + UF.SPACING, UF.BORDER + UF.SPACING)
		else
			frame.InfoPanel:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", UF.BORDER + UF.SPACING, UF.BORDER + UF.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:Point("TOPRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", -UF.BORDER, -(UF.SPACING*3))
		else
			frame.InfoPanel:Point("TOPRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", -UF.BORDER, -(UF.SPACING*3))
		end
	end
end