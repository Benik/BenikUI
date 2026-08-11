local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Shadows')

function mod:AuraIconShadow(_, button)
	if (E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows) ~= true then return end
	if not button then return end

	if not button.shadow then
		button:CreateSoftShadow()
	end

	if button.statusbar and not button.statusbar.backdrop.shadow then
		button.statusbar.backdrop:CreateSoftShadow()
	end
end

function mod:Initialize()
	if E.private.auras.enable ~= true then return end
	if E.private.auras.masque.buffs or E.private.auras.masque.debuffs then return end

	hooksecurefunc(E, "Auras_CreateButton", mod.AuraIconShadow)
	hooksecurefunc(E, "Auras_UpdateButton", mod.AuraIconShadow)
end

BUI:RegisterModule(mod:GetName())