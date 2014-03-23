local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

if E.db.bui == nil then E.db.bui = {} end
if E.db.fbf == nil then E.db.fbf = {} end

-- Defaults
P['bui'] = {
	['installed'] = nil,
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
		},
	}
end

table.insert(E.BuiConfig, buiTable)

-- Defaults
P['fbf'] = {
	['forceBuiFonts'] = true,
}

local function buiGeneralTable()
	E.Options.args.general.args.media.args.fbf = {
		order = 1,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		args = {
			forceBuiFonts = {
				order = 1,
				type = "toggle",
				name = BUI:cOption(L["Force BenikUI fonts"]),
				desc = L["The font that appears on the text above players heads and combat text. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
				get = function(info) return E.db.fbf[ info[#info] ] end,
				set = function(info, value) E.db.fbf[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
		},
	}
end

table.insert(E.BuiConfig, buiGeneralTable)