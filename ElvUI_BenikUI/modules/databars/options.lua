local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local mod = BUI:GetModule('Databars');

local tinsert = table.insert

local REPUTATION, ENABLE, DEFAULT = REPUTATION, ENABLE, DEFAULT

local backdropValues = {
	TRANSPARENT = L['Transparent'],
	DEFAULT = DEFAULT,
	NO_BACK = L['Without Backdrop'],
}

local function databarsTable()
	E.Options.args.benikui.args.benikuiDatabars = {
		order = 30,
		type = 'group',
		name = L['DataBars'],
		childGroups = 'tab',
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(L['DataBars']),
			},
			experience = {
				order = 1,
				type = 'group',
				name = L['XP Bar'],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikuiDatabars.experience.enable end,
						set = function(info, value) E.db.benikuiDatabars.experience.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					buiStyle = {
						order = 2,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.experience.enable end,
						desc = L['Show BenikUI decorative bars on the default ElvUI XP bar'],
						get = function(info) return E.db.benikuiDatabars.experience.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.experience.buiStyle = value; mod:ApplyXpStyling(); end,
					},
					buttonStyle = {
						order = 3,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.experience.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.experience.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.experience.buttonStyle = value; mod:ToggleXPBackdrop(); end,
					},
					notifiers = {
						order = 4,
						type = 'group',
						name = L['Notifiers'],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								get = function(info) return E.db.benikuiDatabars.experience.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.experience.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							combat = {
								order = 2,
								type = 'toggle',
								name = L["Combat Fade"],
								get = function(info) return E.db.benikuiDatabars.experience.notifiers.combat end,
								set = function(info, value) E.db.benikuiDatabars.experience.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 3,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.experience.notifiers.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiDatabars.experience.notifiers.position end,
								set = function(info, value) E.db.benikuiDatabars.experience.notifiers.position = value; mod:UpdateXpNotifierPositions(); end,
							},
						},
					},
					elvuiOption = {
						order = 10,
						type = "execute",
						name = L["ElvUI"].." "..XPBAR_LABEL,
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "experience") end,
					},
				},
			},
			azerite = {
				order = 2,
				type = 'group',
				name = L['Azerite Bar'],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikuiDatabars.azerite.enable end,
						set = function(info, value) E.db.benikuiDatabars.azerite.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					buiStyle = {
						order = 2,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.azerite.enable end,
						desc = L['Show BenikUI decorative bars on the default ElvUI Azerite bar'],
						get = function(info) return E.db.benikuiDatabars.azerite.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.azerite.buiStyle = value; mod:ApplyAzeriteStyling(); end,
					},
					buttonStyle = {
						order = 3,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.azerite.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.azerite.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.azerite.buttonStyle = value; mod:ToggleAzeriteBackdrop(); end,
					},
					notifiers = {
						order = 4,
						type = 'group',
						name = L['Notifiers'],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								get = function(info) return E.db.benikuiDatabars.azerite.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.azerite.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							combat = {
								order = 2,
								type = 'toggle',
								name = L["Combat Fade"],
								get = function(info) return E.db.benikuiDatabars.azerite.notifiers.combat end,
								set = function(info, value) E.db.benikuiDatabars.azerite.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 3,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.azerite.notifiers.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiDatabars.azerite.notifiers.position end,
								set = function(info, value) E.db.benikuiDatabars.azerite.notifiers.position = value; mod:UpdateAzeriteNotifier(); end,
							},
						},
					},
					elvuiOption = {
						order = 10,
						type = "execute",
						name = L["ElvUI"].." "..L["Azerite Bar"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "azerite") end,
					},
				},
			},
			reputation = {
				order = 3,
				type = 'group',
				name = REPUTATION,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikuiDatabars.reputation.enable end,
						set = function(info, value) E.db.benikuiDatabars.reputation.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					buiStyle = {
						order = 2,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.reputation.enable end,
						desc = L['Show BenikUI decorative bars on the default ElvUI Reputation bar'],
						get = function(info) return E.db.benikuiDatabars.reputation.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.reputation.buiStyle = value; mod:ApplyRepStyling(); end,
					},
					buttonStyle = {
						order = 3,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.reputation.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.reputation.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.reputation.buttonStyle = value; mod:ToggleRepBackdrop(); end,
					},
					autotrack = {
						order = 4,
						type = 'toggle',
						name = L['AutoTrack'],
						desc = L['Change the tracked Faction automatically when reputation changes'],
						get = function(info) return E.db.benikuiDatabars.reputation.autotrack end,
						set = function(info, value) E.db.benikuiDatabars.reputation.autotrack = value; mod:ToggleRepAutotrack(); end,
					},
					notifiers = {
						order = 5,
						type = 'group',
						name = L['Notifiers'],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								get = function(info) return E.db.benikuiDatabars.reputation.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.reputation.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							combat = {
								order = 2,
								type = 'toggle',
								name = L["Combat Fade"],
								get = function(info) return E.db.benikuiDatabars.reputation.notifiers.combat end,
								set = function(info, value) E.db.benikuiDatabars.reputation.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 3,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.reputation.notifiers.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiDatabars.reputation.notifiers.position end,
								set = function(info, value) E.db.benikuiDatabars.reputation.notifiers.position = value; mod:UpdateRepNotifierPositions(); end,
							},
						},
					},
					elvuiOption = {
						order = 10,
						type = "execute",
						name = L["ElvUI"].." "..REPUTATION,
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "reputation") end,
					},
				},
			},
			honor = {
				order = 4,
				type = 'group',
				name = HONOR,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikuiDatabars.honor.enable end,
						set = function(info, value) E.db.benikuiDatabars.honor.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					buiStyle = {
						order = 2,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.honor.enable end,
						desc = L['Show BenikUI decorative bars on the default ElvUI Honor bar'],
						get = function(info) return E.db.benikuiDatabars.honor.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.honor.buiStyle = value; mod:ApplyHonorStyling(); end,
					},
					buttonStyle = {
						order = 3,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.honor.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.honor.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.honor.buttonStyle = value; mod:ToggleHonorBackdrop(); end,
					},
					notifiers = {
						order = 4,
						type = 'group',
						name = L['Notifiers'],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								get = function(info) return E.db.benikuiDatabars.honor.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.honor.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							combat = {
								order = 2,
								type = 'toggle',
								name = L["Combat Fade"],
								get = function(info) return E.db.benikuiDatabars.honor.notifiers.combat end,
								set = function(info, value) E.db.benikuiDatabars.honor.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 3,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.honor.notifiers.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiDatabars.honor.notifiers.position end,
								set = function(info, value) E.db.benikuiDatabars.honor.notifiers.position = value; mod:UpdateHonorNotifierPositions(); end,
							},
						},
					},
					elvuiOption = {
						order = 10,
						type = "execute",
						name = L["ElvUI"].." "..HONOR,
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "honor") end,
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, databarsTable)

local function injectElvUIDatabarOptions()
	-- xp
	E.Options.args.databars.args.experience.args.textYoffset = {
		order = 20,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.experience[ info[#info] ] end,
		set = function(info, value) E.db.databars.experience[ info[#info] ] = value; mod:XpTextOffset() end,
	}

	E.Options.args.databars.args.experience.args.spacer1 = {
		order = 21,
		type = 'description',
		name = '',
	}
	E.Options.args.databars.args.experience.args.spacer2 = {
		order = 22,
		type = 'header',
		name = '',
	}

	E.Options.args.databars.args.experience.args.gotobenikui = {
		order = 23,
		type = "execute",
		name = BUI.Title..XPBAR_LABEL,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "experience") end,
	}

	-- azerite
	E.Options.args.databars.args.azerite.args.textYoffset = {
		order = 20,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.azerite[ info[#info] ] end,
		set = function(info, value) E.db.databars.azerite[ info[#info] ] = value; mod:AzeriteTextOffset() end,
	}

	E.Options.args.databars.args.azerite.args.spacer1 = {
		order = 21,
		type = 'description',
		name = '',
	}

	E.Options.args.databars.args.azerite.args.spacer2 = {
		order = 22,
		type = 'header',
		name = '',
	}

	E.Options.args.databars.args.azerite.args.gotobenikui = {
		order = 23,
		type = "execute",
		name = BUI.Title..L["Azerite Bar"],
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "azerite") end,
	}

	-- reputation
	E.Options.args.databars.args.reputation.args.textYoffset = {
		order = 20,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.reputation[ info[#info] ] end,
		set = function(info, value) E.db.databars.reputation[ info[#info] ] = value; mod:RepTextOffset() end,
	}

	E.Options.args.databars.args.reputation.args.spacer1 = {
		order = 21,
		type = 'description',
		name = '',
	}

	E.Options.args.databars.args.reputation.args.spacer2 = {
		order = 22,
		type = 'header',
		name = '',
	}

	E.Options.args.databars.args.reputation.args.gotobenikui = {
		order = 23,
		type = "execute",
		name = BUI.Title..REPUTATION,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "reputation") end,
	}

	-- honor
	E.Options.args.databars.args.honor.args.textYoffset = {
		order = 20,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.honor[ info[#info] ] end,
		set = function(info, value) E.db.databars.honor[ info[#info] ] = value; mod:HonorTextOffset() end,
	}

	E.Options.args.databars.args.honor.args.spacer1 = {
		order = 21,
		type = 'description',
		name = '',
	}

	E.Options.args.databars.args.honor.args.spacer2 = {
		order = 22,
		type = 'header',
		name = '',
	}

	E.Options.args.databars.args.honor.args.gotobenikui = {
		order = 23,
		type = "execute",
		name = BUI.Title..HONOR,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "honor") end,
	}
end
tinsert(BUI.Config, injectElvUIDatabarOptions)
