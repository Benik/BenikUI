local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local BUIC = E:GetModule('BuiCastbar');
local UF = E:GetModule('UnitFrames');

local function ufTable()
	E.Options.args.bui.args.config.args.ufb = {
		order = 10,
		type = 'group',
		name = L['UnitFrames'],
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			eframes = {
				order = 1,
				type = 'group',
				name = L['EmptyBars'],
				guiInline = true,
				get = function(info) return E.db.ufb[ info[#info] ] end,
				set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); UFB:ArrangeTarget(); end,
				args = {
					barshow = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						desc = L['Enable the EmptyBars (Player and Target).'],
					},
					toggleTransparency = {
						order = 2,
						type = 'toggle',
						name = L['Transparent'],
						desc = L['Toggle EmptyBars transparency'],
						get = function(info) return E.db.ufb[ info[#info] ] end,
						disabled = function() return not E.db.ufb.barshow end,
						set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:TogglePlayerBarTransparency(); UFB:ToggleTargetBarTransparency(); end,
					},
					barheight = {
						order = 3,
						type = 'range',
						name = L['Height'],
						desc = L['Change the EmptyBars height (Player and Target).'],
						set = function(info, value) E.db.ufb[ info[#info] ] = value; BUIC:UpdatePlayer(); BUIC:UpdateTarget(); UF:CreateAndUpdateUF('player'); UF:CreateAndUpdateUF('target'); end,
						disabled = function() return not E.db.ufb.barshow end,
						min = 10, max = 50, step = 1,
					},
					threat = {
						order = 4,
						type = 'toggle',
						name = L['Threat on EmptyBars']..BUI.newsign,
						desc = L['Places the threat glow on PlayerBar and TargetBar'],
						get = function(info) return E.db.ufb[ info[#info] ] end,
						disabled = function() return not E.db.ufb.barshow end,
						set = function(info, value) E.db.ufb[ info[#info] ] = value; BUIC:UpdatePlayer(); BUIC:UpdateTarget(); UF:CreateAndUpdateUF('player'); UF:CreateAndUpdateUF('target'); end,
					},
				},
			},
			buibars = {
				order = 2,
				type = 'group',
				name = L['Bars'],
				guiInline = true,
				args = {
					powerstatusbar = {
						type = 'select', dialogControl = 'LSM30_Statusbar',
						order = 1,
						name = L['PowerBar Texture'],
						desc = L['Power statusbar texture.'],
						values = AceGUIWidgetLSMlists.statusbar,
						get = function(info) return E.db.ufb[ info[#info] ] end,				
						set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:Update_PowerStatusBar() end,
					},
				},
			},
			buicastbar = {
				order = 3,
				type = 'group',
				name = L['Castbar'],
				guiInline = true,
				disabled = function() return not E.db.ufb.barshow end,
				get = function(info) return E.db.ufb[ info[#info] ] end,
				set = function(info, value) E.db.ufb[ info[#info] ] = value; BUIC:UpdatePlayer(); BUIC:UpdateTarget(); UF:CreateAndUpdateUF('player'); UF:CreateAndUpdateUF('target'); end,
				args = {
					attachCastbar = {
						order = 1,
						type = 'toggle',
						name = L['Attach on EmptyBars'],
						desc = L['Attaches Player and Target Castbar on the EmptyBars.'],
					},
					castText = {
						order = 2,
						type = 'toggle',
						name = L['Castbar Text'],
						desc = L['Show/Hide the Castbar text.'],
					},
					yOffsetText = {
						order = 3,
						type = 'range',
						name = L['Y Offset'],
						desc = L['Adjust text Y Offset'],
						min = -25, max = 0, step = 1,
					},
					hideText = {
						type = 'toggle',
						order = 4,
						name = L['Hide EmptyBar text'],
						desc = L['Hide any text placed on the EmptyBars, while casting.'],
						set = function(info, value) E.db.ufb[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
table.insert(E.BuiConfig, ufTable)

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.portrait.args.ufb = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.ufb[ info[#info] ] end,
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); end,
		args = {		
			detachPlayerPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.ufb[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
					else
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 15
						E.db.unitframe.units.player.portrait.width = 45
					end
					UF:CreateAndUpdateUF('player')
				end,
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Apply transparency on the portrait backdrop.'],
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Apply shadow under the portrait'],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
			},
			PlayerPortraitWidth = {
				order = 4,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},	
			PlayerPortraitHeight = {
				order = 5,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},
		},
	}
end
table.insert(E.BuiConfig, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.portrait.args.ufb = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.ufb[ info[#info] ] end,
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangeTarget(); end,
		args = {		
			detachTargetPortrait = {
				order = 1,
				type = 'toggle',
				name = L['Detach Portrait'],
				set = function(info, value)
					E.db.ufb[ info[#info] ] = value;
					--Easiest way to properly set new width of various elements on the target frame
					--such as classbar, stagger, power etc. The alternative is to include a lot of code
					--in UFB:ArrangePlayer() to reposition these elements.
					if value == true then
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
					else
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 15
						E.db.unitframe.units.target.portrait.width = 45
					end
					UF:CreateAndUpdateUF('target')
				end,
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			TargetPortraitTransparent = {
				order = 2,
				type = 'toggle',
				name = L['Transparent'],
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			TargetPortraitShadow = {
				order = 3,
				type = 'toggle',
				name = L['Shadow'],
				desc = L['Add shadow under the portrait'],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			getPlayerPortraitSize = {
				order = 4,
				type = 'toggle',
				name = L['Player Size'],
				desc = L['Copy Player portrait width and height'],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			TargetPortraitWidth = {
				order = 5,
				type = 'range',
				name = L['Width'],
				desc = L['Change the detached portrait width'],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},	
			TargetPortraitHeight = {
				order = 6,
				type = 'range',
				name = L['Height'],
				desc = L['Change the detached portrait height'],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},
		},
	}
end
table.insert(E.BuiConfig, ufTargetTable)

local function injectPartyOptions()
	E.Options.args.unitframe.args.party.args.portrait = {
		order = 5,
		type = 'group',
		name = BUI:cOption(L["Portrait"]),
		get = function(info) return E.db.unitframe.units['party']['portrait'][ info[#info] ] end,
		set = function(info, value) E.db.unitframe.units['party']['portrait'][ info[#info] ] = value; UF:CreateAndUpdateHeaderGroup('party') end,
		args = {
			enable = {
				type = 'toggle',
				order = 1,
				name = L["Enable"],
				width = "full",
			},
			width = {
				type = 'range',
				order = 2,
				name = L["Width"],
				min = 15, max = 150, step = 1,
			},
			height = {
				type = 'range',
				order = 3,
				name = BUI:cOption("+ "..L["Height"]),
				min = 0, max = 150, step = 1,
			},							
			overlay = {
				type = 'toggle',
				name = L["Overlay"],
				desc = L["Overlay the healthbar"],
				order = 4,
			},
			rotation = {
				type = 'range',
				name = L["Model Rotation"],
				order = 5,
				min = 0, max = 360, step = 1,
			},
			camDistanceScale = {
				type = 'range',
				name = L["Camera Distance Scale"],
				desc = L["How far away the portrait is from the camera."],
				order = 6,
				min = 0.01, max = 4, step = 0.01,
			},
			style = {
				type = 'select',
				name = L["Style"],
				desc = L["Select the display method of the portrait."],
				order = 7,
				values = {
					['2D'] = L["2D"],
					['3D'] = L["3D"],
				},
			},
			xOffset = {
				order = 8,
				type = "range",
				name = L["xOffset"],
				desc = L["Position the Model horizontally."],
				min = -1, max = 1, step = 0.01,
			},
			yOffset = {
				order = 9,
				type = "range",
				name = L["yOffset"],
				desc = L["Position the Model vertically."],
				min = -1, max = 1, step = 0.01,
			},
			transparent = {
				order = 10,
				type = "toggle",
				name = BUI:cOption(L['Transparent']),
				desc = L['Makes the portrait backdrop transparent'],
				disabled = function() return E.db.unitframe.units.party.portrait.overlay end,
			},
		},
	}
			
	E.Options.args.unitframe.args.party.args.roleIcon.args.xOffset = {
		type = 'range',
		order = 7,
		name = BUI:cOption(L["xOffset"]),
		min = -150, max = 150, step = 1,
	}

	E.Options.args.unitframe.args.party.args.roleIcon.args.yOffset = {
		type = 'range',
		order = 8,
		name = BUI:cOption(L["yOffset"]),
		min = -150, max = 150, step = 1,
	}
end
table.insert(E.BuiConfig, injectPartyOptions)