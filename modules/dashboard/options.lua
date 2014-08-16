local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

if E.db.utils == nil then E.db.utils = {} end

-- Defaults
P['utils'] = {
	['enableSystem'] = true,
	['enableTokens'] = true,
	['Scombat'] = false,
	['Tcombat'] = true,
	['dwidth'] = 150,
	['twidth'] = 150,
	['dtfont'] = true,
	['dbfont'] = E.db.datatexts.font,
	['dbfontsize'] = E.db.datatexts.fontSize,
	['dbfontflags'] = E.db.datatexts.fontOutline,
}

local function utilsTable()
	E.Options.args.bui.args.config.args.utils = {
		order = 20,
		type = 'group',
		name = L["Dashboards"],
		args = {
			header = {
				order = 1,
				type = "header",
				name = L['Dashboards'],
			},
			system = {
				order = 2,
				type = 'group',
				name = L["System"],
				guiInline = true,
				args = {
					enableSystem = {
						order = 1,
						type = "toggle",
						name = L['Enable'],
						desc = L["Enable the System Dashboard."],
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,	
					},
					Scombat = {
						order = 2,
						name = L["Combat Hide"],
						desc = L["Show/Hide System Dashboard when in combat"],
						type = 'toggle',
						disabled = function() return not E.db.utils.enableSystem end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:GetModule('BuiDashboard'):EnableDisableCombat(); end,					
					},
					dwidth = {
						order = 3,
						type = "range",
						name = L['Width'],
						desc = L["Change the System Dashboard width."],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.utils.enableSystem end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:GetModule('BuiDashboard'):HolderWidth() end,	
					},
				},
			},
			tokens = {
				order = 3,
				type = 'group',
				name = L["Tokens"],
				guiInline = true,
				args = {
					enableTokens = {
						order = 1,
						type = "toggle",
						name = L['Enable'],
						desc = L["Enable the Tokens Dashboard."],
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,	
					},
					Tcombat = {
						order = 2,
						name = L["Combat Hide"],
						desc = L["Show/Hide Tokens Dashboard when in combat"],
						type = 'toggle',
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:GetModule('BuiTokensDashboard'):EnableDisableCombat(); end,					
					},
					twidth = {
						order = 3,
						type = "range",
						name = L['Width'],
						desc = L["Change the Tokens Dashboard width."],
						min = 120, max = 220, step = 1,
						disabled = function() return not E.db.utils.enableTokens end,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; E:GetModule('BuiTokensDashboard'):UpdateTHolderDimensions() end,	
					},
				},
			},
			font = {
				order = 4,
				type = "group",
				name = L["Fonts"],
				guiInline = true,
				disabled = function() return not E.db.utils.enableSystem and not E.db.utils.enableTokens end,
				get = function(info) return E.db.utils[ info[#info] ] end,
				set = function(info, value) E.db.utils[ info[#info] ] = value; if E.db.utils.enableSystem then E:GetModule('BuiDashboard'):ChangeFont() end; if E.db.utils.enableTokens then E:GetModule('BuiTokensDashboard'):UpdateTokens() end; end,
				args = {
					dtfont = {
						order = 1,
						name = L["Use DataTexts font"],
						type = 'toggle',
						width = "full",
					},
					dbfont = {
						type = "select", dialogControl = 'LSM30_Font',
						order = 2,
						name = L["Font"],
						desc = L["Choose font for both dashboards."],
						disabled = function() return E.db.utils.dtfont end,
						values = AceGUIWidgetLSMlists.font,
					},
					dbfontsize = {
						order = 3,
						name = L["Font Size"],
						desc = L["Set the font size."],
						disabled = function() return E.db.utils.dtfont end,
						type = "range",
						min = 6, max = 22, step = 1,
					},
					dbfontflags = {
						order = 4,
						name = L["Font Outline"],
						disabled = function() return E.db.utils.dtfont end,
						type = 'select',
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
					},
				},
			},
		},
	}
end

table.insert(E.BuiConfig, utilsTable)