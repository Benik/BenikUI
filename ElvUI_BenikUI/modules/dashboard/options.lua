local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BUID = E:GetModule('BuiDashboard');
local BUIT = E:GetModule('BuiTokensDashboard');

if E.db.utils == nil then E.db.utils = {} end

-- Defaults
P['utils'] = {
	['enableSystem'] = true,
	['enableTokens'] = true,
	['Scombat'] = false,
	['Tcombat'] = true,
	['Ttooltip'] = true,
	['Tshow'] = false,
	['Tflash'] = true,
	['dwidth'] = 150,
	['twidth'] = 150,
	['dtfont'] = true,
	['dbfont'] = E.db.datatexts.font,
	['dbfontsize'] = E.db.datatexts.fontSize,
	['dbfontflags'] = E.db.datatexts.fontOutline,
	['Justice Points'] = true,
	['Valor Points'] = true,
	['Timeless Coin'] = true,
	['Conquest Points'] = true,
	['Honor Points'] = true,
}

local dungeonTokens = {
	776,	-- Warforged Seal
	752,	-- Mogu Rune of Fate
	697,	-- Elder Charm of Good Fortune
	738,	-- Lesser Charm of Good Fortune
	614,	-- Mote of Darkness
	615,	-- Essence of Corrupted Deathwing
	395,	-- Justice Points
	396,	-- Valor Points
}

local pvpTokens = {
	390,	-- Conquest Points
	392,	-- Honor Points
	391,	-- Tol Barad Commendation
}

local secondaryTokens = {
	81,		-- Epicurean's Award
	402,	-- Ironpaw Token
	61,		-- Dalaran Jewelcrafter's Token
	361,	-- Illustrious Jewelcrafter's Token
}

local miscTokens = {
	241,	-- Champion's Seal
	416,	-- Mark of the World Tree
	515,	-- Darkmoon Prize Ticket
	777,	-- Timeless Coin
	789,	-- Bloody Coin
}

local archyTokens = {
	384,	-- Dwarf Archaeology Fragment
	385,	-- Troll Archaeology Fragment
	393,	-- Fossil Archaeology Fragment
	394,	-- Night Elf Archaeology Fragment
	397,	-- Orc Archaeology Fragment
	398,	-- Draenei Archaeology Fragment
	399,	-- Vrykul Archaeology Fragment
	400,	-- Nerubian Archaeology Fragment
	401,	-- Tol'vir Archaeology Fragment	
	676,	-- Pandaren Archaeology Fragment
	677,	-- Mogu Archaeology Fragment
	754,	-- Mantid Archaeology Fragment
}
	
local currencyTables = {
	{dungeonTokens, 'dTokens'},
	{pvpTokens, 'pTokens'},
	{secondaryTokens, 'sTokens'},
	{miscTokens, 'mTokens'},
	{archyTokens, 'aTokens'},
}

-- these options must be updated when the player discovers a new token.
local function UpdateTokenOptions()
	for i, v in ipairs(currencyTables) do
		local tableName, optionName = unpack(v)
		local optionOrder = 1
		for i, id in ipairs(tableName) do
			local tname, _, icon, _, _, _, isDiscovered = GetCurrencyInfo(id)
			if tname then
				E.Options.args.bui.args.config.args.utils.args.tokens.args.chooseTokens.args[optionName].args[tname] = {
					order = optionOrder + 1,
					type = 'toggle',
					name = '|T'..icon..':18|t '..(tname:gsub(' '..PROFESSIONS_ARCHAEOLOGY..' ', ' ')), -- remove 'Archaeology' from the name, to shorten the options a bit.
					desc = L['Enable/Disable ']..tname,
					get = function(info) return E.db.utils[ info[#info] ] end,
					set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:UpdateTokens(); end,
					disabled = function() return not isDiscovered end,
				}
			end
		end
	end
end

local function utilsTable()
	E.Options.args.bui.args.config.args.utils = {
		order = 20,
		type = 'group',
		name = L['Dashboards'],
		childGroups = "select",
		args = {
			header = {
				order = 1,
				type = 'header',
				name = L['Dashboards'],
			},
			system = {
				order = 2,
				type = 'group',
				name = L['System'],
				args = {
					enableSystem = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						desc = L['Enable the System Dashboard.'],
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
					Scombat = {
						order = 2,
						name = L['Combat Fade'],
						desc = L['Show/Hide System Dashboard when in combat'],
						type = 'toggle',
						disabled = function() return not E.db.utils.enableSystem end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUID:EnableDisableCombat(); end,					
					},
					dwidth = {
						order = 3,
						type = 'range',
						name = L['Width'],
						desc = L['Change the System Dashboard width.'],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.utils.enableSystem end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUID:HolderWidth() end,	
					},
				},
			},
			tokens = {
				order = 3,
				type = 'group',
				name = TOKENS,
				args = {
					enableTokens = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						width = 'full',
						desc = L['Enable the Tokens Dashboard.'],
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
					Tcombat = {
						order = 2,
						name = L['Combat Fade'],
						desc = L['Show/Hide Tokens Dashboard when in combat'],
						type = 'toggle',
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:EnableDisableCombat(); end,					
					},
					Ttooltip = {
						order = 3,
						name = L['Tooltip']..BUI.newsign,
						desc = L['Show/Hide Tooltips'],
						type = 'toggle',
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:UpdateTokens(); end,					
					},
					twidth = {
						order = 4,
						type = 'range',
						name = L['Width'],
						desc = L['Change the Tokens Dashboard width.'],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:UpdateTHolderDimensions(); end,	
					},
					Tshow = {
						order = 5,
						name = L['Show zero amount tokens']..BUI.newsign,
						desc = L['Show the token, even if the amount is 0'],
						type = 'toggle',
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:UpdateTokens(); end,					
					},
					Tflash = {
						order = 6,
						name = L['Flash on updates']..BUI.newsign,
						type = 'toggle',
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:UpdateTokens(); end,					
					},
					Tdesc = {
						order = 7,
						name = BUI:cOption(L['Tip: Grayed tokens are not yet discovered']),
						type = 'header',					
					},
					chooseTokens = {
						order = 8,
						type = 'group',
						name = L['Select Tokens']..BUI.newsign,
						disabled = function() return not E.db.utils.enableTokens end,
						args = {
							dTokens = {
								order = 1,
								type = 'group',
								name = format('%s & %s', CALENDAR_TYPE_DUNGEON, CALENDAR_TYPE_RAID),
								args = {
								},
							},
							pTokens = {
								order = 2,
								type = 'group',
								name = format('%s', PLAYER_V_PLAYER),
								args = {
								},
							},
							sTokens = {
								order = 3,
								type = 'group',
								name = format('%s', (SECONDARY_SKILLS:gsub(':', ''))),
								args = {
								},
							},
							mTokens = {
								order = 4,
								type = 'group',
								name = format('%s', MISCELLANEOUS),
								args = {
								},
							},
							aTokens = {
								order = 5,
								type = 'group',
								name = format('%s', PROFESSIONS_ARCHAEOLOGY),
								args = {
								},
							},
						},
					},
				},
			},
			font = {
				order = 4,
				type = 'group',
				name = L['Fonts'],
				guiInline = true,
				disabled = function() return not E.db.utils.enableSystem and not E.db.utils.enableTokens end,
				get = function(info) return E.db.utils[ info[#info] ] end,
				set = function(info, value) E.db.utils[ info[#info] ] = value; if E.db.utils.enableSystem then BUID:ChangeFont() end; if E.db.utils.enableTokens then BUIT:UpdateTokens(); end; end,
				args = {
					dtfont = {
						order = 1,
						name = L['Use DataTexts font'],
						type = 'toggle',
						width = 'full',
					},
					dbfont = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 2,
						name = L['Font'],
						desc = L['Choose font for both dashboards.'],
						disabled = function() return E.db.utils.dtfont end,
						values = AceGUIWidgetLSMlists.font,
					},
					dbfontsize = {
						order = 3,
						name = FONT_SIZE,
						desc = L['Set the font size.'],
						disabled = function() return E.db.utils.dtfont end,
						type = 'range',
						min = 6, max = 22, step = 1,
					},
					dbfontflags = {
						order = 4,
						name = L['Font Outline'],
						disabled = function() return E.db.utils.dtfont end,
						type = 'select',
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
					},
				},
			},
		},
	}
	-- update the options, when the tokens dashboard gets updated
	hooksecurefunc(BUIT, 'UpdateTokens', UpdateTokenOptions)
end

table.insert(E.BuiConfig, utilsTable)
table.insert(E.BuiConfig, UpdateTokenOptions)
