local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');

local LO = E:GetModule('Layout')
local BL = BUI:GetModule('Layout')
local DT = E:GetModule('DataTexts')

if E.db.benikui == nil then E.db.benikui = {} end
local tinsert = table.insert

local MAIL_LABEL, GARRISON_LOCATION_TOOLTIP =MAIL_LABEL, GARRISON_LOCATION_TOOLTIP

local function Datatexts()
	E.Options.args.benikui.args.datatexts = {
		order = 50,
		type = 'group',
		name = L['DataTexts'],
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(L['DataTexts']),
			},
			chat = {
				order = 10,
				type = 'group',
				name = L["Chat"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						desc = L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'],
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; BL:ToggleBuiDts(); LO:ToggleChatPanels(); end,
					},
					spacer1 = {
						order = 2,
						type = 'description',
						name = '',
					},
					transparent = {
						order = 3,
						type = 'toggle',
						name = L['Panel Transparency'],
						disabled = function() return not E.db.benikui.datatexts.chat.enable end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; BL:ToggleTransparency(); end,
					},
					styled = {
						order = 4,
						type = 'toggle',
						name = L['BenikUI Style'],
						desc = L['Styles the chat datetexts and buttons only if both chat backdrops are set to "Hide Both".'],
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; BL:ChatStyles(); E:GetModule('Layout'):ToggleChatPanels(); E.Chat:PositionChats(); end,
					},
					backdrop = {
						order = 5,
						type = 'toggle',
						name = L['Backdrop'],
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; BL:ToggleTransparency(); end,
					},
					spacer2 = {
						order = 6,
						type = 'description',
						name = '',
					},
					editBoxPosition = {
						order = 7,
						type = 'select',
						name = L['Chat EditBox Position'],
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
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; E:GetModule('Chat'):UpdateEditboxAnchors() end,
					},
					showChatDt = {
						order = 8,
						type = 'select',
						name = L["Visibility"],
						values = {
							['SHOWBOTH'] = L["Show Both"],
							['LEFT'] = L["Left Only"],
							['RIGHT'] = L["Right Only"],
						},
						disabled = function() return E.db.benikui.datatexts.chat.enable ~= true end,
						get = function(info) return E.db.benikui.datatexts.chat[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.chat[ info[#info] ] = value; LO:ToggleChatPanels(); E:GetModule('Chat'):UpdateEditboxAnchors(); end,
					},
				},
			},
			middle = {
				order = 20,
				type = 'group',
				name = L['Middle'],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = L["Enable"],
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; BL:MiddleDatatextLayout(); end,
					},
					numPoints = {
						order = 2,
						type = 'range',
						name = L["Number of DataTexts"],
						min = 1, max = 20, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					spacer1 = {
						order = 3,
						type = 'description',
						name = '',
					},
					transparent = {
						order = 4,
						type = 'toggle',
						name = L['Panel Transparency'],
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; BL:MiddleDatatextLayout(); end,
					},
					backdrop = {
						order = 5,
						type = 'toggle',
						name = L['Backdrop'],
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; BL:MiddleDatatextLayout(); end,
					},
					styled = {
						order = 6,
						type = 'toggle',
						name = L['BenikUI Style'],
						disabled = function() return E.db.benikui.datatexts.middle.enable ~= true or E.db.benikui.general.benikuiStyle ~= true end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; BL:MiddleDatatextLayout(); end,
					},
					spacer2 = {
						order = 7,
						type = 'description',
						name = '',
					},
					width = {
						order = 8,
						type = "range",
						name = L["Width"],
						min = 200, max = E.screenwidth, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; BL:MiddleDatatextDimensions(); end,
					},
					height = {
						order = 9,
						type = "range",
						name = L["Height"],
						min = 10, max = 32, step = 1,
						disabled = function() return not E.db.benikui.datatexts.middle.enable end,
						get = function(info) return E.db.benikui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.middle[ info[#info] ] = value; BL:MiddleDatatextDimensions(); end,
					},
				},
			},
			mail = {
				order = 30,
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
				order = 40,
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

local DTPanelOptions = {
	benikuiGroup = {
		order = 6,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		args = {
			benikuiStyle = {
				order = 1,
				type = 'toggle',
				name = L['BenikUI Style'],
			},
		},
	},
}

local function PanelGroup_Create(panel)
	E:CopyTable(E.Options.args.datatexts.args.panels.args[panel].args.panelOptions.args, DTPanelOptions)
end

local function PanelLayoutOptions()
	for panel in pairs(E.global.datatexts.customPanels) do
		PanelGroup_Create(panel)
	end
end

local function initDataTexts()
	PanelLayoutOptions()
	E:CopyTable(E.Options.args.datatexts.args.panels.args.newPanel.args, DTPanelOptions)
	hooksecurefunc(DT, "PanelLayoutOptions", PanelLayoutOptions)
end
tinsert(BUI.Config, initDataTexts)