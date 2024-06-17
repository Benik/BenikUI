local BUI, E, _, V, P, G = unpack((select(2, ...)))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');

local BU = BUI:GetModule('Units');
local BC = BUI:GetModule('Castbar');
local UF = E:GetModule('UnitFrames');

local tinsert = table.insert
local PLAYER, TARGET = PLAYER, TARGET

-- GLOBALS: AceGUIWidgetLSMlists

local strataValues = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	TOOLTIP = "TOOLTIP",
};

local function ufTable()
	E.Options.args.benikui.args.unitframes = {
		order = 40,
		type = 'group',
		name = BUI:cOption(L['UnitFrames'], "orange"),
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			infoPanel = {
				order = 2,
				type = 'group',
				name = L['Information Panel'],
				guiInline = true,
				args = {
					fixInfoPanel = {
						type = 'toggle',
						order = 1,
						name = L['Fix InfoPanel width'],
						desc = L['Lower InfoPanel width when potraits are enabled.'],
						width = "full", 
						get = function(info) return E.db.benikui.unitframes.infoPanel[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.infoPanel[ info[#info] ] = value; BU:UpdateUF() end,
					},
					colors = {
						order = 2,
						type = 'group',
						name = L['Colors'],
						guiInline = true,
						args = {
							enableColor = {
								type = 'toggle',
								order = 1,
								name = L["Enable"],
								width = "full", 
								get = function(info) return E.db.benikui.unitframes.infoPanel[ info[#info] ] end,
								set = function(info, value) E.db.benikui.unitframes.infoPanel[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
							},
							customColor = {
								order = 2,
								type = "select",
								name = format("%s (%s)", L.COLOR, L["Individual Units"]),
								disabled = function() return not E.db.benikui.unitframes.infoPanel.enableColor end,
								values = {
									[1] = L.CLASS_COLORS,
									[2] = L["Custom Color"],
								},
								get = function(info) return E.db.benikui.unitframes.infoPanel[ info[#info] ] end,
								set = function(info, value) E.db.benikui.unitframes.infoPanel[ info[#info] ] = value; BU:UnitInfoPanelColor() end,
							},
							color = {
								order = 3,
								type = "color",
								name = L["Custom Color"],
								hasAlpha = true,
								disabled = function() return E.db.benikui.unitframes.infoPanel.customColor == 1 or not E.db.benikui.unitframes.infoPanel.enableColor end,
								get = function(info)
									local t = E.db.benikui.unitframes.infoPanel[ info[#info] ]
									local d = P.benikui.unitframes.infoPanel[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikui.unitframes.infoPanel[ info[#info] ] = {}
									local t = E.db.benikui.unitframes.infoPanel[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									BU:UnitInfoPanelColor()
								end,
							},
							spacer = {
								order = 4,
								type = 'header',
								name = '',
							},
							groupColor = {
								order = 5,
								type = "color",
								name = format("%s (%s)", L["Custom Color"], L["Group Units"]),
								disabled = function() return not E.db.benikui.unitframes.infoPanel.enableColor end,
								hasAlpha = true,
								get = function(info)
									local t = E.db.benikui.unitframes.infoPanel[ info[#info] ]
									local d = P.benikui.unitframes.infoPanel[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
									end,
								set = function(info, r, g, b, a)
									E.db.benikui.unitframes.infoPanel[ info[#info] ] = {}
									local t = E.db.benikui.unitframes.infoPanel[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									BU:UpdateGroupInfoPanelColor()
								end,
							},
						},
					},
					texture = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 3,
						name = L["Texture"],
						disabled = function() return not E.db.benikui.unitframes.infoPanel.enableColor end,
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.infoPanel[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.infoPanel[ info[#info] ] = value; BU:UnitInfoPanelColor() BU:UpdateGroupInfoPanelColor() end,
					},
				},
			},
			textures = {
				order = 4,
				type = 'group',
				name = L['Textures'],
				guiInline = true,
				args = {
					enableHealth = {
						type = 'toggle',
						order = 1,
						name = L["Enable"],
						--width = "full", 
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL'); end,
					},
					health = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 2,
						name = L['Health'],
						desc = L['Health statusbar texture. Applies only on Group Frames'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; BU:ChangeHealthBarTexture() end,
					},
					ignoreTransparency = {
						type = 'toggle',
						order = 3,
						name = L['Ignore Transparency'],
						desc = L['This will ignore ElvUI Health Transparency setting on all Group Frames.'],
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; UF:Update_AllFrames(); end,
					},
					spacer = {
						order = 4,
						type = 'header',
						name = '',
					},
					enablePower = {
						type = 'toggle',
						order = 5,
						name = L["Enable"],
						--width = "full", 
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL'); end,
					},
					power = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 6,
						name = L['Power'],
						desc = L['Power statusbar texture.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; BU:ChangePowerBarTexture() end,
					},
					spacer2 = {
						order = 7,
						type = 'header',
						name = '',
					},
					enableCastbar = {
						type = 'toggle',
						order = 8,
						name = L["Enable"],
						--width = "full", 
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL'); end,
					},
					castbar = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 9,
						name = L['Castbar'],
						desc = L['This applies on all available castbars.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; BC:CastBarHooks(); end,
					},
				},
			},
			castbarColor = {
				order = 5,
				type = 'group',
				name = L['Castbar Backdrop Color'],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L['This applies on all available castbars.'],
						get = function(info) return E.db.benikui.unitframes.castbarColor[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.castbarColor[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					castbarBackdropColor = {
						type = "color",
						order = 2,
						name = L.COLOR,
						hasAlpha = true,
						disabled = function() return not E.db.benikui.unitframes.castbarColor.enable end,
						get = function(info)
							local t = E.db.benikui.unitframes.castbarColor.castbarBackdropColor
							local d = P.benikui.unitframes.castbarColor.castbarBackdropColor
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							E.db.benikui.unitframes.castbarColor.castbarBackdropColor = {}
							local t = E.db.benikui.unitframes.castbarColor.castbarBackdropColor
							t.r, t.g, t.b, t.a = r, g, b, a;
						end,
					},
				},
			},
			castbar = {
				order = 6,
				type = 'group',
				name = L['Castbar Text'].." ("..PLAYER.."/"..TARGET..")",
				guiInline = true,
				get = function(info) return E.db.benikui.unitframes.castbar.text[ info[#info] ] end,
				set = function(info, value) E.db.benikui.unitframes.castbar.text[ info[#info] ] = value; BC:UpdateAllCastbars(); end,
				args = {
					ShowInfoText = {
						type = 'toggle',
						order = 1,
						name = L['Show InfoPanel text'],
						desc = L['Force show any text placed on the InfoPanel, while casting.'],
					},
				},
			},
			misc = {
				order = 7,
				type = 'group',
				name = L["Miscellaneous"],
				guiInline = true,
				args = {
					svui = {
						order = 1,
						type = 'toggle',
						name = L['SVUI Icons'],
						desc = L['Replaces the default role icons with SVUI ones.'],
						get = function(info) return E.db.benikui.unitframes.misc[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.misc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, ufTable)

local function ufPlayerTable()
	E.Options.args.unitframe.args.individualUnits.args.player.args.portrait.args.benikui = {
		order = 100,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.player[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.player[ info[#info] ] = value; BU:ArrangePlayer(); end,
		args = {
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.player[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.individualUnits.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
						E.db.unitframe.units.player.orientation = "LEFT"
					else
						E.Options.args.unitframe.args.individualUnits.args.player.args.portrait.args.width.min = 15
						E.db.unitframe.units.player.portrait.width = 45
					end
					UF:CreateAndUpdateUF('player')
				end,
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Apply transparency on the portrait backdrop.'],
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			portraitBackdrop = {
				order = 3,
				type = 'toggle',
				name = L['Backdrop'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
			},
			portraitShadow = {
				order = 4,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Apply shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
				min = 10, max = 1000, step = 1,
			},
			portraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
				values = strataValues,
			},
			styleGroup = {
				order = 8,
				type = 'group',
				name = L['BenikUI Style'],
				args = {
					portraitStyle = {
						order = 1,
						type = 'toggle',
						name = L['BenikUI Style on Portrait'],
						disabled = function() return not E.db.benikui.general.benikuiStyle end,
					},
					portraitStyleHeight = {
						order = 2,
						type = 'range',
						name = L['Style Height'],
						disabled = function() return not E.db.benikui.general.benikuiStyle or not E.db.benikui.unitframes.player.portraitStyle end,
						min = 3, max = 20, step = 1,
					},
				},
			},
		},
	}

	E.Options.args.unitframe.args.individualUnits.args.player.args.power.args.vertical = {
		order = 15,
		type = "toggle",
		name = BUI:cOption(L['Vertical'], "blue"),
		desc = L['Vertical power statusbar'],
		disabled = function() return not E.db.unitframe.units.player.power.detachFromFrame end,
	}
end
tinsert(BUI.Config, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.individualUnits.args.target.args.portrait.args.benikui = {
		order = 100,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.target[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.target[ info[#info] ] = value; BU:ArrangeTarget(); end,
		args = {
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.target[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.individualUnits.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
						E.db.unitframe.units.target.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.individualUnits.args.target.args.portrait.args.width.min = 15
						E.db.unitframe.units.target.portrait.width = 45
					end
					UF:CreateAndUpdateUF('target')
				end,
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			portraitBackdrop = {
				order = 3,
				type = 'toggle',
				name = L['Backdrop'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
			},
			portraitShadow = {
				order = 4,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Apply shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
			},
			getPlayerPortraitSize = {
				order = 5,
				type = 'toggle',
				name = L['Player Size'],
				desc = L['Copy Player portrait width and height'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
			},
			portraitWidth = {
				order = 6,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return E.db.benikui.unitframes.target.getPlayerPortraitSize or not E.db.benikui.unitframes.target.detachPortrait end,
				min = 10, max = 1000, step = 1,
			},
			portraitHeight = {
				order = 7,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return E.db.benikui.unitframes.target.getPlayerPortraitSize or not E.db.benikui.unitframes.target.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 8,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
				values = strataValues,
			},
			styleGroup = {
				order = 9,
				type = 'group',
				name = L['BenikUI Style'],
				args = {
					portraitStyle = {
						order = 1,
						type = 'toggle',
						name = L['BenikUI Style on Portrait'],
						disabled = function() return not E.db.benikui.general.benikuiStyle end,
					},
					portraitStyleHeight = {
						order = 2,
						type = 'range',
						name = L['Style Height'],
						disabled = function() return not E.db.benikui.general.benikuiStyle or not E.db.benikui.unitframes.target.portraitStyle end,
						min = 4, max = 20, step = 1,
					},
				},
			},
		},
	}

	E.Options.args.unitframe.args.individualUnits.args.target.args.power.args.vertical = {
		order = 15,
		type = "toggle",
		name = BUI:cOption(L['Vertical'], "blue"),
		desc = L['Vertical power statusbar'],
		disabled = function() return not E.db.unitframe.units.target.power.detachFromFrame end,
	}
end
tinsert(BUI.Config, ufTargetTable)

local function ufTargetTargetTable()
	E.Options.args.unitframe.args.individualUnits.args.targettarget.args.portrait.args.benikui = {
		order = 100,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.targettarget[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.targettarget[ info[#info] ] = value; BU:ArrangeTargetTarget(); end,
		args = {
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.targettarget[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.individualUnits.args.targettarget.args.portrait.args.width.min = 0
						E.db.unitframe.units.targettarget.portrait.width = 0
						E.db.unitframe.units.targettarget.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.individualUnits.args.targettarget.args.portrait.args.width.min = 15
						E.db.unitframe.units.targettarget.portrait.width = 45
						E.db.unitframe.units.targettarget.orientation = "MIDDLE"
					end
					UF:CreateAndUpdateUF('targettarget')
				end,
				disabled = function() return E.db.unitframe.units.targettarget.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.targettarget.portrait.overlay end,
			},
			portraitBackdrop = {
				order = 3,
				type = 'toggle',
				name = L['Backdrop'],
				disabled = function() return not E.db.benikui.unitframes.targettarget.detachPortrait end,
			},
			portraitShadow = {
				order = 4,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.targettarget.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.targettarget.detachPortrait end,
				min = 10, max = 1000, step = 1,
			},
			portraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return E.db.benikui.unitframes.targettarget.getPlayerPortraitSize or not E.db.benikui.unitframes.targettarget.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.targettarget.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(BUI.Config, ufTargetTargetTable)

local function ufFocusTable()
	E.Options.args.unitframe.args.individualUnits.args.focus.args.portrait.args.benikui = {
		order = 100,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.focus[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.focus[ info[#info] ] = value; BU:ArrangeFocus(); end,
		args = {
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.focus[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.individualUnits.args.focus.args.portrait.args.width.min = 0
						E.db.unitframe.units.focus.portrait.width = 0
						E.db.unitframe.units.focus.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.individualUnits.args.focus.args.portrait.args.width.min = 15
						E.db.unitframe.units.focus.portrait.width = 45
						E.db.unitframe.units.focus.orientation = "MIDDLE"
					end
					UF:CreateAndUpdateUF('focus')
				end,
				disabled = function() return E.db.unitframe.units.focus.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.focus.portrait.overlay end,
			},
			portraitBackdrop = {
				order = 3,
				type = 'toggle',
				name = L['Backdrop'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
			},
			portraitShadow = {
				order = 4,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
				min = 10, max = 1000, step = 1,
			},
			portraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(BUI.Config, ufFocusTable)

local function ufPetTable()
	E.Options.args.unitframe.args.individualUnits.args.pet.args.portrait.args.benikui = {
		order = 100,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.pet[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.pet[ info[#info] ] = value; BU:ArrangePet(); end,
		args = {
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.pet[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.individualUnits.args.pet.args.portrait.args.width.min = 0
						E.db.unitframe.units.pet.portrait.width = 0
						E.db.unitframe.units.pet.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.individualUnits.args.pet.args.portrait.args.width.min = 15
						E.db.unitframe.units.pet.portrait.width = 45
						E.db.unitframe.units.pet.orientation = "MIDDLE"
					end
					UF:CreateAndUpdateUF('pet')
				end,
				disabled = function() return E.db.unitframe.units.pet.portrait.overlay end,
			},
			portraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.pet.portrait.overlay end,
			},
			portraitBackdrop = {
				order = 3,
				type = 'toggle',
				name = L['Backdrop'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
			},
			portraitShadow = {
				order = 4,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
				min = 10, max = 1000, step = 1,
			},
			portraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
				values = strataValues,
			},
		},
	}
end
tinsert(BUI.Config, ufPetTable)

local function injectPartyOptions()
	E.Options.args.unitframe.args.groupUnits.args.party.args.portrait.args.height = {
		type = 'range',
		order = 15,
		name = BUI:cOption("+ "..L["Height"], "blue"),
		min = 0, max = 150, step = 1,
	}

	E.Options.args.unitframe.args.groupUnits.args.party.args.portrait.args.transparent = {
		order = 16,
		type = "toggle",
		name = BUI:cOption(L['Transparent'], "blue"),
		desc = L['Makes the portrait backdrop transparent'],
		disabled = function() return E.db.unitframe.units.party.portrait.overlay end,
	}
end
tinsert(BUI.Config, injectPartyOptions)
