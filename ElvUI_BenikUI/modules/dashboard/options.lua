local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local BUID = BUI:GetModule('Dashboards');

local tinsert, pairs, ipairs, gsub, unpack, format, tostring = table.insert, pairs, ipairs, gsub, unpack, string.format, tostring
local GetProfessions, GetProfessionInfo = GetProfessions, GetProfessionInfo
local GetFactionInfoByID = GetFactionInfoByID
local BreakUpLargeNumbers = BreakUpLargeNumbers

local PROFESSIONS_ARCHAEOLOGY, PROFESSIONS_MISSING_PROFESSION, TOKENS = PROFESSIONS_ARCHAEOLOGY, PROFESSIONS_MISSING_PROFESSION, TOKENS
local TRADE_SKILLS = TRADE_SKILLS

-- GLOBALS: AceGUIWidgetLSMlists, hooksecurefunc

local boards = {"FPS", "MS", "Durability", "Bags", "Volume"}

local iconOrientationValues = {
	['LEFT'] = L['Left'],
	['RIGHT'] = L['Right'],
}

local textAlignValues = {
	['CENTER'] = L['Center'],
	['LEFT'] = L['Left'],
	['RIGHT'] = L['Right'],
}

local frameOrientationValues = {
	['RIGHT'] = L['Horizontal'],
	['BOTTOM'] = L['Vertical'],
}

local barColorValues = {
	[1] = L.CLASS_COLORS,
	[2] = L.CUSTOM,
}

local layoutStyles = {
	style = L['BenikUI Style'],
	transparency = L['Panel Transparency'],
	backdrop = L['Backdrop'],
}

local function UpdateSystemOptions()
	local config = E.Options.args.benikui.args.dashboards.args.system
	local db = E.db.benikui.dashboards.system

	for _, boardname in pairs(boards) do
		local optionOrder = 1
		config.args.chooseSystem.args[boardname] = {
			order = optionOrder + 1,
			type = 'toggle',
			name = boardname,
			desc = L['Enable/Disable ']..boardname,
			get = function(info) return db.chooseSystem[boardname] end,
			set = function(info, value) db.chooseSystem[boardname] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
		}
	end

	config.args.latency = {
		order = 10,
		type = "select",
		name = L['Latency (MS)'],
		values = {
			[1] = L.HOME,
			[2] = L.WORLD,
		},
		disabled = function() return not db.chooseSystem.MS end,
		get = function(info) return db.latency end,
		set = function(info, value) db.latency = value; E:StaticPopup_Show('PRIVATE_RL'); end,
	}
end

local function UpdateTokenOptions()
	local config = E.Options.args.benikui.args.dashboards.args.tokens
	local db = E.db.benikui.dashboards.tokens

	for i, info in ipairs(BUI.CurrencyList) do
		local optionOrder = 1
		local name, id = unpack(info)
		if not info[2] then
			config.args[tostring(i)] = {
				order = i,
				type = 'group',
				name = name,
				disabled = function() return not db.enable end,
				args = {
				},
			}
		elseif info[3] then
			local tname, amount, icon = BUID:GetTokenInfo(id)
			if tname then
				config.args[tostring(info[3])].args[tostring(i)] = {
					order = optionOrder + 2,
					type = 'toggle',
					name = (icon and '|T'..icon..':18|t '..tname) or tname,
					desc = format('%s %s\n\n|cffffff00%s: %s|r', L['Enable/Disable'], tname, L['Amount'], BreakUpLargeNumbers(amount)),
					disabled = function() return not db.enable end,
					get = function(info) return E.private.benikui.dashboards.tokens.chooseTokens[id] end,
					set = function(info, value) E.private.benikui.dashboards.tokens.chooseTokens[id] = value; BUID:UpdateTokens(); BUID:UpdateTokenSettings(); end,
				}
			end
		end
	end
end

local function UpdateProfessionOptions()
	local config = E.Options.args.benikui.args.dashboards.args.professions
	local db = E.db.benikui.dashboards.professions

	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	local optionOrder = 1
	if (prof1 or prof2 or archy or fishing or cooking) then
		config.args.choosePofessions = {
			order = 50,
			type = 'group',
			guiInline = true,
			name = L['Select Professions'],
			disabled = function() return not db.enable end,
			args = {
			},
		}
		local proftable = { GetProfessions() }
		for _, id in pairs(proftable) do
			local pname, icon = GetProfessionInfo(id)
			if pname then
				config.args.choosePofessions.args[pname] = {
					order = optionOrder + 1,
					type = 'toggle',
					name = '|T'..icon..':18|t '..pname,
					desc = format('%s %s', L['Enable/Disable'], pname),
					get = function(info) return E.private.benikui.dashboards.professions.choosePofessions[id] end,
					set = function(info, value) E.private.benikui.dashboards.professions.choosePofessions[id] = value; BUID:UpdateProfessions(); BUID:UpdateProfessionSettings(); end,
				}
			end
		end
	else
		config.args.choosePofessions = {
			order = 50,
			type = 'group',
			guiInline = true,
			name = L['Select Professions'],
			disabled = function() return not db.enable end,
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

local function UpdateReputationOptions()
	local config = E.Options.args.benikui.args.dashboards.args.reputations
	local db = E.db.benikui.dashboards.reputations

	local optionOrder = 30
	for i, info in ipairs(BUI.ReputationsList) do
		local optionOrder = 1
		local name, factionID, headerIndex, isHeader, hasRep, isChild = unpack(info)

		if isHeader and not (hasRep or isChild) then
			config.args[tostring(headerIndex)] = {
				order = optionOrder + 1,
				type = 'group',
				name = name,
				args = {
				},
			}
		elseif headerIndex then
			config.args[tostring(headerIndex)].args[tostring(i)] = {
				order = optionOrder + 2,
				type = 'toggle',
				name = name,
				desc = format('%s %s', L['Enable/Disable'], name),
				disabled = function() return not db.enable end,
				get = function(info) return E.private.benikui.dashboards.reputations.chooseReputations[factionID] end,
				set = function(info, value) E.private.benikui.dashboards.reputations.chooseReputations[factionID] = value; BUID:UpdateReputations(); BUID:UpdateReputationSettings(); end,
			}
		end
	end
end

local function UpdateAllDashboards()
	local db = E.db.benikui.dashboards
	if db.professions.enable then BUID:UpdateProfessionSettings(); end
	if db.tokens.enable then BUID:UpdateTokenSettings(); end
	if db.system.enable then BUID:UpdateSystemSettings(); end
	if db.reputations.enable then BUID:UpdateReputationSettings(); end
end

local function dashboardsTable()
	local db = E.db.benikui.dashboards
	E.Options.args.benikui.args.dashboards = {
		order = 60,
		type = 'group',
		name = BUI:cOption(L['Dashboards'], "orange"),
		args = {
			dashColor = {
				order = 1,
				type = 'group',
				name = L.COLOR,
				guiInline = true,
				args = {
					barColor = {
						type = "select",
						order = 1,
						name = L['Bar Color'],
						values = barColorValues,
						get = function(info) return db[ info[#info] ] end,
						set = function(info, value) db[ info[#info] ] = value;
							UpdateAllDashboards()
						end,
					},
					customBarColor = {
						order = 2,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return db.barColor == 1 end,
						get = function(info)
							local t = db[ info[#info] ]
							local d = P.benikui.dashboards[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
						end,
						set = function(info, r, g, b, a)
							db[ info[#info] ] = {}
							local t = db[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							UpdateAllDashboards()
						end,
					},
					spacer = {
						order = 3,
						type = 'header',
						name = '',
					},
					textColor = {
						order = 4,
						type = "select",
						name = L['Text Color'],
						values = barColorValues,
						get = function(info) return db[ info[#info] ] end,
						set = function(info, value) db[ info[#info] ] = value;
							UpdateAllDashboards()
						end,
					},
					customTextColor = {
						order = 5,
						type = "color",
						name = L.COLOR_PICKER,
						disabled = function() return db.textColor == 1 end,
						get = function(info)
							local t = db[ info[#info] ]
							local d = P.benikui.dashboards[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
						set = function(info, r, g, b, a)
							db[ info[#info] ] = {}
							local t = db[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							UpdateAllDashboards()
						end,
					},
				},
			},
			dashfont = {
				order = 2,
				type = 'group',
				name = L['Fonts'],
				guiInline = true,
				disabled = function() return not db.system.enable and not db.tokens.enable and not db.professions.enable end,
				get = function(info) return db.dashfont[ info[#info] ] end,
				set = function(info, value) db.dashfont[ info[#info] ] = value;
					UpdateAllDashboards()
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
						disabled = function() return db.dashfont.useDTfont end,
						values = AceGUIWidgetLSMlists.font,
					},
					dbfontsize = {
						order = 3,
						name = L.FONT_SIZE,
						desc = L['Set the font size.'],
						disabled = function() return db.dashfont.useDTfont end,
						type = 'range',
						min = 6, max = 22, step = 1,
					},
					dbfontflags = {
						order = 4,
						name = L['Font Outline'],
						disabled = function() return db.dashfont.useDTfont end,
						type = 'select',
						values = E.Config[1].Values.FontFlags,
					},
				},
			},
			system = {
				order = 3,
				type = 'group',
				name = L['System'],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the System Dashboard.'],
						get = function(info) return db.system.enable end,
						set = function(info, value) db.system.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					layoutGroup = {
						order = 2,
						type = 'group',
						name = L['Layout'],
						guiInline = true,
						disabled = function() return not db.system.enable end,
						args = {
							width = {
								order = 1,
								type = 'range',
								name = L['Width'],
								desc = L['Change the System Dashboard width.'],
								min = 120, max = 520, step = 1,
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value; BUID:UpdateHolderDimensions(BUI_SystemDashboard, 'system', BUI.SystemDB); BUID:UpdateSystemSettings(); end,
							},
							textAlign ={
								order = 2,
								name = L['Text Alignment'],
								type = 'select',
								values = textAlignValues,
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value BUID:UpdateSystemTextAlignment() end,
							},
							barHeight = {
								order = 3,
								type = 'range',
								name = L['Bar Height'],
								desc = L['Change the Bar Height.'],
								min = 1, max = 20, step = 1,
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value; BUID:BarHeight('system', BUI.SystemDB); end,
							},
							orientation = {
								order = 4,
								name = E.NewSign..L['Frame Orientation'],
								type = 'select',
								values = frameOrientationValues,
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value; BUID:UpdateOrientation(); end,
							},
							layoutOptions = {
								order = 10,
								type = 'multiselect',
								name = ' ',
								disabled = function() return not db.system.enable end,
								get = function(_, key) return db.system[key] end,
								set = function(_, key, value) db.system[key] = value; BUID:ToggleStyle(BUI_SystemDashboard, 'system') BUID:ToggleTransparency(BUI_SystemDashboard, 'system') end,
								values = layoutStyles,
							},
						},
					},
					visibilityGroup = {
						order = 3,
						type = 'group',
						name = L["Visibility"],
						guiInline = true,
						disabled = function() return not db.system.enable end,
						args = {
							combat = {
								order = 1,
								name = L['Combat Fade'],
								desc = L['Show/Hide System Dashboard when in combat'],
								type = 'toggle',
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value; BUID:EnableDisableCombat(BUI_SystemDashboard, 'system'); end,
							},
							mouseover = {
								order = 2,
								name = L['Mouse Over'],
								desc = L['The frame is not shown unless you mouse over the frame.'],
								type = 'toggle',
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value; BUID:UpdateSystemSettings() end,
							},
							instance = {
								order = 3,
								name = L['Hide in Instance'],
								type = 'toggle',
								get = function(info) return db.system[ info[#info] ] end,
								set = function(info, value) db.system[ info[#info] ] = value; BUID:UpdateVisibility(); end,
							},
						},
					},
					spacer = {
						order = 10,
						type = 'header',
						name = '',
					},
					chooseSystem = {
						order = 20,
						type = 'group',
						guiInline = true,
						name = L['Select System Board'],
						disabled = function() return not db.system.enable end,
						args = {
						},
					},
				},
			},
			tokens = {
				order = 4,
				type = 'group',
				name = TOKENS,
				childGroups = 'select',
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Tokens Dashboard.'],
						get = function(info) return db.tokens.enable end,
						set = function(info, value) db.tokens.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					layoutGroup = {
						order = 2,
						type = 'group',
						name = L['Layout'],
						guiInline = true,
						disabled = function() return not db.tokens.enable end,
						args = {
							width = {
								order = 1,
								type = 'range',
								name = L['Width'],
								desc = L['Change the Tokens Dashboard width.'],
								min = 120, max = 520, step = 1,
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokenSettings(); BUID:UpdateTokens(); end,
							},
							iconPosition = {
								order = 2,
								type = 'select',
								name = L['Icon Position'],
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); BUID:UpdateTokenSettings(); end,
								values = iconOrientationValues,
							},
							barHeight = {
								order = 3,
								type = 'range',
								name = L['Bar Height'],
								desc = L['Change the Bar Height.'],
								min = 1, max = 20, step = 1,
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:BarHeight('tokens', BUI.TokensDB); end,
							},
							orientation = {
								order = 4,
								name = E.NewSign..L['Frame Orientation'],
								type = 'select',
								values = frameOrientationValues,
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); end,
							},
							layoutOptions = {
								order = 10,
								type = 'multiselect',
								name = ' ',
								disabled = function() return not db.tokens.enable end,
								get = function(_, key) return db.tokens[key] end,
								set = function(_, key, value) db.tokens[key] = value; BUID:ToggleStyle(BUI_TokensDashboard, 'tokens') BUID:ToggleTransparency(BUI_TokensDashboard, 'tokens') end,
								values = layoutStyles,
							},
							variousGroup = {
								order = 20,
								type = 'group',
								name = ' ',
								guiInline = true,
								disabled = function() return not db.tokens.enable end,
								args = {
									zeroamount = {
										order = 1,
										name = L['Show zero amount tokens'],
										desc = L['Show the token, even if the amount is 0'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); BUID:UpdateTokenSettings(); end,
									},
									weekly = {
										order =2,
										name = L['Show Weekly max'],
										desc = L['Show Weekly max tokens instead of total max'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); BUID:UpdateTokenSettings(); end,
									},
									tooltip = {
										order = 3,
										name = L['Tooltip'],
										desc = L['Show/Hide Tooltips'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); BUID:UpdateTokenSettings(); end,
									},
								},
							},
						},
					},
					visibilityGroup = {
						order = 3,
						type = 'group',
						name = L["Visibility"],
						guiInline = true,
						disabled = function() return not db.tokens.enable end,
						args = {
							combat = {
								order = 1,
								name = L['Combat Fade'],
								desc = L['Show/Hide Tokens Dashboard when in combat'],
								type = 'toggle',
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:EnableDisableCombat(BUI_TokensDashboard, 'tokens'); end,
							},
							mouseover = {
								order = 2,
								name = L['Mouse Over'],
								desc = L['The frame is not shown unless you mouse over the frame.'],
								type = 'toggle',
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); BUID:UpdateTokenSettings(); end,
							},
							instance = {
								order = 3,
								name = L['Hide in Instance'],
								type = 'toggle',
								get = function(info) return db.tokens[ info[#info] ] end,
								set = function(info, value) db.tokens[ info[#info] ] = value; BUID:UpdateTokens(); end,
							},
						},
					},
					spacer = {
						order = 10,
						type = 'header',
						name = '',
					},
				},
			},
			professions = {
				order = 5,
				type = 'group',
				name = TRADE_SKILLS,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Professions Dashboard.'],
						get = function(info) return db.professions[ info[#info] ] end,
						set = function(info, value) db.professions[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					layoutGroup = {
						order = 2,
						type = 'group',
						name = L['Layout'],
						guiInline = true,
						disabled = function() return not db.professions.enable end,
						args = {
							width = {
								order = 1,
								type = 'range',
								name = L['Width'],
								desc = L['Change the Professions Dashboard width.'],
								min = 120, max = 520, step = 1,
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:UpdateProfessions(); BUID:UpdateProfessionSettings(); end,
							},
							iconPosition = {
								order = 2,
								type = 'select',
								name = L['Icon Position'],
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:UpdateProfessions(); BUID:UpdateProfessionSettings(); end,
								values = iconOrientationValues,
							},
							barHeight = {
								order = 3,
								type = 'range',
								name = L['Bar Height'],
								desc = L['Change the Bar Height.'],
								min = 1, max = 20, step = 1,
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:BarHeight('professions', BUI.ProfessionsDB); end,
							},
							orientation = {
								order = 4,
								name = E.NewSign..L['Frame Orientation'],
								type = 'select',
								values = frameOrientationValues,
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:UpdateProfessions(); end,
							},
							layoutOptions = {
								order = 10,
								type = 'multiselect',
								name = ' ',
								disabled = function() return not db.professions.enable end,
								get = function(_, key) return db.professions[key] end,
								set = function(_, key, value) db.professions[key] = value; BUID:ToggleStyle(BUI_ProfessionsDashboard, 'professions') BUID:ToggleTransparency(BUI_ProfessionsDashboard, 'professions') end,
								values = layoutStyles,
							},
							variousGroup = {
								order = 20,
								type = 'group',
								name = ' ',
								guiInline = true,
								disabled = function() return not db.professions.enable end,
								args = {
									capped = {
										order = 1,
										name = L['Filter Capped'],
										desc = L['Show/Hide Professions that are skill capped'],
										type = 'toggle',
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value; BUID:UpdateProfessions(); BUID:UpdateProfessionSettings(); end,
									},
								},
							},
						},
					},
					visibilityGroup = {
						order = 3,
						type = 'group',
						name = L["Visibility"],
						guiInline = true,
						disabled = function() return not db.professions.enable end,
						args = {
							combat = {
								order = 1,
								name = L['Combat Fade'],
								desc = L['Show/Hide Professions Dashboard when in combat'],
								type = 'toggle',
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:EnableDisableCombat(BUI_ProfessionsDashboard, 'professions'); end,
							},
							mouseover = {
								order = 2,
								name = L['Mouse Over'],
								desc = L['The frame is not shown unless you mouse over the frame.'],
								type = 'toggle',
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:UpdateProfessions(); BUID:UpdateProfessionSettings(); end,
							},
							instance = {
								order = 3,
								name = L['Hide in Instance'],
								type = 'toggle',
								get = function(info) return db.professions[ info[#info] ] end,
								set = function(info, value) db.professions[ info[#info] ] = value; BUID:UpdateProfessions(); end,
							},
						},	
					},
					spacer = {
						order = 10,
						type = 'header',
						name = '',
					},
				},
			},
			reputations = {
				order = 6,
				type = 'group',
				name = REPUTATION,
				childGroups = 'select',
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Professions Dashboard.'],
						get = function(info) return db.reputations[ info[#info] ] end,
						set = function(info, value) db.reputations[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					layoutGroup = {
						order = 2,
						type = 'group',
						name = L['Layout'],
						guiInline = true,
						disabled = function() return not db.reputations.enable end,
						args = {
							width = {
								order = 1,
								type = 'range',
								name = L['Width'],
								desc = L['Change the Professions Dashboard width.'],
								min = 120, max = 520, step = 1,
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:UpdateReputationSettings(); BUID:UpdateReputations(); end,
							},
							textAlign ={
								order = 2,
								name = L['Text Alignment'],
								type = 'select',
								values = textAlignValues,
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:UpdateReputations(); end,
							},
							barHeight = {
								order = 3,
								type = 'range',
								name = L['Bar Height'],
								desc = L['Change the Bar Height.'],
								min = 1, max = 20, step = 1,
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:BarHeight('reputations', BUI.FactionsDB); end,
							},
							orientation = {
								order = 4,
								name = E.NewSign..L['Frame Orientation'],
								type = 'select',
								values = frameOrientationValues,
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:UpdateReputations(); end,
							},
							layoutOptions = {
								order = 10,
								type = 'multiselect',
								name = ' ',
								disabled = function() return not db.reputations.enable end,
								get = function(_, key) return db.reputations[key] end,
								set = function(_, key, value) db.reputations[key] = value; BUID:ToggleStyle(BUI_ReputationsDashboard, 'reputations') BUID:ToggleTransparency(BUI_ReputationsDashboard, 'reputations') end,
								values = layoutStyles,
							},
							factionColors = {
								order = 20,
								type = 'multiselect',
								name = ' ',
								disabled = function() return not db.reputations.enable end,
								get = function(_, key) return db.reputations[key] end,
								set = function(_, key, value) db.reputations[key] = value; BUID:UpdateReputations(); BUID:UpdateReputationSettings(); end,
								values = {
									barFactionColors = L['Use Faction Colors on Bars'],
									textFactionColors = L['Use Faction Colors on Text'],
									tooltip = L['Tooltip'],
								}
							},
						},
					},
					visibilityGroup = {
						order = 3,
						type = 'group',
						name = L["Visibility"],
						guiInline = true,
						disabled = function() return not db.reputations.enable end,
						args = {
							combat = {
								order = 1,
								name = L['Hide In Combat'],
								desc = L['Show/Hide Reputations Dashboard when in combat'],
								type = 'toggle',
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:EnableDisableCombat(BUI_ReputationsDashboard, 'reputations'); end,
							},
							mouseover = {
								order = 2,
								name = L['Mouse Over'],
								desc = L['The frame is not shown unless you mouse over the frame.'],
								type = 'toggle',
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:UpdateReputations(); BUID:UpdateReputationSettings(); end,
							},
							instance = {
								order = 3,
								name = L['Hide in Instance'],
								type = 'toggle',
								get = function(info) return db.reputations[ info[#info] ] end,
								set = function(info, value) db.reputations[ info[#info] ] = value; BUID:UpdateReputations(); end,
							},
						},
					},
					spacer = {
						order = 20,
						type = 'header',
						name = '',
					},
				},
			},
		},
	}
end

tinsert(BUI.Config, dashboardsTable)
tinsert(BUI.Config, UpdateSystemOptions)
tinsert(BUI.Config, UpdateTokenOptions)
tinsert(BUI.Config, UpdateProfessionOptions)
tinsert(BUI.Config, UpdateReputationOptions)