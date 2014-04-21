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
		},
	}
end

table.insert(E.BuiConfig, utilsTable)