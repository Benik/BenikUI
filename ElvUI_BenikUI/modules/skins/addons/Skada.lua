local BUI, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')

local hooksecurefunc = hooksecurefunc

------------------------------
-- Based on Azilroka's skin --
------------------------------
local function Skada()
	if not (BUI:IsAddOnEnabled('Skada') and E.db.benikui.skins.variousSkins.skada) then return end

	hooksecurefunc(Skada.displays['bar'], 'ApplySettings', function(_, win)
		local skada = win.bargroup
		skada:SetTemplate("Transparent")
		if not E.db.benikui.general.benikuiStyle then return end

		skada:BuiStyle()
		skada.button:BuiStyle()
		if skada.button.style then
			skada.button.style:Hide()
		end

		if win.db.enabletitle then
			if skada.button.style then
				skada.button.style:Show()
			end
			skada.style:Hide()
		end
	end)
end
S:AddCallbackForAddon("Skada", "BenikUI_Skada", Skada)