local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadPAProfile()
	local PA = _G.ProjectAzilroka
	PA.data:SetProfile('BenikUI')

	local font
	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end

	PA.db['SquareMinimapButtons']['BarEnabled'] = true
	PA.db['SquareMinimapButtons']['ButtonsPerRow'] = 6
	PA.db['SquareMinimapButtons']['IconSize'] = 22
	PA.db['SquareMinimapButtons']['ButtonSpacing'] = 4

	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-258"

	PA.db["stAddonManager"]["NumAddOns"] = 20
	PA.db["stAddonManager"]["ButtonHeight"] = 16
	PA.db["stAddonManager"]["ButtonWidth"] = 16
	PA.db["stAddonManager"]["Font"] = font
	PA.db["stAddonManager"]["ClassColor"] = true
	PA.db["stAddonManager"]["CheckTexture"] = "BuiMelli"
	PA.db["stAddonManager"]["FontSize"] = 12
end