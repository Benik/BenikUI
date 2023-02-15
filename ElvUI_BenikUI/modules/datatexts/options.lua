local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');

local LO = E:GetModule('Layout')
local BL = BUI:GetModule('Layout')
local DT = E:GetModule('DataTexts')

if E.db.benikui == nil then E.db.benikui = {} end
local tinsert = table.insert

local MAIL_LABEL = MAIL_LABEL

local function Datatexts()
	E.Options.args.benikui.args.datatexts = {
		order = 50,
		type = 'group',
		name = BUI:cOption(L['DataTexts'], "orange"),
		args = {
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
					elvuiOption = {
						order = 10,
						type = "execute",
						name = L['Set Datatext Values'],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "datatexts", "panels") end,
					},
				},
			},
			middle = {
				order = 20,
				type = 'group',
				name = L['Middle'],
				guiInline = true,
				args = {
					elvuiOption = {
						order = 1,
						type = "execute",
						name = L['Set Datatext Values'],
						func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "datatexts", "panels", "BuiMiddleDTPanel") end,
					},
					restore = {
						order = 2,
						type = "execute",
						name = L['Restore Defaults'],
						func = function() BL:CreateMiddlePanel(true) DT:UpdatePanelInfo('BuiMiddleDTPanel') end,
						confirmText = L['Restore Defaults'].."?",
						confirm = true,
					},
				},
			},
			mail = {
				order = 30,
				type = 'group',
				name = MAIL_LABEL,
				guiInline = true,
				args = {
					toggle = {
						order = 1,
						type = 'toggle',
						name = L['Hide Mail Icon'],
						desc = L['Show/Hide Mail Icon on minimap'],
						get = function(info) return E.db.benikui.datatexts.mail[ info[#info] ] end,
						set = function(info, value) E.db.benikui.datatexts.mail[ info[#info] ] = value; DT:ToggleMailFrame() end, --E:StaticPopup_Show('PRIVATE_RL');
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
				disabled = function() return E.db.benikui.general.benikuiStyle ~= true end,
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
	E.Options.args.datatexts.args.panels.args.BuiLeftChatDTPanel.name = BUI.Title..BUI:cOption(L['Left Chat Panel'], "blue")
	E.Options.args.datatexts.args.panels.args.BuiLeftChatDTPanel.order = 1001

	E.Options.args.datatexts.args.panels.args.BuiRightChatDTPanel.name = BUI.Title..BUI:cOption(L['Right Chat Panel'], "blue")
	E.Options.args.datatexts.args.panels.args.BuiRightChatDTPanel.order = 1002

	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.name = BUI.Title..BUI:cOption(L['Middle Panel'], "blue")
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.order = 1003
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.args.panelOptions.args.delete.hidden = true
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.args.panelOptions.args.height.hidden = true
	E.Options.args.datatexts.args.panels.args.BuiMiddleDTPanel.args.panelOptions.args.growth.hidden = true
end

local function initDataTexts()
	PanelLayoutOptions()
	E:CopyTable(E.Options.args.datatexts.args.panels.args.newPanel.args, DTPanelOptions)
	hooksecurefunc(DT, "PanelLayoutOptions", PanelLayoutOptions)
end
tinsert(BUI.Config, initDataTexts)