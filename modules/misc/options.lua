local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');
local UFB = E:GetModule('BuiUnits');

if E.db.xprep == nil then E.db.xprep = {} end

-- Defaults
P['xprep'] = {
	['show'] = "REP",
	['textStyle'] = 'UNIT',
	['mouseOver'] = true,
	['xp'] = { r = 0, g = 0.4, b = 1, a = .8 },
	['rested'] = { r = 1, g = 0, b = 1, a = .2 },
	['reputation'] = {r = 0, g = 1, b = 0, a = .8 },
}

local function xprepTable()
	E.Options.args.bui.args.config.args.xprep = {
		order = 30,
		type = 'group',
		name = L["XP - Rep"],
		disabled = function() return not E.db.ufb.barshow end,
		get = function(info) return E.db.xprep[ info[#info] ] end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["XP - Rep"],
			},
			show = {
				order = 2,
				type = "select",
				name = L["Show in PlayerBar"],
				desc = L["Empty Frames must be enabled \n(in UnitFrames options)"],
				values = {
					['NONE'] = L['None'],
					['REP'] = L['Reputation'],
					['XP'] = L['Experience'],
				},
				set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:EnableDisable_ReputationBar(); BXR:EnableDisable_ExperienceBar(); end,
			},
			text = {
				order = 3,
				type = 'group',
				name = L["Text"],
				guiInline = true,
				args = {
					textStyle = {
						order = 1,
						type = "select",
						name = L["Copy Font Style from"],
						values = {
							['DEFAULT'] = DEFAULT,
							['DTS'] = L['DataTexts'],
							['UNIT'] = L['UnitFrames'],
						},
						set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:ChangeRepXpFont(); end,
					},
					textFormat = {
						order = 2,
						type = 'select',
						name = L["Text Format"],
						values = {
							NONE = NONE,
							PERCENT = L["Percent"],
							CURMAX = L["Current - Max"],
							CURPERC = L["Current - Percent"],
						},
						set = function(info, value) E.db.xprep[ info[#info] ] = value; if E.db.xprep.show == 'XP' then BXR:UpdateExperience() elseif E.db.xprep.show == 'REP' then BXR:UpdateReputation() end; end,
					},
					mouseOver = {
						order = 3,
						type = "toggle",
						name = L["Hide PlayerBar text values"],
						desc = L["Hides health, power and custom text values when mousing over, if their yOffset is"].." < -10",
						set = function(info, value) E.db.xprep[ info[#info] ] = value end,
					},
				},
			},
			color = {
				order = 4,
				type = 'group',
				name = L["Color"],
				guiInline = true,
				args = {
					default = {
						order = 1,
						type = "toggle",
						name = DEFAULT,
						width = "full",
						get = function(info) return E.db.xprep[ info[#info] ] end,
						set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:ChangeXPcolor(); BXR:ChangeRepColor(); end,
					},
					xp = {
						order = 2,
						type = "color",
						hasAlpha = true,
						name = COMBAT_XP_GAIN,
						disabled = function() return E.db.xprep.default end,
						get = function(info)
							local t = E.db.xprep[ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b, a)
							local t = E.db.xprep[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							BXR:ChangeXPcolor()
						end,
					},
					rested = {
						order = 3,
						type = "color",
						hasAlpha = true,
						name = TUTORIAL_TITLE26,
						disabled = function() return E.db.xprep.default end,
						get = function(info)
							local t = E.db.xprep[ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b, a)
							local t = E.db.xprep[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							BXR:ChangeXPcolor()
						end,
					},
					reputation = {
						order = 4,
						type = "color",
						hasAlpha = true,
						name = REPUTATION,
						disabled = function() return E.db.xprep.default end,
						get = function(info)
							local t = E.db.xprep[ info[#info] ]
							return t.r, t.g, t.b, t.a
							end,
						set = function(info, r, g, b, a)
							local t = E.db.xprep[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							BXR:ChangeRepColor()
						end,
					},
				},
			},
		},
	}
end

table.insert(E.BuiConfig, xprepTable)