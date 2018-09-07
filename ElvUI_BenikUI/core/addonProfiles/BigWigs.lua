local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadBigWigsProfile()
	local font, fontsize
	if E.private.benikui.expressway == true then
		font = "Expressway"
		fontsize = 11
	else
		font = "Bui Prototype"
		fontsize = 10
	end

	if BigWigs3DB['profiles'] == nil then BigWigs3DB['profiles'] = {} end

	if BigWigs3DB['profiles'][BUI.AddonProfileKey] == nil then
		BigWigs3DB = {
			["namespaces"] = {
				["BigWigs_Plugins_Alt Power"] = {
					["profiles"] = {
						[BUI.AddonProfileKey] = {
							["fontName"] = font,
							["fontOutline"] = "",
							["fontsize"] = fontsize,
						},
					},
				},
				["BigWigs_Plugins_Bars"] = {
					["profiles"] = {
						[BUI.AddonProfileKey] = {
							["fontName"] = font,
							["BigWigsAnchor_width"] = 199.999908447266,
							["texture"] = "BuiFlat",
							["barStyle"] = "AddOnSkins Half-Bar",
						},
					},
				},
				["BigWigs_Plugins_Super Emphasize"] = {
					["profiles"] = {
						[BUI.AddonProfileKey] = {
							["fontName"] = font,
						},
					},
				},
				["BigWigs_Plugins_Messages"] = {
					["profiles"] = {
						[BUI.AddonProfileKey] = {
							["fontSize"] = 20,
							["fontName"] = font,
						},
					},
				},
				["BigWigs_Plugins_Proximity"] = {
					["profiles"] = {
						[BUI.AddonProfileKey] = {
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
				[BUI.AddonProfileKey] = {
				},
			},
		}

		local db = LibStub("AceDB-3.0"):New(BigWigs3DB, nil, true)
		db:SetProfile(BUI.AddonProfileKey)

		if BUI.isInstallerRunning == false then -- don't print during Install, when applying profile that doesn't exist
			print(BUI.profileStrings[1]..L['BigWigs'])
		end
	else
		print(BUI.Title.."- "..L['BigWigs']..BUI.profileStrings[2])
	end
end
