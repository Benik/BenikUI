local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB

-- Add Party portraits additions to ElvUI defaults
P['unitframe']['units']['party']['portrait']['height'] = 0
P['unitframe']['units']['party']['portrait']['transparent'] = false

-- Add Party role icon offsets to ElvUI defaults
P['unitframe']['units']['party']['roleIcon']['xOffset'] = 0
P['unitframe']['units']['party']['roleIcon']['yOffset'] = 0

-- Add Party EmptyBars to ElvUI defaults
P['unitframe']['units']['party']['emptybar'] = {
	['enable'] = false,
	['height'] = 20,
	['transparent'] = true,
	['threat'] = false,
}

-- Add Raid EmptyBars to ElvUI defaults
P['unitframe']['units']['raid']['emptybar'] = {
	['enable'] = false,
	['height'] = 14,
	['transparent'] = true,
	['threat'] = false,
}

-- Add Raid40 EmptyBars to ElvUI defaults
P['unitframe']['units']['raid40']['emptybar'] = {
	['enable'] = false,
	['height'] = 14,
	['transparent'] = true,
	['threat'] = false,
}

-- Add Pet EmptyBars to ElvUI defaults
P['unitframe']['units']['pet']['emptybar'] = {
	['enable'] = false,
	['height'] = 14,
	['transparent'] = true,
	['threat'] = false,
}

-- Add TargetTarget EmptyBars to ElvUI defaults
P['unitframe']['units']['targettarget']['emptybar'] = {
	['enable'] = false,
	['height'] = 14,
	['transparent'] = true,
	['threat'] = false,
}

-- Add Focus EmptyBars to ElvUI defaults
P['unitframe']['units']['focus']['emptybar'] = {
	['enable'] = false,
	['height'] = 14,
	['transparent'] = true,
	['threat'] = false,
}

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

-- Core
P['bui'] = {
	['installed'] = nil,
	['buiStyle'] = true,
	['colorTheme'] = 'Elv',
	['buiDts'] = true,
	['buiFonts'] = true,
	['LoginMsg'] = true,
	['transparentDts'] = false,
	['editBoxPosition'] = 'BELOW_CHAT',
	['middleDatatext'] = {
		['enable'] = true,
		['transparency'] = true,
		['backdrop'] = false,
		['width'] = 400,
		['height'] = 19,
		['styled'] = false,
	},
	['toggleMail'] = true,
	['garrisonCurrency'] = false,
	['gameMenuColor'] = 2,
	['customGameMenuColor'] = {r = .9, g = .7, b = 0},
	['abStyleColor'] = 1,
	['customAbStyleColor'] = {r = .9, g = .7, b = 0},
	['StyleColor'] = 1,
	['customStyleColor'] = {r = .9, g = .7, b = 0},
	['styledChatDts'] = false,
	['chatDtsBackdrop'] = true,
	['ilvl'] = true,
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

-- Actionbars
P['bab'] = {
	['transBack'] = true,
	['enable'] = true,
	['chooseAb'] = 'BAR2',
	['requestStop'] = true,
}

-- XP/Rep
P['buixprep'] = {
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
	
	['barColor'] = {r = 255/255,g = 128/255,b = 0/255},
	['textColor'] = 2,
	['customTextColor'] = {r = 255/255,g = 255/255,b = 255/255},
}

-- Unitframes
P['ufb'] = {
	-- EmptyBars
	['barshow'] = true,
	['barheight'] = 20,
	['toggleTransparency'] = true,
	['threat'] = false,
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
	['hideText'] = false,
	['castbarWarned'] = nil,
}

-- ElvUI addons Styling
P['elvuiaddons'] = {
	['loclite'] = true,
	['locplus'] = true,
	['sle'] = true,
	['smb'] = true,
	['enh'] = true,
	['dtb2'] = true,
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
	['ora'] = true,
}

-- Skins
P['buiVariousSkins'] = {
	['objectiveTracker'] = true,
	['decursive'] = true,
	['storyline'] = true,
}