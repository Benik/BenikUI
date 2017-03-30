local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

if E.db.benikui == nil then E.db.benikui = {} end
local format = string.format
local tinsert, tsort, tconcat = table.insert, table.sort, table.concat

local CLASS_COLORS, CUSTOM, DEFAULT = CLASS_COLORS, CUSTOM, DEFAULT
local COLORS, COLOR_PICKER = COLORS, COLOR_PICKER
local StaticPopup_Show = StaticPopup_Show

local DONATORS = {
	'Cawkycow',
	'Chilou',
	'Judicator',
	'Hilderic',
	'Kevinrc',
	'Merathilis',
	'Sumidian',
	'Justin'
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
		order = 9000,
		type = 'group',
		name = BUI.Title,
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
				image = function() return 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga', 192, 96 end,
				imageCoords = {0.09, 0.99, 0.01, 0.99}
			},			
			install = {
				order = 3,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() BUI:SetupBenikUI(); E:ToggleConfig(); end,
			},
			spacer2 = {
				order = 4,
				type = 'header',
				name = '',
			},
			general = {
				order = 5,
				type = 'group',
				name = L['General'],
				guiInline = true,
				get = function(info) return E.db.benikui.general[ info[#info] ] end,
				set = function(info, value) E.db.benikui.general[ info[#info] ] = value; end,
				args = {
					benikuiStyle = {
						order = 1,
						type = 'toggle',
						name = L['BenikUI Style'],
						desc = L['Enable/Disable the decorative bars from UI elements'],
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					hideStyle = {
						order = 2,
						type = 'toggle',
						name = L['Hide BenikUI Style'],
						desc = L['Show/Hide the decorative bars from UI elements. Usefull when applying Shadows, because BenikUI Style must be enabled. |cff00c0faNote: Some elements like the Actionbars, Databars or BenikUI Datatexts have their own Style visibility options.|r'],
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; BUI:UpdateStyleVisibility(); end,
					},
					shadows = {
						order = 3,
						type = 'toggle',
						name = L['Shadows'].." (Beta)",
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					auras = {
						order = 4,
						type = 'toggle',
						name = L['Style Auras'],
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					spacer = {
						order = 5,
						type = 'header',
						name = '',
					},
					loginMessage = {
						order = 6,
						type = 'toggle',
						name = L['Login Message'],
					},
					splashScreen = {
						order = 7,
						type = 'toggle',
						name = L['Splash Screen'],
					},
				},
			},
			colors = {
				order = 6,
				type = 'group',
				name = COLORS,
				guiInline = true,
				args = {
					themes = {
						order = 1,
						type = 'group',
						name = L['Color Themes'],
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
								name = EDIT,
								hasAlpha = true,
								get = function(info)
									local t = E.db.general.backdropfadecolor
									local d = P.general.backdropfadecolor
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
								end,
								set = function(info, r, g, b, a, color)
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
						order = 2,
						type = 'group',
						name = L['Style Color'],
						args = {
							StyleColor = {
								order = 1,
								type = "select",
								name = "",
								values = {
									[1] = CLASS_COLORS,
									[2] = CUSTOM,
									[3] = L['Value Color'],
									[4] = DEFAULT,
								},
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; BUI:UpdateStyleColors(); end,
							},
							customStyleColor = {
								order = 2,
								type = "color",
								name = COLOR_PICKER,
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
						order = 3,
						type = 'group',
						name = L['ActionBar Style Color'],
						args = {
							abStyleColor = {
								order = 1,
								type = "select",
								name = "",
								values = {
									[1] = CLASS_COLORS,
									[2] = CUSTOM,
									[3] = L['Value Color'],
									[4] = DEFAULT,
								},
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; E:GetModule('BuiActionbars'):ColorBackdrops(); end,
							},
							customAbStyleColor = {
								order = 2,
								type = "color",
								name = COLOR_PICKER,
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
									E:GetModule('BuiActionbars'):ColorBackdrops();
								end,
							},
							abAlpha = {
								order = 3,
								type = "range",
								name = L["Alpha"],
								min = 0, max = 1, step = 0.05,
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; E:GetModule('BuiActionbars'):ColorBackdrops(); end,
							},	
						},
					},
					gameMenu = {
						order = 4,
						type = 'group',
						name = L['Game Menu Color'],
						args = {
							gameMenuColor = {
								order = 1,
								type = "select",
								name = "",
								values = {
									[1] = CLASS_COLORS,
									[2] = CUSTOM,
									[3] = L["Value Color"],
								},
								get = function(info) return E.db.benikui.colors[ info[#info] ] end,
								set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; end,
							},
							customGameMenuColor = {
								order = 2,
								type = "color",
								name = COLOR_PICKER,
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
						name = BUI.Title,
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
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=228") end,
								},
							git = {
								order = 2,
								type = 'execute',
								name = L['Git Ticket tracker'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://git.tukui.org/Benik/ElvUI_BenikUI/issues") end,
							},
							discord = {
								order = 3,
								type = 'execute',
								name = L['Tukui.org Discord Server'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://discord.gg/xFWcfgE") end,
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
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=228") end,
							},
							curse = {
								order = 2,
								type = 'execute',
								name = L['Curse.com'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.curse.com/addons/wow/benikui-v2") end,
							},
							wowint = {
								order = 3,
								type = 'execute',
								name = L['WoW Interface'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.wowinterface.com/downloads/info23675-BenikUIv3.html") end,
							},			
							beta = {
								order = 4,
								type = 'execute',
								name = L['Beta versions'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://git.tukui.org/Benik/ElvUI_BenikUI/commits/master") end,
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
								name = format('|cffffd200%s|r', 'Elv, Tukz, Blazeflack, Azilroka, Darth Predator, Sinaris, Hydra, Merathilis'),
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
								name = format('|cffffd200%s|r', 'Merathilis, Rockxana, BuG, Vxt, V4NT0M, ElvUI community'),
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
							loclite = {
								order = 2,
								type = 'execute',
								name = L['LocationLite for ElvUI'],
								desc = L['Adds a location panel with coords. A LocationPlus alternative.'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.curse.com/addons/wow/elvui-locationlite") end,
							},
							dtText = {
								order = 3,
								type = 'execute',
								name = L['ElvUI DT Text Color'],
								desc = L['a plugin for ElvUI, that changes the DT text color to class color, value color or any user defined'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=213") end,
							},
							trAb = {
								order = 5,
								type = 'execute',
								name = L['ElvUI Transparent Actionbar Backdrops'],
								desc = L['A small plugin that makes the actionbar backdrops and the unused buttons transparent'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.tukui.org/addons/index.php?act=view&id=173") end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, Core)