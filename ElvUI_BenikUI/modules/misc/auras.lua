local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local A = E:GetModule('Auras');
local BUI = E:GetModule('BenikUI');

if E.private.auras.enable ~= true then return end

A.CreateIconBui = A.CreateIcon
function A:CreateIcon(button)
	self:CreateIconBui(button)
	
	button:Style('Inside', _, true)
end

A.UpdateAuraBui = A.UpdateAura
function A:UpdateAura(button, index)
	self:UpdateAuraBui(button, index)
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute('unit')
	local name = UnitAura(unit, index, filter)

	if(name) then
		if E.db.bui.buiStyle == true then
			button.texture:SetTexCoord(unpack(BUI.TexCoords))
		end

		if filter == 'HARMFUL' then
			local color = DebuffTypeColor[dtype or ""]
			if button.style then
				button.style:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		else
			if button.style then
				button.style:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end
end
