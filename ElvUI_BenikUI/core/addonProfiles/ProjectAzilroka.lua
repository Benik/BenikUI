local BUI, E, L, V, P, G = unpack((select(2, ...)))

function BUI:LoadPAProfile()
	local PA = _G.ProjectAzilroka
	PA.data:SetProfile('BenikUI')

	local font
	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end

	PA.db["EnhancedShadows"]["Enable"] = false
	PA.db["DragonOverlay"]["Enable"] = false
	PA.db['SquareMinimapButtons']["MoveGarrison"] = false
	PA.db['SquareMinimapButtons']["HideGarrison"] = true
	PA.db['SquareMinimapButtons']["MoveQueue"] = false
	PA.db['SquareMinimapButtons']["MoveMail"] = false
	PA.db['SquareMinimapButtons']["MoveTracker"] = false
	PA.db['SquareMinimapButtons']["Backdrop"] = true
	PA.db['SquareMinimapButtons']['BarEnabled'] = true
	PA.db['SquareMinimapButtons']['ButtonsPerRow'] = 6
	PA.db['SquareMinimapButtons']['IconSize'] = 22
	PA.db['SquareMinimapButtons']['ButtonSpacing'] = 4

	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-298"

	PA.db["stAddonManager"]["NumAddOns"] = 20
	PA.db["stAddonManager"]["ButtonHeight"] = 16
	PA.db["stAddonManager"]["ButtonWidth"] = 16
	PA.db["stAddonManager"]["Font"] = font
	PA.db["stAddonManager"]["ClassColor"] = true
	PA.db["stAddonManager"]["CheckTexture"] = "BuiMelli"
	PA.db["stAddonManager"]["FontSize"] = 12
end