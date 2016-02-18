local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');
local B = E:GetModule('Bags')

local tinsert = table.insert

if E.db.buixprep == nil then E.db.buixprep = {} end

local function xprepTable()
	E.Options.args.bui.args.config.args.buixprep = {
		order = 30,
		type = 'group',
		name = COMBAT_XP_GAIN.."/"..REPUTATION,
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = ENABLE,
				get = function(info) return E.db.buixprep.enable end,
				set = function(info, value) E.db.buixprep.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			buiStyle = {
				order = 2,
				type = 'toggle',
				name = L['BenikUI Style'],
				disabled = function() return not E.db.buixprep.enable end,
				desc = L['Show BenikUI decorative bars on the default ElvUI xp/rep bars'],
				get = function(info) return E.db.buixprep.buiStyle end,
				set = function(info, value) E.db.buixprep.buiStyle = value; BXR:ApplyXpRepStyling(); end,
			},
			color = {
				order = 3,
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
								get = function(info) return E.db.buixprep.color.experience.default end,
								set = function(info, value) E.db.buixprep.color.experience.default = value; BXR:ChangeXPcolor(); end,
							},
							xp = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = COMBAT_XP_GAIN,
								disabled = function() return E.db.buixprep.color.experience.default end,
								get = function(info)
									local t = E.db.buixprep.color.experience.xp
									local d = P.buixprep.color.experience.xp
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.buixprep[ info[#info] ] = {}
									local t = E.db.buixprep.color.experience.xp
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeXPcolor()
								end,
							},
							rested = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = TUTORIAL_TITLE26,
								disabled = function() return E.db.buixprep.color.experience.default end,
								get = function(info)
									local t = E.db.buixprep.color.experience.rested
									local d = P.buixprep.color.experience.rested
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.buixprep[ info[#info] ] = {}
									local t = E.db.buixprep.color.experience.rested
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
								get = function(info) return E.db.buixprep.color.reputation.default end,
								set = function(info, value) E.db.buixprep.color.reputation.default = value; BXR:ChangeRepColor(); end,
							},
							friendly = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL5.."+",
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.friendly
									local d = P.buixprep.color.reputation.friendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.buixprep[ info[#info] ] = {}
									local t = E.db.buixprep.color.reputation.friendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							neutral = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL4,
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.neutral
									local d = P.buixprep.color.reputation.neutral
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.buixprep[ info[#info] ] = {}
									local t = E.db.buixprep.color.reputation.neutral
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							unfriendly = {
								order = 4,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL3,
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.unfriendly
									local d = P.buixprep.color.reputation.unfriendly
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.buixprep[ info[#info] ] = {}
									local t = E.db.buixprep.color.reputation.unfriendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							hated = {
								order = 5,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL2.."/"..FACTION_STANDING_LABEL1,
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.hated
									local d = P.buixprep.color.reputation.hated
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.buixprep[ info[#info] ] = {}
									local t = E.db.buixprep.color.reputation.hated
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},			
						},
					},
				},
			},
			notifiers = {
				order = 4,
				type = 'group',
				name = L['Notifiers']..BUI.newsign,
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
						get = function(info) return E.db.buixprep.notifiers.combat end,
						set = function(info, value) E.db.buixprep.notifiers.combat = value; E:StaticPopup_Show('PRIVATE_RL'); end,
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
								get = function(info) return E.db.buixprep.notifiers.experience.enable end,
								set = function(info, value) E.db.buixprep.notifiers.experience.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},	
							position = {
								order = 2,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.buixprep.notifiers.experience.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.buixprep.notifiers.experience.position end,
								set = function(info, value) E.db.buixprep.notifiers.experience.position = value; BXR:UpdateXpNotifierPositions(); end,
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
								get = function(info) return E.db.buixprep.notifiers.reputation.enable end,
								set = function(info, value) E.db.buixprep.notifiers.reputation.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},	
							position = {
								order = 2,
								type = 'select',
								name = L['Position'],
								disabled = function() return not E.db.buixprep.notifiers.reputation.enable end,
								values = {
									['LEFT'] = L['Left'],
									['RIGHT'] = L['Right'],
								},
								get = function(info) return E.db.buixprep.notifiers.reputation.position end,
								set = function(info, value) E.db.buixprep.notifiers.reputation.position = value; BXR:UpdateRepNotifierPositions(); end,
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