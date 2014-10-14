local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

-- Core
P['bui'] = {
	['installed'] = nil,
	['colorTheme'] = 'Elv',
	['buiDts'] = true,
	['buiFonts'] = true,
	['transparentDts'] = false,
	['toggleMail'] = true,
	['mailSound'] = false,
}

-- Actionbars
P['bab'] = {
	['transBack'] = true,
	['enable'] = true,
	['chooseAb'] = 'BAR2',
}

-- XP/Rep
P['xprep'] = {
	['show'] = 'REP',
	['textStyle'] = 'UNIT',
	['mouseOver'] = true,
	['xp'] = { r = 0, g = 0.4, b = 1, a = .8 },
	['rested'] = { r = 1, g = 0, b = 1, a = .2 },
	['reputation'] = {r = 0, g = 1, b = 0, a = .8 },
}

-- Dashboards
P['dashboards'] = {
	['system'] = {
		['enableSystem'] = true,
		['combat'] = false,
		['width'] = 150,
	},
	
	['tokens'] = {
		['enableTokens'] = true,
		['combat'] = true,
		['tooltip'] = true,
		['width'] = 150,
		['zeroamount'] = false,
		['flash'] = false,
		['chooseTokens'] = {
			['Justice Points'] = true,
			['Valor Points'] = true,
			['Conquest Points'] = true,
			['Honor Points'] = true,
			['Apexis Crystal'] = true,
			['Garrison Resources'] = true,
		},
	},
	
	['professions'] = {
		['enableProfessions'] = true,
		['combat'] = true,
		['width'] = 172,
		['capped'] = false,
		['choosePofessions'] = {
			['Alchemy'] = true,
			['Blacksmithing'] = true,
			['Enchanting'] = true,
			['Engineering'] = true,
			['Herbalism'] = true,
			['Inscription'] = true,
			['Jewelcrafting'] = true,
			['Leatherworking'] = true,
			['Tailoring'] = true,
			['Skinning'] = true,
			['Mining'] = true,
			['Archaeology'] = false,
			['First Aid'] = false,
			['Cooking'] = false,
			['Fishing'] = false,		
		},
	},

	['dashfont'] = {
		['useDTfont'] = true,
		['dbfont'] = E.db.datatexts.font,
		['dbfontsize'] = E.db.datatexts.fontSize,
		['dbfontflags'] = E.db.datatexts.fontOutline,
	},
}

-- Unitframes
P['ufb'] = {
	-- EmptyBars
	['barshow'] = true,
	['barheight'] = 20,
	-- Detach portrait
	['detachPlayerPortrait'] = false,
	['PlayerPortraitWidth'] = 110,
	['PlayerPortraitHeight'] = 85,
	['PlayerPortraitShadow'] = false,
	['PlayerPortraitTransparent'] = true,
	['detachTargetPortrait'] = false,
	['getPlayerPortraitSize'] = true,
	['TargetPortraitWidth'] = 110,
	['TargetPortraitHeight'] = 85,
	['TargetPortraitShadow'] = false,
	['TargetPortraitTransparent'] = true,
	-- Powerbar texture
	['powerstatusbar'] = 'BuiFlat',
	-- Castbar attach
	['attachCastbar'] = true,
	['castText'] = true,
	['yOffsetText'] = -15,
	['overText'] = false,
}

-- ElvUI addons Styling
P['elvuiaddons'] = {
	['loclite'] = true,
	['locplus'] = true,
	['sle'] = true,
	['smb'] = true,
}

-- Addonskins addons Styling
P['buiaddonskins'] = {
	['rc'] = true,
	['skada'] = true,
	['recount'] = true,
	['tinydps'] = true,
	['atlasloot'] = true,
	['altoholic'] = true,
	['zg'] = true,
	['clique'] = true,
}