local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');

if E.db.bui == nil then E.db.bui = {} end

local function buiCore()
	E.Options.args.bui = {
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
				name = L['BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with ']..BUI:cOption(L['light blue color.']..'\n\n'..BUI:cOption(L['Credits:'])..L[' Elv, Tukz, Blazeflack, Azilroka, Sinaris, Repooc, Darth Predator, Dandruff, Hydra, Merathilis, ElvUI community']),
				fontSize = 'medium',
				image = function() return 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga', 192, 96 end,
				imageCoords = {0.09,0.99,0.01,0.99},
			},			
			install = {
				order = 3,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() E:SetupBui(); E:ToggleConfig(); end,
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
				args = {
					buiStyle = {
						order = 1,
						type = 'toggle',
						name = L['BenikUI Style'],
						desc = L['Show/Hide the decorative bars from UI elements'],
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, color) E.db.bui[ info[#info] ] = color; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
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
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, color) E.db.bui[ info[#info] ] = color; BUI:BuiColorThemes(color); end,
					},
					buiFonts = {
						order = 3,
						type = 'toggle',
						name = L['Force BenikUI fonts'],
						desc = L['Enables BenikUI fonts overriding the default combat and name fonts. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r'],
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, value) E.db.bui[ info[#info] ] = value; value, _, _, _ = GetAddOnInfo('ElvUI_BenikUI_Fonts'); BUI:EnableBuiFonts(); E:StaticPopup_Show('PRIVATE_RL'); end,	
					},
					gameMenuColor = {
						order = 4,
						type = "select",
						name = L['Game Menu Color']..BUI.newsign,
						values = {
							[1] = CLASS_COLORS,
							[2] = CUSTOM,
						},
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, value) E.db.bui[ info[#info] ] = value; end,
					},
					customGameMenuColor = {
						order = 5,
						type = "color",
						name = COLOR_PICKER,
						disabled = function() return E.db.bui.gameMenuColor == 1 end,
						get = function(info)
							local t = E.db.bui[ info[#info] ]
							local d = P.bui[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
						set = function(info, r, g, b)
							E.db.bui[ info[#info] ] = {}
							local t = E.db.bui[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
						end,
					},
				},
			},
			datatexts = {
				order = 6,
				type = 'group',
				name = L['DataTexts'],
				guiInline = true,
				args = {
					chat = {
						order = 1,
						type = 'group',
						name = CHAT,
						guiInline = true,
						args = {
							buiDts = {
								order = 1,
								type = 'toggle',
								name = ENABLE,
								desc = L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'],
								get = function(info) return E.db.bui[ info[#info] ] end,
								set = function(info, value) E.db.bui[ info[#info] ] = value; LO:ToggleChatPanels(); E:GetModule('Chat'):UpdateAnchors(); end,	
							},
							transparentDts = {
								order = 2,
								type = 'toggle',
								name = L['Panel Transparency'],
								disabled = function() return not E.db.bui.buiDts end,
								get = function(info) return E.db.bui[ info[#info] ] end,
								set = function(info, value) E.db.bui[ info[#info] ] = value; E:GetModule('BuiLayout'):ToggleTransparency(); end,	
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
								disabled = function() return not E.db.bui.buiDts end,
								get = function(info) return E.db.bui[ info[#info] ] end,
								set = function(info, value) E.db.bui[ info[#info] ] = value; E:GetModule('Chat'):UpdateAnchors() end,
							},							
						},
					},
					middleDatatext = {
						order = 2,
						type = 'group',
						name = L['Middle'],
						guiInline = true,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = ENABLE,
								get = function(info) return E.db.bui.middleDatatext.enable end,
								set = function(info, value) E.db.bui.middleDatatext.enable = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
							},
							transparency = {
								order = 2,
								type = 'toggle',
								name = L['Panel Transparency'],
								disabled = function() return not E.db.bui.middleDatatext.enable end,
								get = function(info) return E.db.bui.middleDatatext.transparency end,
								set = function(info, value) E.db.bui.middleDatatext.transparency = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
							},
							backdrop = {
								order = 3,
								type = 'toggle',
								name = L['Backdrop'],
								disabled = function() return not E.db.bui.middleDatatext.enable end,
								get = function(info) return E.db.bui.middleDatatext.backdrop end,
								set = function(info, value) E.db.bui.middleDatatext.backdrop = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
							},
							styled = {
								order = 4,
								type = 'toggle',
								name = L['BenikUI Style'],
								disabled = function() return not E.db.bui.middleDatatext.enable end,
								get = function(info) return E.db.bui.middleDatatext.styled end,
								set = function(info, value) E.db.bui.middleDatatext.styled = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
							},
							width = {
								order = 5,
								type = "range",
								name = L["Width"],
								min = 300, max = 1400, step = 1,
								disabled = function() return not E.db.bui.middleDatatext.enable end,
								get = function(info) return E.db.bui.middleDatatext.width end,
								set = function(info, value) E.db.bui.middleDatatext.width = value; E:GetModule('BuiLayout'):MiddleDatatextDimensions(); end,
							},	
							height = {
								order = 6,
								type = "range",
								name = L["Height"],
								min = 10, max = 32, step = 1,
								disabled = function() return not E.db.bui.middleDatatext.enable end,
								get = function(info) return E.db.bui.middleDatatext.height end,
								set = function(info, value) E.db.bui.middleDatatext.height = value; E:GetModule('BuiLayout'):MiddleDatatextDimensions(); end,
							},								
						},
					},
					mail = {
						order = 4,
						type = 'group',
						name = MAIL_LABEL,
						guiInline = true,
						args = {
							toggleMail = {
								order = 1,
								type = 'toggle',
								name = L['Hide Mail Icon'],
								desc = L['Show/Hide Mail Icon on minimap'],
								get = function(info) return E.db.bui[ info[#info] ] end,
								set = function(info, value) E.db.bui[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
							},
						},
					},
					garrison = {
						order = 5,
						type = 'group',
						name = GARRISON_LOCATION_TOOLTIP,
						guiInline = true,
						args = {
							garrisonCurrency = {
								order = 1,
								type = 'toggle',
								name = L['Show Garrison Currency'],
								desc = L['Show/Hide garrison currency on the datatext tooltip'],
								get = function(info) return E.db.bui[ info[#info] ] end,
								set = function(info, value) E.db.bui[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
							},
						},
					},
				},
			},

			config = {
				order = 20,
				type = 'group',
				name = L['Options'],
				childGroups = 'tab',
				args = {},
			},
		},
	}
end

table.insert(E.BuiConfig, buiCore)