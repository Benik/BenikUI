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

	BigWigs3DB = {
		["namespaces"] = {
			["BigWigs_Plugins_Alt Power"] = {
				["profiles"] = {
					["BenikUI"] = {
						["font"] = font,
						["fontOutline"] = "",
						["fontsize"] = fontsize,
					},
				},
			},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["BenikUI"] = {
						["font"] = font,
						["BigWigsAnchor_width"] = 199.999908447266,
						["texture"] = "BuiFlat",
						["barStyle"] = "AddOnSkins Half-Bar",
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["BenikUI"] = {
						["font"] = font,
					},
				},
			},
			["BigWigs_Plugins_Messages"] = {
				["profiles"] = {
					["BenikUI"] = {
						["fontSize"] = 20,
						["font"] = font,
					},
				},
			},
			["BigWigs_Plugins_Proximity"] = {
				["profiles"] = {
					["BenikUI"] = {
						["fontSize"] = 20,
						["font"] = font,
						["width"] = 139.999984741211,
						["posy"] = 453.688899874687,
						["posx"] = 976.355666002965,
						["height"] = 120.000007629395,
					},
				},
			},
		},
		["profiles"] = {
			["BenikUI"] = {
			},
		},
	}

	local db = LibStub("AceDB-3.0"):New(BigWigs3DB, nil, true)
	db:SetProfile("BenikUI")
end
