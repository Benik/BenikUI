local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local mod = BUI:GetModule('Databars');

local tinsert = table.insert

local REPUTATION, DEFAULT = REPUTATION, DEFAULT

local backdropValues = {
	TRANSPARENT = L['Transparent'],
	DEFAULT = DEFAULT,
	NO_BACK = L['Without Backdrop'],
}

local positionValues = {
	['ABOVE'] = L['Above'],
	['BELOW'] = L['Below'],
	['LEFT'] = L['Left'],
	['RIGHT'] = L['Right'],
}

local function databarsTable()
	E.Options.args.benikui.args.benikuiDatabars = {
		order = 80,
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
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					buiStyle = {
						order = 3,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.experience.enable end,
						get = function(info) return E.db.benikuiDatabars.experience.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.experience.buiStyle = value; mod:ApplyXpStyling(); end,
					},
					buttonStyle = {
						order = 4,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.experience.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.experience.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.experience.buttonStyle = value; mod:ToggleXPBackdrop(); end,
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
								get = function(info) return E.db.benikuiDatabars.experience.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.experience.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							spacer1 = {
								order = 2,
								type = 'description',
								name = '',
							},
							combat = {
								order = 3,
								type = 'toggle',
								name = L["Combat Fade"],
								get = function(info) return E.db.benikuiDatabars.experience.notifiers.combat end,
								set = function(info, value) E.db.benikuiDatabars.experience.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 4,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.experience.notifiers.enable end,
								values = positionValues,
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
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					buiStyle = {
						order = 3,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.azerite.enable end,
						get = function(info) return E.db.benikuiDatabars.azerite.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.azerite.buiStyle = value; mod:ApplyAzeriteStyling(); end,
					},
					buttonStyle = {
						order = 4,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.azerite.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.azerite.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.azerite.buttonStyle = value; mod:ToggleAzeriteBackdrop(); end,
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
								values = positionValues,
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
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					buiStyle = {
						order = 3,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.reputation.enable end,
						get = function(info) return E.db.benikuiDatabars.reputation.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.reputation.buiStyle = value; mod:ApplyRepStyling(); end,
					},
					buttonStyle = {
						order = 4,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.reputation.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.reputation.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.reputation.buttonStyle = value; mod:ToggleRepBackdrop(); end,
					},
					notifiers = {
						order = 6,
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
								values = positionValues,
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
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					buiStyle = {
						order = 3,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.honor.enable end,
						get = function(info) return E.db.benikuiDatabars.honor.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.honor.buiStyle = value; mod:ApplyHonorStyling(); end,
					},
					buttonStyle = {
						order = 4,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.honor.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.honor.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.honor.buttonStyle = value; mod:ToggleHonorBackdrop(); end,
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
								values = positionValues,
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
			threat = {
				order = 5,
				type = 'group',
				name = L["Threat"],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikuiDatabars.threat.enable end,
						set = function(info, value) E.db.benikuiDatabars.threat.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					buiStyle = {
						order = 3,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.threat.enable end,
						get = function(info) return E.db.benikuiDatabars.threat.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.threat.buiStyle = value; mod:ApplyThreatStyling(); end,
					},
					buttonStyle = {
						order = 4,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.threat.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.threat.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.threat.buttonStyle = value; mod:ToggleThreatBackdrop(); end,
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
								get = function(info) return E.db.benikuiDatabars.threat.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.threat.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 3,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.threat.notifiers.enable end,
								values = positionValues,
								get = function(info) return E.db.benikuiDatabars.threat.notifiers.position end,
								set = function(info, value) E.db.benikuiDatabars.threat.notifiers.position = value; mod:UpdateThreatNotifierPositions(); end,
							},
						},
					},
					elvuiOption = {
						order = 10,
						type = "execute",
						name = L["ElvUI"].." "..L["Threat"],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", "threat") end,
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, databarsTable)

local function injectElvUIDatabarOptions()
	-- xp
	E.Options.args.databars.args.experience.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.experience[ info[#info] ] end,
		set = function(info, value) E.db.databars.experience[ info[#info] ] = value; mod:XpTextOffset() end,
	}

	E.Options.args.databars.args.experience.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..XPBAR_LABEL,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "experience") end,
	}

	-- azerite
	E.Options.args.databars.args.azerite.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.azerite[ info[#info] ] end,
		set = function(info, value) E.db.databars.azerite[ info[#info] ] = value; mod:AzeriteTextOffset() end,
	}

	E.Options.args.databars.args.azerite.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..L["Azerite Bar"],
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "azerite") end,
	}

	-- reputation
	E.Options.args.databars.args.reputation.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.reputation[ info[#info] ] end,
		set = function(info, value) E.db.databars.reputation[ info[#info] ] = value; mod:RepTextOffset() end,
	}

	E.Options.args.databars.args.reputation.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..REPUTATION,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "reputation") end,
	}

	-- honor
	E.Options.args.databars.args.honor.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.honor[ info[#info] ] end,
		set = function(info, value) E.db.databars.honor[ info[#info] ] = value; mod:HonorTextOffset() end,
	}

	E.Options.args.databars.args.honor.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..HONOR,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "honor") end,
	}

	-- threat
	E.Options.args.databars.args.threat.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset']),
		get = function(info) return E.db.databars.threat[ info[#info] ] end,
		set = function(info, value) E.db.databars.threat[ info[#info] ] = value; mod:ThreatTextOffset() end,
	}

	E.Options.args.databars.args.threat.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..HONOR,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "threat") end,
	}
end
tinsert(BUI.Config, injectElvUIDatabarOptions)
