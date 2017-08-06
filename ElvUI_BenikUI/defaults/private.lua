local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB

V['benikui'] = {
	['install_complete'] = nil,
	['expressway'] = false,
}

-- Dashboards
V['dashboards'] = {
	['tokens'] = {
		['chooseTokens'] = {
			[1220] = true, -- Order Resources
			[1273] = true, -- Seal of Broken Fate
			[1155] = true, -- Ancient Mana
		},
	},
	
	['professions'] = {
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