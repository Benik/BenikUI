local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local B = E:GetModule('Bags')

local tinsert = table.insert

local RARITY, COLOR, CUSTOM = RARITY, COLOR, CUSTOM

local function miscTable()
	E.Options.args.benikui.args.misc = {
		order = 35,
		type = 'group',
		name = MISCELLANEOUS,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(MISCELLANEOUS),
			},
			flightMode = {
				order = 2,
				type = 'group',
				guiInline = true,
				name = L['Flight Mode'],
				get = function(info) return E.db.benikui.misc.flightMode[ info[#info] ] end,
				set = function(info, value) E.db.benikui.misc.flightMode[ info[#info] ] = value; E:GetModule('BUIFlightMode'):Toggle() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						desc = L['Display the Flight Mode screen when taking flight paths'],
					},
					cameraRotation = {
						order = 2,
						type = 'toggle',
						name = L['Camera rotation'],
						disabled = function() return not E.db.benikui.misc.flightMode.enable end,
					},
				},
			},
			ilevel = {
				order = 3,
				type = 'group',
				guiInline = true,
				name = L['iLevel'],
				get = function(info) return E.db.benikui.misc.ilevel[ info[#info] ] end,
				set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; E:GetModule('BUIiLevel'):UpdateItemLevel() end,
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
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					fontsize = {
						order = 3,
						name = FONT_SIZE,
						type = 'range',
						min = 6, max = 22, step = 1,
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
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
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					colorStyle = {
						order = 5,
						type = "select",
						name = COLOR,
						values = {
							['RARITY'] = RARITY,
							['CUSTOM'] = CUSTOM,
						},
						disabled = function() return not E.db.benikui.misc.ilevel.enable end,
					},
					color = {
						order = 6,
						type = "color",
						name = COLOR_PICKER,
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
						set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; E:GetModule('BUIiLevel'):UpdateItemLevelPosition() end,
					},
				},
			},
			panels = {
				order = 4,
				type = 'group',
				guiInline = true,
				name = L['Panels'],
				args = {
					top = {
						order = 1,
						type = 'group',
						guiInline = true,
						name = L['Top Panel'],
						get = function(info) return E.db.benikui.misc.panels.top[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc.panels.top[ info[#info] ] = value; E:GetModule('BuiLayout'):TopPanelLayout() end,
						args = {
							style = {
								order = 1,
								type = 'toggle',
								name = L['BenikUI Style'],
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
							},
							transparency = {
								order = 2,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							height = {
								order = 3,
								type = "range",
								name = L["Height"],
								min = 8, max = 60, step = 1,
							},
						},
					},
					bottom = {
						order = 2,
						type = 'group',
						guiInline = true,
						name = L['Bottom Panel'],
						get = function(info) return E.db.benikui.misc.panels.bottom[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc.panels.bottom[ info[#info] ] = value; E:GetModule('BuiLayout'):BottomPanelLayout() end,
						args = {
							style = {
								order = 1,
								type = 'toggle',
								name = L['BenikUI Style'],
								disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
							},
							transparency = {
								order = 2,
								type = 'toggle',
								name = L['Panel Transparency'],
							},
							height = {
								order = 3,
								type = "range",
								name = L["Height"],
								min = 8, max = 60, step = 1,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, miscTable)

local positionValues = {
	TOPLEFT = 'TOPLEFT',
	LEFT = 'LEFT',
	BOTTOMLEFT = 'BOTTOMLEFT',
	RIGHT = 'RIGHT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	BOTTOM = 'BOTTOM',
}

local function injectBagOptions()
	E.Options.args.bags.args.general.args.countGroup.args.countPosition = {
		type = 'select',
		order = 5,
		name = BUI:cOption(L["Position"]),
		values = positionValues,
		set = function(info, value) E.db.bags.countPosition = value; B:UpdateCountDisplay() end,
	}
end
tinsert(BUI.Config, injectBagOptions)