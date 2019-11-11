local BUI, E, L, V, P, G = unpack(select(2, ...))
local A = E:GetModule('Auras');

local unpack = unpack

if E.private.auras.enable ~= true then return end
if E.private.auras.masque.buffs or E.private.auras.masque.debuffs then return end

A.CreateIconBui = A.CreateIcon
function A:CreateIcon(button)
	self:CreateIconBui(button)
	if E.db.benikui.general.shadows then
		if not button.shadow then
			button:CreateSoftShadow()
		end

		if not button.statusBar.backdrop.shadow then
			button.statusBar.backdrop:CreateSoftShadow()
		end
	end
end