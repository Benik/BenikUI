local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB

V['benikui'] = {
	['install_complete'] = nil,
}

-- Dashboards
V['dashboards'] = {
	['tokens'] = {
		['enableTokens'] = true,
		['chooseTokens'] = {
			[1220] = true, -- Order Resources
			[1273] = true, -- Seal of Broken Fate
			[1155] = true, -- Ancient Mana
		},
	},
	
	['professions'] = {
		['enableProfessions'] = true,
		['choosePofessions'] = {
			[5] = true,
			[6] = true,
			[7] = true,
			[8] = true,
			[9] = true,
			[10] = true,
		},
	},
}