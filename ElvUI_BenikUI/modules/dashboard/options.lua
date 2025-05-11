local BUI, E, _, V, P, G = unpack((select(2, ...)))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local mod = BUI:GetModule('Dashboards')

local tinsert, pairs, ipairs, gsub, unpack, format, tostring = table.insert, pairs, ipairs, gsub, unpack, string.format, tostring
local GetProfessions, GetProfessionInfo = GetProfessions, GetProfessionInfo
local BreakUpLargeNumbers = BreakUpLargeNumbers

local PROFESSIONS_MISSING_PROFESSION, TOKENS = PROFESSIONS_MISSING_PROFESSION, TOKENS
local TRADE_SKILLS = TRADE_SKILLS
local LFG_LIST_LEGACY = LFG_LIST_LEGACY

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
	[2] = L["Custom Color"],
}

local layoutStyles = {
	style = L['BenikUI Style'],
	transparency = L['Panel Transparency'],
	backdrop = L['Backdrop'],
}

local ItemSetup = {
	['id'] = "",
}

local ItemDefaultValues = {
	['enable'] = true,
	['useCustomStack'] = false,
	['customStack'] = 100,
}

local function UpdateSystemOptions()
	local config = E.Options.args.benikui.args.dashboards.args.system.args.chooseSystem
	local db = E.db.benikui.dashboards.system

	for _, boardname in pairs(boards) do
		local optionOrder = 1
		config.args.systemGroup.args[boardname] = {
			order = optionOrder + 1,
			type = 'toggle',
			name = boardname,
			desc = L['Enable/Disable ']..boardname,
			get = function(info) return db.chooseSystem[boardname] end,
			set = function(info, value) db.chooseSystem[boardname] = value E:StaticPopup_Show('PRIVATE_RL') end,
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
		set = function(info, value) db.latency = value E:StaticPopup_Show('PRIVATE_RL') end,
	}
end

local function UpdateTokenOptions()
	local config = E.Options.args.benikui.args.dashboards.args.tokens.args.selectTokens
	local db = E.db.benikui.dashboards.tokens

	local optionOrder = 1
	for i, info in ipairs(mod.CurrencyList) do
		local name, id = unpack(info)
		if not info[2] and name ~= LFG_LIST_LEGACY then
			config.args[tostring(i)] = {
				order = optionOrder + i,
				type = 'group',
				name = name,
				disabled = function() return not db.enable end,
				args = {
				},
			}
		elseif info[3] then
			local tname, amount, icon = mod:GetTokenInfo(id)
			if tname then
				config.args[tostring(info[3])].args[tostring(i)] = {
					order = optionOrder + 2,
					type = 'toggle',
					name = (icon and '|T'..icon..':18|t '..tname) or tname,
					desc = format('%s %s\n\n|cffffff00%s: %s|r', L['Enable/Disable'], tname, L['Amount'], BreakUpLargeNumbers(amount)),
					disabled = function() return not db.enable end,
					get = function(info) return E.private.benikui.dashboards.tokens.chooseTokens[id] end,
					set = function(info, value) E.private.benikui.dashboards.tokens.chooseTokens[id] = value mod:UpdateTokens() end,
				}
			end
		end
	end
end

local function UpdateProfessionOptions()
	local config = E.Options.args.benikui.args.dashboards.args.professions.args.selectProfessions
	local db = E.db.benikui.dashboards.professions

	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	local optionOrder = 1
	if (prof1 or prof2 or archy or fishing or cooking) then
		config.args.choosePofessions = {
			order = optionOrder + 1,
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
					order = optionOrder + 2,
					type = 'toggle',
					name = '|T'..icon..':18|t '..pname,
					desc = format('%s %s', L['Enable/Disable'], pname),
					get = function(info) return E.private.benikui.dashboards.professions.choosePofessions[id] end,
					set = function(info, value) E.private.benikui.dashboards.professions.choosePofessions[id] = value mod:UpdateProfessions() end,
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
	local config = E.Options.args.benikui.args.dashboards.args.reputations.args.selectReputations
	local db = E.db.benikui.dashboards.reputations

	local optionOrder = 1
	for i, info in ipairs(mod.ReputationsList) do
		local name, factionID, headerIndex, isHeader, isChild, isHeaderWithRep = unpack(info)

		if isHeader and not isChild then
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
				set = function(info, value) E.private.benikui.dashboards.reputations.chooseReputations[factionID] = value mod:UpdateReputations() end,
			}
		end
	end
end

local function UpdateItemsOptions()
	local db = E.db.benikui.dashboards.items
	local vdb = E.private.benikui.dashboards.items.chooseItems
	local config = E.Options.args.benikui.args.dashboards.args.items.args.selectItems
	local optionOrder = 10

	for itemID in pairs(mod.ItemsList) do
		local itemName, icon, amount, totalMax = mod:GetItemsInfo(itemID)
		if itemName then
			config.args[tostring(itemID)] = {
				order = optionOrder + 1,
				type = 'group',
				name = itemName,
				icon = icon,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						width = 'full',
						name = format('%s %s|cfffcba03 (%s)|r', ENABLE, itemName, itemID),
						get = function(_) if vdb[itemID] and vdb[itemID].enable then return vdb[itemID].enable end end,
						set = function(_, value) vdb[itemID].enable = value mod:GetUserItems() end,
					},
					spacer = {
						order = 2,
						type = 'header',
						name = '',
					},
					useCustomStack = {
						order = 10,
						type = 'toggle',
						name = L['Use Custom Stack'],
						disabled = function() return not vdb[itemID].enable end,
						get = function(_) if vdb[itemID] and vdb[itemID].useCustomStack then return vdb[itemID].useCustomStack end end,
						set = function(_, value) vdb[itemID].useCustomStack = value mod:UpdateItems() end,
					},
					customStack = {
						order = 11,
						type = 'input',
						width = 'half',
						name = L['Custom Stack'],
						hidden = function() if vdb[itemID] and vdb[itemID].customStack then return not vdb[itemID].useCustomStack end end,
						get = function(_) if vdb[itemID] and vdb[itemID].customStack then return vdb[itemID].customStack end end,
						set = function(_, value)
							vdb[itemID].customStack = tonumber(value)
							mod:UpdateItems()
						end,
					},
					spacer2 = {
						order = 20,
						type = 'header',
						name = '',
					},
					delete = {
						order = 21,
						name = DELETE,
						type = 'execute',
						disabled = function() return not vdb[itemID].enable end,
						func = function()
							config.args[tostring(itemID)] = nil
							vdb[itemID] = nil
							mod.ItemsList[itemID] = nil
							mod:GetUserItems()
						end,
					},
				},
			}
		end
	end
end

local function UpdateAllDashboards()
	local db = E.db.benikui.dashboards
	if db.professions.enable then mod:UpdateProfessions() end
	if db.tokens.enable then mod:UpdateTokens() end
	if db.system.enable then mod:UpdateSystemSettings() end
	if db.reputations.enable then mod:UpdateReputations() end
	if db.items.enable then mod:UpdateItems() end
end

local function dashboardsTable()
	local db = E.db.benikui.dashboards
	E.Options.args.benikui.args.dashboards = {
		order = 60,
		type = 'group',
		name = BUI:cOption(L['Dashboards'], "orange"),
		childGroups = "tab",
		args = {
			general = {
				order = 1,
				type = 'group',
				name = L['General'],
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
								set = function(info, value) db[ info[#info] ] = value UpdateAllDashboards() end,
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
								set = function(info, value) db[ info[#info] ] = value UpdateAllDashboards() end,
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
						disabled = function() return not db.system.enable and not db.tokens.enable and not db.professions.enable and not db.reputations.enable and not db.items.enable end,
						get = function(info) return db.dashfont[ info[#info] ] end,
						set = function(info, value) db.dashfont[ info[#info] ] = value UpdateAllDashboards() end,
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
								name = L['Font Size'],
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
				},
			},
			system = {
				order = 3,
				type = 'group',
				name = L['System'],
				childGroups = "tab",
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the System Dashboard.'],
						get = function(info) return db.system.enable end,
						set = function(info, value) db.system.enable = value E:StaticPopup_Show('PRIVATE_RL') end,
					},
					chooseSystem = {
						order = 10,
						type = 'group',
						name = L['Select System Board'],
						disabled = function() return not db.system.enable end,
						args = {
							systemGroup = {
								order = 10,
								type = 'group',
								guiInline = true,
								name = L['Select System Board'],
								args = {
								},
							},
						},
					},
					layout = {
						order = 20,
						type = 'group',
						name = L['Layout'],
						disabled = function() return not db.system.enable end,
						args = {
							layoutGroup = {
								order = 1,
								type = 'group',
								name = L['Layout'],
								guiInline = true,
								args = {
									width = {
										order = 1,
										type = 'range',
										name = L['Width'],
										desc = L['Change the System Dashboard width.'],
										min = 120, max = 520, step = 1,
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:UpdateHolderDimensions(BUI_SystemDashboard, 'system', mod.SystemDB, true) mod:UpdateSystemSettings() end,
									},
									barHeight = {
										order = 2,
										type = 'range',
										name = L['Bar Height'],
										desc = L['Change the Bar Height.'],
										min = 1, max = 20, step = 1,
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:BarHeight('system', mod.SystemDB) end,
									},
									spacing = {
										order = 3,
										type = 'range',
										name = L["Spacing"],
										min = 1, max = 30, step = 1,
										disabled = function() return db.system.orientation == 'BOTTOM' end,
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:UpdateOrientation() end,
									},
									spacer = {
										order = 4,
										type = 'header',
										name = '',
									},
									updateThrottle = {
										order = 5,
										type = 'range',
										name = L['Update Throttle'],
										min = 1, max = 10, step = 1,
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value end,
									},
									textAlign = {
										order = 6,
										name = L['Text Alignment'],
										type = 'select',
										values = textAlignValues,
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:UpdateSystemTextAlignment() end,
									},
									orientation = {
										order = 7,
										name = L['Frame Orientation'],
										type = 'select',
										values = frameOrientationValues,
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:UpdateOrientation() end,
									},
									spacer2 = {
										order = 8,
										type = 'header',
										name = '',
									},
									overrideColor = {
										order = 9,
										name = L['Value Color'],
										type = 'toggle',
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value E:StaticPopup_Show('PRIVATE_RL') end,
									},
									layoutOptions = {
										order = 10,
										type = 'multiselect',
										name = ' ',
										disabled = function() return not db.system.enable end,
										get = function(_, key) return db.system[key] end,
										set = function(_, key, value) db.system[key] = value mod:ToggleStyle(BUI_SystemDashboard, 'system') mod:ToggleTransparency(BUI_SystemDashboard, 'system') end,
										values = layoutStyles,
									},
								},
							},
						},
					},
					visibility = {
						order = 30,
						type = 'group',
						name = L["Visibility"],
						disabled = function() return not db.system.enable end,
						args = {
							visibilityGroup = {
								order = 1,
								type = 'group',
								name = L["Visibility"],
								guiInline = true,
								args = {
									combat = {
										order = 1,
										name = L['Hide In Combat'],
										desc = L['Show/Hide System Dashboard when in combat'],
										type = 'toggle',
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:EnableDisableCombat(BUI_SystemDashboard, 'system') end,
									},
									mouseover = {
										order = 2,
										name = L['Mouse Over'],
										desc = L['The frame is not shown unless you mouse over the frame.'],
										type = 'toggle',
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:UpdateSystemSettings() end,
									},
									instance = {
										order = 3,
										name = L['Hide in Instance'],
										type = 'toggle',
										get = function(info) return db.system[ info[#info] ] end,
										set = function(info, value) db.system[ info[#info] ] = value mod:UpdateVisibility() end,
									},
								},
							},
						},
					},
				},
			},
			tokens = {
				order = 4,
				type = 'group',
				name = TOKENS,
				childGroups = 'tab',
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Tokens Dashboard.'],
						get = function(info) return db.tokens.enable end,
						set = function(info, value) db.tokens.enable = value mod:ToggleTokens() end,
					},
					selectTokens = {
						order = 2,
						type = 'group',
						name = TOKENS,
						disabled = function() return not db.tokens.enable end,
						args = {
							variousGroup = {
								order = 1,
								type = 'group',
								name = ' ',
								guiInline = true,
								args = {
									zeroamount = {
										order = 1,
										name = L['Show zero amount tokens'],
										desc = L['Show the token, even if the amount is 0'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
									weekly = {
										order =2,
										name = L['Show Weekly max'],
										desc = L['Show Weekly max tokens instead of total max'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
									tooltip = {
										order = 3,
										name = L['Tooltip'],
										desc = L['Show/Hide Tooltips'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
								},
							},
						},
					},
					layout = {
						order = 3,
						type = 'group',
						name = L['Layout'],
						disabled = function() return not db.tokens.enable end,
						args = {
							layoutGroup = {
								order = 1,
								type = 'group',
								name = L['Layout'],
								guiInline = true,
								args = {
									width = {
										order = 1,
										type = 'range',
										name = L['Width'],
										desc = L['Change the Tokens Dashboard width.'],
										min = 120, max = 520, step = 1,
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
									barHeight = {
										order = 2,
										type = 'range',
										name = L['Bar Height'],
										desc = L['Change the Bar Height.'],
										min = 1, max = 20, step = 1,
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:BarHeight('tokens', mod.TokensDB) end,
									},
									spacing = {
										order = 3,
										type = 'range',
										name = L["Spacing"],
										min = 1, max = 30, step = 1,
										disabled = function() return db.tokens.orientation == 'BOTTOM' end,
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
									spacer = {
										order = 4,
										type = 'header',
										name = '',
									},
									iconPosition = {
										order = 5,
										type = 'select',
										name = L['Icon Position'],
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
										values = iconOrientationValues,
									},
									orientation = {
										order = 6,
										name = L['Frame Orientation'],
										type = 'select',
										values = frameOrientationValues,
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
									layoutOptions = {
										order = 10,
										type = 'multiselect',
										name = ' ',
										get = function(_, key) return db.tokens[key] end,
										set = function(_, key, value) db.tokens[key] = value mod:ToggleStyle(BUI_TokensDashboard, 'tokens') mod:ToggleTransparency(BUI_TokensDashboard, 'tokens') end,
										values = layoutStyles,
									},
								},
							},
						},
					},
					visibility = {
						order = 4,
						type = 'group',
						name = L["Visibility"],
						disabled = function() return not db.tokens.enable end,
						args = {
							visibilityGroup = {
								order = 1,
								type = 'group',
								name = L["Visibility"],
								guiInline = true,
								args = {
									combat = {
										order = 1,
										name = L['Hide In Combat'],
										desc = L['Show/Hide Tokens Dashboard when in combat'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:EnableDisableCombat(BUI_TokensDashboard, 'tokens') end,
									},
									mouseover = {
										order = 2,
										name = L['Mouse Over'],
										desc = L['The frame is not shown unless you mouse over the frame.'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
									instance = {
										order = 3,
										name = L['Hide in Instance'],
										type = 'toggle',
										get = function(info) return db.tokens[ info[#info] ] end,
										set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
									},
								},
							},
						},
					},
				},
			},
			professions = {
				order = 5,
				type = 'group',
				name = TRADE_SKILLS,
				childGroups = 'tab',
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Professions Dashboard.'],
						get = function(info) return db.professions[ info[#info] ] end,
						set = function(info, value) db.professions[ info[#info] ] = value mod:ToggleProfessions() end,
					},
					selectProfessions = {
						order = 2,
						type = 'group',
						name = TRADE_SKILLS,
						disabled = function() return not db.professions.enable end,
						args = {
							variousGroup = {
								order = 1,
								type = 'group',
								name = ' ',
								guiInline = true,
								args = {
									capped = {
										order = 1,
										name = L['Filter Capped'],
										desc = L['Show/Hide Professions that are skill capped'],
										type = 'toggle',
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
									},
								},
							},
						},
					},
					layoutGroup = {
						order = 3,
						type = 'group',
						name = L['Layout'],
						disabled = function() return not db.professions.enable end,
						args = {
							layout = {
								order = 2,
								type = 'group',
								name = L['Layout'],
								guiInline = true,
								args = {
									width = {
										order = 1,
										type = 'range',
										name = L['Width'],
										desc = L['Change the Professions Dashboard width.'],
										min = 120, max = 520, step = 1,
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
									},
									barHeight = {
										order = 2,
										type = 'range',
										name = L['Bar Height'],
										desc = L['Change the Bar Height.'],
										min = 1, max = 20, step = 1,
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:BarHeight('professions', mod.ProfessionsDB) end,
									},
									spacing = {
										order = 3,
										type = 'range',
										name = L["Spacing"],
										min = 1, max = 30, step = 1,
										disabled = function() return db.professions.orientation == 'BOTTOM' end,
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
									},
									spacer = {
										order = 4,
										type = 'header',
										name = '',
									},
									iconPosition = {
										order = 5,
										type = 'select',
										name = L['Icon Position'],
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
										values = iconOrientationValues,
									},
									orientation = {
										order = 6,
										name = L['Frame Orientation'],
										type = 'select',
										values = frameOrientationValues,
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
									},
									layoutOptions = {
										order = 10,
										type = 'multiselect',
										name = ' ',
										get = function(_, key) return db.professions[key] end,
										set = function(_, key, value) db.professions[key] = value mod:ToggleStyle(BUI_ProfessionsDashboard, 'professions') mod:ToggleTransparency(BUI_ProfessionsDashboard, 'professions') end,
										values = layoutStyles,
									},
								},
							},
						},
					},
					visibility = {
						order = 4,
						type = 'group',
						name = L["Visibility"],
						disabled = function() return not db.professions.enable end,
						args = {
							visibilityGroup = {
								order = 1,
								type = 'group',
								name = L["Visibility"],
								guiInline = true,
								args = {
									combat = {
										order = 1,
										name = L['Hide In Combat'],
										desc = L['Show/Hide Professions Dashboard when in combat'],
										type = 'toggle',
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:EnableDisableCombat(BUI_ProfessionsDashboard, 'professions') end,
									},
									mouseover = {
										order = 2,
										name = L['Mouse Over'],
										desc = L['The frame is not shown unless you mouse over the frame.'],
										type = 'toggle',
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
									},
									instance = {
										order = 3,
										name = L['Hide in Instance'],
										type = 'toggle',
										get = function(info) return db.professions[ info[#info] ] end,
										set = function(info, value) db.professions[ info[#info] ] = value mod:UpdateProfessions() end,
									},
								},
							},
						},	
					},
				},
			},
			reputations = {
				order = 6,
				type = 'group',
				name = REPUTATION,
				childGroups = 'tab',
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Reputations Dashboard.'],
						get = function(info) return db.reputations[ info[#info] ] end,
						set = function(info, value) db.reputations[ info[#info] ] = value mod:ToggleReputations() end,
					},
					selectReputations = {
						order = 2,
						type = 'group',
						name = REPUTATION,
						disabled = function() return not db.reputations.enable end,
						args = {
							factionColors = {
								order = 1,
								type = 'multiselect',
								name = ' ',
								get = function(_, key) return db.reputations[key] end,
								set = function(_, key, value) db.reputations[key] = value mod:UpdateReputations() end,
								values = {
									barFactionColors = L['Use Faction Colors on Bars'],
									textFactionColors = L['Use Faction Colors on Text'],
									tooltip = L['Tooltip'],
								},
							},
						},
					},
					layout = {
						order = 3,
						type = 'group',
						name = L['Layout'],
						disabled = function() return not db.reputations.enable end,
						args = {
							layoutGroup = {
								order = 3,
								type = 'group',
								name = L['Layout'],
								guiInline = true,
								args = {
									width = {
										order = 1,
										type = 'range',
										name = L['Width'],
										desc = L['Change the Reputations Dashboard width.'],
										min = 120, max = 520, step = 1,
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:UpdateReputations() end,
									},
									barHeight = {
										order = 2,
										type = 'range',
										name = L['Bar Height'],
										desc = L['Change the Bar Height.'],
										min = 1, max = 20, step = 1,
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:BarHeight('reputations', mod.FactionsDB) end,
									},
									spacing = {
										order = 3,
										type = 'range',
										name = L["Spacing"],
										min = 1, max = 30, step = 1,
										disabled = function() return db.reputations.orientation == 'BOTTOM' end,
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:UpdateReputations() end,
									},
									spacer = {
										order = 4,
										type = 'header',
										name = '',
									},
									textAlign ={
										order = 5,
										name = L['Text Alignment'],
										type = 'select',
										values = textAlignValues,
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:UpdateReputations() end,
									},
									orientation = {
										order = 6,
										name = L['Frame Orientation'],
										type = 'select',
										values = frameOrientationValues,
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:UpdateReputations() end,
									},
									layoutOptions = {
										order = 10,
										type = 'multiselect',
										name = ' ',
										get = function(_, key) return db.reputations[key] end,
										set = function(_, key, value) db.reputations[key] = value mod:ToggleStyle(BUI_ReputationsDashboard, 'reputations') mod:ToggleTransparency(BUI_ReputationsDashboard, 'reputations') end,
										values = layoutStyles,
									},
								},
							},
						},
					},
					visibility = {
						order = 4,
						type = 'group',
						name = L["Visibility"],
						disabled = function() return not db.reputations.enable end,
						args = {
							visibilityGroup = {
								order = 1,
								type = 'group',
								name = L["Visibility"],
								guiInline = true,
								args = {
									combat = {
										order = 1,
										name = L['Hide In Combat'],
										desc = L['Show/Hide Reputations Dashboard when in combat'],
										type = 'toggle',
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:EnableDisableCombat(BUI_ReputationsDashboard, 'reputations') end,
									},
									mouseover = {
										order = 2,
										name = L['Mouse Over'],
										desc = L['The frame is not shown unless you mouse over the frame.'],
										type = 'toggle',
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:UpdateReputations() end,
									},
									instance = {
										order = 3,
										name = L['Hide in Instance'],
										type = 'toggle',
										get = function(info) return db.reputations[ info[#info] ] end,
										set = function(info, value) db.reputations[ info[#info] ] = value mod:UpdateReputations() end,
									},
								},
							},
						},
					},
				},
			},
			items = {
				order = 7,
				type = 'group',
				name = L['Items'],
				childGroups = 'tab',
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						width = 'full',
						desc = L['Enable the Items Dashboard.'],
						get = function(info) return db.items.enable end,
						set = function(info, value) db.items.enable = value mod:ToggleItems() end,
					},
					selectItems = {
						order = 2,
						type = 'group',
						name = L['Items'],
						disabled = function() return not db.items.enable end,
						args = {
							createButton = {
								order = 1,
								name = ADD,
								width = 'half',
								type = 'execute',
								func = function()
									if E.global.benikui.CustomItems.createButton == true then
										E.global.benikui.CustomItems.createButton = false
									else
										E.global.benikui.CustomItems.createButton = true
									end
								end,
							},
							tooltip = {
								order = 2,
								type = 'toggle',
								name = L['Tooltip'],
								get = function(info) return db.items.tooltip end,
								set = function(info, value) db.items.tooltip = value end,
							},
							showMax = {
								order = 3,
								type = 'toggle',
								name = L['Show Max Amount'],
								get = function(info) return db.items[ info[#info] ] end,
								set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
							},
							newItem = {
								order = 10,
								type = "group",
								guiInline = true,
								name = ' ',
								hidden = function() return not E.global.benikui.CustomItems.createButton end,
								args = {
									newID = {
										order = 1,
										type = 'input',
										width = 'double',
										name = L["New Item by ID"],
										hidden = function() return not E.global.benikui.CustomItems.createButton end,
										get = function() return ItemSetup.id end,
										set = function(_, value)
											ItemSetup.id = strmatch(value, 'item:(%d+)') or value
											local name = GetItemInfo(ItemSetup.id)
											local checkDuplicate = false
											if not name then
												E.PopupDialogs["BUI_Panel_Name"].text = (format(L["The ID |cff00c0fa%d|r doesn't exist in the game."], ItemSetup.id))
												E:StaticPopup_Show("BUI_Panel_Name")
												ItemSetup.id = nil
											elseif not checkDuplicate then
												for object in pairs(mod.ItemsList) do
													if object == tonumber(ItemSetup.id) then
														E.PopupDialogs["BUI_Panel_Name"].text = (format(L["The Item |cff00c0fa%s|r already exists."], name))
														E:StaticPopup_Show("BUI_Panel_Name")
														ItemSetup.id = nil
														checkDuplicate = true
													else
														ItemSetup.id = ItemSetup.id
														checkDuplicate = false
													end
												end
											end
										end,
									},
									add = {
										order = 2,
										name = KEY_INSERT,
										width = 'half',
										type = 'execute',
										hidden = function() return not E.global.benikui.CustomItems.createButton end,
										func = function()
											local itemID = tonumber(ItemSetup.id)
											if itemID then
												E.private.benikui.dashboards.items.chooseItems[itemID] = ItemDefaultValues
											end
											mod:GetUserItems()
											UpdateItemsOptions()
											E.global.benikui.CustomItems.createButton = false
										end,
									},
								},
							},
						},
					},
					layout = {
						order = 3,
						type = 'group',
						name = L['Layout'],
						disabled = function() return not db.items.enable end,
						args = {
							layoutGroup = {
								order = 1,
								type = 'group',
								name = L['Layout'],
								guiInline = true,
								args = {
									width = {
										order = 1,
										type = 'range',
										name = L['Width'],
										desc = L['Change the Items Dashboard width.'],
										min = 120, max = 520, step = 1,
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
									},
									barHeight = {
										order = 2,
										type = 'range',
										name = L['Bar Height'],
										desc = L['Change the Bar Height.'],
										min = 1, max = 20, step = 1,
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:BarHeight('items', mod.ItemsDB) end,
									},
									spacing = {
										order = 3,
										type = 'range',
										name = L["Spacing"],
										min = 1, max = 30, step = 1,
										disabled = function() return db.items.orientation == 'BOTTOM' end,
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
									},
									spacer = {
										order = 4,
										type = 'header',
										name = '',
									},
									iconPosition = {
										order = 5,
										type = 'select',
										name = L['Icon Position'],
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
										values = iconOrientationValues,
									},
									orientation = {
										order = 6,
										name = L['Frame Orientation'],
										type = 'select',
										values = frameOrientationValues,
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
									},
									layoutOptions = {
										order = 10,
										type = 'multiselect',
										name = ' ',
										get = function(_, key) return db.items[key] end,
										set = function(_, key, value) db.items[key] = value mod:ToggleStyle(BUI_ItemsDashboard, 'items') mod:ToggleTransparency(BUI_ItemsDashboard, 'items') end,
										values = layoutStyles,
									},
								},
							},
						},
					},
					visibility = {
						order = 4,
						type = 'group',
						name = L["Visibility"],
						disabled = function() return not db.items.enable end,
						args = {
							visibilityGroup = {
								order = 1,
								type = 'group',
								name = L["Visibility"],
								guiInline = true,
								args = {
									combat = {
										order = 1,
										name = L['Hide In Combat'],
										desc = L['Show/Hide items Dashboard when in combat'],
										type = 'toggle',
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:EnableDisableCombat(BUI_ItemsDashboard, 'items') end,
									},
									mouseover = {
										order = 2,
										name = L['Mouse Over'],
										desc = L['The frame is not shown unless you mouse over the frame.'],
										type = 'toggle',
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
									},
									instance = {
										order = 3,
										name = L['Hide in Instance'],
										type = 'toggle',
										get = function(info) return db.items[ info[#info] ] end,
										set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
									},
								},
							},
						},
					},
				},
			},
		},
	}
	hooksecurefunc(mod, 'ToggleTokens', UpdateTokenOptions)
	hooksecurefunc(mod, 'ToggleReputations', UpdateReputationOptions)
end

tinsert(BUI.Config, dashboardsTable)
tinsert(BUI.Config, UpdateSystemOptions)
tinsert(BUI.Config, UpdateTokenOptions)
tinsert(BUI.Config, UpdateProfessionOptions)
tinsert(BUI.Config, UpdateReputationOptions)
tinsert(BUI.Config, UpdateItemsOptions)