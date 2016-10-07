local E, L, V, P, G = unpack(ElvUI);

-- Add Vertical Powerbar option on Player
P['unitframe']['units']['player']['power']['vertical'] = false

-- Add Vertical Powerbar option on target
P['unitframe']['units']['target']['power']['vertical'] = false

-- Add Party portraits additions to ElvUI defaults
P['unitframe']['units']['party']['portrait']['height'] = 0
P['unitframe']['units']['party']['portrait']['transparent'] = false

-- Add raid classHover to ElvUI defaults
P['unitframe']['units']['raid']['classHover'] = false

-- Add raid40 classHover to ElvUI defaults
P['unitframe']['units']['raid40']['classHover'] = false

-- Add Bag stack count to ElvUI defaults
P['bags']['countPosition'] = 'BOTTOMRIGHT'

-- Core
P['benikui'] = {
	['installed'] = nil,

	['general'] = {
		['benikuiStyle'] = true,
		['loginMessage'] = true,
		['splashScreen'] = true,
	},

	['colors'] = {
		['colorTheme'] = 'Elv',
		['StyleColor'] = 1,
		['customStyleColor'] = {r = .9, g = .7, b = 0},
		['abStyleColor'] = 1,
		['customAbStyleColor'] = {r = .9, g = .7, b = 0},
		['gameMenuColor'] = 2,
		['customGameMenuColor'] = {r = .9, g = .7, b = 0},
	},

	['misc'] = {
		['ilevel'] = {
			['enable'] = true,
			['font'] = 'Bui Prototype',
			['fontsize'] = 9,
			['fontflags'] = 'OUTLINE',
			['colorStyle'] = 'RARITY',
			['color'] = {r = 1, g = 1, b = 0},
		},
		['flightMode'] = {
			['enable'] = true,
			['cameraRotation'] = false,
		},
		['panels'] = {
			['top'] = {
				['style'] = false,
				['transparency'] = true,
				['height'] = 22
			},
			['bottom'] = {
				['style'] = false,
				['transparency'] = true,
				['height'] = 22
			},
		},
	},

	['datatexts'] = {
		['chat'] = {
			['enable'] = true,
			['transparent'] = false,
			['editBoxPosition'] = 'BELOW_CHAT',
			['styled'] = false,
			['backdrop'] = true,
		},
		['middle'] = {
			['enable'] = true,
			['transparent'] = true,
			['backdrop'] = false,
			['width'] = 400,
			['height'] = 19,
			['styled'] = false,
		},
		['mail'] = {
			['toggle'] = true,
		},
		['garrison'] = {
			['currency'] = false,
			['oil'] = false,
		},
	},

	['actionbars'] = {
		['transparent'] = true,
		['toggleButtons'] = {
			['enable'] = true,
			['chooseAb'] = 'BAR2',
		},
		['requestStop'] = true,
	},
	
	['unitframes'] = {
		['player'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = false,
			['portraitTransparent'] = true,
			['portraitStyle'] = false,
			['portraitStyleHeight'] = 6,
		},
		['target'] = {
			['detachPortrait'] = false,
			['getPlayerPortraitSize'] = true,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = false,
			['portraitTransparent'] = true,
			['portraitStyle'] = false,
			['portraitStyleHeight'] = 6,
		},
		['infoPanel'] = {
			['fixInfoPanel'] = true,
			['texture'] = 'BuiEmpty',
			['color'] = {r = .9, g = .7, b = 0, a = .7},
		},
		['castbar'] = {
			['text'] = {
				['yOffset'] = -16,
				['ShowInfoText'] = true,
				['castText'] = true,
				['forceTargetText'] = false,
				['texture'] = 'BuiFlat',
				['textColor'] = {r = 1, g = 1, b = 1, a = 1},
			},
		},
		['textures'] = {
			['power'] = E.db.unitframe.statusbar,
			['health'] = E.db.unitframe.statusbar,
		},
		['misc'] = {
			['svui'] = true,
			['portraitTransparency'] = 0.70,
		},
	},
}

-- Datatexts
P.datatexts.panels.BuiLeftChatDTPanel = {
	left = E.db.datatexts.panels.LeftChatDataPanel.left,
	middle = E.db.datatexts.panels.LeftChatDataPanel.middle,
	right = E.db.datatexts.panels.LeftChatDataPanel.right,
}

P.datatexts.panels.BuiRightChatDTPanel = {
	left = E.db.datatexts.panels.RightChatDataPanel.left,
	middle = E.db.datatexts.panels.RightChatDataPanel.middle,
	right = E.db.datatexts.panels.RightChatDataPanel.right,
}

P.datatexts.panels.BuiMiddleDTPanel = {
	left = 'Multistrike',
	middle = 'Garrison+ (BenikUI)',
	right = 'Spec Switch (BenikUI)',
}

-- Skins and ElvUI addons Styling
P['benikuiSkins'] = {
	['elvuiAddons'] = {
		['loclite'] = true,
		['locplus'] = true,
		['sle'] = true,
		['smb'] = true,
		['enh'] = true,
		['dtb2'] = true,
	},
	
	['addonSkins'] = {
		['rc'] = true,
		['skada'] = true,
		['recount'] = true,
		['tinydps'] = true,
		['atlasloot'] = true,
		['altoholic'] = true,
		['zg'] = true,
		['clique'] = true,
		['ora'] = true,
	},
	
	['variousSkins'] = {
		['objectiveTracker'] = true,
		['talkingHead'] = true,
		['decursive'] = true,
		['storyline'] = true,
	},
}

-- Databars
P['benikuiDatabars'] = {
	['experience'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "DEFAULT",
		['color'] = {
			['default'] = true,
			['xp'] = { r = 0, g = 0.4, b = 1, a = .8 },
			['rested'] = { r = 1, g = 0, b = 1, a = .2 },
		},
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'RIGHT',
		},
	},
	
	['reputation'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "DEFAULT",
		['color'] = {
			['default'] = true,
			['friendly'] = {r = 0, g = .6, b = .1, a = .8 },
			['neutral'] = {r = .9, g = .7, b = 0, a = .8 },
			['unfriendly'] = {r = .75, g = .27, b = 0, a = .8 },
			['hated'] = {r = 1, g = 0, b = 0, a = .8 },
		},
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'LEFT',
		},
	},
	
	['artifact'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "TRANSPARENT",
		['color'] = {
			['default'] = true,
			['af'] = {r = .901, g = .8, b = .601, a = .8 },
		},
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'LEFT',
		},
	},
	
	['honor'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "DEFAULT",
		['color'] = {
			['default'] = true,
			['hn'] = {r = .941, g = .447, b = .254, a = .8 },
		},
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'RIGHT',
		},
	},
}

-- Dashboards
P['dashboards'] = {
	['system'] = {
		['enableSystem'] = true,
		['combat'] = false,
		['width'] = 150,
		['chooseSystem'] = {
			['FPS'] = true,
			['MS'] = true,
			['Memory'] = true,
			['Durability'] = true,
			['Volume'] = true,
		},
		['latency'] = 2,
	},
	
	['tokens'] = {
		['enableTokens'] = true,
		['combat'] = true,
		['tooltip'] = true,
		['width'] = 150,
		['zeroamount'] = false,
		['weekly'] = true,
		['flash'] = false,
		['chooseTokens'] = {
			['Conquest Points'] = true,
			['Honor Points'] = true,
			['Apexis Crystal'] = true,
			['Garrison Resources'] = true,
		},
	},
	
	['professions'] = {
		['enableProfessions'] = true,
		['combat'] = true,
		['width'] = 150,
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
	
	['barColor'] = {r = 255/255,g = 128/255,b = 0/255},
	['textColor'] = 2,
	['customTextColor'] = {r = 255/255,g = 255/255,b = 255/255},
}