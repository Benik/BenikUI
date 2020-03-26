local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');

if E.db.benikui == nil then E.db.benikui = {} end
local format = string.format
local tinsert, tsort, tconcat = table.insert, table.sort, table.concat

local StaticPopup_Show = StaticPopup_Show

local DONATORS = {
	'Cawkycow',
	'Chilou',
	'Judicator',
	'Hilderic',
	'Kevinrc',
	'Merathilis',
	'Sumidian (twice!)',
	'Justin',
	'Scott C.',
	'Edward F.',
	'Marcus G.',
	'Michael W.',
	'Ara M.',
	'CHRONiC',
	'Tlareg',
	'Nizz',
	'CremeEgg',
	'Louis S.',
	'Frisko',
	'Robert D.',
	'Shannon B.',
	'Joseph L.',
	'Valentina K.',
	'Max T.',
	'Kevin G.',
	'Ahmed A.',
	'Christopher S-C.',
	'George McC.',
	'Christian S.',
}
tsort(DONATORS, function(a, b) return a < b end)
local DONATOR_STRING = tconcat(DONATORS, ", ")

	StaticPopupDialogs["BENIKUI_CREDITS"] = {
		text = BUI.Title,
		button1 = OKAY,
		hasEditBox = 1,
		OnShow = function(self, data)
			self.editBox:SetAutoFocus(false)
			self.editBox.width = self.editBox:GetWidth()
			self.editBox:Width(280)
			self.editBox:AddHistoryLine("text")
			self.editBox.temptxt = data
			self.editBox:SetText(data)
			self.editBox:HighlightText()
			self.editBox:SetJustifyH("CENTER")
		end,
		OnHide = function(self)
			self.editBox:Width(self.editBox.width or 50)
			self.editBox.width = nil
			self.temptxt = nil
		end,
		EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide();
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		EditBoxOnTextChanged = function(self)
			if(self:GetText() ~= self.temptxt) then
				self:SetText(self.temptxt)
			end
			self:HighlightText()
			self:ClearFocus()
		end,
		OnAccept = E.noop,
		timeout = 0,
		whileDead = 1,
		preferredIndex = 3,
		hideOnEscape = 1,
	}

local function Core()
	E.Options.args.benikui = {
		order = 6,
		type = 'group',
		name = BUI.Title,
		childGroups = "tab",
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
				name = L['General'],
				get = function(info) return E.db.benikui.general[ info[#info] ] end,
				set = function(info, value) E.db.benikui.general[ info[#info] ] = value; end,
				args = {
					name = {
						order = 1,
						type = 'header',
						name = BUI:cOption(L['General']),
					},
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
						name = E.NewSign..L['Shadow Size'],
						min = 3, max = 10, step = 1,
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true or E.db.benikui.general.shadows ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
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
				name = L.COLORS,
				args = {
					name = {
						order = 1,
						type = 'header',
						name = BUI:cOption(L.COLORS),
					},
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
								min = 0, max = 1, step = 0.05,
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
								min = 0, max = 1, step = 0.05,
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
			info = {
				order = 2000,
				type = 'group',
				name = L['Information'],
				args = {
					name = {
						order = 1,
						type = 'header',
						name = BUI:cOption(L['Information']),
					},
					support = {
						order = 2,
						type = 'group',
						name = BUI:cOption(L['Support']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'execute',
								name = L['Tukui.org'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://www.tukui.org/forum/viewforum.php?f=33") end,
								},
							git = {
								order = 2,
								type = 'execute',
								name = L['Git Ticket tracker'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://git.tukui.org/Benik/ElvUI_BenikUI/issues") end,
							},
							discord = {
								order = 3,
								type = 'execute',
								name = L['Discord Server'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://discord.gg/8ZDDUem") end,
							},
						},
					},
					download = {
						order = 3,
						type = 'group',
						name = BUI:cOption(L['Download']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'execute',
								name = L['Tukui.org'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://www.tukui.org/addons.php?id=11") end,
							},
							curse = {
								order = 2,
								type = 'execute',
								name = L['Curseforge'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://www.curseforge.com/wow/addons/benikui-v3") end,
							},
							beta = {
								order = 3,
								type = 'execute',
								name = L['Beta versions'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://git.tukui.org/Benik/ElvUI_BenikUI/repository/archive.zip?ref=development") end,
							},
						},
					},
					coding = {
						order = 4,
						type = 'group',
						name = BUI:cOption(L['Coding']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format('|cffffd200%s|r', 'Elv, Tukz, Blazeflack, Azilroka, Darth Predator, Sinaris, Hydra, Merathilis, NihilisticPandemonium'),
							},
						},
					},
					testing = {
						order = 5,
						type = 'group',
						name = BUI:cOption(L['Testing & Inspiration']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format('|cffffd200%s|r', 'Merathilis, Roxanne, BuG, Semprini, Vxt, V4NT0M, Obscurrium, ElvUI community'),
							},
						},
					},
					donors = {
						order = 6,
						type = 'group',
						name = BUI:cOption(L['Donations']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format('|cffffd200%s|r', DONATOR_STRING)
							},
						},
					},
					addons = {
						order = 7,
						type = 'group',
						name = BUI:cOption(L['My other Addons']),
						guiInline = true,
						args = {
							locplus = {
								order = 1,
								type = 'execute',
								name = L['LocationPlus for ElvUI'],
								desc = L['Adds player location, coords + 2 Datatexts and a tooltip with info based on player location/level.'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.curse.com/addons/wow/elvui-location-plus") end,
							},
							nuts = {
								order = 2,
								type = 'execute',
								name = L['Nuts & Bolts for ElvUI'],
								desc = L['ElvUI Nuts & Bolts is a compilation of my addons hosted at tukui.org/Twitch plus some features that are moved from BenikUI'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://www.curseforge.com/wow/addons/elvui-nutsandbolts") end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, Core)
