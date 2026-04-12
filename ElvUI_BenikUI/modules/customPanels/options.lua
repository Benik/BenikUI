--[[
  File: customPanels/options.lua
  Builds the AceConfig options table for the CustomPanels module.
  Covers panel enabling, style settings, size, title, visibility, and clone/delete.
]]

local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('CustomPanels')
local LSM = E.Libs.LSM
local tinsert = table.insert
local format = format
local pairs = pairs
local ceil = math.ceil

local PanelSetup = {
	name = "",
	cloneName = "",
}

local strataValues = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
}

local positionValues = {
	TOP = L["Top"],
	BOTTOM = L["Bottom"],
}

local colorValues = {
	[1] = L.CLASS_COLORS,
	[2] = CUSTOM,
	[3] = L["Value Color"],
	[4] = DEFAULT,
}

-- Builds options table for each custom panel
local function updateOptions()
	for panelname in pairs(E.db.benikui.panels) do
		E.Options.args.benikui.args.panels.args[panelname] = {
			order = 10,
			name = panelname,
			type = 'group',
			childGroups = 'tab',
			args = {
				delete = {
					order = 1,
					type = 'execute',
					name = DELETE,
					disabled = function()
						return not E.db.benikui.panels[panelname].enable
					end,
					func = function()
						E.PopupDialogs["BUI_Panel_Delete"].OnAccept = function()
							mod:Panel_Delete(panelname)
						end
						E.PopupDialogs["BUI_Panel_Delete"].text = format(
								L["This will delete the Custom Panel named |cff00c0fa%s|r.\nContinue?"],
								panelname
						)
						E:StaticPopup_Show("BUI_Panel_Delete")
					end,
				},
				clone = {
					order = 2,
					type = 'execute',
					name = L["Clone"],
					disabled = function()
						return not E.db.benikui.panels[panelname].enable
					end,
					func = function()
						local noBui = panelname:gsub('BenikUI_', '')
						E.PopupDialogs["BUI_Panel_Clone"].OnAccept = function()
							for object in pairs(E.db.benikui.panels) do
								if object:lower() == PanelSetup.cloneName:lower() then
									E.PopupDialogs["BUI_Panel_Name"].text = format(
											L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."],
											noBui
									)
									E:StaticPopup_Show("BUI_Panel_Name")
									PanelSetup.cloneName = ""
									return
								end
							end
							mod:ClonePanel(panelname, PanelSetup.cloneName)
							updateOptions()
							E.Libs.AceConfigDialog:SelectGroup("ElvUI", "benikui", "panels", PanelSetup.cloneName)
						end
						E.PopupDialogs["BUI_Panel_Clone"].text = format(
								L["Clone the Custom Panel: |cff00c0fa%s|r.\nPlease type the new Name"],
								panelname
						)
						E:StaticPopup_Show("BUI_Panel_Clone", nil, nil, noBui)
					end,
				},
				enable = {
					order = 3,
					type = "toggle",
					name = ENABLE,
					width = 'normal',
					get = function() return E.db.benikui.panels[panelname].enable end,
					set = function(_, value)
						E.db.benikui.panels[panelname].enable = value
						mod:SetupPanels()
					end,
				},

				styleGroup = {
					order = 20,
					name = L["BenikUI Style"],
					type = 'group',
					disabled = function()
						return E.db.benikui.general.benikuiStyle ~= true
								or not E.db.benikui.panels[panelname].enable
					end,
					get = function(info)
						return E.db.benikui.panels[panelname][ info[#info] ]
					end,
					set = function(info, value)
						E.db.benikui.panels[panelname][ info[#info] ] = value
						mod:SetupPanels()
					end,
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
						colorGroup = {
							order = 3,
							name = COLOR,
							type = 'group',
							guiInline = true,
							args = {
								styleColor = {
									order = 1,
									type = "select",
									name = "",
									values = colorValues,
								},
								customStyleColor = {
									order = 2,
									type = "color",
									name = L.COLOR_PICKER,
									disabled = function()
										return E.db.benikui.panels[panelname].styleColor ~= 2
												or E.db.benikui.general.benikuiStyle ~= true
												or not E.db.benikui.panels[panelname].enable
									end,
									get = function(info)
										local t = E.db.benikui.panels[panelname][ info[#info] ]
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.benikui.panels[panelname][ info[#info] ]
										t.r, t.g, t.b, t.a = r, g, b, a
										mod:SetupPanels()
									end,
								},
							},
						},
					},
				},
				generalOptions = {
					order = 30,
					type = 'group',
					name = L["General Panel Options"],
					disabled = function()
						return not E.db.benikui.panels[panelname].enable
					end,
					args = {
						functionalityOptions = {
							order = 1,
							type = 'group',
							name = '',
							guiInline = true,
							args = {
								clickThrough = {
									order = 1,
									type = 'toggle',
									name = L["Click Through"],
									get = function()
										return E.db.benikui.panels[panelname].clickThrough
									end,
									set = function(_, value)
										E.db.benikui.panels[panelname].clickThrough = value
										mod:SetupPanels()
									end,
								},
								tooltip = {
									order = 2,
									name = L["Name Tooltip"],
									desc = L["Enable tooltip to reveal the panel name"],
									type = 'toggle',
									get = function()
										return E.db.benikui.panels[panelname].tooltip
									end,
									set = function(_, value)
										E.db.benikui.panels[panelname].tooltip = value
									end,
								},
								-- Shadow moved here to come right after "tooltip"
								shadow = {
									order = 3,
									type = 'toggle',
									name = L["Shadow"],
									get = function()
										return E.db.benikui.panels[panelname].shadow
									end,
									set = function(_, value)
										E.db.benikui.panels[panelname].shadow = value
										mod:SetupPanels()
									end,
								},
							},
						},
						-- Renamed from "Display Mode" -> "Backdrop"
						Backdrop = {
							order = 2,
							type = 'group',
							name = L["Backdrop"],
							guiInline = true,
							args = {
								BUIOpaque = {
									order = 1,
									type = 'toggle',
									name = BUI.Title .. ": Opaque",
									desc = L["Panel will use opaque style."],
									get = function()
										return E.db.benikui.panels[panelname].opaque
									end,
									set = function(_, value)
										if value then
											E.db.benikui.panels[panelname].opaque = true
											E.db.benikui.panels[panelname].transparent = false
											E.db.benikui.panels[panelname].custom = false
										end
										mod:SetupPanels()
										updateOptions()
									end,
								},
								BUITransparent = {
									order = 2,
									type = 'toggle',
									name = BUI.Title .. ": Transparent",
									desc = L["Panel will use transparent style."],
									get = function()
										return E.db.benikui.panels[panelname].transparent
									end,
									set = function(_, value)
										if value then
											E.db.benikui.panels[panelname].transparent = true
											E.db.benikui.panels[panelname].opaque = false
											E.db.benikui.panels[panelname].custom = false
										end
										mod:SetupPanels()
										updateOptions()
									end,
								},
								custom = {
									order = 3,
									type = 'toggle',
									name = L["Custom"],
									desc = L["Enable custom color for the backdrop."],
									get = function()
										return E.db.benikui.panels[panelname].custom
									end,
									set = function(_, value)
										if value then
											E.db.benikui.panels[panelname].custom = true
											E.db.benikui.panels[panelname].opaque = false
											E.db.benikui.panels[panelname].transparent = false
											if E.db.benikui.panels[panelname].alpha
													== select(4, E.media.backdropfadecolor) then
												E.db.benikui.panels[panelname].alpha = 0.7
											end
										end
										mod:SetupPanels()
										updateOptions()
									end,
								},
								-- Backdrop Color inserted right after 'custom'
								customBackdropColor = {
									order = 4,
									type = 'color',
									name = L["Backdrop Color"],
									desc = L["Set the custom transparency level. (Disabled unless Custom is enabled.)"],
									hasAlpha = true,
									disabled = function()
										return not E.db.benikui.panels[panelname].custom
									end,
									get = function()
										local t = E.db.benikui.panels[panelname].customBackdropColor
										return t.r, t.g, t.b, t.a
									end,
									set = function(_, r, g, b, a)
										local t = E.db.benikui.panels[panelname].customBackdropColor
										t.r, t.g, t.b, t.a = r, g, b, a
										mod:SetupPanels()
									end,
								},
							},
						},
					},
				},
				sizeGroup = {
					order = 40,
					type = 'group',
					name = L["Size and Strata"],
					disabled = function()
						return not E.db.benikui.panels[panelname].enable
					end,
					args = {
						width = {
							order = 11,
							type = "range",
							name = L["Width"],
							min = 2, max = ceil(E.screenWidth), step = 1,
							get = function()
								return E.db.benikui.panels[panelname].width
							end,
							set = function(_, value)
								E.db.benikui.panels[panelname].width = value
								mod:Resize()
							end,
						},
						height = {
							order = 12,
							type = "range",
							name = L["Height"],
							min = 2, max = ceil(E.screenHeight), step = 1,
							get = function()
								return E.db.benikui.panels[panelname].height
							end,
							set = function(_, value)
								E.db.benikui.panels[panelname].height = value
								mod:Resize()
							end,
						},
						strata = {
							order = 13,
							type = 'select',
							name = L["Frame Strata"],
							get = function()
								return E.db.benikui.panels[panelname].strata
							end,
							set = function(_, value)
								E.db.benikui.panels[panelname].strata = value
								mod:SetupPanels()
							end,
							values = strataValues,
						},
					},
				},
				titleGroup = {
					order = 50,
					name = L["Title"],
					type = 'group',
					disabled = function()
						return not E.db.benikui.panels[panelname].enable
					end,
					get = function(info)
						return E.db.benikui.panels[panelname].title[ info[#info] ]
					end,
					set = function(info, value)
						E.db.benikui.panels[panelname].title[ info[#info] ] = value
						mod:UpdatePanelTitle()
					end,
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
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
							end,
							get = function()
								return E.db.benikui.panels[panelname].title.text
							end,
							set = function(_, value)
								E.db.benikui.panels[panelname].title.text = value
								mod:UpdatePanelTitle()
							end,
						},
						position = {
							order = 3,
							type = 'select',
							name = L["Title Bar Position"],
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
							end,
							values = positionValues,
						},
						height = {
							order = 4,
							type = "range",
							name = L["Height"],
							min = 10, max = 30, step = 1,
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
							end,
						},
						textPositionGroup = {
							order = 10,
							name = " ",
							type = 'group',
							guiInline = true,
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
							end,
							get = function(info)
								return E.db.benikui.panels[panelname].title[ info[#info] ]
							end,
							set = function(info, value)
								E.db.benikui.panels[panelname].title[ info[#info] ] = value
								mod:UpdatePanelTitle()
							end,
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
									min = -30, max = 30, step = 1,
								},
							},
						},
						fontGroup = {
							order = 20,
							name = L["Fonts"],
							type = 'group',
							guiInline = true,
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
							end,
							get = function(info)
								return E.db.benikui.panels[panelname].title[ info[#info] ]
							end,
							set = function(info, value)
								E.db.benikui.panels[panelname].title[ info[#info] ] = value
								mod:UpdatePanelTitle()
							end,
							args = {
								useDTfont = {
									order = 1,
									name = L["Use DataTexts font"],
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
									type = 'select',
									dialogControl = 'LSM30_Font',
									order = 4,
									name = L["Font"],
									disabled = function()
										return E.db.benikui.panels[panelname].title.useDTfont
									end,
									values = AceGUIWidgetLSMlists.font,
								},
								fontsize = {
									order = 5,
									name = L["Font Size"],
									disabled = function()
										return E.db.benikui.panels[panelname].title.useDTfont
									end,
									type = 'range',
									min = 6, max = 30, step = 1,
								},
								fontflags = {
									order = 6,
									name = L["Font Outline"],
									disabled = function()
										return E.db.benikui.panels[panelname].title.useDTfont
									end,
									type = 'select',
									values = {
										NONE = L["None"],
										OUTLINE = "OUTLINE",
										MONOCROMEOUTLINE = "MONOCROMEOUTLINE",
										THICKOUTLINE = "THICKOUTLINE",
									},
								},
							},
						},
						textureGroup = {
							order = 30,
							name = L["Texture"],
							type = 'group',
							guiInline = true,
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
							end,
							get = function(info)
								return E.db.benikui.panels[panelname].title[ info[#info] ]
							end,
							set = function(info, value)
								E.db.benikui.panels[panelname].title[ info[#info] ] = value
								mod:UpdatePanelTitle()
							end,
							args = {
								panelTexture = {
									type = 'select',
									dialogControl = 'LSM30_Statusbar',
									order = 1,
									name = L["Texture"],
									values = AceGUIWidgetLSMlists.statusbar,
								},
								panelColor = {
									order = 2,
									type = "color",
									name = L["Texture Color"],
									hasAlpha = true,
									get = function(_)
										local t = E.db.benikui.panels[panelname].title.panelColor
										return t.r, t.g, t.b, t.a
									end,
									set = function(_, r, g, b, a)
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
					order = 60,
					name = L["Visibility"],
					type = 'group',
					disabled = function()
						return not E.db.benikui.panels[panelname].enable
					end,
					args = {
						petHide = {
							order = 1,
							name = L["Hide in Pet Battle"],
							type = 'toggle',
							get = function() return E.db.benikui.panels[panelname].petHide end,
							set = function(_, value)
								E.db.benikui.panels[panelname].petHide = value
								mod:RegisterHide()
							end,
						},
						combatHide = {
							order = 2,
							name = L["Hide In Combat"],
							type = 'toggle',
							get = function() return E.db.benikui.panels[panelname].combatHide end,
							set = function(_, value)
								E.db.benikui.panels[panelname].combatHide = value
							end,
						},
						vehicleHide = {
							order = 3,
							name = L["Hide In Vehicle"],
							type = 'toggle',
							get = function() return E.db.benikui.panels[panelname].vehicleHide end,
							set = function(_, value)
								E.db.benikui.panels[panelname].vehicleHide = value
							end,
						},
						visibility = {
							order = 4,
							type = 'input',
							name = L["Visibility State"],
							desc = L["This works like a macro, you can run different situations to get the panel to show/hide differently.\n Example: '[combat] show;hide'"],
							width = 'full',
							multiline = true,
							get = function() return E.db.benikui.panels[panelname].visibility end,
							set = function(_, value)
								if value and value:match('[\n\r]') then
									value = value:gsub('[\n\r]', '')
								end
								E.db.benikui.panels[panelname].visibility = value
								mod:SetupPanels()
							end,
						},
					},
				},
			},
		}
	end
end

-- Top-level panels group, with a "New Custom Panel" setup
local function panelsTable()
	E.Options.args.benikui.args.panels = {
		type = "group",
		name = BUI:cOption(L['Custom Panels'], "orange"),
		order = 70,
		childGroups = "select",
		args = {
			createButton = {
				order = 1,
				name = L["Create"],
				type = 'execute',
				func = function()
					E.global.benikui.CustomPanels.createButton = not E.global.benikui.CustomPanels.createButton
				end,
			},
			spacerAboveNew = {
				order = 1.5,
				type = 'description',
				name = "\n",
			},
			newPanelGroup = {
				order = 2,
				type = "group",
				guiInline = true,
				name = L["New Custom Panel"],
				hidden = function()
					return not E.global.benikui.CustomPanels.createButton
				end,
				args = {
					name = {
						order = 1,
						type = 'input',
						width = 'double',
						name = L["Name"],
						desc = L["Type a unique name for the new panel. \n|cff00c0faNote: 'BenikUI_' will be added at the beginning, to ensure uniqueness|r"],
						hidden = function()
							return not E.global.benikui.CustomPanels.createButton
						end,
						get = function() return PanelSetup.name end,
						set = function(_, textName)
							local name = 'BenikUI_' .. textName
							for object in pairs(E.db.benikui.panels) do
								if object:lower() == name:lower() then
									E.PopupDialogs["BUI_Panel_Name"].text = format(
											L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."],
											name
									)
									E:StaticPopup_Show("BUI_Panel_Name")
									return
								end
							end
							PanelSetup.name = textName
						end,
					},
					spacer2 = {
						order = 2,
						type = 'description',
						name = ' ',
					},
					add = {
						order = 3,
						name = ADD,
						type = 'execute',
						disabled = function() return PanelSetup.name == "" end,
						hidden = function() return not E.global.benikui.CustomPanels.createButton end,
						func = function()
							mod:InsertPanel(PanelSetup.name)
							mod:UpdatePanels()
							updateOptions()
							E.global.benikui.CustomPanels.createButton = false
							E.Libs.AceConfigDialog:SelectGroup("ElvUI", "benikui", "panels", "BenikUI_" .. PanelSetup.name)
							PanelSetup.name = ""
						end,
					},
				},
			},
		}
	}
	updateOptions()
end

tinsert(BUI.Config, panelsTable)

function mod:Panel_Delete(panel)
	E.Options.args.benikui.args.panels.args[panel] = nil
	E.db.benikui.panels[panel] = nil
	mod:DeletePanel(panel)
	updateOptions()
	E.Libs.AceConfigDialog:SelectGroup("ElvUI", "benikui")
end

local D = E:GetModule('Distributor')
if D.GeneratedKeys.profile.benikui == nil then
	D.GeneratedKeys.profile.benikui = {}
end
D.GeneratedKeys.profile.benikui.panels = true

E.PopupDialogs["BUI_Panel_Delete"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

E.PopupDialogs["BUI_Panel_Name"] = {
	button1 = OKAY,
	OnAccept = E.noop,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

E.PopupDialogs["BUI_Panel_Clone"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	OnShow = function(self)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox:SetText("")
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
		PanelSetup.cloneName = ""
	end,
	OnHide = function(self)
		PanelSetup.cloneName = ""
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
	end,
	EditBoxOnEnterPressed = function(_) E.noop() end,
	EditBoxOnEscapePressed = function(self)
		PanelSetup.cloneName = ""
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		local name = self:GetText()
		PanelSetup.cloneName = "BenikUI_" .. name
	end,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}
