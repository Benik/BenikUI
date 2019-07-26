local BUI, E, L, V, P, G = unpack(select(2, ...)) --Inport: Engine, Locales, ProfileDB, GlobalDB

V['benikui'] = {
	['install_complete'] = nil,
	['expressway'] = false,
	['session'] = {
		['day'] = 1,
	},
}

-- Dashboards
V['dashboards'] = {
	['tokens'] = {
		['chooseTokens'] = {
			[1560] = true, -- War Resources
			[1580] = true, -- Seal of Wartorn Fate
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