local BUI, E, L, V, P, G = unpack(select(2, ...))
local UF = E:GetModule('UnitFrames');
local BU = BUI:GetModule('Units');

-- GLOBALS: hooksecurefunc

UF.RoleIconTextures = {
	TANK = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\tank.tga]],
	HEALER = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\healer.tga]],
	DAMAGER = [[Interface\AddOns\ElvUI_BenikUI\media\textures\roleIcons\dps.tga]]
}
