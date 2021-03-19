local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local mod = BUI:GetModule('Databars');

local tinsert, ipairs = table.insert, ipairs

local REPUTATION, DEFAULT, HONOR = REPUTATION, DEFAULT, HONOR

local backdropValues = {
	TRANSPARENT = L['Transparent'],
	DEFAULT = DEFAULT,
	NO_BACK = L['Without Backdrop'],
}

local positionValues = {
	['ABOVE'] = L['Above'],
	['BELOW'] = L['Below'],
	['LEFT'] = L['Left'],
	['RIGHT'] = L['Right'],
}

local databarsTbl = {
	-- bar, option, name
	{'ElvUI_ExperienceBar', 'experience', L['XP Bar']},
	{'ElvUI_AzeriteBar', 'azerite', L['Azerite Bar']},
	{'ElvUI_ReputationBar', 'reputation', REPUTATION},
	{'ElvUI_HonorBar', 'honor', HONOR},
	{'ElvUI_ThreatBar', 'threat', L["Threat"]}
}

local function databarsTable()
	E.Options.args.benikui.args.benikuiDatabars = {
		order = 80,
		type = 'group',
		name = BUI:cOption(L['DataBars'], "orange"),
		childGroups = 'tab',
		args = {
		},
	}
	for i, v in ipairs(databarsTbl) do
		local barname, option, optionName = unpack(v)
		local bar = _G[barname]
		E.Options.args.benikui.args.benikuiDatabars.args[option] = {
			order = i+1,
			type = 'group',
			name = optionName,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L["Enable"],
					get = function(info) return E.db.benikuiDatabars[option].enable end,
					set = function(info, value) E.db.benikuiDatabars[option].enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
				},
				spacer1 = {
					order = 2,
					type = 'description',
					name = '',
				},
				buiStyle = {
					order = 3,
					type = 'toggle',
					name = L['BenikUI Style'],
					disabled = function() return not E.db.benikuiDatabars[option].enable end,
					get = function(info) return E.db.benikuiDatabars[option].buiStyle end,
					set = function(info, value) E.db.benikuiDatabars[option].buiStyle = value; mod:ApplyStyle(bar, option); end,
				},
				buttonStyle = {
					order = 4,
					type = 'select',
					name = L['Button Backdrop'],
					disabled = function() return not E.db.benikuiDatabars[option].enable end,
					values = backdropValues,
					get = function(info) return E.db.benikuiDatabars[option].buttonStyle end,
					set = function(info, value) E.db.benikuiDatabars[option].buttonStyle = value; mod:ToggleBackdrop(bar, option); end,
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
							name = L["Enable"],
							get = function(info) return E.db.benikuiDatabars[option].notifiers.enable end,
							set = function(info, value) E.db.benikuiDatabars[option].notifiers.enable = value; E:StaticPopup_Show('PRIVATE_RL'); end,
						},
						position = {
							order = 2,
							type = 'select',
							name = L['Position'],
							disabled = function() return not E.db.benikuiDatabars[option].notifiers.enable end,
							values = positionValues,
							get = function(info) return E.db.benikuiDatabars[option].notifiers.position end,
							set = function(info, value) E.db.benikuiDatabars[option].notifiers.position = value; mod:UpdateNotifierPositions(bar, option); end,
						},
					},
				},
				elvuiOption = {
					order = 10,
					type = "execute",
					name = L["ElvUI"].." "..optionName,
					func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "databars", option) end,
				},
			},
		}
	end

	-- Maw bar
	E.Options.args.benikui.args.benikuiDatabars.args.mawBar = {
		order = -1,
		type = 'group',
		name = L["BenikUI Maw Bar"],
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = L["Enable"],
				get = function(info) return E.db.benikuiDatabars.mawBar[ info[#info] ] end,
				set = function(info, value) E.db.benikuiDatabars.mawBar[ info[#info] ] = value E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			spacer1 = {
				order = 2,
				type = 'description',
				name = '',
			},
			sizeGroup = {
				order = 3,
				type = 'group',
				name = L["Size"],
				guiInline = true,
				disabled = function() return not E.db.benikuiDatabars.mawBar.enable end,
				get = function(info) return E.db.benikuiDatabars.mawBar[ info[#info] ] end,
				set = function(info, value) E.db.benikuiDatabars.mawBar[ info[#info] ] = value mod:MawBar_Update() end,
				args = {
					width = {
						order = 1,
						type = 'range',
						name = L['Width'],
						min = 40, max = 400, step = 1,
					},
					height = {
						order = 2,
						type = 'range',
						name = L['Height'],
						min = 5, max = 30, step = 1,
					},
				},
			},
			colorGroup = {
				order = 4,
				type = 'group',
				name = L.COLOR,
				guiInline = true,
				disabled = function() return not E.db.benikuiDatabars.mawBar.enable end,
				args = {
					barColor = {
						order = 1,
						type = "color",
						name = L['Bar Color'],
						hasAlpha = true,
						get = function(info)
							local t = E.db.benikuiDatabars.mawBar[ info[#info] ]
							local d = P.benikuiDatabars.mawBar[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.db.benikuiDatabars.mawBar[ info[#info] ] = {}
							local t = E.db.benikuiDatabars.mawBar[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							mod:MawBar_Update()
						end,
					},
					textColor = {
						order = 2,
						type = "color",
						name = L['Text Color'],
						get = function(info)
							local t = E.db.benikuiDatabars.mawBar[ info[#info] ]
							local d = P.benikuiDatabars.mawBar[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.benikuiDatabars.mawBar[ info[#info] ] = {}
							local t = E.db.benikuiDatabars.mawBar[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							mod:MawBar_Update()
						end,
					},
				},
			},
			fontGroup = {
				order = 5,
				type = 'group',
				name = L['Fonts'],
				guiInline = true,
				disabled = function() return not E.db.benikuiDatabars.mawBar.enable end,
				get = function(info) return E.db.benikuiDatabars.mawBar[ info[#info] ] end,
				set = function(info, value) E.db.benikuiDatabars.mawBar[ info[#info] ] = value mod:MawBar_Update() end,
				args = {
					useDTfont = {
						order = 1,
						name = L['Use DataTexts font'],
						type = 'toggle',
						width = 'full',
					},
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 2,
						name = L['Font'],
						desc = L['Choose font for all dashboards.'],
						disabled = function() return E.db.benikuiDatabars.mawBar.useDTfont end,
						values = AceGUIWidgetLSMlists.font,
					},
					fontsize = {
						order = 3,
						name = L.FONT_SIZE,
						desc = L['Set the font size.'],
						disabled = function() return E.db.benikuiDatabars.mawBar.useDTfont end,
						type = 'range',
						min = 6, max = 22, step = 1,
					},
					fontflags = {
						order = 4,
						name = L['Font Outline'],
						disabled = function() return E.db.benikuiDatabars.mawBar.useDTfont end,
						type = 'select',
						values = {
							NONE = L["NONE"],
							OUTLINE = 'Outline',
							THICKOUTLINE = 'Thick',
							MONOCHROME = '|cffaaaaaaMono|r',
							MONOCHROMEOUTLINE = '|cffaaaaaaMono|r Outline',
							MONOCHROMETHICKOUTLINE = '|cffaaaaaaMono|r Thick',
						},
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, databarsTable)

local function injectElvUIDatabarOptions()
	-- xp
	E.Options.args.databars.args.experience.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset'], "blue"),
		get = function(info) return E.db.databars.experience[ info[#info] ] end,
		set = function(info, value) E.db.databars.experience[ info[#info] ] = value; mod:XpTextOffset() end,
	}

	E.Options.args.databars.args.experience.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..XPBAR_LABEL,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "experience") end,
	}

	-- azerite
	E.Options.args.databars.args.azerite.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset'], "blue"),
		get = function(info) return E.db.databars.azerite[ info[#info] ] end,
		set = function(info, value) E.db.databars.azerite[ info[#info] ] = value; mod:AzeriteTextOffset() end,
	}

	E.Options.args.databars.args.azerite.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..L["Azerite Bar"],
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "azerite") end,
	}

	-- reputation
	E.Options.args.databars.args.reputation.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset'], "blue"),
		get = function(info) return E.db.databars.reputation[ info[#info] ] end,
		set = function(info, value) E.db.databars.reputation[ info[#info] ] = value; mod:RepTextOffset() end,
	}

	E.Options.args.databars.args.reputation.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..REPUTATION,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "reputation") end,
	}

	-- honor
	E.Options.args.databars.args.honor.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset'], "blue"),
		get = function(info) return E.db.databars.honor[ info[#info] ] end,
		set = function(info, value) E.db.databars.honor[ info[#info] ] = value; mod:HonorTextOffset() end,
	}

	E.Options.args.databars.args.honor.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..HONOR,
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "honor") end,
	}

	-- threat
	E.Options.args.databars.args.threat.args.fontGroup.args.textYoffset = {
		order = 100,
		type = "range",
		min = -30, max = 30, step = 1,
		name = BUI:cOption(L['Text yOffset'], "blue"),
		get = function(info) return E.db.databars.threat[ info[#info] ] end,
		set = function(info, value) E.db.databars.threat[ info[#info] ] = value; mod:ThreatTextOffset() end,
	}

	E.Options.args.databars.args.threat.args.gotobenikui = {
		order = -1,
		type = "execute",
		name = BUI.Title..L["Threat"],
		func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui", "benikuiDatabars", "threat") end,
	}
end
tinsert(BUI.Config, injectElvUIDatabarOptions)
