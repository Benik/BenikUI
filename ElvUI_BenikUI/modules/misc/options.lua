local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');
local B = E:GetModule('Bags')

local tinsert = table.insert

local COMBAT_XP_GAIN, REPUTATION, ENABLE, COLOR, DEFAULT = COMBAT_XP_GAIN, REPUTATION, ENABLE, COLOR, DEFAULT
local TUTORIAL_TITLE26, FACTION_STANDING_LABEL1, FACTION_STANDING_LABEL2 = TUTORIAL_TITLE26, FACTION_STANDING_LABEL1, FACTION_STANDING_LABEL2
local FACTION_STANDING_LABEL3, FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5 = FACTION_STANDING_LABEL3, FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5

if E.db.benikuiXprep == nil then E.db.benikuiXprep = {} end

local function xprepTable()
	E.Options.args.benikui.args.benikuiXprep = {
		order = 30,
		type = 'group',
		name = COMBAT_XP_GAIN.."/"..REPUTATION,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(COMBAT_XP_GAIN.."/"..REPUTATION),
			},
			enable = {
				order = 2,
				type = 'toggle',
				name = ENABLE,
				get = function(info) return E.db.benikuiXprep.enable end,
				set = function(info, value) E.db.benikuiXprep.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			buiStyle = {
				order = 3,
				type = 'toggle',
				name = L['BenikUI Style'],
				disabled = function() return not E.db.benikuiXprep.enable end,
				desc = L['Show BenikUI decorative bars on the default ElvUI xp/rep bars'],
				get = function(info) return E.db.benikuiXprep.buiStyle end,
				set = function(info, value) E.db.benikuiXprep.buiStyle = value; BXR:ApplyXpRepStyling(); end,
			},
			color = {
				order = 4,
				type = 'group',
				name = COLOR,
				guiInline = true,
				args = {
					experience = {
						order = 1,
						type = 'group',
						name = COMBAT_XP_GAIN,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.benikuiXprep.color.experience.default end,
								set = function(info, value) E.db.benikuiXprep.color.experience.default = value; BXR:ChangeXPcolor(); end,
							},
							xp = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = COMBAT_XP_GAIN,
								disabled = function() return E.db.benikuiXprep.color.experience.default end,
								get = function(info)
									local t = E.db.benikuiXprep.color.experience.xp
									local d = P.benikuiXprep.color.experience.xp
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiXprep[ info[#info] ] = {}
									local t = E.db.benikuiXprep.color.experience.xp
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeXPcolor()
								end,
							},
							rested = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = TUTORIAL_TITLE26,
								disabled = function() return E.db.benikuiXprep.color.experience.default end,
								get = function(info)
									local t = E.db.benikuiXprep.color.experience.rested
									local d = P.benikuiXprep.color.experience.rested
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiXprep[ info[#info] ] = {}
									local t = E.db.benikuiXprep.color.experience.rested
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeXPcolor()
								end,
							},
						},
					},
					reputation = {
						order = 2,
						type = 'group',
						name = REPUTATION,
						args = {				
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.benikuiXprep.color.reputation.default end,
								set = function(info, value) E.db.benikuiXprep.color.reputation.default = value; BXR:ChangeRepColor(); end,
							},
							friendly = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL5.."+",
								disabled = function() return E.db.benikuiXprep.color.reputation.default end,
								get = function(info)
									local t = E.db.benikuiXprep.color.reputation.friendly
									local d = P.benikuiXprep.color.reputation.friendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiXprep[ info[#info] ] = {}
									local t = E.db.benikuiXprep.color.reputation.friendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							neutral = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL4,
								disabled = function() return E.db.benikuiXprep.color.reputation.default end,
								get = function(info)
									local t = E.db.benikuiXprep.color.reputation.neutral
									local d = P.benikuiXprep.color.reputation.neutral
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiXprep[ info[#info] ] = {}
									local t = E.db.benikuiXprep.color.reputation.neutral
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							unfriendly = {
								order = 4,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL3,
								disabled = function() return E.db.benikuiXprep.color.reputation.default end,
								get = function(info)
									local t = E.db.benikuiXprep.color.reputation.unfriendly
									local d = P.benikuiXprep.color.reputation.unfriendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiXprep[ info[#info] ] = {}
									local t = E.db.benikuiXprep.color.reputation.unfriendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							hated = {
								order = 5,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL2.."/"..FACTION_STANDING_LABEL1,
								disabled = function() return E.db.benikuiXprep.color.reputation.default end,
								get = function(info)
									local t = E.db.benikuiXprep.color.reputation.hated
									local d = P.benikuiXprep.color.reputation.hated
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiXprep[ info[#info] ] = {}
									local t = E.db.benikuiXprep.color.reputation.hated
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},			
						},
					},
				},
			},
			notifiers = {
				order = 5,
				type = 'group',
				name = L['Notifiers'],
				guiInline = true,
				args = {
					desc = {
						order = 1,
						type = 'description',
						name = L['Show a small arrow and percentage, near the xp/rep vertical statusbars.'],
						fontSize = 'medium',
					},
					spacer = {
						order = 2,
						type = 'description',
						name = '',
						fontSize = 'medium',
					},
					combat = {
						order = 3,
						type = 'toggle',
						name = L["Combat Fade"],
						get = function(info) return E.db.benikuiXprep.notifiers.combat end,
						set = function(info, value) E.db.benikuiXprep.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					experience = {
						order = 4,
						type = 'group',
						name = COMBAT_XP_GAIN,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = ENABLE,
								get = function(info) return E.db.benikuiXprep.notifiers.experience.enable end,
								set = function(info, value) E.db.benikuiXprep.notifiers.experience.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},	
							position = {
								order = 2,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiXprep.notifiers.experience.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiXprep.notifiers.experience.position end,
								set = function(info, value) E.db.benikuiXprep.notifiers.experience.position = value; BXR:UpdateXpNotifierPositions(); end,
							},
						},
					},
					reputation = {
						order = 5,
						type = 'group',
						name = REPUTATION,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = ENABLE,
								get = function(info) return E.db.benikuiXprep.notifiers.reputation.enable end,
								set = function(info, value) E.db.benikuiXprep.notifiers.reputation.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},	
							position = {
								order = 2,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiXprep.notifiers.reputation.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiXprep.notifiers.reputation.position end,
								set = function(info, value) E.db.benikuiXprep.notifiers.reputation.position = value; BXR:UpdateRepNotifierPositions(); end,
							},
						},
					},
				},
			},
		},
	}

	E.Options.args.benikui.args.misc = {
		order = 40,
		type = 'group',
		name = MISCELLANEOUS,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(MISCELLANEOUS),
			},
			flightMode = {
				order = 2,
				type = 'group',
				guiInline = true,
				name = L['Flight Mode']..BUI.NewSign,
				get = function(info) return E.db.benikui.misc.flightMode[ info[#info] ] end,
				set = function(info, value) E.db.benikui.misc.flightMode[ info[#info] ] = value; E:GetModule('BUIFlightMode'):Toggle() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Display the Flight Mode screen when taking flight paths'],
					},
				},
			},
			ilevel = {
				order = 3,
				type = 'group',
				guiInline = true,
				name = L['iLevel'],
				get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
				set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; BUI:update_iLevelItems() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Show item level per slot, on the character info frame'],
						width = "full",
						get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,	
					},
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 2,
						name = L['Font'],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					fontsize = {
						order = 3,
						name = FONT_SIZE,
						type = 'range',
						min = 6, max = 22, step = 1,
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					fontflags = {
						order = 4,
						name = L['Font Outline'],
						type = 'select',
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					colorStyle = {
						order = 5,
						type = "select",
						name = COLOR,
						values = {
							['RARITY'] = RARITY,
							['CUSTOM'] = CUSTOM,
						},
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					color = {
						order = 6,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.benikui.misc.ilevel.colorStyle == 'RARITY' or not E.db.benikui.misc.ilevel.enable end,
						get = function(info)
							local t = E.db.benikui.misc.ilevel[ info[#info] ]
							local d = P.benikui.misc.ilevel[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
						set = function(info, r, g, b)
							E.db.benikui.misc.ilevel[ info[#info] ] = {}
							local t = E.db.benikui.misc.ilevel[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
						end,
					},
				},
			},
			panels = {
				order = 4,
				type = 'group',
				guiInline = true,
				name = L['Panels'],
				args = {
					top = {
						order = 1,
						type = 'group',
						guiInline = true,
						name = L['Top Panel'],
						get = function(info) return E.db.benikui.misc.panels.top[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc.panels.top[ info[#info] ] = value; E:GetModule('BuiLayout'):TopPanelLayout() end,
						args = {
							style = {
								order = 1,
								type = 'toggle',
								name = L['BenikUI Style'],
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
							},
							transparency = {
								order = 2,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							height = {
								order = 3,
								type = "range",
								name = L["Height"],
								min = 8, max = 60, step = 1,
							},
						},
					},
					bottom = {
						order = 2,
						type = 'group',
						guiInline = true,
						name = L['Bottom Panel'],
						get = function(info) return E.db.benikui.misc.panels.bottom[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc.panels.bottom[ info[#info] ] = value; E:GetModule('BuiLayout'):BottomPanelLayout() end,
						args = {
							style = {
								order = 1,
								type = 'toggle',
								name = L['BenikUI Style'],
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
							},
							transparency = {
								order = 2,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							height = {
								order = 3,
								type = "range",
								name = L["Height"],
								min = 8, max = 60, step = 1,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, xprepTable)

local positionValues = {
	TOPLEFT = 'TOPLEFT',
	LEFT = 'LEFT',
	BOTTOMLEFT = 'BOTTOMLEFT',
	RIGHT = 'RIGHT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	BOTTOM = 'BOTTOM',
}

local function injectBagOptions()
	E.Options.args.bags.args.general.args.countGroup.args.countPosition = {
		type = 'select',
		order = 5,
		name = BUI:cOption(L["Position"]),
		values = positionValues,
		set = function(info, value) E.db.bags.countPosition = value; B:UpdateCountDisplay() end,
	}
end
tinsert(BUI.Config, injectBagOptions)