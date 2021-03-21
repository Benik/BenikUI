local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local mod = BUI:GetModule('Widgetbars');

local tinsert = table.insert

local textFormatValues = {
	NONE = L["NONE"],
	PERCENT = L["Percent"],
}

local function widgetTable()
	E.Options.args.benikui.args.benikuiWidgetbars = {
		order = 85,
		type = 'group',
		name = BUI:cOption(L['Widget Bars'], "orange"),
		args = {
			mawBar = {
				order = 1,
				type = 'group',
				name = L["BenikUI Maw Bar"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikuiWidgetbars.mawBar[ info[#info] ] end,
						set = function(info, value) E.db.benikuiWidgetbars.mawBar[ info[#info] ] = value E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					textFormat = {
						order = 3,
						name = L["Text Format"],
						disabled = function() return not E.db.benikuiWidgetbars.mawBar.enable end,
						type = 'select',
						values = textFormatValues,
						get = function(info) return E.db.benikuiWidgetbars.mawBar[ info[#info] ] end,
						set = function(info, value) E.db.benikuiWidgetbars.mawBar[ info[#info] ] = value mod:MawBar_Update() end,
					},
					sizeGroup = {
						order = 4,
						type = 'group',
						name = L["Size"],
						guiInline = true,
						disabled = function() return not E.db.benikuiWidgetbars.mawBar.enable end,
						get = function(info) return E.db.benikuiWidgetbars.mawBar[ info[#info] ] end,
						set = function(info, value) E.db.benikuiWidgetbars.mawBar[ info[#info] ] = value mod:MawBar_Update() end,
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
						order = 5,
						type = 'group',
						name = L.COLOR,
						guiInline = true,
						disabled = function() return not E.db.benikuiWidgetbars.mawBar.enable end,
						args = {
							barAutoColor = {
								order = 1,
								name = L['Color by Tier'],
								type = 'toggle',
								get = function(info) return E.db.benikuiWidgetbars.mawBar[ info[#info] ] end,
								set = function(info, value) E.db.benikuiWidgetbars.mawBar[ info[#info] ] = value mod:MawBar_Update() end,
							},
							barColor = {
								order = 2,
								type = "color",
								name = L['Bar Color'],
								hasAlpha = true,
								disabled = function() return E.db.benikuiWidgetbars.mawBar.barAutoColor end,
								get = function(info)
									local t = E.db.benikuiWidgetbars.mawBar[ info[#info] ]
									local d = P.benikuiWidgetbars.mawBar[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
								end,
								set = function(info, r, g, b, a)
									E.db.benikuiWidgetbars.mawBar[ info[#info] ] = {}
									local t = E.db.benikuiWidgetbars.mawBar[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									mod:MawBar_Update()
								end,
							},
							textColor = {
								order = 3,
								type = "color",
								name = L['Text Color'],
								get = function(info)
									local t = E.db.benikuiWidgetbars.mawBar[ info[#info] ]
									local d = P.benikuiWidgetbars.mawBar[info[#info]]
									return t.r, t.g, t.b, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									E.db.benikuiWidgetbars.mawBar[ info[#info] ] = {}
									local t = E.db.benikuiWidgetbars.mawBar[ info[#info] ]
									t.r, t.g, t.b = r, g, b
									mod:MawBar_Update()
								end,
							},
						},
					},
					fontGroup = {
						order = 6,
						type = 'group',
						name = L['Fonts'],
						guiInline = true,
						disabled = function() return not E.db.benikuiWidgetbars.mawBar.enable end,
						get = function(info) return E.db.benikuiWidgetbars.mawBar[ info[#info] ] end,
						set = function(info, value) E.db.benikuiWidgetbars.mawBar[ info[#info] ] = value mod:MawBar_Update() end,
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
								disabled = function() return E.db.benikuiWidgetbars.mawBar.useDTfont end,
								values = AceGUIWidgetLSMlists.font,
							},
							fontsize = {
								order = 3,
								name = L.FONT_SIZE,
								desc = L['Set the font size.'],
								disabled = function() return E.db.benikuiWidgetbars.mawBar.useDTfont end,
								type = 'range',
								min = 6, max = 22, step = 1,
							},
							fontflags = {
								order = 4,
								name = L['Font Outline'],
								disabled = function() return E.db.benikuiWidgetbars.mawBar.useDTfont end,
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
							textYoffset = {
								order = 5,
								type = "range",
								min = -30, max = 30, step = 1,
								name = L['Text yOffset'],
							},
						},
					},
				},
			},
			halfBar = {
				order = 2,
				type = 'multiselect',
				name = L["Half Bar"],
				get = function(_, key) return E.db.benikuiWidgetbars.halfBar[key] end,
				set = function(_, key, value) E.db.benikuiWidgetbars.halfBar[key] = value; 
					if key == 'mirrorbar' then mod:MirrorBar() end
				end,
				values = {
					altbar = L["Alternative Power"],
					mirrorbar = L["Mirror Timers"],
				}
			},
		},
	}
end
tinsert(BUI.Config, widgetTable)