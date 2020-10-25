local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local tinsert = table.insert

if E.db.benikui == nil then E.db.benikui = {} end

local function Core()
	E.Options.args.benikui = {
		order = 6,
		type = 'group',
		name = BUI.Title,
		childGroups = "tree",
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI.Title..BUI:cOption(BUI.Version)..L['by Benik (EU-Emerald Dream)'],
			},
			logo = {
				order = 2,
				type = 'description',
				name = L['BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with ']..BUI:cOption(L['light blue color.']),
				fontSize = 'medium',
				image = function() return 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga', 384, 96 end,
			},
			install = {
				order = 3,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() E:GetModule("PluginInstaller"):Queue(BUI.installTable); E:ToggleOptionsUI() end,
			},
			spacer2 = {
				order = 4,
				type = 'header',
				name = '',
			},
			general = {
				order = 10,
				type = 'group',
				name = BUI:cOption(L['General']),
				get = function(info) return E.db.benikui.general[ info[#info] ] end,
				set = function(info, value) E.db.benikui.general[ info[#info] ] = value; end,
				args = {
					benikuiStyle = {
						order = 2,
						type = 'toggle',
						name = L['BenikUI Style'],
						desc = L['Enable/Disable the decorative bars from UI elements'],
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					hideStyle = {
						order = 3,
						type = 'toggle',
						name = L['Hide BenikUI Style'],
						desc = L['Show/Hide the decorative bars from UI elements. Usefull when applying Shadows, because BenikUI Style must be enabled. |cff00c0faNote: Some elements like the Actionbars, Databars or BenikUI Datatexts have their own Style visibility options.|r'],
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; BUI:UpdateStyleVisibility(); end,
					},
					spacer = {
						order = 10,
						type = 'description',
						name = '',
					},
					shadows = {
						order = 11,
						type = 'toggle',
						name = L['Shadows'],
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					shadowSize = {
						order = 12,
						type = "range",
						name = L['Shadow Size'],
						min = 3, max = 10, step = 1,
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true or E.db.benikui.general.shadows ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; BUI:UpdateShadowSize(); end,
					},
					spacer2 = {
						order = 20,
						type = 'header',
						name = '',
					},
					loginMessage = {
						order = 21,
						type = 'toggle',
						name = L['Login Message'],
					},
					splashScreen = {
						order = 22,
						type = 'toggle',
						name = L['Splash Screen'],
					},
				},
			},
			colors = {
				order = 20,
				type = 'group',
				name = BUI:cOption(L.COLORS),
				args = {
					themes = {
						order = 2,
						type = 'group',
						name = L['Color Themes'],
						guiInline = true,
						args = {
							colorTheme = {
								order = 1,
								type = 'select',
								name = "",
								values = {
									['Elv'] = L['ElvUI'],
									['Diablo'] = L['Diablo'],
									['Hearthstone'] = L['Hearthstone'],
									['Mists'] = L['Mists'],
								},
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, color) E.db.benikui.colors[ info[#info] ] = color; BUI:SetupColorThemes(color); end,
							},
							customThemeColor = {
								order = 2,
								type = 'color',
								name = L.EDIT,
								hasAlpha = true,
								get = function(info)
									local t = E.db.general.backdropfadecolor
									local d = P.general.backdropfadecolor
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
								end,
								set = function(info, r, g, b, a)
									E.db.general.backdropfadecolor = {}
									local t = E.db.general.backdropfadecolor
									t.r, t.g, t.b, t.a = r, g, b, a
									E:UpdateMedia()
									E:UpdateBackdropColors()
								end,
							},
						},
					},
					style = {
						order = 3,
						type = 'group',
						name = L['Style Color'],
						guiInline = true,
						args = {
							StyleColor = {
								order = 1,
								type = "select",
								name = "",
								values = {
									[1] = L.CLASS_COLORS,
									[2] = L.CUSTOM,
									[3] = L['Value Color'],
									[4] = L.DEFAULT,
								},
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; BUI:UpdateStyleColors(); end,
							},
							customStyleColor = {
								order = 2,
								type = "color",
								name = L.COLOR_PICKER,
								disabled = function() return E.db.benikui.colors.StyleColor ~= 2 or E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info)
									local t = E.db.benikui.colors[ info[#info] ]
									local d = P.benikui.colors[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b)
									E.db.benikui.colors[ info[#info] ] = {}
									local t = E.db.benikui.colors[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									BUI:UpdateStyleColors();
								end,
							},
							styleAlpha = {
								order = 3,
								type = "range",
								name = L["Alpha"],
								min = .2, max = 1, step = 0.05,
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; BUI:UpdateStyleColors(); end,
							},
						},
					},
					abStyle = {
						order = 4,
						type = 'group',
						name = L['ActionBar Style Color'],
						guiInline = true,
						args = {
							abStyleColor = {
								order = 1,
								type = "select",
								name = "",
								values = {
									[1] = L.CLASS_COLORS,
									[2] = L.CUSTOM,
									[3] = L['Value Color'],
									[4] = L.DEFAULT,
								},
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; BUI:GetModule('Actionbars'):ColorBackdrops(); end,
							},
							customAbStyleColor = {
								order = 2,
								type = "color",
								name = L.COLOR_PICKER,
								disabled = function() return E.db.benikui.colors.abStyleColor ~= 2 or E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info)
									local t = E.db.benikui.colors[ info[#info] ]
									local d = P.benikui.colors[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
									end,
								set = function(info, r, g, b)
									E.db.benikui.colors[ info[#info] ] = {}
									local t = E.db.benikui.colors[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									BUI:GetModule('Actionbars'):ColorBackdrops();
								end,
							},
							abAlpha = {
								order = 3,
								type = "range",
								name = L["Alpha"],
								min = .2, max = 1, step = 0.05,
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; BUI:GetModule('Actionbars'):ColorBackdrops(); end,
							},
						},
					},
					gameMenu = {
						order = 5,
						type = 'group',
						name = L['Game Menu Color'],
						guiInline = true,
						args = {
							gameMenuColor = {
								order = 1,
								type = "select",
								name = "",
								values = {
									[1] = L.CLASS_COLORS,
									[2] = L.CUSTOM,
									[3] = L["Value Color"],
								},
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; end,
							},
							customGameMenuColor = {
								order = 2,
								type = "color",
								name = L.COLOR_PICKER,
								disabled = function() return E.db.benikui.colors.gameMenuColor == 1 or E.db.benikui.colors.gameMenuColor == 3 end,
								get = function(info)
									local t = E.db.benikui.colors[ info[#info] ]
									local d = P.benikui.colors[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
									end,
								set = function(info, r, g, b)
									E.db.benikui.colors[ info[#info] ] = {}
									local t = E.db.benikui.colors[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
								end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, Core)