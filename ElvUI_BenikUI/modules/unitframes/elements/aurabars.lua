local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');

function BU:Create_AuraBarsWithShadow(statusBar)
	statusBar:CreateBackdrop(nil, nil, nil, UF.thinBorders, true)
	statusBar:CreateSoftShadow()
	statusBar:SetScript('OnMouseDown', OnClick)
	statusBar:Point("LEFT")
	statusBar:Point("RIGHT")

	statusBar.icon:CreateBackdrop(nil, nil, nil, UF.thinBorders, true)
	statusBar.icon.backdrop:CreateSoftShadow()
	UF.statusbars[statusBar] = true
	UF:Update_StatusBar(statusBar)

	UF:Configure_FontString(statusBar.timeText)
	UF:Configure_FontString(statusBar.nameText)

	UF:Update_FontString(statusBar.timeText)
	UF:Update_FontString(statusBar.nameText)

	statusBar.nameText:SetJustifyH('LEFT')
	statusBar.nameText:SetJustifyV('MIDDLE')
	statusBar.nameText:Point("RIGHT", statusBar.timeText, "LEFT", -4, 0)

	statusBar.bg = statusBar:CreateTexture(nil, 'BORDER')
	statusBar.bg:Show()

	local frame = statusBar:GetParent()
	statusBar.db = frame.db and frame.db.aurabar
end

function BU:Configure_AuraBars(frame)
	if not BUI.ShadowMode then return end

	local auraBars = frame.AuraBars
	local db = frame.db
	auraBars.db = db.aurabar

	if db.aurabar.enable then
		auraBars.PostCreateBar = BU.Create_AuraBarsWithShadow
	end
end
