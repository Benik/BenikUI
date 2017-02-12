local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

local tinsert, format = table.insert, string.format
local ipairs, unpack = ipairs, unpack

local IsAddOnLoaded = IsAddOnLoaded
local QUEST_OBJECTIVES, ADDONS = QUEST_OBJECTIVES, ADDONS

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
	{'Pawn', L['Pawn'], 'pawn'},
}

local SupportedProfiles = {
	{'AddOnSkins', 'AddOnSkins'},
	{'DBM-Core', 'Deadly Boss Mods'},
	{'Details', 'Details'},
	{'ElvUI_VisualAuraTimers', 'ElvUI VisualAuraTimers'},
	{'ElvUI_LocLite', 'Location Lite'},
	{'ElvUI_LocPlus', 'Location Plus'},
	{'MikScrollingBattleText', "Mik's Scrolling Battle Text"},
	{'Pawn', 'Pawn'},
	{'Recount', 'Recount'},
	{'Skada', 'Skada'},
	{'SquareMinimapButtons', 'Square Minimap Buttons'},
}

local profileString = format('|cfffff400%s |r', L['BenikUI successfully created and applied profile(s) for:'])

local function SkinTable()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	E.Options.args.benikui.args.skins = {
		order = 40,
		type = 'group',
		name = ADDONS..BUI.NewSign,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = BUI:cOption(ADDONS),
			},
			desc = {
				order = 2,
				type = 'description',
				name = L['Choose which addon you wish to be decorated to fit with BenikUI style'].."\n",
			},
		},
	}
	
	E.Options.args.benikui.args.skins.args.elvuiaddons = {
		order = 3,
		type = 'group',
		guiInline = true,
		name = L['ElvUI AddOns'],
		get = function(info) return E.db.benikuiSkins.elvuiAddons[ info[#info] ] end,
		set = function(info, value) E.db.benikuiSkins.elvuiAddons[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			},
		}
	
	local elvorder = 0
	for i, v in ipairs(DecorElvUIAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.benikui.args.skins.args.elvuiaddons.args[addonOption] = {
			order = elvorder + 1,
			type = 'toggle',
			name = addonString,
			desc = format('%s '..addonString..' %s', L['Enable/Disable'], L['decor.']),
			disabled = function() return not IsAddOnLoaded(addonName) end,
		}
	end
	
	E.Options.args.benikui.args.skins.args.addonskins = {
		order = 4,
		type = 'group',
		guiInline = true,
		name = L['AddOnSkins'],
		get = function(info) return E.db.benikuiSkins.addonSkins[ info[#info] ] end,
		set = function(info, value) E.db.benikuiSkins.addonSkins[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			},
		}
		
	local addorder = 0
	for i, v in ipairs(DecorAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.benikui.args.skins.args.addonskins.args[addonOption] = {
			order = addorder + 1,
			type = 'toggle',
			name = addonString,
			desc = format('%s '..addonString..' %s', L['Enable/Disable'], L['decor.']),
			disabled = function() return not (IsAddOnLoaded('AddOnSkins') and IsAddOnLoaded(addonName)) end,
		}
	end

	E.Options.args.benikui.args.skins.args.variousSkins = {
		order = 5,
		type = 'group',
		guiInline = true,
		name = L['Skins'],
		get = function(info) return E.db.benikuiSkins.variousSkins[ info[#info] ] end,
		set = function(info, value) E.db.benikuiSkins.variousSkins[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL') end,
		args = {
			talkingHead = {
				order = 1,
				type = 'toggle',
				name = L["TalkingHead"],
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
	
	E.Options.args.benikui.args.skins.args.profiles = {
		order = 6,
		type = 'group',
		guiInline = true,
		name = L['Profiles']..BUI.NewSign,
		args = {
		},
	}

	for i, v in ipairs(SupportedProfiles) do
		local addon, addonName = unpack(v)
		local optionOrder = 1
		E.Options.args.benikui.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = 'execute',
			name = addonName,
			desc = L['This will create and apply profile for ']..addonName,
			func = function()
				if addon == 'DBM-Core' then
					BUI:LoadDBMProfile()
				elseif addon == 'Details' then
					BUI:LoadDetailsProfile()
				elseif addon == 'ElvUI_LocLite' then
					BUI:LoadLocationLiteProfile()
				elseif addon == 'ElvUI_LocPlus' then
					BUI:LoadLocationPlusProfile()
				elseif addon == 'MikScrollingBattleText' then
					BUI:LoadMSBTProfile()
				elseif addon == 'Pawn' then
					BUI:LoadPawnProfile()
				elseif addon == 'Recount' then
					BUI:LoadRecountProfile()
				elseif addon == 'Skada' then
					BUI:LoadSkadaProfile()
				elseif addon == 'SquareMinimapButtons' then
					BUI:LoadSMBProfile()
				elseif addon == 'ElvUI_VisualAuraTimers' then
					BUI:LoadVATProfile()
				elseif addon == 'AddOnSkins' then
					BUI:LoadAddOnSkinsProfile()
				end
				print(profileString..addonName)
			end,
			disabled = function() return not IsAddOnLoaded(addon) end,
		}
	end

end

tinsert(BUI.Config, SkinTable)
