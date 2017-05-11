local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');

if E.db.benikui == nil then E.db.benikui = {} end
local tinsert = table.insert

local CHAT, ENABLE, MAIL_LABEL, GARRISON_LOCATION_TOOLTIP = CHAT, ENABLE, MAIL_LABEL, GARRISON_LOCATION_TOOLTIP

local function Datatexts()
	E.Options.args.benikui.args.datatexts = {
		order = 9,
		type = 'group',
		name = L['DataTexts'],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(L['DataTexts']),
			},
			chat = {
				order = 2,
				type = 'group',
				name = CHAT,
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						desc = L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'],
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; LO:ToggleChatPanels(); E:GetModule('Chat'):UpdateAnchors(); end,	
					},
					transparent = {
						order = 2,
						type = 'toggle',
						name = L['Panel Transparency'],
						disabled = function() return not E.db.benikui.datatexts.chat.enable end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('BuiLayout'):ToggleTransparency(); end,	
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
						disabled = function() return not E.db.benikui.datatexts.chat.enable end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('Chat'):UpdateAnchors() end,
					},
					styled = {
						order = 4,
						type = 'toggle',
						name = L['BenikUI Style'],
						desc = L['Styles the chat datetexts and buttons only if both chat backdrops are set to "Hide Both".'],
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('BuiLayout'):ChatStyles(); E:GetModule('Layout'):ToggleChatPanels(); E.Chat:PositionChat(true); end,	
					},
					backdrop = {
						order = 5,
						type = 'toggle',
						name = L['Backdrop'],
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('BuiLayout'):ToggleTransparency(); end,	
					},								
				},
			},
			middle = {
				order = 3,
				type = 'group',
				name = L['Middle'],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = ENABLE,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					transparent = {
						order = 2,
						type = 'toggle',
						name = L['Panel Transparency'],
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					backdrop = {
						order = 3,
						type = 'toggle',
						name = L['Backdrop'],
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					styled = {
						order = 4,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return E.db.benikui.datatexts.middle.enable ~= true or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextLayout(); end,	
					},
					width = {
						order = 5,
						type = "range",
						name = L["Width"],
						min = 200, max = 1400, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextDimensions(); end,
					},	
					height = {
						order = 6,
						type = "range",
						name = L["Height"],
						min = 10, max = 32, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:GetModule('BuiLayout'):MiddleDatatextDimensions(); end,
					},								
				},
			},
			mail = {
				order = 4,
				type = 'group',
				name = MAIL_LABEL,
				guiInline = true,
				get = function(info) return E.db.benikui.datatexts.mail[ info[#info] ] end,
				set = function(info, value) E.db.benikui.datatexts.mail[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
				args = {
					toggle = {
						order = 1,
						type = 'toggle',
						name = L['Hide Mail Icon'],
						desc = L['Show/Hide Mail Icon on minimap'],
					},
				},
			},
			garrison = {
				order = 5,
				type = 'group',
				name = GARRISON_LOCATION_TOOLTIP,
				guiInline = true,
				get = function(info) return E.db.benikui.datatexts.garrison[ info[#info] ] end,
				set = function(info, value) E.db.benikui.datatexts.garrison[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
				args = {
					currency = {
						order = 1,
						type = 'toggle',
						name = L['Show Garrison Currency'],
						desc = L['Show/Hide garrison currency on the datatext tooltip'],
					},
					oil = {
						order = 2,
						type = 'toggle',
						name = L['Show Oil'],
						desc = L['Show/Hide oil on the datatext tooltip'],
					},
				},
			},
		},
	}
end
tinsert(BUI.Config, Datatexts)