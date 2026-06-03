local BUI, E, _, V, P, G = unpack((select(2, ...)))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');

local tinsert = table.insert
local CH = E:GetModule('Chat')

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
						set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
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
						set = function(info, value) E.db.benikui.misc.ilevel[ info[#info] ] = value; BUI:GetModule('iLevel'):UpdateItemLevelPosition() end,
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
						set = function(info, value) E.db.benikui.misc.flightMode[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
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
						set = function(info, value) E.db.benikui.misc.flightMode[ info[#info] ] = value; BUI:GetModule('FlightMode'):ToggleLogo() end,
					},
				},
			},
			editBoxGroup = {
				order = 4,
				type = 'group',
				guiInline = true,
				name = L['Chat EditBox'],
				args = {
					editBoxPosition = {
						order = 1,
						type = 'select',
						name = L['Position'],
						desc = L['Position of the Chat EditBox, if datatexts are disabled this will be forced to be above chat.'],
						values = {
							['BELOW_CHAT'] = L['Below Chat'],
							['ABOVE_CHAT'] = L['Above Chat'],
							['MIDDLE_DT'] = L['Middle Datatext'],
							['EAB_1'] = L['Actionbar 1'],
							['EAB_2'] = L['Actionbar 2'],
						},
						disabled = function() return not E.db.benikui.datatexts.chat.enable end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; CH:UpdateEditboxAnchors() end,
					},
				},
			},
			afkModeGroup = {
				order = 5,
				type = 'group',
				guiInline = true,
				name = L['AFK Mode'],
				args = {
					afkMode = {
						order = 1,
						type = 'toggle',
						name = L['Enable'],
						get = function(info) return E.db.benikui.misc[ info[#info] ] end,
						set = function(info, value) E.db.benikui.misc[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, miscTable)
