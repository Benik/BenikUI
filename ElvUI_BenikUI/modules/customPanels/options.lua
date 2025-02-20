-- ============================================================================
-- CustomPanels Options for BenikUI (ElvUI addon)
--
-- This file builds the AceConfig options table for the CustomPanels module.
-- It covers panel enabling, style settings (including display mode as radio-
-- like toggles), size, title, visibility, and actions (delete/clone).
-- ============================================================================
local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('CustomPanels')
local LSM = E.Libs.LSM
local tinsert = table.insert

-- Temporary storage for new panel names.
local PanelSetup = {
	name = "",
	cloneName = "",
}

-- Predefined values.
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
local colorValues = {
	[1] = L.CLASS_COLORS,
	[2] = CUSTOM,
	[3] = L['Value Color'],
	[4] = DEFAULT,
}

-- ============================================================================
-- updateOptions
-- Builds the options table for each custom panel.
-- ============================================================================
local function updateOptions()
	for panelname in pairs(E.db.benikui.panels) do
		E.Options.args.benikui.args.panels.args[panelname] = {
			order = 10,
			name = panelname,
			type = 'group',
			args = {
				-- Enable toggle.
				enable = {
					order = 1,
					type = "toggle",
					name = ENABLE,
					width = 'full',
					get = function() return E.db.benikui.panels[panelname].enable end,
					set = function(_, value)
						E.db.benikui.panels[panelname].enable = value
						mod:SetupPanels()
					end,
				},
				-- BenikUI Style Options.
				styleGroup = {
					order = 2,
					name = L["BenikUI Style"],
					type = 'group',
					guiInline = true,
					disabled = function()
						return E.db.benikui.general.benikuiStyle ~= true or not E.db.benikui.panels[panelname].enable
					end,
					get = function(info) return E.db.benikui.panels[panelname][ info[#info] ] end,
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
									set = function(info, r, g, b)
										E.db.benikui.panels[panelname][ info[#info] ] = {}
										local t = E.db.benikui.panels[panelname][ info[#info] ]
										t.r, t.g, t.b, t.a = r, g, b, a
										mod:SetupPanels()
									end,
								},
							},
						},
					},
				},
				-- Spacer.
				spacer1 = {
					order = 3,
					type = 'description',
					name = ' ',
				},
				-- General Panel Options.
				generalOptions = {
					order = 4,
					type = 'group',
					name = 'General Panel Options',
					guiInline = true,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					args = {
						functionalityOptions = {
							order = 1,
							type = 'group',
							name = '',
							guiInline = true,
							width = 'full',
							args = {
								clickThrough = {
									order = 1,
									type = 'toggle',
									name = L["Click Through"],
									get = function() return E.db.benikui.panels[panelname].clickThrough end,
									set = function(_, value)
										E.db.benikui.panels[panelname].clickThrough = value
										mod:SetupPanels()
									end,
								},
							},
						},
						-- Display Mode Options (simulate radio buttons).
						StyleOptions = {
							order = 2,
							type = 'group',
							name = 'Display Mode',
							guiInline = true,
							args = {
								BUIOpaque = {
									order = 1,
									type = 'toggle',
									name = BUI.Title .. ": Opaque",
									desc = "Panel will use opaque style.",
									get = function() return E.db.benikui.panels[panelname].opaque end,
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
									desc = "Panel will use transparent style.",
									get = function() return E.db.benikui.panels[panelname].transparent end,
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
									name = "Custom",
									desc = "Enable custom transparency.",
									get = function() return E.db.benikui.panels[panelname].custom end,
									set = function(_, value)
										if value then
											E.db.benikui.panels[panelname].custom = true
											E.db.benikui.panels[panelname].opaque = false
											E.db.benikui.panels[panelname].transparent = false
											-- Force default alpha of 0.7 if current equals the media default.
											if E.db.benikui.panels[panelname].alpha == select(4, E.media.backdropfadecolor) then
												E.db.benikui.panels[panelname].alpha = 0.7
											end
										end
										mod:SetupPanels()
										updateOptions()
									end,
								},
							},
						},
						-- Spacer between display mode and custom options.
						styleOptionsSpacer = {
							order = 3,
							type = 'description',
							name = "\n",
						},
						-- Custom style options (active only when Custom is enabled).
						customStyleOptions = {
							order = 4,
							type = 'group',
							name = '',
							guiInline = true,
							args = {
								transparency = {
									order = 1,
									type = 'range',
									name = "Transparency",
									desc = "Set the custom transparency level. (Disabled unless Custom is enabled.)",
									min = 0, max = 1, step = 0.01,
									disabled = function() return not E.db.benikui.panels[panelname].custom end,
									get = function() return E.db.benikui.panels[panelname].alpha or 1 end,
									set = function(_, value)
										E.db.benikui.panels[panelname].alpha = value
										mod:SetupPanels()
									end,
								},
								shadow = {
									order = 2,
									type = 'toggle',
									name = L["Shadow"],
									get = function() return E.db.benikui.panels[panelname].shadow end,
									set = function(_, value)
										E.db.benikui.panels[panelname].shadow = value
										mod:SetupPanels()
									end,
								},
							},
						},
					},
				},
				-- Spacer.
				spacer2 = {
					order = 5,
					type = 'description',
					name = ' ',
				},
				-- Size and Strata Options.
				sizeGroup = {
					order = 6,
					type = 'group',
					name = 'Size and Strata',
					guiInline = true,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					args = {
						width = {
							order = 11,
							type = "range",
							name = L['Width'],
							min = 2, max = ceil(E.screenWidth), step = 1,
							get = function() return E.db.benikui.panels[panelname].width end,
							set = function(_, value)
								E.db.benikui.panels[panelname].width = value
								mod:Resize()
							end,
						},
						height = {
							order = 12,
							type = "range",
							name = L['Height'],
							min = 2, max = ceil(E.screenHeight), step = 1,
							get = function() return E.db.benikui.panels[panelname].height end,
							set = function(_, value)
								E.db.benikui.panels[panelname].height = value
								mod:Resize()
							end,
						},
						strata = {
							order = 13,
							type = 'select',
							name = L["Frame Strata"],
							get = function() return E.db.benikui.panels[panelname].strata end,
							set = function(_, value)
								E.db.benikui.panels[panelname].strata = value
								mod:SetupPanels()
							end,
							values = strataValues,
						},
					},
				},
				-- Spacer.
				spacer3 = {
					order = 7,
					type = 'description',
					name = ' ',
				},
				-- Title Options.
				titleGroup = {
					order = 8,
					name = L["Title"],
					type = 'group',
					guiInline = true,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
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
								return not E.db.benikui.panels[panelname].title.enable or not E.db.benikui.panels[panelname].enable
							end,
							get = function() return E.db.benikui.panels[panelname].title.text end,
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
								return not E.db.benikui.panels[panelname].title.enable or not E.db.benikui.panels[panelname].enable
							end,
							values = positionValues,
						},
						height = {
							order = 4,
							type = "range",
							name = L['Height'],
							min = 10, max = 30, step = 1,
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable or not E.db.benikui.panels[panelname].enable
							end,
						},
						textPositionGroup = {
							order = 10,
							name = " ",
							type = 'group',
							guiInline = true,
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable or not E.db.benikui.panels[panelname].enable
							end,
							get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
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
								return not E.db.benikui.panels[panelname].title.enable or not E.db.benikui.panels[panelname].enable
							end,
							get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
							set = function(info, value)
								E.db.benikui.panels[panelname].title[ info[#info] ] = value
								mod:UpdatePanelTitle()
							end,
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
									name = L['Font Size'],
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
										['MONOCROMEOUTLINE'] = 'MONOCROMEOUTLINE',
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
							disabled = function()
								return not E.db.benikui.panels[panelname].title.enable
										or not E.db.benikui.panels[panelname].enable
							end,
							get = function(info) return E.db.benikui.panels[panelname].title[ info[#info] ] end,
							set = function(info, value)
								E.db.benikui.panels[panelname].title[ info[#info] ] = value
								mod:UpdatePanelTitle()
							end,
							args = {
								panelTexture = {
									type = 'select', dialogControl = 'LSM30_Statusbar',
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
				-- Spacer.
				spacer4 = {
					order = 9,
					type = 'description',
					name = ' ',
				},
				-- Visibility Options.
				visibilityGroup = {
					order = 10,
					name = L["Visibility"],
					type = 'group',
					guiInline = true,
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
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
							type = 'input',
							order = 4,
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
				-- Spacer before tooltip.
				spacer5 = {
					order = 11,
					type = 'description',
					name = ' ',
				},
				-- Tooltip toggle.
				tooltip = {
					order = 12,
					name = L["Name Tooltip"],
					desc = L["Enable tooltip to reveal the panel name"],
					type = 'toggle',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					get = function() return E.db.benikui.panels[panelname].tooltip end,
					set = function(_, value)
						E.db.benikui.panels[panelname].tooltip = value
					end,
				},
				-- Header spacer.
				spacer6 = {
					order = 13,
					type = 'header',
					name = '',
				},
				-- Delete and Clone actions.
				delete = {
					order = -1,
					name = DELETE,
					type = 'execute',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					func = function()
						E.PopupDialogs["BUI_Panel_Delete"].OnAccept = function()
							mod:Panel_Delete(panelname)
						end
						E.PopupDialogs["BUI_Panel_Delete"].text = format(L["This will delete the Custom Panel named |cff00c0fa%s|r.\nContinue?"], panelname)
						E:StaticPopup_Show("BUI_Panel_Delete")
					end,
				},
				clone = {
					order = -2,
					name = L["Clone"],
					type = 'execute',
					disabled = function() return not E.db.benikui.panels[panelname].enable end,
					func = function()
						local noBui = panelname:gsub('BenikUI_', '')
						E.PopupDialogs["BUI_Panel_Clone"].OnAccept = function()
							for object in pairs(E.db.benikui.panels) do
								if object:lower() == PanelSetup.cloneName:lower() then
									E.PopupDialogs["BUI_Panel_Name"].text = format(L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."], noBui)
									E:StaticPopup_Show("BUI_Panel_Name")
									PanelSetup.cloneName = nil
									return
								end
							end
							mod:ClonePanel(panelname, PanelSetup.cloneName)
							updateOptions()
							E.Libs.AceConfigDialog:SelectGroup("ElvUI", "benikui")
						end
						E.PopupDialogs["BUI_Panel_Clone"].text = format(L["Clone the Custom Panel: |cff00c0fa%s|r.\nPlease type the new Name"], panelname)
						E:StaticPopup_Show("BUI_Panel_Clone", nil, nil, noBui)
					end,
				},
			},
		}
	end
end

-- ============================================================================
-- panelsTable
-- Builds the top-level options group for custom panels.
-- ============================================================================
local function panelsTable()
	E.Options.args.benikui.args.panels = {
		type = "group",
		name = BUI:cOption(L['Custom Panels'], "orange"),
		order = 70,
		childGroups = "select",
		args = {
			-- Create button toggles the "new panel" input group.
			createButton = {
				order = 1,
				name = L["Create"],
				type = 'execute',
				func = function()
					E.global.benikui.CustomPanels.createButton = not E.global.benikui.CustomPanels.createButton
				end,
			},
			-- Spacer for extra vertical space.
			spacerAboveNew = {
				order = 1.5,
				type = 'description',
				name = "\n",
			},
			-- New Panel Group for entering a panel name.
			newPanelGroup = {
				order = 2,
				type = "group",
				guiInline = true,
				name = L["New Custom Panel"],
				hidden = function() return not E.global.benikui.CustomPanels.createButton end,
				args = {
					name = {
						order = 1,
						type = 'input',
						width = 'double',
						name = L["Name"],
						desc = L["Type a unique name for the new panel. \n|cff00c0faNote: 'BenikUI_' will be added at the beginning, to ensure uniqueness|r"],
						hidden = function() return not E.global.benikui.CustomPanels.createButton end,
						get = function() return PanelSetup.name end,
						set = function(_, textName)
							local name = 'BenikUI_' .. textName
							for object in pairs(E.db.benikui.panels) do
								if object:lower() == name:lower() then
									E.PopupDialogs["BUI_Panel_Name"].text = format(L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."], name)
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

							-- Automatically select the newly created panel:
							E.Libs.AceConfigDialog:SelectGroup("ElvUI", "benikui", "panels", "BenikUI_" .. PanelSetup.name)
							PanelSetup.name = ""
						end,
					},
				},
			},
		},
	}
	updateOptions()
end
tinsert(BUI.Config, panelsTable)

-- ============================================================================
-- Popup Dialogs for deletion, naming, and cloning panels.
-- ============================================================================
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
D.GeneratedKeys.profile.benikui.panels = true -- needed to export the custom panels

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
	OnShow = function(self, _)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox:SetText("")
		self.editBox:HighlightText()
		self.editBox:SetJustifyH("CENTER")
		PanelSetup.cloneName = nil
	end,
	OnHide = function(self)
		PanelSetup.cloneName = nil
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
	end,
	EditBoxOnEnterPressed = function(_)
		E.noop()
	end,
	EditBoxOnEscapePressed = function(self)
		PanelSetup.cloneName = nil
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