local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadStamProfile()
	local font
	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end

	if stAddonManagerDB["profiles"]["BenikUI"] == nil then stAddonManagerDB["profiles"]["BenikUI"] = {} end
	stAddonManagerDB["profiles"]["BenikUI"]["FontSize"] = 12
	stAddonManagerDB["profiles"]["BenikUI"]["NumAddOns"] = 20
	stAddonManagerDB["profiles"]["BenikUI"]["ButtonHeight"] = 16
	stAddonManagerDB["profiles"]["BenikUI"]["ButtonWidth"] = 16
	stAddonManagerDB["profiles"]["BenikUI"]["Font"] = font
	stAddonManagerDB["profiles"]["BenikUI"]["CheckTexture"] = "BuiMelli"

	_G.stAddonManager.data:SetProfile("BenikUI")
end