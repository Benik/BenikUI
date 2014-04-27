local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local LO = E:GetModule('Layout');

if E.db.bui == nil then E.db.bui = {} end

-- Defaults
P['bui'] = {
	['installed'] = nil,
	['colorTheme'] = 'Elv',
	['buiDts'] = true,
	['buiFonts'] = true,
	['transparentDts'] = false,
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
				name = L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "]..BUI:cOption(L["light blue color."].."\n\n"..BUI:cOption(L["Credits:"])..L[" Elv, Tukz, Blazeflack, Azilroka, Sinaris, Repooc, Darth Predator, Dandruff, ElvUI community"]),
				fontSize = "medium",
				image = function() return 'Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga', 192, 96 end,
				imageCoords = {0.09,0.99,0.01,0.99},
			},			
			install = {
				order = 3,
				type = "execute",
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() E:SetupBui(); E:ToggleConfig(); end,
			},
			spacer2 = {
				order = 4,
				type = "header",
				name = "",
			},
			general = {
				order = 5,
				type = "group",
				name = L["General"],
				guiInline = true,
				args = {
					colorTheme = {
						order = 1,
						type = "select",
						name = L["Color Themes"],
						values = {
							['Elv'] = L['ElvUI'],
							['Diablo'] = L['Diablo'],
							['Hearthstone'] = L['Hearthstone'],
							['Mists'] = L['Mists'],
						},
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, color) E.db.bui[ info[#info] ] = color; BUI:BuiColorThemes(color); end,
					},
					buiFonts = {
						order = 2,
						type = "toggle",
						name = L["Force BenikUI fonts"],
						desc = L["Enables BenikUI fonts overriding the default combat and name fonts. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r"],
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, value) E.db.bui[ info[#info] ] = value; value, _, _, _ = GetAddOnInfo("ElvUI_BenikUI_Fonts"); BUI:EnableBuiFonts(); E:StaticPopup_Show("PRIVATE_RL"); end,	
					},
				},
			},
			datatexts = {
				order = 6,
				type = "group",
				name = L["DataTexts"],
				guiInline = true,
				args = {
					buiDts = {
						order = 1,
						type = "toggle",
						name = ENABLE,
						desc = L["Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled"],
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, value) E.db.bui[ info[#info] ] = value; LO:ToggleChatPanels(); end,	
					},
					transparentDts = {
						order = 2,
						type = "toggle",
						name = L["Panel Transparency"],
						disabled = function() return not E.db.bui.buiDts end,
						get = function(info) return E.db.bui[ info[#info] ] end,
						set = function(info, value) E.db.bui[ info[#info] ] = value; E:GetModule('BuiLayout'):ToggleTransparency(); end,	
					},
				},
			},
			config = {
				order = 20,
				type = 'group',
				name = L['Options'],
				childGroups = 'tab',
				args = {},
			},
		},
	}
end

table.insert(E.BuiConfig, buiTable)