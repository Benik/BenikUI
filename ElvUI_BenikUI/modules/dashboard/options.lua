local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BUID = E:GetModule('BuiDashboard');
local BUIT = E:GetModule('BuiTokensDashboard');
local BUIP = E:GetModule('BuiProfessionsDashboard')

local dungeonTokens = {
	776,	-- Warforged Seal
	752,	-- Mogu Rune of Fate
	697,	-- Elder Charm of Good Fortune
	738,	-- Lesser Charm of Good Fortune
	614,	-- Mote of Darkness
	615,	-- Essence of Corrupted Deathwing
	395,	-- Justice Points
	396,	-- Valor Points
	823,	-- Apexis Crystal (for gear, like the valors)
	994,	-- Seal of Tempered Fate (Raid loot roll)
}

local pvpTokens = {
	390,	-- Conquest Points
	392,	-- Honor Points
	391,	-- Tol Barad Commendation
	944,	-- Artifact Fragment (PvP)
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
	980,	-- Dingy Iron Coins (rogue only, from pickpocketing)
	824,	-- Garrison Resources
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
	821,	-- Draenor Clans Archaeology Fragment
	828,	-- Ogre Archaeology Fragment
	829,	-- Arakkoa Archaeology Fragment
}
	
local currencyTables = {
	{dungeonTokens, 'dTokens'},
	{pvpTokens, 'pTokens'},
	{secondaryTokens, 'sTokens'},
	{miscTokens, 'mTokens'},
	{archyTokens, 'aTokens'},
}

local boards = {"FPS", "MS", "Memory", "Durability", "Volume"}

local function UpdateSystemOptions()
	for _, boardname in pairs(boards) do
		local optionOrder = 1
		E.Options.args.bui.args.config.args.dashboards.args.system.args.chooseSystem.args[boardname] = {
			order = optionOrder + 1,
			type = 'toggle',
			name = boardname,
			desc = L['Enable/Disable ']..boardname,
			get = function(info) return E.db.dashboards.system.chooseSystem[boardname] end,
			set = function(info, value) E.db.dashboards.system.chooseSystem[boardname] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
		}
	end
end

-- these options must be updated when the player discovers a new token.
local function UpdateTokenOptions()
	for i, v in ipairs(currencyTables) do
		local tableName, optionName = unpack(v)
		local optionOrder = 1
		for _, id in ipairs(tableName) do
			local tname, _, icon, _, _, _, isDiscovered = GetCurrencyInfo(id)
			if tname then
				E.Options.args.bui.args.config.args.dashboards.args.tokens.args.chooseTokens.args[optionName].args[tname] = {
					order = optionOrder + 1,
					type = 'toggle',
					name = '|T'..icon..':18|t '..(tname:gsub(' '..PROFESSIONS_ARCHAEOLOGY..' ', ' ')), -- remove 'Archaeology' from the name, to shorten the options a bit.
					desc = L['Enable/Disable ']..tname,
					get = function(info) return E.db.dashboards.tokens.chooseTokens[tname] end,
					set = function(info, value) E.db.dashboards.tokens.chooseTokens[tname] = value; BUIT:UpdateTokens(); end,
					disabled = function() return not isDiscovered end,
				}
			end
		end
	end
end

local function UpdateProfessionOptions()
	local prof1, prof2, archy, fishing, cooking, firstAid = GetProfessions()
	local optionOrder = 1
	if (prof1 or prof2 or archy or fishing or cooking or firstAid) then
		E.Options.args.bui.args.config.args.dashboards.args.professions.args.choosePofessions = {
			order = 5,
			type = 'group',
			guiInline = true,
			name = L['Select Professions'],
			disabled = function() return not E.db.dashboards.professions.enableProfessions end,
			args = {
			},
		}
		local proftable = { GetProfessions() }
		for _, id in pairs(proftable) do
			local pname, icon = GetProfessionInfo(id)
			if pname then
				E.Options.args.bui.args.config.args.dashboards.args.professions.args.choosePofessions.args[pname] = {
					order = optionOrder + 1,
					type = 'toggle',
					name = '|T'..icon..':18|t '..pname,
					desc = L['Enable/Disable ']..pname,
					get = function(info) return E.db.dashboards.professions.choosePofessions[pname] end,
					set = function(info, value) E.db.dashboards.professions.choosePofessions[pname] = value; BUIP:UpdateProfessions(); end,
				}			
			end
		end
	else
		E.Options.args.bui.args.config.args.dashboards.args.professions.args.choosePofessions = {
			order = 5,
			type = 'group',
			guiInline = true,
			name = L['Select Professions'],
			disabled = function() return not E.db.dashboards.professions.enableProfessions end,
			args = {
				noprof = {
					order = 1,
					type = 'description',
					name = PROFESSIONS_MISSING_PROFESSION,
				},	
			},
		}		
	end
end

local function dashboardsTable()
	E.Options.args.bui.args.config.args.dashboards = {
		order = 20,
		type = 'group',
		name = L['Dashboards']..BUI.newsign,
		childGroups = "tab",
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
						width = 'full',
						desc = L['Enable the System Dashboard.'],
						get = function(info) return E.db.dashboards.system.enableSystem end,
						set = function(info, value) E.db.dashboards.system.enableSystem = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
					combat = {
						order = 2,
						name = L['Combat Fade'],
						desc = L['Show/Hide System Dashboard when in combat'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.system.enableSystem end,
						get = function(info) return E.db.dashboards.system.combat end,
						set = function(info, value) E.db.dashboards.system.combat = value; BUID:EnableDisableCombat(); end,					
					},
					width = {
						order = 3,
						type = 'range',
						name = L['Width'],
						desc = L['Change the System Dashboard width.'],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.dashboards.system.enableSystem end,
						get = function(info) return E.db.dashboards.system.width end,
						set = function(info, value) E.db.dashboards.system.width = value; BUID:UpdateSysHolderDimensions() end,	
					},
					chooseSystem = {
						order = 4,
						type = 'group',
						guiInline = true,
						name = L['Select System Board'],
						disabled = function() return not E.db.dashboards.system.enableSystem end,
						args = {
						},
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
						get = function(info) return E.db.dashboards.tokens.enableTokens end,
						set = function(info, value) E.db.dashboards.tokens.enableTokens = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
					combat = {
						order = 2,
						name = L['Combat Fade'],
						desc = L['Show/Hide Tokens Dashboard when in combat'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.tokens.enableTokens end,
						get = function(info) return E.db.dashboards.tokens.combat end,
						set = function(info, value) E.db.dashboards.tokens.combat = value; BUIT:EnableDisableCombat(); end,					
					},
					tooltip = {
						order = 3,
						name = L['Tooltip'],
						desc = L['Show/Hide Tooltips'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.tokens.enableTokens end,
						get = function(info) return E.db.dashboards.tokens.tooltip end,
						set = function(info, value) E.db.dashboards.tokens.tooltip = value; BUIT:UpdateTokens(); end,					
					},
					width = {
						order = 4,
						type = 'range',
						name = L['Width'],
						desc = L['Change the Tokens Dashboard width.'],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.dashboards.tokens.enableTokens end,
						get = function(info) return E.db.dashboards.tokens.width end,
						set = function(info, value) E.db.dashboards.tokens.width = value; BUIT:UpdateTHolderDimensions(); end,	
					},
					zeroamount = {
						order = 5,
						name = L['Show zero amount tokens'],
						desc = L['Show the token, even if the amount is 0'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.tokens.enableTokens end,
						get = function(info) return E.db.dashboards.tokens.zeroamount end,
						set = function(info, value) E.db.dashboards.tokens.zeroamount = value; BUIT:UpdateTokens(); end,					
					},
					flash = {
						order = 6,
						name = L['Flash on updates'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.tokens.enableTokens end,
						get = function(info) return E.db.dashboards.tokens.flash end,
						set = function(info, value) E.db.dashboards.tokens.flash = value; BUIT:UpdateTokens(); end,					
					},
					desc = {
						order = 7,
						name = BUI:cOption(L['Tip: Grayed tokens are not yet discovered']),
						type = 'header',					
					},
					chooseTokens = {
						order = 8,
						type = 'group',
						name = L['Select Tokens'],
						disabled = function() return not E.db.dashboards.tokens.enableTokens end,
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
			professions = {
				order = 4,
				type = 'group',
				name = TRADE_SKILLS..BUI.newsign,
				args = {
					enableProfessions = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						width = 'full',
						desc = L['Enable the Professions Dashboard.'],
						get = function(info) return E.db.dashboards.professions.enableProfessions end,
						set = function(info, value) E.db.dashboards.professions.enableProfessions = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
					combat = {
						order = 2,
						name = L['Combat Fade'],
						desc = L['Show/Hide Professions Dashboard when in combat'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.professions.enableProfessions end,
						get = function(info) return E.db.dashboards.professions.combat end,
						set = function(info, value) E.db.dashboards.professions.combat = value; BUIP:EnableDisableCombat(); end,					
					},
					width = {
						order = 3,
						type = 'range',
						name = L['Width'],
						desc = L['Change the Professions Dashboard width.'],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.dashboards.professions.enableProfessions end,
						get = function(info) return E.db.dashboards.professions.width end,
						set = function(info, value) E.db.dashboards.professions.width = value; BUIP:UpdatePholderDimensions(); end,	
					},
					capped = {
						order = 4,
						name = L['Filter Capped'],
						desc = L['Show/Hide Professions that are skill capped'],
						type = 'toggle',
						disabled = function() return not E.db.dashboards.professions.enableProfessions end,
						get = function(info) return E.db.dashboards.professions.capped end,
						set = function(info, value) E.db.dashboards.professions.capped = value; BUIP:UpdateProfessions(); end,					
					},
				},
			},
			dashfont = {
				order = 1,
				type = 'group',
				name = L['Fonts'],
				guiInline = true,
				disabled = function() return not E.db.dashboards.system.enableSystem and not E.db.dashboards.tokens.enableTokens and not E.db.dashboards.professions.enableProfessions end,
				get = function(info) return E.db.dashboards.dashfont[ info[#info] ] end,
				set = function(info, value) E.db.dashboards.dashfont[ info[#info] ] = value;
					if E.db.dashboards.system.enableSystem then BUID:ChangeFont() end;
					if E.db.dashboards.tokens.enableTokens then BUIT:UpdateTokens() end;
					if E.db.dashboards.professions.enableProfessions then BUIP:UpdateProfessions() end;
					end,
				args = {
					useDTfont = {
						order = 1,
						name = L['Use DataTexts font'],
						type = 'toggle',
						width = 'full',
					},
					dbfont = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 2,
						name = L['Font'],
						desc = L['Choose font for all dashboards.'],
						disabled = function() return E.db.dashboards.dashfont.useDTfont end,
						values = AceGUIWidgetLSMlists.font,
					},
					dbfontsize = {
						order = 3,
						name = FONT_SIZE,
						desc = L['Set the font size.'],
						disabled = function() return E.db.dashboards.dashfont.useDTfont end,
						type = 'range',
						min = 6, max = 22, step = 1,
					},
					dbfontflags = {
						order = 4,
						name = L['Font Outline'],
						disabled = function() return E.db.dashboards.dashfont.useDTfont end,
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
	-- update the options, when ElvUI Config fires
	hooksecurefunc(E, "ToggleConfig", UpdateTokenOptions)
	hooksecurefunc(E, "ToggleConfig", UpdateProfessionOptions)
end

table.insert(E.BuiConfig, dashboardsTable)
table.insert(E.BuiConfig, UpdateSystemOptions)
table.insert(E.BuiConfig, UpdateTokenOptions)
table.insert(E.BuiConfig, UpdateProfessionOptions)


