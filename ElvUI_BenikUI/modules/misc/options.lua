--[[
	BenikUI Miscellaneous Options
	This file sets up the ElvUI config table for various "miscellaneous" features of BenikUI,
	including M's Cursor Tracker (MCT).
--]]

local BUI, E, _, V, P, G = unpack((select(2, ...)))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');

local tinsert = table.insert

-- Creates the configuration table for BenikUI -> Misc
local function miscTable()
	E.Options.args.benikui.args.misc = {
		order = 90,
		type = 'group',
		name = BUI:cOption(L["Miscellaneous"], "orange"),
		args = {
			ilevel = {
				order = 2,
				type = 'group',
				guiInline = true,
				name = L['iLevel'],
				get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
				set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; BUI:GetModule('iLevel'):UpdateItemLevel() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Show item level per slot, on the character info frame'],
						width = "full",
						get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
						set = function(info, value)
							E.db.benikui.misc.ilevel[ info[#info] ] = value
							E:StaticPopup_Show('PRIVATE_RL')
						end,
					},
					font = {
						type = 'select', dialogControl = 'LSM30_Font',
						order = 2,
						name = L['Font'],
						values = AceGUIWidgetLSMlists.font,
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					fontsize = {
						order = 3,
						name = L['Font Size'],
						type = 'range',
						min = 6, max = 22, step = 1,
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					fontflags = {
						order = 4,
						name = L['Font Outline'],
						type = 'select',
						values = E.Config[1].Values.FontFlags,
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					colorStyle = {
						order = 5,
						type = "select",
						name = L.COLOR,
						values = {
							['RARITY'] = L.RARITY,
							['CUSTOM'] = L.CUSTOM,
						},
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					color = {
						order = 6,
						type = "color",
						name = L.COLOR_PICKER,
						disabled = function() return E.db.benikui.misc.ilevel.colorStyle == 'RARITY' or not E.db.benikui.misc.ilevel.enable end,
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
					position = {
						order = 7,
						type = "select",
						name = L["Text Position"],
						values = {
							['INSIDE'] = L['Inside the item slot'],
							['OUTSIDE'] = L['Outside the item slot'],
						},
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
						get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
						set = function(info, value)
							E.db.benikui.misc.ilevel[ info[#info] ] = value
							BUI:GetModule('iLevel'):UpdateItemLevelPosition()
						end,
					},
				},
			},
			flightMode = {
				order = 3,
				type = 'group',
				guiInline = true,
				name = L['Flight Mode'],
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Display the Flight Mode screen when taking flight paths'],
						get = function(info) return E.db.benikui.misc.flightMode[ info[#info] ] end,
						set = function(info, value)
							E.db.benikui.misc.flightMode[ info[#info] ] = value
							BUI:GetModule('FlightMode'):Toggle()
							E:StaticPopup_Show('PRIVATE_RL')
						end,
					},
					logo = {
						order = 2,
						type = 'select',
						name = L['Shown Logo'],
						values = {
							['BENIKUI'] = L['BenikUI'],
							['WOW'] = L['WoW'],
							['NONE'] = NONE,
						},
						disabled = function() return not E.db.benikui.misc.flightMode.enable end,
						get = function(info) return E.db.benikui.misc.flightMode[ info[#info] ] end,
						set = function(info, value)
							E.db.benikui.misc.flightMode[ info[#info] ] = value
							BUI:GetModule('FlightMode'):ToggleLogo()
						end,
					},
				},
			},
			afkModeGroup = {
				order = 4,
				type = 'group',
				guiInline = true,
				name = L['AFK Mode'],
				args = {
					afkMode = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						get = function(info) return E.db.benikui.misc[ info[#info] ] end,
						set = function(info, value)
							E.db.benikui.misc[ info[#info] ] = value
							E:StaticPopup_Show('PRIVATE_RL')
						end,
					},
				},
			},
			mct = {
				order = 5,
				type = 'group',
				name = "|c64A330C9M|r's Cursor Tracker",
				guiInline = true,
				get = function(info)
					return E.db.benikui.misc.mct[ info[#info] ]
				end,
				set = function(info, value)
					E.db.benikui.misc.mct[ info[#info] ] = value
					BUI:GetModule('MCT'):UpdateSettings()
				end,
				args = {
					-- Row 1: M's Defaults + Enable
					defaultsButton = {
						order = 1,
						type = 'execute',
						name = "|c64A330C9M|r's Defaults",
						func = function()
							-- Restore defaults
							local defaults = {
								lockRatio = true,
								width = 15,
								height = 15,
								size = 15,
								strata = "HIGH",
								level = 10,
								color = {r=1, g=1, b=1, a=1},
								inwardsRotation = true,
								outwardsRotation = false,
								direction = "Down",
							}
							for k, v in pairs(defaults) do
								E.db.benikui.misc.mct[k] = v
							end
							BUI:GetModule('MCT'):UpdateSettings()
						end,
					},
					enable = {
						order = 2,
						type = 'toggle',
						name = "Enable",
						desc = "Master toggle for M's Cursor Tracker.",
					},
					spacer1 = {
						order = 3,
						type = 'description',
						name = '',
					},

					-- Row 2: Size group
					sizeGroup = {
						order = 4,
						type = 'group',
						guiInline = true,
						name = "Size",
						args = {
							-- If Lock Ratio is ON, show Size slider and Lock Ratio toggle
							-- If OFF, show Width, Height, Lock Ratio
							size = {
								order = 1,
								type = 'range',
								name = "Size",
								desc = "Overall arrow size (square) if Lock Ratio is on.",
								min = 1, max = 200, step = 1,
								hidden = function() return not E.db.benikui.misc.mct.lockRatio end,
							},
							width = {
								order = 1,
								type = 'range',
								name = "Width",
								desc = "Arrow width if Lock Ratio is off.",
								min = 1, max = 200, step = 1,
								hidden = function() return E.db.benikui.misc.mct.lockRatio end,
							},
							height = {
								order = 2,
								type = 'range',
								name = "Height",
								desc = "Arrow height if Lock Ratio is off.",
								min = 1, max = 200, step = 1,
								hidden = function() return E.db.benikui.misc.mct.lockRatio end,
							},
							lockRatio = {
								order = function()
									-- If lockRatio is off, we want this to come third (below width & height)
									-- If on, it can come second (below size)
									return E.db.benikui.misc.mct.lockRatio and 2 or 3
								end,
								type = 'toggle',
								name = "Lock Ratio",
								desc = "Force a square arrow. When ON, only a single size slider is shown.",
							},
						},
					},

					-- Row 3: Strata group
					strataGroup = {
						order = 5,
						type = 'group',
						guiInline = true,
						name = "Strata",
						args = {
							strata = {
								order = 1,
								type = 'select',
								name = "Frame Strata",
								desc = "The frame layer (strata) the arrow will be placed on.",
								values = {
									["BACKGROUND"] = "BACKGROUND",
									["LOW"] = "LOW",
									["MEDIUM"] = "MEDIUM",
									["HIGH"] = "HIGH",
									["DIALOG"] = "DIALOG",
									["FULLSCREEN"] = "FULLSCREEN",
									["FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG",
									["TOOLTIP"] = "TOOLTIP",
								},
							},
							level = {
								order = 2,
								type = 'range',
								name = "Strata Level",
								desc = "Within the Strata, the level determines the draw order (higher = on top).",
								min = 0, max = 50, step = 1,
							},
						},
					},

					-- Row 4: Arrow Options group
					arrowOptionsGroup = {
						order = 6,
						type = 'group',
						guiInline = true,
						name = "Arrow Options",
						args = {
							-- First row: Direction, Inwards, Outwards
							direction = {
								order = 1,
								type = 'select',
								name = "Arrow Direction",
								desc = "Select a fixed direction when the rotation toggles are off.",
								values = {
									["Up"]    = "Up",
									["Down"]  = "Down",
									["Left"]  = "Left",
									["Right"] = "Right",
								},
								disabled = function()
									return E.db.benikui.misc.mct.inwardsRotation or E.db.benikui.misc.mct.outwardsRotation
								end,
							},
							inwardsRotation = {
								order = 2,
								type = 'toggle',
								name = "Inwards Rotation",
								desc = "Arrow points away from the center.",
								set = function(info, value)
									E.db.benikui.misc.mct.inwardsRotation = value
									if value then
										E.db.benikui.misc.mct.outwardsRotation = false
									end
									BUI:GetModule('MCT'):UpdateSettings()
								end,
							},
							outwardsRotation = {
								order = 3,
								type = 'toggle',
								name = "Outwards Rotation",
								desc = "Arrow points toward the center.",
								set = function(info, value)
									E.db.benikui.misc.mct.outwardsRotation = value
									if value then
										E.db.benikui.misc.mct.inwardsRotation = false
									end
									BUI:GetModule('MCT'):UpdateSettings()
								end,
							},
							spacer1 = {
								order = 4,
								type = 'description',
								name = '',
							},
							color = {
								order = 5,
								type = 'color',
								name = "Arrow Color",
								desc = "Set the arrow's texture color, including alpha.",
								hasAlpha = true,
								get = function(info)
									local c = E.db.benikui.misc.mct.color
									return c.r, c.g, c.b, c.a
								end,
								set = function(info, r, g, b, a)
									local c = E.db.benikui.misc.mct.color
									c.r, c.g, c.b, c.a = r, g, b, a
									BUI:GetModule('MCT'):UpdateSettings()
								end,
							},
						},
					},
				},
			},
		},
	}
end

tinsert(BUI.Config, miscTable)
