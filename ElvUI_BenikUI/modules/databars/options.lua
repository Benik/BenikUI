local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BDB = E:GetModule('BenikUI_databars');

local tinsert = table.insert

local COMBAT_XP_GAIN, REPUTATION, ENABLE, COLOR, DEFAULT = COMBAT_XP_GAIN, REPUTATION, ENABLE, COLOR, DEFAULT
local TUTORIAL_TITLE26, FACTION_STANDING_LABEL1, FACTION_STANDING_LABEL2 = TUTORIAL_TITLE26, FACTION_STANDING_LABEL1, FACTION_STANDING_LABEL2
local FACTION_STANDING_LABEL3, FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5 = FACTION_STANDING_LABEL3, FACTION_STANDING_LABEL4, FACTION_STANDING_LABEL5

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
						name = ENABLE,
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
						set = function(info, value) E.db.benikuiDatabars.experience.buiStyle = value; BDB:ApplyXpStyling(); end,
					},
					buttonStyle = {
						order = 3,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.experience.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.experience.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.experience.buttonStyle = value; BDB:ToggleXPBackdrop(); end,
					},
					color = {
						order = 4,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.benikuiDatabars.experience.color.default end,
								set = function(info, value) E.db.benikuiDatabars.experience.color.default = value; BDB:ChangeXPcolor(); end,
							},
							xp = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = COMBAT_XP_GAIN,
								disabled = function() return E.db.benikuiDatabars.experience.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.experience.color.xp
									local d = P.benikuiDatabars.experience.color.xp
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.experience.color.xp
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeXPcolor()
								end,
							},
							rested = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = TUTORIAL_TITLE26,
								disabled = function() return E.db.benikuiDatabars.experience.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.experience.color.rested
									local d = P.benikuiDatabars.experience.color.rested
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.experience.color.rested
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeXPcolor()
								end,
							},
						},
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
								name = ENABLE,
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
								set = function(info, value) E.db.benikuiDatabars.experience.notifiers.position = value; BDB:UpdateXpNotifierPositions(); end,
							},
						},
					},
				},
			},
			artifact = {
				order = 2,
				type = 'group',
				name = L['Artifact Bar'],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						get = function(info) return E.db.benikuiDatabars.artifact.enable end,
						set = function(info, value) E.db.benikuiDatabars.artifact.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					buiStyle = {
						order = 2,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return not E.db.benikuiDatabars.artifact.enable end,
						desc = L['Show BenikUI decorative bars on the default ElvUI Artifact bar'],
						get = function(info) return E.db.benikuiDatabars.artifact.buiStyle end,
						set = function(info, value) E.db.benikuiDatabars.artifact.buiStyle = value; BDB:ApplyAfStyling(); end,
					},
					buttonStyle = {
						order = 3,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.artifact.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.artifact.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.artifact.buttonStyle = value; BDB:ToggleAFBackdrop(); end,
					},
					color = {
						order = 4,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.benikuiDatabars.artifact.color.default end,
								set = function(info, value) E.db.benikuiDatabars.artifact.color.default = value; BDB:ChangeAFcolor(); end,
							},
							af = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = ARTIFACT_POWER,
								disabled = function() return E.db.benikuiDatabars.artifact.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.artifact.color.af
									local d = P.benikuiDatabars.artifact.color.af
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.artifact.color.af
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeAFcolor()
								end,
							},
						},
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
								name = ENABLE,
								get = function(info) return E.db.benikuiDatabars.artifact.notifiers.enable end,
								set = function(info, value) E.db.benikuiDatabars.artifact.notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							combat = {
								order = 2,
								type = 'toggle',
								name = L["Combat Fade"],
								get = function(info) return E.db.benikuiDatabars.artifact.notifiers.combat end,
								set = function(info, value) E.db.benikuiDatabars.artifact.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							position = {
								order = 3,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.benikuiDatabars.artifact.notifiers.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.benikuiDatabars.artifact.notifiers.position end,
								set = function(info, value) E.db.benikuiDatabars.artifact.notifiers.position = value; BDB:UpdateAfNotifierPositions(); end,
							},
						},
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
						name = ENABLE,
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
						set = function(info, value) E.db.benikuiDatabars.reputation.buiStyle = value; BDB:ApplyRepStyling(); end,
					},
					buttonStyle = {
						order = 4,
						type = 'select',
						name = L['Button Backdrop'],
						disabled = function() return not E.db.benikuiDatabars.reputation.enable end,
						values = backdropValues,
						get = function(info) return E.db.benikuiDatabars.reputation.buttonStyle end,
						set = function(info, value) E.db.benikuiDatabars.reputation.buttonStyle = value; BDB:ToggleRepBackdrop(); end,
					},
					color = {
						order = 5,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {				
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.benikuiDatabars.reputation.color.default end,
								set = function(info, value) E.db.benikuiDatabars.reputation.color.default = value; BDB:ChangeRepColor(); end,
							},
							friendly = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL5.."+",
								disabled = function() return E.db.benikuiDatabars.reputation.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.reputation.color.friendly
									local d = P.benikuiDatabars.reputation.color.friendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.reputation.color.friendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeRepColor()
								end,
							},
							neutral = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL4,
								disabled = function() return E.db.benikuiDatabars.reputation.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.reputation.color.neutral
									local d = P.benikuiDatabars.reputation.color.neutral
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.reputation.color.neutral
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeRepColor()
								end,
							},
							unfriendly = {
								order = 4,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL3,
								disabled = function() return E.db.benikuiDatabars.reputation.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.reputation.color.unfriendly
									local d = P.benikuiDatabars.reputation.color.unfriendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.reputation.color.unfriendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeRepColor()
								end,
							},
							hated = {
								order = 5,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL2.."/"..FACTION_STANDING_LABEL1,
								disabled = function() return E.db.benikuiDatabars.reputation.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.reputation.color.hated
									local d = P.benikuiDatabars.reputation.color.hated
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.reputation.color.hated
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeRepColor()
								end,
							},
						},
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
								name = ENABLE,
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
								set = function(info, value) E.db.benikuiDatabars.reputation.notifiers.position = value; BDB:UpdateRepNotifierPositions(); end,
							},
						},
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
						name = ENABLE,
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
						set = function(info, value) E.db.benikuiDatabars.honor.buiStyle = value; BDB:ApplyHonorStyling(); end,
					},
					color = {
						order = 3,
						type = 'group',
						name = COLOR,
						guiInline = true,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.benikuiDatabars.honor.color.default end,
								set = function(info, value) E.db.benikuiDatabars.honor.color.default = value; BDB:ChangeHonorColor(); end,
							},
							hn = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = HONOR,
								disabled = function() return E.db.benikuiDatabars.honor.color.default end,
								get = function(info)
									local t = E.db.benikuiDatabars.honor.color.hn
									local d = P.benikuiDatabars.honor.color.hn
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikuiDatabars[ info[#info] ] = {}
									local t = E.db.benikuiDatabars.honor.color.hn
									t.r, t.g, t.b, t.a = r, g, b, a
									BDB:ChangeHonorColor()
								end,
							},
						},
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
								name = ENABLE,
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
								set = function(info, value) E.db.benikuiDatabars.honor.notifiers.position = value; BDB:UpdateHonorNotifierPositions(); end,
							},
						},
					},				
				},
			},
		},
	}
end
tinsert(BUI.Config, databarsTable)