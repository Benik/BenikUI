local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BUIS = E:GetModule('BuiSkins');

if E.db.buiskins == nil then E.db.buiskins = {} end
if E.db.elvuiaddons == nil then E.db.elvuiaddons = {} end
if E.db.addonskins == nil then E.db.addonskins = {} end

local DecorElvUIAddons = {
	{"ElvUI_LocLite", "LocationLite", "loclite"},
	{"ElvUI_LocPlus", "LocationPlus", "locplus"},
	{"ElvUI_SLE", "Shadow & Light", "sle"},
	{"SquareMinimapButtons", "Square Minimap Buttons", "smb"},
}

local DecorAddons = {
	{"RareCoordinator", "Rare Coordinator", "rc"},
	{"Skada", "Skada", "skada"},
	{"Recount", "Recount", "recount"},
	{"TinyDPS", "TinyDPS", "tinydps"},
	{"AtlasLoot", "AtlasLoot", "atlasloot"},
	{"Altoholic", "Altoholic", "altoholic"},
	{"ZygorGuidesViewer", "Zygor Guides", "zg"},
}

-- Defaults
P['buiskins'] = {
}

P['elvuiaddons'] = {
	['loclite'] = true,
	['locplus'] = true,
	['sle'] = true,
	['smb'] = true,
}

P['addonskins'] = {
	['rc'] = true,
	['skada'] = true,
	['recount'] = true,
	['tinydps'] = true,
	['atlasloot'] = true,
	['altoholic'] = true,
	['zg'] = true,
}

local function SkinTable()
	E.Options.args.bui.args.config.args.buiskins = {
		order = 40,
		type = 'group',
		name = L["AddOns Decor"]..BUI.newsign,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Choose which addon you wish to be decorated to fit with BenikUI style"],
			},
		},
	}
	
	E.Options.args.bui.args.config.args.buiskins.args.elvuiaddons = {
		order = 1,
		type = 'group',
		guiInline = true,
		name = L["ElvUI AddOns"],
		get = function(info) return E.db.elvuiaddons[ info[#info] ] end,
		set = function(info, value) E.db.elvuiaddons[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			},
		}
	
	local elvorder = 0
	for i, v in ipairs(DecorElvUIAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.bui.args.config.args.buiskins.args.elvuiaddons.args[addonOption] = {
			order = elvorder + 1,
			type = "toggle",
			name = addonString,
			desc = L["Enable/Disable this decor."],
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end
	
	E.Options.args.bui.args.config.args.buiskins.args.addonskins = {
		order = 2,
		type = 'group',
		guiInline = true,
		name = L["AddOnSkins"],
		get = function(info) return E.db.addonskins[ info[#info] ] end,
		set = function(info, value) E.db.addonskins[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
		args = {
			},
		}
		
	local addorder = 0
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.bui.args.config.args.buiskins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = "toggle",
			name = addonString,
			desc = L["Enable/Disable this decor."],
			disabled = function() return not (IsAddOnLoaded("AddOnSkins") and IsAddOnLoaded(addonName)) end,
		}
	end		
end

table.insert(E.BuiConfig, SkinTable)
