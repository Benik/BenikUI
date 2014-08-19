local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local A = E:GetModule('Auras');
local BUI = E:GetModule('BenikUI');
local LSM = LibStub("LibSharedMedia-3.0");

if E.private.auras.enable ~= true then return end

A.CreateIconBui = A.CreateIcon
function A:CreateIcon(button)
	self:CreateIconBui(button)
	
	button:Style('Inside')
end

A.UpdateAuraBui = A.UpdateAura
function A:UpdateAura(button, index)
	self:UpdateAuraBui(button, index)
	local filter = button:GetParent():GetAttribute('filter')
	local unit = button:GetParent():GetAttribute("unit")
	local name = UnitAura(unit, index, filter)

	if(name) then
		button.texture:SetTexCoord(unpack(BUI.TexCoords))
	end
end
