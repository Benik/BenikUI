local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');

if E.db.buixprep == nil then E.db.buixprep = {} end

local function xprepTable()
	E.Options.args.bui.args.config.args.buixprep = {
		order = 30,
		type = 'group',
		name = COMBAT_XP_GAIN.."/"..REPUTATION,
		disabled = function() return not E.db.ufb.barshow or not E.private.unitframe.enable end,
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
		},
	}
end

table.insert(E.BuiConfig, xprepTable)