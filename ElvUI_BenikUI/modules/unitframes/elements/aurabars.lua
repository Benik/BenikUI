local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');

function BU:Create_AuraBarsWithShadow(bar)
	bar.auraInfo = {}
	bar:CreateBackdrop(nil, nil, nil, nil, true)
	bar:CreateSoftShadow()
	bar:SetScript('OnMouseDown', OnClick)
	bar:Point("LEFT")
	bar:Point("RIGHT")

	bar.spark:SetTexture(E.media.blankTex)
	bar.spark:SetVertexColor(1, 1, 1, 0.4)
	bar.spark:Width(2)

	bar.icon:CreateBackdrop(nil, nil, nil, nil, true)
	bar.icon:ClearAllPoints()
	bar.icon:Point('RIGHT', bar, 'LEFT', -self.barSpacing, 0)
	bar.icon:SetTexCoord(unpack(E.TexCoords))

	UF.statusbars[bar] = true
	UF:Update_StatusBar(bar)

	UF:Configure_FontString(bar.timeText)
	UF:Configure_FontString(bar.nameText)

	UF:AuraBars_UpdateBar(bar)

	bar.nameText:SetJustifyH('LEFT')
	bar.nameText:SetJustifyV('MIDDLE')
	bar.nameText:Point('RIGHT', bar.timeText, 'LEFT', -4, 0)
	bar.nameText:SetWordWrap(false)

	bar.bg = bar:CreateTexture(nil, 'BORDER')
	bar.bg:Show()

	local frame = bar:GetParent()
	bar.db = frame.db and frame.db.aurabar
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
