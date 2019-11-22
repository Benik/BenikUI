local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');

function UF:Construct_AuraBars(statusBar)
	statusBar:CreateBackdrop(nil, nil, nil, UF.thinBorders, true)
	statusBar:SetScript('OnMouseDown', UF.AuraBars_OnClick)
	statusBar:SetPoint("LEFT")
	statusBar:SetPoint("RIGHT")

	statusBar.icon:CreateBackdrop(nil, nil, nil, UF.thinBorders, true)
	UF.statusbars[statusBar] = true
	UF:Update_StatusBar(statusBar)

	UF:Configure_FontString(statusBar.timeText)
	UF:Configure_FontString(statusBar.nameText)

	UF:Update_FontString(statusBar.timeText)
	UF:Update_FontString(statusBar.nameText)

	statusBar.nameText:SetJustifyH('LEFT')
	statusBar.nameText:SetJustifyV('MIDDLE')
	statusBar.nameText:SetPoint("RIGHT", statusBar.timeText, "LEFT", -4, 0)

	statusBar.bg = statusBar:CreateTexture(nil, 'BORDER')
	statusBar.bg:Show()

	local frame = statusBar:GetParent()
	statusBar.db = frame.db and frame.db.aurabar

	if not BUI.ShadowMode then return end
	statusBar:CreateSoftShadow()
	statusBar.icon.backdrop:CreateSoftShadow()
end
