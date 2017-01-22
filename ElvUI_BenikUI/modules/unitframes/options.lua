local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local BUIC = E:GetModule('BuiCastbar');
local UF = E:GetModule('UnitFrames');

local tinsert = table.insert
local PLAYER, TARGET, MISCELLANEOUS = PLAYER, TARGET, MISCELLANEOUS

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
		order = 10,
		type = 'group',
		name = L['UnitFrames'],
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(L['UnitFrames']),
			},
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
						get = function(info) return E.db.benikui.unitframes.infoPanel[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.infoPanel[ info[#info] ] = value; UFB:UpdateUF() end,
					},
					color = {
						order = 2,
						type = "color",
						name = COLOR_PICKER,
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
							UFB:InfoPanelColor()
						end,
					},
					texture = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 3,
						name = L['Textures'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.infoPanel[ info[#info] ] end,				
						set = function(info, value) E.db.benikui.unitframes.infoPanel[ info[#info] ] = value; UFB:InfoPanelColor() end,
					},
				},
			},
			textures = {
				order = 4,
				type = 'group',
				name = L['Textures'],
				guiInline = true,
				args = {
					health = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 1,
						name = L['Health'],
						desc = L['Health statusbar texture. Applies only on Group Frames'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,				
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; UFB:ChangeHealthBarTexture() end,
					},
					power = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 2,
						name = L['Power'],
						desc = L['Power statusbar texture.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.textures[ info[#info] ] end,				
						set = function(info, value) E.db.benikui.unitframes.textures[ info[#info] ] = value; UFB:ChangePowerBarTexture() end,
					},
				},
			},
			castbar = {
				order = 5,
				type = 'group',
				name = L['Castbar'].." ("..PLAYER.."/"..TARGET..")",
				guiInline = true,
				get = function(info) return E.db.benikui.unitframes.castbar.text[ info[#info] ] end,
				set = function(info, value) E.db.benikui.unitframes.castbar.text[ info[#info] ] = value; BUIC:UpdateSettings("player"); BUIC:UpdateSettings("target"); end,
				args = {
					ShowInfoText = {
						type = 'toggle',
						order = 1,
						name = L['Show InfoPanel text'],
						desc = L['Force show any text placed on the InfoPanel, while casting.'],
					},
					castText = {
						type = 'toggle',
						order = 2,
						name = L['Show Castbar text'],
					},
					forceTargetText = {
						type = 'toggle',
						order = 3,
						name = L['Show on Target'],
						disabled = function() return E.db.benikui.unitframes.castbar.text.castText end,
					},
					yOffset = {
						order = 4,
						type = 'range',
						name = L['Y Offset'],
						desc = L['Adjust castbar text Y Offset'],
						min = -25, max = 0, step = 1,
					},
					texture = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 5,
						name = L['Textures'],
						desc = L['This applies on all available castbars.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.benikui.unitframes.castbar.text[ info[#info] ] end,				
						set = function(info, value) E.db.benikui.unitframes.castbar.text[ info[#info] ] = value; BUIC:CastBarHooks(); end,
					},
					textColor = {
						order = 6,
						type = "color",
						name = L["Text Color"],
						hasAlpha = true,
						get = function(info)
							local t = E.db.benikui.unitframes.castbar.text[ info[#info] ]
							local d = P.benikui.unitframes.castbar.text[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
						set = function(info, r, g, b, a)
							E.db.benikui.unitframes.castbar.text[ info[#info] ] = {}
							local t = E.db.benikui.unitframes.castbar.text[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							BUIC:CastBarHooks();
						end,
					},
				},
			},
			misc = {
				order = 6,
				type = 'group',
				name = MISCELLANEOUS,
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
					portraitTransparency = {
						order = 2,
						type = 'range',
						name = L['Overlayed Portraits Alpha'],
						isPercent = true,
						min = 0.2, max = 1, step = 0.05,
						get = function(info) return E.db.benikui.unitframes.misc[ info[#info] ] end,
						set = function(info, value) E.db.benikui.unitframes.misc[ info[#info] ] = value; UF:Update_AllFrames(); end,
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, ufTable)

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.portrait.args.benikui = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.player[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.player[ info[#info] ] = value; UFB:ArrangePlayer(); end,
		args = {
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.player[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
						E.db.unitframe.units.player.orientation = "LEFT"
					else
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 15
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
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Apply shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
			},
			portraitWidth = {
				order = 4,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
				min = 10, max = 500, step = 1,
			},	
			portraitHeight = {
				order = 5,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 6,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.player.detachPortrait end,
				values = strataValues,
			},
			styleGroup = {
				order = 7,
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
	
	E.Options.args.unitframe.args.player.args.power.args.vertical = {	
		order = 15,
		type = "toggle",
		name = BUI:cOption(L['Vertical']),
		desc = L['Vertical power statusbar'],
		disabled = function() return not E.db.unitframe.units.player.power.detachFromFrame end,
	}
end
tinsert(BUI.Config, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.portrait.args.benikui = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.target[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.target[ info[#info] ] = value; UFB:ArrangeTarget(); end,
		args = {		
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.target[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
						E.db.unitframe.units.target.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 15
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
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
			},
			getPlayerPortraitSize = {
				order = 4,
				type = 'toggle',
				name = L['Player Size'],
				desc = L['Copy Player portrait width and height'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
			},
			portraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return E.db.benikui.unitframes.target.getPlayerPortraitSize or not E.db.benikui.unitframes.target.detachPortrait end,
				min = 10, max = 500, step = 1,
			},	
			portraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return E.db.benikui.unitframes.target.getPlayerPortraitSize or not E.db.benikui.unitframes.target.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 7,
				type = "select",
				name = L['Frame Strata'],
				disabled = function() return not E.db.benikui.unitframes.target.detachPortrait end,
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
						disabled = function() return not E.db.benikui.general.benikuiStyle or not E.db.benikui.unitframes.target.portraitStyle end,
						min = 4, max = 20, step = 1,
					},
				},
			},
		},
	}

	E.Options.args.unitframe.args.target.args.power.args.vertical = {	
		order = 15,
		type = "toggle",
		name = BUI:cOption(L['Vertical']),
		desc = L['Vertical power statusbar'],
		disabled = function() return not E.db.unitframe.units.target.power.detachFromFrame end,
	}
end
tinsert(BUI.Config, ufTargetTable)

local function ufTargetTargetTable()
	E.Options.args.unitframe.args.targettarget.args.portrait.args.benikui = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.targettarget[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.targettarget[ info[#info] ] = value; UFB:ArrangeTargetTarget(); end,
		args = {		
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.targettarget[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.targettarget.args.portrait.args.width.min = 0
						E.db.unitframe.units.targettarget.portrait.width = 0
						E.db.unitframe.units.targettarget.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.targettarget.args.portrait.args.width.min = 15
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
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.targettarget.detachPortrait end,
			},
			portraitWidth = {
				order = 4,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.targettarget.detachPortrait end,
				min = 10, max = 500, step = 1,
			},	
			portraitHeight = {
				order = 5,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return E.db.benikui.unitframes.targettarget.getPlayerPortraitSize or not E.db.benikui.unitframes.targettarget.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 6,
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
	E.Options.args.unitframe.args.focus.args.portrait.args.benikui = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.focus[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.focus[ info[#info] ] = value; UFB:ArrangeFocus(); end,
		args = {		
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.focus[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.focus.args.portrait.args.width.min = 0
						E.db.unitframe.units.focus.portrait.width = 0
						E.db.unitframe.units.focus.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.focus.args.portrait.args.width.min = 15
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
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
			},
			portraitWidth = {
				order = 4,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
				min = 10, max = 500, step = 1,
			},	
			portraitHeight = {
				order = 5,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.benikui.unitframes.focus.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 6,
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
	E.Options.args.unitframe.args.pet.args.portrait.args.benikui = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.benikui.unitframes.pet[ info[#info] ] end,
		set = function(info, value) E.db.benikui.unitframes.pet[ info[#info] ] = value; UFB:ArrangePet(); end,
		args = {		
			detachPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.benikui.unitframes.pet[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.pet.args.portrait.args.width.min = 0
						E.db.unitframe.units.pet.portrait.width = 0
						E.db.unitframe.units.pet.orientation = "RIGHT"
					else
						E.Options.args.unitframe.args.pet.args.portrait.args.width.min = 15
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
			portraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
			},
			portraitWidth = {
				order = 4,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
				min = 10, max = 500, step = 1,
			},	
			portraitHeight = {
				order = 5,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.benikui.unitframes.pet.detachPortrait end,
				min = 10, max = 250, step = 1,
			},
			portraitFrameStrata = {
				order = 6,
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

	E.Options.args.unitframe.args.party.args.portrait.args.height = {
		type = 'range',
		order = 15,
		name = BUI:cOption("+ "..L["Height"]),
		min = 0, max = 150, step = 1,
	}
	
	E.Options.args.unitframe.args.party.args.portrait.args.transparent = {	
		order = 16,
		type = "toggle",
		name = BUI:cOption(L['Transparent']),
		desc = L['Makes the portrait backdrop transparent'],
		disabled = function() return E.db.unitframe.units.party.portrait.overlay end,
	}
end
tinsert(BUI.Config, injectPartyOptions)

local function injectRaidOptions()
	E.Options.args.unitframe.args.raid.args.general.args.classHover = {	
		order = 7,
		type = "toggle",
		name = BUI:cOption(L['Class Hover']),
		desc = L['Enable Class color on health border, when mouse over'],
		set = function(info, value) E.db.unitframe.units['raid'][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
	}
end
tinsert(BUI.Config, injectRaidOptions)

local function injectRaid40Options()
	E.Options.args.unitframe.args.raid40.args.general.args.classHover = {	
		order = 7,
		type = "toggle",
		name = BUI:cOption(L['Class Hover']),
		desc = L['Enable Class color on health border, when mouse over'],
		set = function(info, value) E.db.unitframe.units['raid40'][ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
	}
end
tinsert(BUI.Config, injectRaid40Options)