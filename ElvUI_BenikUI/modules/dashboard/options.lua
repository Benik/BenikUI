local BUI, E, _, V, P, G = unpack((select(2, ...)))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local mod = BUI:GetModule('Dashboards')

local tinsert, pairs, ipairs, next = table.insert, pairs, ipairs, next
local format, tostring, tonumber, strmatch, type = format, tostring, tonumber, strmatch, type

local AceGUIWidgetLSMlists = AceGUIWidgetLSMlists
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local GetItemInfo = C_Item.GetItemInfo

local ADD = ADD
local COLOR_PICKER = COLOR_PICKER
local DELETE = DELETE
local ENABLE = ENABLE
local KEY_INSERT = KEY_INSERT
local LFG_LIST_LEGACY = LFG_LIST_LEGACY
local PROFESSIONS_MISSING_PROFESSION = PROFESSIONS_MISSING_PROFESSION
local REPUTATION = REPUTATION
local TOKENS = TOKENS
local TRADE_SKILLS = TRADE_SKILLS
local DESCRIPTION = DESCRIPTION

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

local function BuildLayoutGroup(key, dashboardFrame, updateFunc, dashboardDB, hasOption)
	hasOption = hasOption or {}
	local db = E.db.benikui.dashboards

	local args = {
		width = {
			order = 1,
			type = 'range',
			name = L['Width'],
			desc = format(L['Change the %s Dashboard width.'], key),
			min = 120, max = 520, step = 1,
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value)
				db[key][ info[#info] ] = value
				mod:UpdateHolderDimensions(dashboardFrame, key, dashboardDB, true)
				updateFunc()
			end,
		},
		barHeight = {
			order = 2,
			type = 'range',
			name = L['Bar Height'],
			desc = L['Change the Bar Height.'],
			min = 1, max = 20, step = 1,
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value)
				db[key][ info[#info] ] = value
				mod:BarHeight(key, dashboardDB)
			end,
		},
		spacer = {
			order = 4,
			type = 'header',
			name = '',
		},
		orientation = {
			order = 6,
			name = L['Frame Orientation'],
			type = 'select',
			values = frameOrientationValues,
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value updateFunc() end,
		},
		spacing = {
			order = 7,
			type = 'range',
			name = L["Spacing"],
			min = 1, max = 30, step = 1,
			disabled = function() return db[key].orientation == 'BOTTOM' end,
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value updateFunc() end,
		},
		layoutOptions = {
			order = 10,
			type = 'multiselect',
			name = ' ',
			get = function(_, k) return db[key][k] end,
			set = function(_, k, value)
				db[key][k] = value
				mod:ToggleStyle(dashboardFrame, key)
				mod:ToggleTransparency(dashboardFrame, key)
			end,
			values = layoutStyles,
		},
	}

	if hasOption.iconPosition then
		args.iconPosition = {
			order = 5,
			type = 'select',
			name = L['Icon Position'],
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value updateFunc() end,
			values = iconOrientationValues,
		}
	end

	if hasOption.textAlign then
		args.textAlign = {
			order = 5,
			name = L['Text Alignment'],
			type = 'select',
			values = textAlignValues,
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value updateFunc() end,
		}
	end

	if hasOption.updateThrottle then
		args.updateThrottle = {
			order = 5,
			type = 'range',
			name = L['Update Throttle'],
			min = 1, max = 10, step = 1,
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value end,
		}
		args.spacer2 = {
			order = 8,
			type = 'header',
			name = '',
		}
	end

	if hasOption.overrideColor then
		args.overrideColor = {
			order = 9,
			name = L['Value Color'],
			type = 'toggle',
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value E:StaticPopup_Show('PRIVATE_RL') end,
		}
	end

	return args
end

local function BuildVisibilityGroup(key, dashboardFrame, updateFunc)
	local db = E.db.benikui.dashboards
	return {
		combat = {
			order = 1,
			name = L['Hide In Combat'],
			desc = format(L['Show/Hide %s Dashboard when in combat'], key),
			type = 'toggle',
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value)
				db[key][ info[#info] ] = value
				mod:EnableDisableCombat(dashboardFrame, key)
			end,
		},
		mouseover = {
			order = 2,
			name = L['Mouse Over'],
			desc = L['The dashboard is not shown unless you mouse over the dashboard.'],
			type = 'toggle',
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value updateFunc() end,
		},
		instance = {
			order = 3,
			name = L['Hide in Instance'],
			type = 'toggle',
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value mod:UpdateVisibility() end,
		},
		housing = {
			order = 4,
			name = L['Hide in Housing'],
			type = 'toggle',
			get = function(info) return db[key][ info[#info] ] end,
			set = function(info, value) db[key][ info[#info] ] = value mod:UpdateVisibility() end,
		},
	}
end

local function GetDashboardConfig(key)
	local config = E.Options.args.benikui.args.dashboards.args[key].args.select
	local db = E.db.benikui.dashboards[key]
	return config, db
end

local function UpdateSystemOptions()
	local config, db = GetDashboardConfig('system')

	for _, board in next, mod.systemBoards do
		local optionOrder = 1
		local boardname = board.name

		config.args.systemGroup.args[boardname] = {
			order = optionOrder + 1,
			type = 'toggle',
			name = boardname,
			desc = L['Enable/Disable ']..boardname,
			get = function() return db.chooseSystem[boardname] end,
			set = function(_, value) db.chooseSystem[boardname] = value E:StaticPopup_Show('PRIVATE_RL') end,
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
		get = function() return db.latency end,
		set = function(_, value) db.latency = value E:StaticPopup_Show('PRIVATE_RL') end,
	}
end

local function isSeasonHeader(name)
	return type(name) == "string" and name:match("^Season%s+%d+$") ~= nil
end

local function isLegacyHeader(name)
	return type(LFG_LIST_LEGACY) == "string" and name == LFG_LIST_LEGACY
end

local function UpdateTokenOptions()
	local config, db = GetDashboardConfig('tokens')
	local optionOrder = 1

	config.args = config.args or {}
	for k in pairs(config.args) do
		if tonumber(k) then config.args[k] = nil end
	end

	local foldHeaderTo = {}
	local lastRealHeaderIndex

	for i, row in ipairs(mod.CurrencyList) do
		local name = row[1]

		if not row[2] then
			if isLegacyHeader(name) then
				-- do nothing and get rid of Legacy Header
			elseif isSeasonHeader(name) then
				if lastRealHeaderIndex then
					foldHeaderTo[i] = lastRealHeaderIndex
				else
					config.args[tostring(i)] = {
						order = optionOrder + i,
						type = "group",
						name = name,
						disabled = function() return not db.enable end,
						args = {
						},
					}
					lastRealHeaderIndex = i
				end
			else
				config.args[tostring(i)] = {
					order = optionOrder + i,
					type = "group",
					name = name,
					disabled = function() return not db.enable end,
					args = {
					},
				}
				lastRealHeaderIndex = i
			end
		end
	end

	for i, row in ipairs(mod.CurrencyList) do
		local id = row[2]
		local parentHeaderIndex = row[3]

		if parentHeaderIndex and id then
			parentHeaderIndex = foldHeaderTo[parentHeaderIndex] or parentHeaderIndex

			local parentGroup = config.args[tostring(parentHeaderIndex)]
			if parentGroup then
				local name, amount, icon, _, _, _, _, _, _, _, description = mod:GetTokenInfo(id)
				if name then
					parentGroup.args[tostring(i)] = {
						order = optionOrder + 2,
						type = "toggle",
						name = (icon and "|T"..icon..":18|t "..name) or name,
						desc = format("%s %s\n\n|cffffff00%s: %s|r %s",
							L["Enable/Disable"], name, L["Amount"], BreakUpLargeNumbers(amount), description and format("\n\n|cffffff00%s:|r %s", DESCRIPTION, description) or ""),
						disabled = function() return not db.enable end,
						get = function() return E.private.benikui.dashboards.tokens.chooseTokens[id] end,
						set = function(_, value)
							E.private.benikui.dashboards.tokens.chooseTokens[id] = value
							mod:UpdateTokens()
						end,
					}
				end
			end
		end
	end
end

local function UpdateProfessionOptions()
	local config, db = GetDashboardConfig('professions')

	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	local optionOrder = 1
	if (prof1 or prof2 or archy or fishing or cooking) then
		config.args.chooseProfessions = {
			order = optionOrder + 1,
			type = 'group',
			guiInline = true,
			name = L['Select Professions'],
			disabled = function() return not db.enable end,
			args = {
			},
		}
		local proftable = { GetProfessions() }
		for i = 1, 5 do
			local id = proftable[i]
			if id then
				local pname, icon = GetProfessionInfo(id)
				if pname then
					config.args.chooseProfessions.args[pname] = {
						order = optionOrder + 2,
						type = 'toggle',
						name = '|T'..icon..':18|t '..pname,
						desc = format('%s %s', L['Enable/Disable'], pname),
						get = function() return E.private.benikui.dashboards.professions.chooseProfessions[id] end,
						set = function(_, value) E.private.benikui.dashboards.professions.chooseProfessions[id] = value mod:UpdateProfessions() end,
					}
				end
			end
		end
	else
		config.args.chooseProfessions = {
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
	local config, db = GetDashboardConfig('reputations')

	local optionOrder = 1
	for i, info in ipairs(mod.ReputationsList) do
		local name, factionID, headerIndex, isHeader, isChild = unpack(info)

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
				get = function() return E.private.benikui.dashboards.reputations.chooseReputations[factionID] end,
				set = function(_, value) E.private.benikui.dashboards.reputations.chooseReputations[factionID] = value mod:UpdateReputations() end,
			}
		end
	end
end

local function UpdateItemsOptions()
	local config = GetDashboardConfig('items')
	local db = E.private.benikui.dashboards.items.chooseItems
	local optionOrder = 10

	for itemID in next, mod.ItemsList do
		local itemName, icon = mod:GetItemsInfo(itemID)
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
						get = function() if db[itemID] and db[itemID].enable then return db[itemID].enable end end,
						set = function(_, value) db[itemID].enable = value mod:GetUserItems() end,
					},
					spacer = {
						order = 2,
						type = 'header',
						name = '',
					},
					useCustomStack = {
						order = 10,
						type = 'toggle',
						name = function()
							if db[itemID] and db[itemID].useCustomStack and db[itemID].customStack then
								return format('%s |cfffcba03(%s)|r', L['Use Custom Stack'], db[itemID].customStack)
							end
							return L['Use Custom Stack']
						end,
						disabled = function() return not db[itemID].enable end,
						get = function() if db[itemID] and db[itemID].useCustomStack then return db[itemID].useCustomStack end end,
						set = function(_, value)
							db[itemID].useCustomStack = value
							if not value then
								db[itemID].customStack = nil
							end
							mod:UpdateItems()
						end,
					},
					customStack = {
						order = 11,
						type = 'input',
						width = 'half',
						name = L['Custom Stack'],
						hidden = function() return not (db[itemID] and db[itemID].useCustomStack) end,
						get = function() if db[itemID] and db[itemID].customStack then return db[itemID].customStack end end,
						set = function(_, value)
							db[itemID].customStack = tonumber(value)
							mod:UpdateItems()
						end,
					},
					clearCustomStack = {
						order = 12,
						type = 'execute',
						name = '|TInterface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\Close.tga:12:12|t',
						width = 0.25,
						hidden = function() return not (db[itemID] and db[itemID].useCustomStack) end,
						disabled = function() return not db[itemID].customStack end,
						func = function()
							db[itemID].customStack = nil
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
						disabled = function() return not db[itemID].enable end,
						func = function()
							config.args[tostring(itemID)] = nil
							db[itemID] = nil
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

	local BUI_SystemDashboard		= _G.BUI_SystemDashboard
	local BUI_TokensDashboard		= _G.BUI_TokensDashboard
	local BUI_ProfessionsDashboard	= _G.BUI_ProfessionsDashboard
	local BUI_ReputationsDashboard	= _G.BUI_ReputationsDashboard
	local BUI_ItemsDashboard		= _G.BUI_ItemsDashboard

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
						disabled = function()
							return not db.system.enable and not db.tokens.enable
								and not db.professions.enable and not db.reputations.enable
								and not db.items.enable
						end,
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
					select = {
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
								args = BuildLayoutGroup('system', BUI_SystemDashboard, function() mod:UpdateSystemSettings() end, mod.SystemDB, {
									textAlign		= true,
									updateThrottle	= true,
									overrideColor	= true,
								}),
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
								args = BuildVisibilityGroup('system', BUI_SystemDashboard, function() mod:UpdateSystemSettings() end,
									L['Show/Hide System Dashboard when in combat']),
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
						get = function() return db.tokens.enable end,
						set = function(_, value) db.tokens.enable = value mod:ToggleTokens() end,
					},
					select = {
						order = 2,
						type = 'group',
						name = TOKENS,
						disabled = function() return not db.tokens.enable end,
						get = function(info) return db.tokens[ info[#info] ] end,
						set = function(info, value) db.tokens[ info[#info] ] = value mod:UpdateTokens() end,
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
									},
									weekly = {
										order = 2,
										name = L['Show Weekly max'],
										desc = L['Show Weekly max tokens instead of total max'],
										type = 'toggle',
									},
									tooltip = {
										order = 3,
										name = L['Tooltip'],
										desc = L['Show/Hide Tooltips'],
										type = 'toggle',
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
								args = BuildLayoutGroup('tokens', BUI_TokensDashboard, function() mod:UpdateTokens() end, mod.TokensDB, {
									iconPosition = true,
								}),
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
								args = BuildVisibilityGroup('tokens', BUI_TokensDashboard, function() mod:UpdateTokens() end,
									L['Show/Hide Tokens Dashboard when in combat']),
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
					select = {
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
								args = BuildLayoutGroup('professions', BUI_ProfessionsDashboard, function() mod:UpdateProfessions() end, mod.ProfessionsDB, {
									iconPosition = true,
								}),
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
								args = BuildVisibilityGroup('professions', BUI_ProfessionsDashboard, function() mod:UpdateProfessions() end,
									L['Show/Hide Professions Dashboard when in combat']),
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
					select = {
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
									barFactionColors	= L['Use Faction Colors on Bars'],
									textFactionColors	= L['Use Faction Colors on Text'],
									tooltip				= L['Tooltip'],
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
								args = BuildLayoutGroup('reputations', BUI_ReputationsDashboard, function() mod:UpdateReputations() end, mod.FactionsDB, {
									textAlign = true,
								}),
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
								args = BuildVisibilityGroup('reputations', BUI_ReputationsDashboard, function() mod:UpdateReputations() end,
									L['Show/Hide Reputations Dashboard when in combat']),
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
						get = function() return db.items.enable end,
						set = function(_, value) db.items.enable = value mod:ToggleItems() end,
					},
					select = {
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
								get = function() return db.items.tooltip end,
								set = function(_, value) db.items.tooltip = value end,
							},
							showMax = {
								order = 3,
								type = 'toggle',
								name = L['Show Max Amount'],
								get = function(info) return db.items[ info[#info] ] end,
								set = function(info, value) db.items[ info[#info] ] = value mod:UpdateItems() end,
							},
							spacer = {
								order = 4,
								type = 'header',
								name = '',
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
												for object in ipairs(mod.ItemsList) do
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
								args = BuildLayoutGroup('items', BUI_ItemsDashboard, function() mod:UpdateItems() end, mod.ItemsDB, {
									iconPosition = true,
								}),
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
								args = BuildVisibilityGroup('items', BUI_ItemsDashboard, function() mod:UpdateItems() end,
									L['Show/Hide items Dashboard when in combat']),
							},
						},
					},
				},
			},
		},
	}
end

tinsert(BUI.Config, dashboardsTable)

local UpdateSelectOptions = {
	system		= UpdateSystemOptions,
	tokens		= UpdateTokenOptions,
	professions	= UpdateProfessionOptions,
	reputations	= UpdateReputationOptions,
	items		= UpdateItemsOptions,
}

for _, updateFunc in next, UpdateSelectOptions do
	tinsert(BUI.Config, updateFunc)
end