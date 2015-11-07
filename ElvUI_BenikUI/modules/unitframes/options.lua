local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local BUIC = E:GetModule('BuiCastbar');
local UF = E:GetModule('UnitFrames');

local tinsert = table.insert

local function ufTable()
	E.Options.args.bui.args.config.args.ufb = {
		order = 10,
		type = 'group',
		name = L['UnitFrames'],
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			eframes = {
				order = 1,
				type = 'group',
				name = L['EmptyBars'],
				guiInline = true,
				get = function(info) return E.db.ufb[ info[#info] ] end,
				set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); UFB:ArrangeTarget(); end,
				args = {
					barshow = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						desc = L['Enable the EmptyBars (Player and Target).'],
					},
					toggleTransparency = {
						order = 2,
						type = 'toggle',
						name = L['Transparent'],
						desc = L['Toggle EmptyBars transparency'],
						get = function(info) return E.db.ufb[ info[#info] ] end,
						disabled = function() return not E.db.ufb.barshow end,
						set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:TogglePlayerBarTransparency(); UFB:ToggleTargetBarTransparency(); end,
					},
					barheight = {
						order = 3,
						type = 'range',
						name = L['Height'],
						desc = L['Change the EmptyBars height (Player and Target).'],
						set = function(info, value) E.db.ufb[ info[#info] ] = value; UF:CreateAndUpdateUF('player'); UF:CreateAndUpdateUF('target'); BUIC:UpdatePlayer(); BUIC:UpdateTarget(); end,
						disabled = function() return not E.db.ufb.barshow end,
						min = 10, max = 50, step = 1,
					},
					threat = {
						order = 4,
						type = 'toggle',
						name = L['Threat on EmptyBars'],
						desc = L['Places the threat glow on Player and Target EmptyBar'],
						get = function(info) return E.db.ufb[ info[#info] ] end,
						disabled = function() return not E.db.ufb.barshow end,
						set = function(info, value) E.db.ufb[ info[#info] ] = value; UF:CreateAndUpdateUF('player'); UF:CreateAndUpdateUF('target'); end,
					},
				},
			},
			buibars = {
				order = 2,
				type = 'group',
				name = L['Bars'],
				guiInline = true,
				args = {
					powerstatusbar = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 1,
						name = L['PowerBar Texture'],
						desc = L['Power statusbar texture.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.ufb[ info[#info] ] end,				
						set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:Update_PowerStatusBar() end,
					},
				},
			},
			buicastbar = {
				order = 3,
				type = 'group',
				name = L['Castbar'],
				guiInline = true,
				disabled = function() return not E.db.ufb.barshow end,
				get = function(info) return E.db.ufb[ info[#info] ] end,
				set = function(info, value) E.db.ufb[ info[#info] ] = value; BUIC:UpdatePlayer(); BUIC:UpdateTarget(); end,
				args = {
					attachCastbar = {
						order = 1,
						type = 'toggle',
						name = L['Attach on EmptyBars'],
						desc = L['Attaches Player and Target Castbar on the EmptyBars.'],
					},
					castText = {
						order = 2,
						type = 'toggle',
						name = L['Castbar Text'],
						desc = L['Show/Hide the Castbar text.'],
					},
					yOffsetText = {
						order = 3,
						type = 'range',
						name = L['Y Offset'],
						desc = L['Adjust text Y Offset'],
						min = -25, max = 0, step = 1,
					},
					hideText = {
						type = 'toggle',
						order = 4,
						name = L['Hide EmptyBar text'],
						desc = L['Hide any text placed on the EmptyBars, while casting.'],
						set = function(info, value) E.db.ufb[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
			buttons = {
				order = 4,
				type = 'group',
				name = L['Shortcuts to EmptyBar Options for:'],
				guiInline = true,
				args = {
					focus = {
						order = 1,
						name = L['Focus Frame'],
						desc = L['This opens the Focus Frame EmptyBar settings.'],
						type = 'execute',
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "focus", "emptybar") end,
					},
					tot = {
						order = 2,
						name = L['TargetTarget Frame'],
						desc = L['This opens the TargetTarget Frame EmptyBar settings.'],
						type = 'execute',
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "targettarget", "emptybar") end,
					},
					pet = {
						order = 3,
						name = L['Pet Frame'],
						desc = L['This opens the Pet Frame EmptyBar settings.'],
						type = 'execute',
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "pet", "emptybar") end,
					},
					party = {
						order = 4,
						name = L['Party Frames'],
						desc = L['This opens the Party Frames EmptyBars settings.'],
						type = 'execute',
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "party", "emptybar") end,
					},
					raid = {
						order = 5,
						name = L['Raid Frames'],
						desc = L['This opens the Raid Frames EmptyBars settings.'],
						type = 'execute',
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "raid", "emptybar") end,
					},
					raid40 = {
						order = 6,
						name = L['Raid-40 Frames'],
						desc = L['This opens the Raid-40 Frames EmptyBars settings.'],
						type = 'execute',
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "unitframe", "raid40", "emptybar") end,
					},
				},
			},			
		},
	}
end
tinsert(E.BuiConfig, ufTable)

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.portrait.args.ufb = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.ufb[ info[#info] ] end,
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); end,
		args = {		
			detachPlayerPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.ufb[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
					else
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 15
						E.db.unitframe.units.player.portrait.width = 45
					end
					UF:CreateAndUpdateUF('player')
				end,
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Apply transparency on the portrait backdrop.'],
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Apply shadow under the portrait'],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
			},
			PlayerPortraitWidth = {
				order = 4,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},	
			PlayerPortraitHeight = {
				order = 5,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},
		},
	}
end
tinsert(E.BuiConfig, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.portrait.args.ufb = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.ufb[ info[#info] ] end,
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangeTarget(); end,
		args = {		
			detachTargetPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.ufb[ info[#info] ] = value;
					--Easiest way to properly set new width of various elements on the target frame
					--such as classbar, stagger, power etc. The alternative is to include a lot of code
					--in UFB:ArrangePlayer() to reposition these elements.
					if value == true then
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
					else
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 15
						E.db.unitframe.units.target.portrait.width = 45
					end
					UF:CreateAndUpdateUF('target')
				end,
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			TargetPortraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			TargetPortraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			getPlayerPortraitSize = {
				order = 4,
				type = 'toggle',
				name = L['Player Size'],
				desc = L['Copy Player portrait width and height'],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			TargetPortraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},	
			TargetPortraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},
		},
	}
end
tinsert(E.BuiConfig, ufTargetTable)

local function injectPetOptions()
	E.Options.args.unitframe.args.pet.args.emptybar = {
		order = 900,
		type = 'group',
		name = BUI:cOption(L["EmptyBars"]),
		get = function(info) return E.db.unitframe.units['pet']['emptybar'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['pet']['emptybar'][ info[#info] ] = value; UF:CreateAndUpdateUF('pet') end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			height = {
				type = 'range',
				order = 2,
				name = L["Height"],
				min = 10, max = 50, step = 1,
			},							
			transparent = {
				type = 'toggle',
				name = L["Transparent"],
				desc = L["Toggle EmptyBars transparency"],
				order = 3,
			},
			threat = {
				type = 'toggle',
				name = L['Threat on EmptyBars'],
				desc = L['Places the threat glow on Pet EmptyBar'],
				order = 4,
			},
		},
	}
end
tinsert(E.BuiConfig, injectPetOptions)

local function injectFocusOptions()
	E.Options.args.unitframe.args.focus.args.emptybar = {
		order = 900,
		type = 'group',
		name = BUI:cOption(L["EmptyBars"]),
		get = function(info) return E.db.unitframe.units['focus']['emptybar'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['focus']['emptybar'][ info[#info] ] = value; UF:CreateAndUpdateUF('focus'); end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			height = {
				type = 'range',
				order = 2,
				name = L["Height"],
				min = 10, max = 50, step = 1,
			},							
			transparent = {
				type = 'toggle',
				name = L["Transparent"],
				desc = L["Toggle EmptyBars transparency"],
				order = 3,
			},
			threat = {
				type = 'toggle',
				name = L['Threat on EmptyBars'],
				desc = L['Places the threat glow on Focus EmptyBar'],
				order = 4,
			},
		},
	}
end
tinsert(E.BuiConfig, injectFocusOptions)

local function injectTargetTargetOptions()
	E.Options.args.unitframe.args.targettarget.args.emptybar = {
		order = 900,
		type = 'group',
		name = BUI:cOption(L["EmptyBars"]),
		get = function(info) return E.db.unitframe.units['targettarget']['emptybar'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['targettarget']['emptybar'][ info[#info] ] = value; UF:CreateAndUpdateUF('targettarget'); end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			height = {
				type = 'range',
				order = 2,
				name = L["Height"],
				min = 10, max = 50, step = 1,
			},							
			transparent = {
				type = 'toggle',
				name = L["Transparent"],
				desc = L["Toggle EmptyBars transparency"],
				order = 3,
			},
			threat = {
				type = 'toggle',
				name = L['Threat on EmptyBars'],
				desc = L['Places the threat glow on TargetTarget EmptyBar'],
				order = 4,
			},
		},
	}
end
tinsert(E.BuiConfig, injectTargetTargetOptions)

local function injectPartyOptions()
	E.Options.args.unitframe.args.party.args.portrait.args.height = {
		type = 'range',
		order = 15,
		name = BUI:cOption("+ "..L["Height"]),
		min = 0, max = 150, step = 1,
	}
	
	E.Options.args.unitframe.args.party.args.portrait.args.transparent = {	
		order = 16,
		type = "toggle",
		name = BUI:cOption(L['Transparent']),
		desc = L['Makes the portrait backdrop transparent'],
		disabled = function() return E.db.unitframe.units.party.portrait.overlay end,
	}

	E.Options.args.unitframe.args.party.args.roleIcon.args.xOffset = {
		type = 'range',
		order = 7,
		name = BUI:cOption(L["xOffset"]),
		min = -150, max = 150, step = 1,
	}

	E.Options.args.unitframe.args.party.args.roleIcon.args.yOffset = {
		type = 'range',
		order = 8,
		name = BUI:cOption(L["yOffset"]),
		min = -150, max = 150, step = 1,
	}
	
	E.Options.args.unitframe.args.party.args.emptybar = {
		order = 900,
		type = 'group',
		name = BUI:cOption(L["EmptyBars"]),
		get = function(info) return E.db.unitframe.units['party']['emptybar'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['party']['emptybar'][ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('party') end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			height = {
				type = 'range',
				order = 2,
				name = L["Height"],
				min = 10, max = 50, step = 1,
			},							
			transparent = {
				type = 'toggle',
				name = L["Transparent"],
				desc = L["Toggle EmptyBars transparency"],
				order = 3,
			},
			threat = {
				type = 'toggle',
				name = L['Threat on EmptyBars'],
				desc = L['Places the threat glow on Party EmptyBars'],
				order = 4,
			},
		},
	}
end
tinsert(E.BuiConfig, injectPartyOptions)

local function injectRaidOptions()
	E.Options.args.unitframe.args.raid.args.emptybar = {
		order = 900,
		type = 'group',
		name = BUI:cOption(L["EmptyBars"]),
		get = function(info) return E.db.unitframe.units['raid']['emptybar'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['raid']['emptybar'][ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('raid') end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			height = {
				type = 'range',
				order = 2,
				name = L["Height"],
				min = 10, max = 50, step = 1,
			},							
			transparent = {
				type = 'toggle',
				name = L["Transparent"],
				desc = L["Toggle EmptyBars transparency"],
				order = 3,
			},
			threat = {
				type = 'toggle',
				name = L['Threat on EmptyBars'],
				desc = L['Places the threat glow on Raid EmptyBars'],
				order = 4,
			},
		},
	}
	
	E.Options.args.unitframe.args.raid.args.roleIcon.args.xOffset = {
		type = 'range',
		order = 7,
		name = BUI:cOption(L["xOffset"]),
		min = -50, max = 50, step = 1,
	}

	E.Options.args.unitframe.args.raid.args.roleIcon.args.yOffset = {
		type = 'range',
		order = 8,
		name = BUI:cOption(L["yOffset"]),
		min = -50, max = 50, step = 1,
	}
	
	E.Options.args.unitframe.args.raid.args.general.args.classHover = {	
		order = 7,
		type = "toggle",
		name = BUI:cOption(L['Class Hover']),
		desc = L['Enable Class color on health border, when mouse over'],
		set = function(info, value) E.db.unitframe.units['raid'][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
	}
end
tinsert(E.BuiConfig, injectRaidOptions)

local function injectRaid40Options()
	E.Options.args.unitframe.args.raid40.args.emptybar = {
		order = 900,
		type = 'group',
		name = BUI:cOption(L["EmptyBars"]),
		get = function(info) return E.db.unitframe.units['raid40']['emptybar'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['raid40']['emptybar'][ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('raid40') end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			height = {
				type = 'range',
				order = 2,
				name = L["Height"],
				min = 10, max = 50, step = 1,
			},							
			transparent = {
				type = 'toggle',
				name = L["Transparent"],
				desc = L["Toggle EmptyBars transparency"],
				order = 3,
			},
			threat = {
				type = 'toggle',
				name = L['Threat on EmptyBars'],
				desc = L['Places the threat glow on Raid-40 EmptyBars'],
				order = 4,
			},
		},
	}
	
	E.Options.args.unitframe.args.raid40.args.roleIcon.args.xOffset = {
		type = 'range',
		order = 7,
		name = BUI:cOption(L["xOffset"]),
		min = -50, max = 50, step = 1,
	}

	E.Options.args.unitframe.args.raid40.args.roleIcon.args.yOffset = {
		type = 'range',
		order = 8,
		name = BUI:cOption(L["yOffset"]),
		min = -50, max = 50, step = 1,
	}
	
	E.Options.args.unitframe.args.raid40.args.general.args.classHover = {	
		order = 7,
		type = "toggle",
		name = BUI:cOption(L['Class Hover']),
		desc = L['Enable Class color on health border, when mouse over'],
		set = function(info, value) E.db.unitframe.units['raid40'][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
	}
end
tinsert(E.BuiConfig, injectRaid40Options)