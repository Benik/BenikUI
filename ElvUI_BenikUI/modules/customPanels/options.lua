local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local mod = BUI:GetModule('CustomPanels');

local tinsert = table.insert

local PanelSetup = {
	['name'] = "",
}

local strataValues = {
	["BACKGROUND"] = "BACKGROUND",
	["LOW"] = "LOW",
	["MEDIUM"] = "MEDIUM",
	["HIGH"] = "HIGH",
	["DIALOG"] = "DIALOG",
	["TOOLTIP"] = "TOOLTIP",
}

local positionValues = {
	TOP = L["Top"],
	BOTTOM = L["Bottom"],
}

local function updateOptions()
	for panelname in pairs(E.db.benikui.panels) do
		E.Options.args.benikui.args.panels.args[panelname] = {
			order = 10,
			name = panelname,
			type = 'group',
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = ENABLE,
					width = 'full',
					get = function(info) return E.db.benikui.panels[panelname].enable end,
					set = function(info, value) E.db.benikui.panels[panelname].enable = value; mod:SetupPanels() end,
				},
				styleGroup = {
					order = 2,
					name = L["BenikUI Style"],
					type = 'group',
					guiInline = true,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info) return E.db.benikui.panels[panelname][ info[#info] ] end,
					set = function(info, value) E.db.benikui.panels[panelname][ info[#info] ] = value; mod:SetupPanels() end,
					args = {
						style = {
							order = 1,
							type = "toggle",
							name = SHOW,
						},
						stylePosition = {
							order = 2,
							type = 'select',
							name = L["Style Position"],
							values = positionValues,
						},
					},
				},
				generalOptions = {
					order = 3,
					type = 'multiselect',
					name = '',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(_, key) return E.db.benikui.panels[panelname][key] end,
					set = function(_, key, value) E.db.benikui.panels[panelname][key] = value; mod:SetupPanels() end,
					values = {
						transparency = L["Panel Transparency"],
						shadow = L["Shadow"],
						clickThrough = L["Click Through"],
					}
				},
				width = {
					order = 11,
					type = "range",
					name = L['Width'],
					min = 2, max = E.screenwidth, step = 1,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info, value) return E.db.benikui.panels[panelname].width end,
					set = function(info, value) E.db.benikui.panels[panelname].width = value; mod:Resize() end,
				},
				height = {
					order = 12,
					type = "range",
					name = L['Height'],
					min = 2, max = E.screenheight, step = 1,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info, value) return E.db.benikui.panels[panelname].height end,
					set = function(info, value) E.db.benikui.panels[panelname].height = value; mod:Resize() end,
				},
				strata = {
					order = 13,
					type = 'select',
					name = L["Frame Strata"],
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info) return E.db.benikui.panels[panelname].strata end,
					set = function(info, value) E.db.benikui.panels[panelname].strata = value; mod:SetupPanels() end,
					values = strataValues,
				},
				spacer2 = {
					order = 20,
					type = 'description',
					name = ' ',
				},
				titleGroup = {
					order = 21,
					name = L["Title"],
					type = 'group',
					guiInline = true,
					get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
					set = function(info, value) E.db.benikui.panels[panelname].title[ info[#info] ] = value; mod:UpdatePanelTitle() end,
					args = {
						enable = {
							order = 1,
							type = "toggle",
							name = ENABLE,
							width = 'full',
						},
						name = {
							order = 2,
							type = 'input',
							name = L["Name"],
							get = function(info) return E.db.benikui.panels[panelname].title.text end,
							set = function(info, value)
								E.db.benikui.panels[panelname].title.text = value; mod:UpdatePanelTitle()
							end,
						},
						position = {
							order = 3,
							type = 'select',
							name = L["Title Bar Position"],
							disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
							values = positionValues,
						},
						height = {
							order = 4,
							type = "range",
							name = L['Height'],
							min = 10, max = 30, step = 1,
							disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
						},
						textPositionGroup = {
							order = 10,
							name = " ",
							type = 'group',
							guiInline = true,
							disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
							get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
							set = function(info, value) E.db.benikui.panels[panelname].title[ info[#info] ] = value; mod:UpdatePanelTitle() end,
							args = {
								textPosition = {
									order = 1,
									type = 'select',
									name = L["Title Text Position"],
									values = {
										LEFT = L["Left"],
										RIGHT = L["Right"],
										CENTER = L["Center"],
									},
								},
								textXoffset = {
									order = 2,
									type = "range",
									name = L["X-Offset"],
									min = -30, max = 30, step = 1,
								},
								textYoffset = {
									order = 3,
									type = "range",
									name = L["Y-Offset"],
									min = 1-30, max = 30, step = 1,
								},
							},
						},
						fontGroup = {
							order = 20,
							name = L["Fonts"],
							type = 'group',
							guiInline = true,
							disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
							get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
							set = function(info, value) E.db.benikui.panels[panelname].title[ info[#info] ] = value; mod:UpdatePanelTitle() end,
							args = {
								useDTfont = {
									order = 1,
									name = L['Use DataTexts font'],
									type = 'toggle',
								},
								fontColor = {
									order = 2,
									type = "color",
									name = L.COLOR_PICKER,
									get = function(info)
										local t = E.db.benikui.panels[panelname].title[ info[#info] ]
										return t.r, t.g, t.b
										end,
									set = function(info, r, g, b)
										E.db.benikui.panels[panelname].title[ info[#info] ] = {}
										local t = E.db.benikui.panels[panelname].title[ info[#info] ]
										t.r, t.g, t.b = r, g, b
										mod:UpdatePanelTitle()
									end,
								},
								spacer = {
									order = 3,
									type = 'description',
									name = '',
								},
								font = {
									type = 'select', dialogControl = 'LSM30_Font',
									order = 4,
									name = L['Font'],
									disabled = function() return E.db.benikui.panels[panelname].title.useDTfont end,
									values = AceGUIWidgetLSMlists.font,
								},
								fontsize = {
									order = 5,
									name = L.FONT_SIZE,
									disabled = function() return E.db.benikui.panels[panelname].title.useDTfont end,
									type = 'range',
									min = 6, max = 30, step = 1,
								},
								fontflags = {
									order = 6,
									name = L['Font Outline'],
									disabled = function() return E.db.benikui.panels[panelname].title.useDTfont end,
									type = 'select',
									values = {
										['NONE'] = L['None'],
										['OUTLINE'] = 'OUTLINE',
										['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
										['THICKOUTLINE'] = 'THICKOUTLINE',
									},
								},
							},
						},
						textureGroup = {
							order = 30,
							name = L["Texture"],
							type = 'group',
							guiInline = true,
							disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
							get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
							set = function(info, value) E.db.benikui.panels[panelname].title[ info[#info] ] = value; mod:UpdatePanelTitle() end,
							args = {
								panelTexture = {
									type = 'select', dialogControl = 'LSM30_Statusbar',
									order = 1,
									name = L["Texture"],
									disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
									values = AceGUIWidgetLSMlists.statusbar,
								},
								panelColor = {
									order = 2,
									type = "color",
									name = L["Texture Color"],
									disabled = function() return not E.db.benikui.panels[panelname].title.enable end,
									hasAlpha = true,
									get = function(info)
										local t = E.db.benikui.panels[panelname].title.panelColor
										return t.r, t.g, t.b, t.a
										end,
									set = function(info, r, g, b, a)
										E.db.benikui.panels[panelname].title.panelColor = {}
										local t = E.db.benikui.panels[panelname].title.panelColor
										t.r, t.g, t.b, t.a = r, g, b, a
										mod:UpdatePanelTitle()
									end,
								},
							},
						},
					},
				},
				visibilityGroup = {
					order = 25,
					name = L["Visibility"],
					type = 'group',
					guiInline = true,
					args = {
						petHide = {
							order = 1,
							name = L["Hide in Pet Battle"],
							type = 'toggle',
							disabled = function() return not E.db.benikui.panels[panelname].enable end,
							get = function() return E.db.benikui.panels[panelname].petHide end,
							set = function(info, value) E.db.benikui.panels[panelname].petHide = value; mod:RegisterHide() end,
						},
						combatHide = {
							order = 2,
							name = L["Hide In Combat"],
							type = 'toggle',
							disabled = function() return not E.db.benikui.panels[panelname].enable end,
							get = function() return E.db.benikui.panels[panelname].combatHide end,
							set = function(info, value) E.db.benikui.panels[panelname].combatHide = value; end,
						},
						vehicleHide = {
							order = 3,
							name = L["Hide In Vehicle"],
							type = 'toggle',
							disabled = function() return not E.db.benikui.panels[panelname].enable end,
							get = function() return E.db.benikui.panels[panelname].vehicleHide end,
							set = function(info, value) E.db.benikui.panels[panelname].vehicleHide = value; end,
						},
						visibility = {
							type = 'input',
							order = 4,
							name = L["Visibility State"],
							desc = L["This works like a macro, you can run different situations to get the panel to show/hide differently.\n Example: '[combat] show;hide'"],
							width = 'full',
							disabled = function() return not E.db.benikui.panels[panelname].enable end,
							multiline = true,
							get = function() return E.db.benikui.panels[panelname].visibility end,
							set = function(info, value)
								if value and value:match('[\n\r]') then
									value = value:gsub('[\n\r]','')
								end
								E.db.benikui.panels[panelname].visibility = value;
								mod:SetupPanels()
							end,
						},
					},
				},
				spacer4 = {
					order = 30,
					type = 'description',
					name = ' ',
				},
				tooltip = {
					order = 31,
					name = L["Name Tooltip"],
					desc = L["Enable tooltip to reveal the panel name"],
					type = 'toggle',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function() return E.db.benikui.panels[panelname].tooltip end,
					set = function(info, value) E.db.benikui.panels[panelname].tooltip = value; end,
				},
				spacer5 = {
					order = 40,
					type = 'header',
					name = '',
				},
				delete = {
					order = 41,
					name = DELETE,
					type = 'execute',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					func = function()
						E.PopupDialogs["BUI_Panel_Delete"].OnAccept = function() mod:DeletePanel(panelname) end
						E.PopupDialogs["BUI_Panel_Delete"].text = (format(L["This will delete the Custom Panel named |cff00c0fa%s|r. This action will require a reload.\nContinue?"], panelname))
						E:StaticPopup_Show("BUI_Panel_Delete")
					end,
				},
			},
		}
	end
end

local function panelsTable()
	E.Options.args.benikui.args.panels = {
		type = "group",
		name = BUI:cOption(L["Custom Panels"], "blue"),
		order = 70,
		childGroups = "select",
		args = {
			createButton = {
				order = 1,
				name = L["Create"],
				type = 'execute',
				func = function()
					if E.global.benikui.CustomPanels.createButton == true then
						E.global.benikui.CustomPanels.createButton = false
					else
						E.global.benikui.CustomPanels.createButton = true
					end
				end,
			},
			spacer1 = {
				order = 2,
				type = 'description',
				name = ' ',
			},
			name = {
				order = 3,
				type = 'input',
				width = 'double',
				name = L["Name"],
				desc = L["Type a unique name for the new panel. \n|cff00c0faNote: 'BenikUI_' will be added at the beginning, to ensure uniqueness|r"],
				hidden = function() return not E.global.benikui.CustomPanels.createButton end,
				get = function(info) return PanelSetup.name end,
				set = function(info, textName)
					local name = 'BenikUI_'..textName
					for object in pairs(E.db.benikui.panels) do
						if object:lower() == name:lower() then
							E.PopupDialogs["BUI_Panel_Name"].text = (format(L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."], name))
							E:StaticPopup_Show("BUI_Panel_Name")
							return
						end
					end
					PanelSetup.name = textName
				end,
			},
			spacer2 = {
				order = 4,
				type = 'description',
				name = ' ',
			},
			add = {
				order = 5,
				name = ADD,
				type = 'execute',
				disabled = function() return PanelSetup.name == "" end,
				hidden = function() return not E.global.benikui.CustomPanels.createButton end,
				func = function()
					mod:InsertPanel(PanelSetup.name)
					mod:UpdatePanels()
					updateOptions()
					E.global.benikui.CustomPanels.createButton = false;
				end,
			},
			spacer3 = {
				order = 6,
				type = 'description',
				name = ' ',
			},
		},
	}
	
	updateOptions()
end
tinsert(BUI.Config, panelsTable)

local D = E:GetModule('Distributor')
if D.GeneratedKeys.profile.benikui == nil then D.GeneratedKeys.profile.benikui = {} end
D.GeneratedKeys.profile.benikui.panels = true -- needed to export the custom panels

E.PopupDialogs["BUI_Panel_Delete"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["BUI_Panel_Name"] = {
	button1 = OKAY,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}