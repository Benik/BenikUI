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

-- Databars text yOffset
P['databars']['experience']['textYoffset'] = 0
P['databars']['azerite']['textYoffset'] = 0
P['databars']['reputation']['textYoffset'] = 0
P['databars']['honor']['textYoffset'] = 0

-- Add Minimap styling toggle default
P['general']['minimap']['benikuiStyle'] = true

-- Core
P['benikui'] = {
	['installed'] = nil,

	['general'] = {
		['benikuiStyle'] = true,
		['hideStyle'] = false,
		['shadows'] = true,
		['loginMessage'] = true,
		['splashScreen'] = true,
	},

	['colors'] = {
		['colorTheme'] = 'Elv',
		['StyleColor'] = 1,
		['customStyleColor'] = {r = .9, g = .7, b = 0},
		['styleAlpha'] = 1,
		['abStyleColor'] = 1,
		['customAbStyleColor'] = {r = .9, g = .7, b = 0},
		['abAlpha'] = 1,
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
			['position'] = 'INSIDE',
		},
		['flightMode'] = true,
		['afkMode'] = true,
	},

	['datatexts'] = {
		['chat'] = {
			['enable'] = true,
			['transparent'] = false,
			['editBoxPosition'] = 'BELOW_CHAT',
			['styled'] = false,
			['backdrop'] = true,
			['showChatDt'] = 'SHOWBOTH',
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
		['toggleButtons'] = {
			['enable'] = true,
			['chooseAb'] = 'BAR2',
		},
		['requestStop'] = true,
		['style'] = {
			['bar1'] = true,
			['bar2'] = true,
			['bar3'] = true,
			['bar4'] = true,
			['bar5'] = true,
			['bar6'] = true,
			['bar7'] = true,
			['bar8'] = true,
			['bar9'] = true,
			['bar10'] = true,
			['petbar'] = true,
			['stancebar'] = true,
		},
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
			['portraitFrameStrata'] = "MEDIUM",
			['portraitBackdrop'] = true,
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
			['portraitFrameStrata'] = "MEDIUM",
			['portraitBackdrop'] = true,
		},
		['targettarget'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = false,
			['portraitTransparent'] = true,
			['portraitFrameStrata'] = "MEDIUM",
		},
		['focus'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = false,
			['portraitTransparent'] = true,
			['portraitFrameStrata'] = "MEDIUM",
		},
		['pet'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = false,
			['portraitTransparent'] = true,
			['portraitFrameStrata'] = "MEDIUM",
		},
		['infoPanel'] = {
			['fixInfoPanel'] = true,
			['texture'] = 'BuiEmpty',
			['customColor'] = 2,
			['color'] = {r = .9, g = .7, b = 0, a = .7},
		},
		['castbar'] = {
			['text'] = {
				['ShowInfoText'] = false,
			},
		},
		['textures'] = {
			['health'] = E.db.unitframe.statusbar,
			['ignoreTransparency'] = false,
			['power'] = E.db.unitframe.statusbar,
			['castbar'] = 'BuiFlat',
		},
		['castbarColor'] = {
			['enable'] = true,
			['castbarBackdropColor'] = {r = 0.054, g = 0.054, b = 0.054, a = 0.75},
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
		['enh'] = true,
		['dtb2'] = true,
		['pa'] = true,
	},
	
	['addonSkins'] = {
		['skada'] = true,
		['recount'] = true,
		['tinydps'] = true,
		['atlasloot'] = true,
		['altoholic'] = true,
		['clique'] = true,
		['ora'] = true,
		['pawn'] = true,
		['dbm'] = true,
		['bigwigs'] = true,
		['zygor'] = true,
		['immersion'] = true,
		['adibags'] = true,
	},
	
	['variousSkins'] = {
		['talkingHead'] = true,
		['decursive'] = true,
		['storyline'] = true,
		['inflight'] = true,
	},
}

-- Databars
P['benikuiDatabars'] = {
	['experience'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "TRANSPARENT",
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'RIGHT',
		},
	},
	
	['reputation'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "TRANSPARENT",
		['autotrack'] = false,
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'LEFT',
		},
	},
	
	['azerite'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "TRANSPARENT",
		['notifiers'] = {
			['enable'] = true,
			['combat'] = false,
			['position'] = 'LEFT',
		},
	},
	
	['honor'] = {
		['enable'] = true,
		['buiStyle'] = true,
		['buttonStyle'] = "TRANSPARENT",
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
		['style'] = true,
		['transparency'] = true,
		['backdrop'] = true,
		['chooseSystem'] = {
			['FPS'] = true,
			['MS'] = true,
			['Bags'] = true,
			['Durability'] = true,
			['Volume'] = true,
		},
		['latency'] = 2,
	},
	
	['tokens'] = {
		['enableTokens'] = true,
		['combat'] = true,
		['mouseover'] = false,
		['tooltip'] = true,
		['width'] = 150,
		['style'] = true,
		['transparency'] = true,
		['backdrop'] = true,
		['zeroamount'] = false,
		['weekly'] = true,
	},
	
	['professions'] = {
		['enableProfessions'] = true,
		['combat'] = true,
		['mouseover'] = false,
		['width'] = 150,
		['style'] = true,
		['transparency'] = true,
		['backdrop'] = true,
		['capped'] = false,
	},

	['dashfont'] = {
		['useDTfont'] = true,
		['dbfont'] = E.db.datatexts.font,
		['dbfontsize'] = E.db.datatexts.fontSize,
		['dbfontflags'] = E.db.datatexts.fontOutline,
	},
	
	['barColor'] = 1,
	['customBarColor'] = {r = 255/255,g = 128/255,b = 0/255},
	['textColor'] = 2,
	['customTextColor'] = {r = 255/255,g = 255/255,b = 255/255},
}