local E, L, V, P, G, _ = unpack(ElvUI);
local A = E:GetModule('Auras');
local BUI = E:GetModule('BenikUI');

local unpack = unpack

if E.private.auras.enable ~= true then return end
if E.private.auras.masque.buffs or E.private.auras.masque.debuffs then return end

A.CreateIconBui = A.CreateIcon
function A:CreateIcon(button)
	self:CreateIconBui(button)
	if E.db.benikui.general.auras then
		button:Style('Inside', _, true)
		button.texture:SetTexCoord(unpack(BUI.TexCoords))
	elseif E.db.benikui.general.benikuiStyle and E.db.benikui.general.shadows then
		if not button.shadow then
			button:CreateSoftShadow()
		end
	end
end