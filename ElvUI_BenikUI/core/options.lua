local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');

if E.db.benikui == nil then E.db.benikui = {} end
local tinsert = table.insert

local CLASS_COLORS, CUSTOM, DEFAULT = CLASS_COLORS, CUSTOM, DEFAULT
local COLORS, COLOR_PICKER, MISCELLANEOUS = COLORS, COLOR_PICKER, MISCELLANEOUS
local CHAT, ENABLE, MAIL_LABEL, GARRISON_LOCATION_TOOLTIP, FONT_SIZE = CHAT, ENABLE, MAIL_LABEL, GARRISON_LOCATION_TOOLTIP, FONT_SIZE
local StaticPopup_Show = StaticPopup_Show

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
						desc = L['Show/Hide the decorative bars from UI elements'],
						width = 'full',
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, color) E.db.benikui.general[ info[#info] ] = color; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					loginMessage = {
						order = 2,
						type = 'toggle',
						name = L['Login Message'],
					},
					splashScreen = {
						order = 3,
						type = 'toggle',
						name = L['Splash Screen'],
					},
					gameMenuButton = {
						order = 4,
						type = 'toggle',
						name = L['GameMenu Button'],
						get = function(info) return E.db.benikui.general[ info[#info] ] end,
						set = function(info, value) E.db.benikui.general[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
				},
			},
			colors = {
				order = 6,
				type = 'group',
				name = COLORS,
				guiInline = true,
				args = {
					colorTheme = {
						order = 2,
						type = 'select',
						name = L['Color Themes'],
						values = {
							['Elv'] = L['ElvUI'],
							['Diablo'] = L['Diablo'],
							['Hearthstone'] = L['Hearthstone'],
							['Mists'] = L['Mists'],
						},
						get = function(info) return E.db.benikui.colors[ info[#info] ] end,
						set = function(info, color) E.db.benikui.colors[ info[#info] ] = color; BUI:BuiColorThemes(color); end,
					},
					StyleColor = {
						order = 3,
						type = "select",
						name = L['Style Color'],
						values = {
							[1] = CLASS_COLORS,
							[2] = CUSTOM,
							[3] = L['Value Color'],
							[4] = DEFAULT,
						},
						disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.colors[ info[#info] ] end,
						set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					customStyleColor = {
						order = 4,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.benikui.colors.StyleColor ~= 2 or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info)
							local t = E.db.benikui.colors[ info[#info] ]
							local d = P.benikui.colors[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
						set = function(info, r, g, b)
							E.db.benikui.colors[ info[#info] ] = {}
							local t = E.db.benikui.colors[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							E:StaticPopup_Show('PRIVATE_RL'); 
						end,
					},
					abStyleColor = {
						order = 5,
						type = "select",
						name = L['ActionBar Style Color'],
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
						order = 6,
						type = "color",
						name = COLOR_PICKER,
						width = "half",
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
					gameMenuColor = {
						order = 7,
						type = "select",
						name = L['Game Menu Color'],
						values = {
							[1] = CLASS_COLORS,
							[2] = CUSTOM,
						},
						get = function(info) return E.db.benikui.colors[ info[#info] ] end,
						set = function(info, value) E.db.benikui.colors[ info[#info] ] = value; end,
					},
					customGameMenuColor = {
						order = 8,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.benikui.colors.gameMenuColor == 1 end,
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
			misc = {
				order = 7,
				type = 'group',
				name = MISCELLANEOUS,
				guiInline = true,
				args = {
					ilevel = {
						order = 1,
						type = 'group',
						name = L['iLevel'],
						get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; end,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L['Enable'],
								desc = L['Show item level per slot, on the character info frame'],
								width = "full",
								get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
								set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,	
							},
							font = {
								type = 'select', dialogControl = 'LSM30_Font',
								order = 2,
								name = L['Font'],
								values = AceGUIWidgetLSMlists.font,
							},
							fontsize = {
								order = 3,
								name = FONT_SIZE,
								type = 'range',
								min = 6, max = 22, step = 1,
							},
							fontflags = {
								order = 4,
								name = L['Font Outline'],
								type = 'select',
								values = {
									['NONE'] = L['None'],
									['OUTLINE'] = 'OUTLINE',
									['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
									['THICKOUTLINE'] = 'THICKOUTLINE',
								},
							},
							colorStyle = {
								order = 5,
								type = "select",
								name = COLOR,
								values = {
									['RARITY'] = RARITY,
									['CUSTOM'] = CUSTOM,
								},
							},
							color = {
								order = 6,
								type = "color",
								name = COLOR_PICKER,
								disabled = function() return E.db.benikui.misc.ilevel.colorStyle == 'RARITY' end,
								get = function(info)
									local t = E.db.benikui.misc.ilevel[ info[#info] ]
									local d = P.benikui.misc.ilevel[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
									end,
								set = function(info, r, g, b)
									E.db.benikui.misc.ilevel[ info[#info] ] = {}
									local t = E.db.benikui.misc.ilevel[ info[#info] ]
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
							beta = {
								order = 3,
								type = 'execute',
								name = L['Beta versions'],
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://git.tukui.org/Benik/ElvUI_BenikUI/commits/master") end,
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
								func = function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "http://www.wowinterface.com/downloads/info23675-BenikUIv2.html") end,
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
								name = format('|cffffd200%s|r', 'Elv, Tukz, Blazeflack, Azilroka, Sinaris, Repooc, Darth Predator, Hydra, Merathilis'),
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
					donators = {
						order = 6,
						type = 'group',
						name = BUI:cOption(L['Donations']),
						guiInline = true,
						args = {
							tukui = {
								order = 1,
								type = 'description',
								fontSize = 'medium',
								name = format('|cffffd200%s|r', 'Chilou, Merathilis'),
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

local function Datatexts()
	E.Options.args.benikui.args.datatexts = {
		order = 9,
		type = 'group',
		name = L['DataTexts'],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(L['DataTexts']),
			},
			chat = {
				order = 2,
				type = 'group',
				name = CHAT,
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						desc = L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'],
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; LO:ToggleChatPanels(); E:GetModule('Chat'):UpdateAnchors(); end,	
					},
					transparent = {
						order = 2,
						type = 'toggle',
						name = L['Panel Transparency'],
						disabled = function() return not E.db.benikui.datatexts.chat.enable end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('BuiLayout'):ToggleTransparency(); end,	
					},
					editBoxPosition = {
						order = 3,
						type = 'select',
						name = L['Chat EditBox Position'],
						desc = L['Position of the Chat EditBox, if datatexts are disabled this will be forced to be above chat.'],
						values = {
							['BELOW_CHAT'] = L['Below Chat'],
							['ABOVE_CHAT'] = L['Above Chat'],
						},
						disabled = function() return not E.db.benikui.datatexts.chat.enable end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('Chat'):UpdateAnchors() end,
					},
					styled = {
						order = 4,
						type = 'toggle',
						name = L['BenikUI Style'],
						desc = L['Styles the chat datetexts and buttons only if both chat backdrops are set to "Hide Both".'],
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('BuiLayout'):ChatStyles(); E:GetModule('Layout'):ToggleChatPanels(); E.Chat:PositionChat(true); end,	
					},
					backdrop = {
						order = 5,
						type = 'toggle',
						name = L['Backdrop'],
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('BuiLayout'):ToggleTransparency(); end,	
					},								
				},
			},
			middle = {
				order = 3,
				type = 'group',
				name = L['Middle'],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					transparent = {
						order = 2,
						type = 'toggle',
						name = L['Panel Transparency'],
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					backdrop = {
						order = 3,
						type = 'toggle',
						name = L['Backdrop'],
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					styled = {
						order = 4,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return E.db.benikui.datatexts.middle.enable ~= true or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					width = {
						order = 5,
						type = "range",
						name = L["Width"],
						min = 300, max = 1400, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextDimensions(); end,
					},	
					height = {
						order = 6,
						type = "range",
						name = L["Height"],
						min = 10, max = 32, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextDimensions(); end,
					},								
				},
			},
			mail = {
				order = 4,
				type = 'group',
				name = MAIL_LABEL,
				guiInline = true,
				get = function(info) return E.db.benikui.datatexts.mail[ info[#info] ] end,
				set = function(info, value) E.db.benikui.datatexts.mail[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
				args = {
					toggle = {
						order = 1,
						type = 'toggle',
						name = L['Hide Mail Icon'],
						desc = L['Show/Hide Mail Icon on minimap'],
					},
				},
			},
			garrison = {
				order = 5,
				type = 'group',
				name = GARRISON_LOCATION_TOOLTIP,
				guiInline = true,
				get = function(info) return E.db.benikui.datatexts.garrison[ info[#info] ] end,
				set = function(info, value) E.db.benikui.datatexts.garrison[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
				args = {
					currency = {
						order = 1,
						type = 'toggle',
						name = L['Show Garrison Currency'],
						desc = L['Show/Hide garrison currency on the datatext tooltip'],
					},
					oil = {
						order = 2,
						type = 'toggle',
						name = L['Show Oil'],
						desc = L['Show/Hide oil on the datatext tooltip'],
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, Datatexts)