local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

if E.db.bui == nil then E.db.bui = {} end

-- Defaults
P['bui'] = {
	['installed'] = nil,
	['colorTheme'] = 'Elv',
}

local function buiTable()
	E.Options.args.bui = {
		order = 9000,
		type = 'group',
		name = BUI.Title,
		args = {
			name = {
				order = 1,
				type = "header",
				name = L["BenikUI "]..BUI:cOption(BUI.Version)..L["by Benik (EU-Emerald Dream)"],
			},		
			desc = {
				order = 2,
				type = "description",
				name = L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "]..BUI:cOption(L["light blue color."]),
			},
			spacer1 = {
				order = 3,
				type = "description",
				name = "",
			},
			install = {
				order = 4,
				type = "execute",
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() E:SetupBui(); E:ToggleConfig(); end,
			},
			spacer12 = {
				order = 5,
				type = "header",
				name = "",
			},
			colorTheme = {
				order = 6,
				type = "select",
				name = L["Color themes"],
				values = {
					['Elv'] = L['ElvUI'],
					['Diablo'] = L['Diablo'],
					['Hearthstone'] = L['Hearthstone'],
					['Mists'] = L['Mists'],
				},
				get = function(info) return E.db.bui[ info[#info] ] end,
				set = function(info, color) E.db.bui[ info[#info] ] = color; E:SetupBuiColors(color); end,
			},
		},
	}
end

table.insert(E.BuiConfig, buiTable)
