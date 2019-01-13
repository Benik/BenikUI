local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadBigWigsProfile()
	local font, fontsize
	local key = BUI.Title

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
							["BigWigsAnchor_width"] = 199.999908447266,
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
							["width"] = 139.999984741211,
							["posy"] = 453.688899874687,
							["posx"] = 976.355666002965,
							["height"] = 120.000007629395,
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
			print(BUI.profileStrings[1]..L['BigWigs'])
		end
	else
		print(BUI.Title.."- "..L['BigWigs']..BUI.profileStrings[2])
	end

	BigWigs.db:SetProfile(key)
end
