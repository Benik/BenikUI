local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BUID = E:GetModule('BuiDashboard')

if E.db.utils == nil then E.db.utils = {} end

-- Defaults
P['utils'] = {
	['dwidth'] = 150,
}

local function utilsTable()
	E.Options.args.bui.args.utils = {
		order = 6,
		type = 'group',
		name = L["Utilities"],
		guiInline = true,
		args = {
			infod = {
				order = 1,
				type = 'group',
				name = L["Dashboard"],
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = SHOW,
						desc = L["Show small buttons over Actionbar 2 decoration, to show/hide Actionbars 3 or 5."],
						--get = function(info) return E.db.bab[ info[#info] ] end,
						--set = function(info, value) E.db.bab[ info[#info] ] = value; BAB:ShowButtons() end,	
					},
					dwidth = {
						order = 1,
						type = "range",
						name = L['Width'],
						desc = L["Show small buttons over Actionbar 2 decoration, to show/hide Actionbars 3 or 5."],
						min = 120, max = 220, step = 1,
						get = function(info) return E.db.utils[ info[#info] ] end,
						set = function(info, value) E.db.utils[ info[#info] ] = value; BUID:HolderWidth() end,	
					},
				},
			},
			infot = {
				order = 2,
				type = 'group',
				name = L["Tokens"],
				guiInline = true,
				args = {
					toks = {
						order = 1,
						type = "toggle",
						name = L["Fart"],
						
						desc = L["Show small buttons over Actionbar 2 decoration, to show/hide Actionbars 3 or 5."],
						--get = function(info) return E.db.bab[ info[#info] ] end,
						--set = function(info, value) E.db.bab[ info[#info] ] = value; BAB:ShowButtons() end,
					},
				},
			},
		},
	}
end

table.insert(E.BuiConfig, utilsTable)