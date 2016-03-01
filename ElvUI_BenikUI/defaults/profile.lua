local E, L, V, P, G = unpack(ElvUI);

-- Add Party portraits additions to ElvUI defaults
P['unitframe']['units']['party']['portrait']['height'] = 0
P['unitframe']['units']['party']['portrait']['transparent'] = false

-- Add Party role icon offsets to ElvUI defaults
P['unitframe']['units']['party']['roleIcon']['xOffset'] = 0
P['unitframe']['units']['party']['roleIcon']['yOffset'] = 0

-- Add Raid role icon offsets to ElvUI defaults
P['unitframe']['units']['raid']['roleIcon']['xOffset'] = 0
P['unitframe']['units']['raid']['roleIcon']['yOffset'] = 0

-- Add Raid40 role icon offsets to ElvUI defaults
P['unitframe']['units']['raid40']['roleIcon']['xOffset'] = 0
P['unitframe']['units']['raid40']['roleIcon']['yOffset'] = 0

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
		['gameMenuButton'] = true,
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
			['color'] =  {r = 1, g = 1, b = 0},
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
		},
		['castbar'] = {
			['text'] = {
				['yOffset'] = -16,
				['ShowInfoText'] = true,
				['castText'] = true,
			},
		},
		['misc'] = {
			['svui'] = true,
		},
	
	},
	
	-- db
	['dbCleaned'] = false,
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
	right = 'Versatility',
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
		['decursive'] = true,
		['storyline'] = true,
	},
}

-- XP/Rep
P['benikuiXprep'] = {
	['enable'] = true,
	['buiStyle'] = true,
	
	['color'] = {
		['experience'] = {
			['default'] = true,
			['xp'] = { r = 0, g = 0.4, b = 1, a = .8 },
			['rested'] = { r = 1, g = 0, b = 1, a = .2 },
		},
		['reputation'] = {
			['default'] = true,
			['friendly'] = {r = 0, g = .6, b = .1, a = .8 },
			['neutral'] = {r = .9, g = .7, b = 0, a = .8 },
			['unfriendly'] = {r = .75, g = .27, b = 0, a = .8 },
			['hated'] = {r = 1, g = 0, b = 0, a = .8 },
		},
	},
	
	['notifiers'] = {
		['combat'] = false,
		['experience'] = {
			['enable'] = true,
			['position'] = 'RIGHT',
		},
		['reputation'] = {
			['enable'] = true,
			['position'] = 'LEFT',
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
		['width'] = 171,
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