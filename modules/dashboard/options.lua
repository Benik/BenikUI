local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BUID = E:GetModule('BuiDashboard')
local BUIT = E:GetModule('BuiTokensDashboard')

if E.db.utils == nil then E.db.utils = {} end

-- Defaults
P['utils'] = {
	['dwidth'] = 150,
	['twidth'] = 150,
	['sameWidth'] = false,
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
			infod = {
				order = 2,
				type = 'group',
				name = L["Width"],
				guiInline = true,
				args = {
					dwidth = {
						order = 1,
						type = "range",
						name = L['System'],
						desc = L["Change the System Dashboard width."],
						min = 120, max = 220, step = 1,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUID:HolderWidth() end,	
					},
					twidth = {
						order = 2,
						type = "range",
						name = L['Tokens'],
						desc = L["Change the Tokens Dashboard width."],
						min = 120, max = 220, step = 1,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUIT:UpdateTHolderDimensions() end,	
					},
				},
			},
		},
	}
end

table.insert(E.BuiConfig, utilsTable)