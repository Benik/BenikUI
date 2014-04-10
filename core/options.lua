local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');

if E.db.bui == nil then E.db.bui = {} end

-- Defaults
P['bui'] = {
	['installed'] = nil,
	['colorTheme'] = 'Elv',
	['buiDts'] = true,
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
				name = BUI.Title..BUI:cOption(BUI.Version)..L["by Benik (EU-Emerald Dream)"],
			},
			logo = {
				order = 2,
				type = "description",
				name = "",
				image = function() return 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga', 256, 128 end,
			},			
			desc = {
				order = 3,
				type = "description",
				name = L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "]..BUI:cOption(L["light blue color."]),
			},
			desc2 = {
				order = 4,
				type = "description",
				name = BUI:cOption(L["Credits:"])..L[" Elv, Tukz, Blazeflack, Azilroka, Sinaris, Repooc, Darth Predator, Dandruff, ElvUI community"],
			},
			spacer1 = {
				order = 5,
				type = "description",
				name = "",
			},
			install = {
				order = 6,
				type = "execute",
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() E:SetupBui(); E:ToggleConfig(); end,
			},
			spacer2 = {
				order = 7,
				type = "header",
				name = "",
			},
			colorTheme = {
				order = 8,
				type = "select",
				name = L["Color Themes"],
				values = {
					['Elv'] = L['ElvUI'],
					['Diablo'] = L['Diablo'],
					['Hearthstone'] = L['Hearthstone'],
					['Mists'] = L['Mists'],
				},
				get = function(info) return E.db.bui[ info[#info] ] end,
				set = function(info, color) E.db.bui[ info[#info] ] = color; E:SetupBuiColors(color); end,
			},
			buiDts = {
				order = 9,
				type = "toggle",
				name = L["Chat DataTexts"],
				desc = L["Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled"],
				get = function(info) return E.db.bui[ info[#info] ] end,
				set = function(info, value) E.db.bui[ info[#info] ] = value; LO:ToggleChatPanels(); end,	
			},
		},
	}
end

table.insert(E.BuiConfig, buiTable)
