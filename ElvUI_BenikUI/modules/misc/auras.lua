local BUI, E, L, V, P, G = unpack((select(2, ...)))
local A = E:GetModule('Auras')
local mod = BUI:GetModule('Shadows')

function mod:AuraIconShadow(_, button)
	if E.db.benikui.general.benikuiStyle ~= true then return end

	if E.db.benikui.general.shadows then
		if not button.shadow then
			button:CreateSoftShadow()
		end

		if not button.statusBar.backdrop.shadow then
			button.statusBar.backdrop:CreateSoftShadow()
		end
	end
end

function mod:AuraShadows()
	if E.private.auras.enable ~= true then return end
	if E.private.auras.masque.buffs or E.private.auras.masque.debuffs then return end

	self:SecureHook(A, "CreateIcon", "AuraIconShadow")
	self:SecureHook(A, "UpdateAura", "AuraIconShadow")
end