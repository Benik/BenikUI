local BUI, E, L, V, P, G = unpack((select(2, ...)))

function BUI:LoadBigWigsProfile()
	local font, fontsize
	local key = BUI.AddonProfileKey

	local LoadAddOn = (C_AddOns and C_AddOns.LoadAddOn) or LoadAddOn

	LoadAddOn("BigWigs_Options")
	LoadAddOn("BigWigs")

	if E.private.benikui.expressway == true then
		font = "Expressway"
		fontsize = 11
	else
		font = "Bui Prototype"
		fontsize = 10
	end

	if BigWigs3DB['profiles'] == nil then BigWigs3DB['profiles'] = {} end

	if BigWigs3DB['profiles'][key] == nil then
		BigWigs3DB = {
			["namespaces"] = {
				["BigWigs_Plugins_Alt Power"] = {
					["profiles"] = {
						[key] = {
							["fontName"] = font,
							["fontOutline"] = "",
							["fontsize"] = fontsize,
						},
					},
				},
				["BigWigs_Plugins_Bars"] = {
					["profiles"] = {
						[key] = {
							["fontName"] = font,
							["BigWigsAnchor_width"] = 200,
							["texture"] = "BuiFlat",
							["barStyle"] = "AddOnSkins Half-Bar",
						},
					},
				},
				["BigWigs_Plugins_Super Emphasize"] = {
					["profiles"] = {
						[key] = {
							["fontName"] = font,
						},
					},
				},
				["BigWigs_Plugins_Messages"] = {
					["profiles"] = {
						[key] = {
							["fontSize"] = 20,
							["fontName"] = font,
						},
					},
				},
				["BigWigs_Plugins_Proximity"] = {
					["profiles"] = {
						[key] = {
							["fontSize"] = 20,
							["fontName"] = font,
							["width"] = 140,
							["posy"] = 454,
							["posx"] = 976,
							["height"] = 120,
						},
					},
				},
			},
			["profiles"] = {
				[key] = {
				},
			},
		}

		if BUI.isInstallerRunning == false then -- don't print during Install, when applying profile that doesn't exist
			BUI:Print(format(BUI.profileStrings[1], L['BigWigs']))
		end
	else
		BUI:Print(format(BUI.profileStrings[2], L['BigWigs']))
	end

	BigWigs.db:SetProfile(key)
end
