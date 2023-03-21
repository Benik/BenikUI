local BUI, E, L, V, P, G = unpack((select(2, ...)))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');

-- GLOBALS: hooksecurefunc

function BU:Configure_RoleIcons()
	if E.db.benikui.unitframes.misc.svui ~= true then return end

	-- Replace Role Icons
	UF.RoleIconTextures = {
		TANK = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\tank.tga]],
		HEALER = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\healer.tga]],
		DAMAGER = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\dps.tga]]
	}
end
