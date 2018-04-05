local E, L, V, P, G = unpack(ElvUI);
local UF = E:GetModule('UnitFrames');
local UFB = E:GetModule('BuiUnits');

--Replace ElvUI AuraBars creation. Don't want to create shadows on PostUpdate
function UFB:Create_AuraBarsWithShadow()
	local bar = self.statusBar

	self:SetTemplate('Default', nil, nil, UF.thinBorders, true)
	self:CreateSoftShadow()
	local inset = UF.thinBorders and E.mult or nil
	bar:SetInside(self, inset, inset)
	UF['statusbars'][bar] = true
	UF:Update_StatusBar(bar)

	UF:Configure_FontString(bar.spelltime)
	UF:Configure_FontString(bar.spellname)
	UF:Update_FontString(bar.spelltime)
	UF:Update_FontString(bar.spellname)

	bar.spellname:ClearAllPoints()
	bar.spellname:Point('LEFT', bar, 'LEFT', 2, 0)
	bar.spellname:Point('RIGHT', bar.spelltime, 'LEFT', -4, 0)
	bar.spellname:SetWordWrap(false)

	bar.iconHolder:SetTemplate('Default', nil, nil, UF.thinBorders, true)
	bar.iconHolder:CreateSoftShadow()
	bar.iconHolder:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT', -2, 0) -- Move the icon a bit to the left
	bar.icon:SetInside(bar.iconHolder, inset, inset)
	bar.icon:SetDrawLayer('OVERLAY')

	bar.bg = bar:CreateTexture(nil, 'BORDER')
	bar.bg:Hide()

	bar.iconHolder:RegisterForClicks('RightButtonUp')
	bar.iconHolder:SetScript('OnClick', function(self)
		if E.db.unitframe.auraBlacklistModifier == "NONE" or not ((E.db.unitframe.auraBlacklistModifier == "SHIFT" and IsShiftKeyDown()) or (E.db.unitframe.auraBlacklistModifier == "ALT" and IsAltKeyDown()) or (E.db.unitframe.auraBlacklistModifier == "CTRL" and IsControlKeyDown())) then return; end
		local auraName = self:GetParent().aura.name

		if auraName then
			E:Print(format(L["The spell '%s' has been added to the Blacklist unitframe aura filter."], auraName))
			E.global['unitframe']['aurafilters']['Blacklist']['spells'][auraName] = {
				['enable'] = true,
				['priority'] = 0,
			}
			UF:Update_AllFrames()
		end
	end)
end

function UFB:Configure_AuraBars(frame)
	if not E.db.benikui.general.shadows then return end

	if not frame.VARIABLES_SET then return end
	local auraBars = frame.AuraBars

	auraBars.PostCreateBar = UFB.Create_AuraBarsWithShadow
end