local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIS = E:GetModule('BuiSkins');

if E.db.buiskins == nil then E.db.buiskins = {} end
if E.db.elvuiaddons == nil then E.db.elvuiaddons = {} end
if E.db.buiaddonskins == nil then E.db.buiaddonskins = {} end

local tinsert, format, ipairs = table.insert, string.format, ipairs

local DecorElvUIAddons = {
	{'ElvUI_LocLite', L['LocationLite'], 'loclite'},
	{'ElvUI_LocPlus', L['LocationPlus'], 'locplus'},
	{'ElvUI_SLE', L['Shadow & Light'], 'sle'},
	{'SquareMinimapButtons', L['Square Minimap Buttons'], 'smb'},
	{'ElvUI_Enhanced', L['ElvUI_Enhanced'], 'enh'},
	{'ElvUI_DTBars2', L['DT Bars 2'], 'dtb2'},
}

local DecorAddons = {
	{'RareCoordinator', L['Rare Coordinator'], 'rc'},
	{'Skada', L['Skada'], 'skada'},
	{'Recount', L['Recount'], 'recount'},
	{'TinyDPS', L['TinyDPS'], 'tinydps'},
	{'AtlasLoot', L['AtlasLoot'], 'atlasloot'},
	{'Altoholic', L['Altoholic'], 'altoholic'},
	{'ZygorGuidesViewer', L['Zygor Guides'], 'zg'},
	{'Clique', L['Clique'], 'clique'},
	{'oRA3', L['oRA3'], 'ora'},
}

local function SkinTable()
	if E.db.bui.buiStyle ~= true then return end
	E.Options.args.bui.args.config.args.buiskins = {
		order = 40,
		type = 'group',
		name = L['AddOns Decor'],
		args = {
			header = {
				order = 1,
				type = 'header',
				name = L['Choose which addon you wish to be decorated to fit with BenikUI style'],
			},
		},
	}
	
	E.Options.args.bui.args.config.args.buiskins.args.elvuiaddons = {
		order = 1,
		type = 'group',
		guiInline = true,
		name = L['ElvUI AddOns'],
		get = function(info) return E.db.elvuiaddons[ info[#info] ] end,
		set = function(info, value) E.db.elvuiaddons[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			},
		}
	
	local elvorder = 0
	for i, v in ipairs(DecorElvUIAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.bui.args.config.args.buiskins.args.elvuiaddons.args[addonOption] = {
			order = elvorder + 1,
			type = 'toggle',
			name = addonString,
			desc = format('%s '..addonString..' %s', L['Enable/Disable'], L['decor.']),
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end
	
	E.Options.args.bui.args.config.args.buiskins.args.buiaddonskins = {
		order = 2,
		type = 'group',
		guiInline = true,
		name = L['AddOnSkins'],
		get = function(info) return E.db.buiaddonskins[ info[#info] ] end,
		set = function(info, value) E.db.buiaddonskins[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			},
		}
		
	local addorder = 0
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.bui.args.config.args.buiskins.args.buiaddonskins.args[addonOption] = {
			order = addorder + 1,
			type = 'toggle',
			name = addonString,
			desc = format('%s '..addonString..' %s', L['Enable/Disable'], L['decor.']),
			disabled = function() return not (IsAddOnLoaded('AddOnSkins') and IsAddOnLoaded(addonName)) end,
		}
	end

	E.Options.args.bui.args.config.args.buiskins.args.buiVariousSkins = {
		order = 3,
		type = 'group',
		guiInline = true,
		name = L['Skins'],
		get = function(info) return E.db.buiVariousSkins[ info[#info] ] end,
		set = function(info, value) E.db.buiVariousSkins[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			objectiveTracker = {
				order = 1,
				type = 'toggle',
				name = QUEST_OBJECTIVES,
			},
			decursive = {
				order = 2,
				type = 'toggle',
				name = L['Decursive'],
				disabled = function() return not IsAddOnLoaded('Decursive') end,
			},
			storyline = {
				order = 3,
				type = 'toggle',
				name = L['Storyline'],
				disabled = function() return not IsAddOnLoaded('Storyline') end,
			},	
		},
	}

end

tinsert(BUI.Config, SkinTable)
