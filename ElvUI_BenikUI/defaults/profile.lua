﻿local E, L, V, P, G = unpack(ElvUI);

-- Add Vertical Powerbar option on Player
P['unitframe']['units']['player']['power']['vertical'] = false

-- Add Vertical Powerbar option on target
P['unitframe']['units']['target']['power']['vertical'] = false

-- Add Party portraits additions to ElvUI defaults
P['unitframe']['units']['party']['portrait']['height'] = 0
P['unitframe']['units']['party']['portrait']['transparent'] = false

-- Add Minimap styling toggle default
P['general']['minimap']['benikuiStyle'] = true

-- Add Chat styling toggle default
P['chat']['benikuiStyle'] = true

-- Datatexts
P['datatexts']['panels']['BuiLeftChatDTPanel'] = {
	[1] = 'Primary Stat',
	[2] = 'Missions (BenikUI)',
	[3] = 'BuiMail',
}

P['datatexts']['panels']['BuiRightChatDTPanel'] = {
	[1] = 'Talent/Loot Specialization',
	[2] = 'Gold',
	[3] = 'Bags',
}

P['datatexts']['panels']['BuiMiddleDTPanel'] = {
	[1] = 'Haste',
	[2] = 'Mastery',
	[3] = 'Crit',
}

P['benikui'] = {
	['installed'] = nil,

	['general'] = {
		['benikuiStyle'] = true,
		['hideStyle'] = false,
		['shadows'] = true,
		['shadowSize'] = 4,
		['shadowAlpha'] = 0.6,
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
		['flightMode'] = {
			['enable'] = true,
			['logo'] = 'WOW',
		},
		['afkMode'] = true,
		['alternativePower'] = true,
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
		['mail'] = {
			['toggle'] = true,
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
			['bar13'] = true,
			['bar14'] = true,
			['bar15'] = true,
			['petbar'] = true,
			['stancebar'] = true,
			['microbar'] = true,
		},
	},

	['unitframes'] = {
		['player'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = true,
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
			['portraitShadow'] = true,
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
			['portraitShadow'] = true,
			['portraitTransparent'] = true,
			['portraitFrameStrata'] = "MEDIUM",
			['portraitBackdrop'] = true,
		},
		['focus'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = true,
			['portraitTransparent'] = true,
			['portraitFrameStrata'] = "MEDIUM",
			['portraitBackdrop'] = true,
		},
		['pet'] = {
			['detachPortrait'] = false,
			['portraitWidth'] = 110,
			['portraitHeight'] = 85,
			['portraitShadow'] = true,
			['portraitTransparent'] = true,
			['portraitFrameStrata'] = "MEDIUM",
			['portraitBackdrop'] = true,
		},
		['infoPanel'] = {
			['fixInfoPanel'] = true,
			['texture'] = 'BuiEmpty',
			['enableColor'] = false,
			['customColor'] = 2,
			['color'] = {r = .9, g = .7, b = 0, a = .7},
			['groupColor'] = {r = .9, g = .7, b = 0, a = .7},
		},
		['castbar'] = {
			['text'] = {
				['ShowInfoText'] = false,
			},
		},
		['textures'] = {
			['enableHealth'] = true,
			['health'] = E.db.unitframe.statusbar,
			['ignoreTransparency'] = false,
			['enablePower'] = true,
			['power'] = E.db.unitframe.statusbar,
			['enableCastbar'] = true,
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

	['panels'] = {

	},

	-- Skins and ElvUI addons Styling
	['skins'] = {
		['elvuiAddons'] = {
			['locplus'] = true,
			['sle'] = true,
			['enh'] = true,
			['pa'] = true,
			['mer'] = true,
			['elv'] = true,
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
			['allthethings'] = true,
			['tinyinspect'] = true,
			['arkinventory'] = true,
			['classTactics'] = true,
			['hekili'] = true,
			['wowpro'] = true,
		},

		['variousSkins'] = {
			['talkingHead'] = true,
			['objectiveTracker'] = true,
			['inflight'] = true,
			['kt'] = true,
			['rt'] = true,
			['wa'] = true,
			['tomtom'] = true,
		},
	},

	-- Databars
	['databars'] = {
		['experience'] = {
			['enable'] = true,
			['buiStyle'] = true,
			['buttonStyle'] = "DEFAULT",
			['notifiers'] = {
				['enable'] = true,
				['position'] = 'RIGHT',
			},
		},

		['reputation'] = {
			['enable'] = true,
			['buiStyle'] = true,
			['buttonStyle'] = "DEFAULT",
			['notifiers'] = {
				['enable'] = true,
				['position'] = 'LEFT',
			},
		},

		['azerite'] = {
			['enable'] = true,
			['buiStyle'] = true,
			['buttonStyle'] = "DEFAULT",
			['notifiers'] = {
				['enable'] = true,
				['position'] = 'LEFT',
			},
		},

		['honor'] = {
			['enable'] = true,
			['buiStyle'] = true,
			['buttonStyle'] = "DEFAULT",
			['notifiers'] = {
				['enable'] = true,
				['position'] = 'RIGHT',
			},
		},

		['threat'] = {
			['enable'] = true,
			['buiStyle'] = true,
			['buttonStyle'] = "DEFAULT",
			['notifiers'] = {
				['enable'] = true,
				['position'] = 'RIGHT',
			},
		},
	},

	-- Widgetbars
	['widgetbars'] = {
		['mawBar'] = {
			['enable'] = true,
			['width'] = 222,
			['height'] = 5,
			['textYoffset'] = 13,
			['barColor'] = {r = 0.192, g = 0.858, b = 0.858, a = 1},
			['barAutoColor'] = true,
			['textColor'] = {r = 1, g = 1, b = 1},
			['useDTfont'] = true,
			['font'] = E.db.datatexts.font,
			['fontsize'] = E.db.datatexts.fontSize,
			['fontflags'] = E.db.datatexts.fontOutline,
			['textFormat'] = 'PERCENT',
		},

		['halfBar'] = {
			['altbar'] = true,
			['mirrorbar'] = true,
		},
	},

	-- Dashboards
	['dashboards'] = {
		['DashboardDBConverted'] = nil,
		['system'] = {
			['enable'] = true,
			['combat'] = false,
			['width'] = 150,
			['barHeight'] = 1,
			['style'] = true,
			['transparency'] = true,
			['backdrop'] = true,
			['mouseover'] = false,
			['textAlign'] = 'LEFT',
			['chooseSystem'] = {
				['FPS'] = true,
				['MS'] = true,
				['Bags'] = true,
				['Durability'] = true,
				['Volume'] = true,
			},
			['latency'] = 2,
			['instance'] = true,
			['orientation'] = 'BOTTOM',
			['overrideColor'] = true,
			['updateThrottle'] = 2,
			['spacing'] = 1,
		},

		['tokens'] = {
			['enable'] = true,
			['combat'] = true,
			['mouseover'] = false,
			['tooltip'] = true,
			['width'] = 150,
			['barHeight'] = 1,
			['style'] = true,
			['transparency'] = true,
			['backdrop'] = true,
			['zeroamount'] = false,
			['weekly'] = true,
			['iconPosition'] = 'LEFT',
			['instance'] = true,
			['orientation'] = 'BOTTOM',
			['spacing'] = 1,
		},

		['professions'] = {
			['enable'] = true,
			['combat'] = true,
			['mouseover'] = false,
			['width'] = 150,
			['barHeight'] = 1,
			['style'] = true,
			['transparency'] = true,
			['backdrop'] = true,
			['capped'] = false,
			['iconPosition'] = 'RIGHT',
			['instance'] = true,
			['orientation'] = 'BOTTOM',
			['spacing'] = 1,
		},

		['reputations'] = {
			['enable'] = true,
			['combat'] = true,
			['mouseover'] = false,
			['width'] = 200,
			['barHeight'] = 1,
			['style'] = true,
			['transparency'] = true,
			['backdrop'] = true,
			['barFactionColors'] = true,
			['textFactionColors'] = true,
			['tooltip'] = false,
			['textAlign'] = 'LEFT',
			['instance'] = true,
			['orientation'] = 'BOTTOM',
			['spacing'] = 1,
		},

		['items'] = {
			['enable'] = true,
			['combat'] = true,
			['mouseover'] = false,
			['width'] = 150,
			['barHeight'] = 1,
			['style'] = true,
			['transparency'] = true,
			['backdrop'] = true,
			['iconPosition'] = 'RIGHT',
			['instance'] = true,
			['orientation'] = 'BOTTOM',
			['spacing'] = 1,
			['tooltip'] = true,
			['showMax'] = true,
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
	},
}

G['benikui'] = {
	['CustomPanels'] = {
		['createButton'] = false,
	},
	['CustomItems'] = {
		['createButton'] = false,
	},
}

G.datatexts.newPanelInfo.benikuiStyle = true
