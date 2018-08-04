local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

local tinsert, format = table.insert, string.format
local ipairs, unpack = ipairs, unpack

local IsAddOnLoaded = IsAddOnLoaded
local ADDONS = ADDONS

local DecorElvUIAddons = {
	{'ElvUI_LocLite', L['LocationLite'], 'loclite'},
	{'ElvUI_LocPlus', L['LocationPlus'], 'locplus'},
	{'ElvUI_SLE', L['Shadow & Light'], 'sle'},
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
	{'Clique', L['Clique'], 'clique'},
	{'oRA3', L['oRA3'], 'ora'},
	{'Pawn', L['Pawn'], 'pawn'},
	{'DBM-Core', L['Deadly Boss Mods'], 'dbm'},
	{'BigWigs', L['BigWigs'], 'bigwigs'},
}

local SupportedProfiles = {
	{'AddOnSkins', 'AddOnSkins'},
	{'BigWigs', 'BigWigs'},
	{'DBM-Core', 'Deadly Boss Mods'},
	{'Details', 'Details'},
	{'ElvUI_VisualAuraTimers', 'ElvUI VisualAuraTimers'},
	{'ElvUI_LocLite', 'Location Lite'},
	{'ElvUI_LocPlus', 'Location Plus'},
	{'InFlight_Load', 'InFlight'},
	{'MikScrollingBattleText', "Mik's Scrolling Battle Text"},
	{'Pawn', 'Pawn'},
	{'Recount', 'Recount'},
	{'Skada', 'Skada'},
}

BUI.profileStrings = {
	[1] = format('|cfffff400%s |r', L['BenikUI successfully created and applied profile(s) for:']),
	[2] = format('|cfffff400%s |r', L[': Profile for this character already exists. Aborting.']),
}

local smb = L['Square Minimap Buttons']
local stAM = L['stAddOnManager']

local function SkinTable()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	E.Options.args.benikui.args.skins = {
		order = 40,
		type = 'group',
		name = ADDONS,
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

	-- New SquareMinimapButtons
	E.Options.args.benikui.args.skins.args.elvuiaddons.args.smb = {
		order = elvorder + 1,
		type = 'toggle',
		name = smb,
		desc = format('%s '..smb..' %s', L['Enable/Disable'], L['decor.']),
		disabled = function() return not (BUI.PA and _G.ProjectAzilroka.db['SMB']) end,
	}
	
	-- stAddonManager
	E.Options.args.benikui.args.skins.args.elvuiaddons.args.stam = {
		order = elvorder + 1,
		type = 'toggle',
		name = stAM,
		desc = format('%s '..stAM..' %s', L['Enable/Disable'], L['decor.']),
		disabled = function() return not (BUI.PA and _G.ProjectAzilroka.db['stAM']) end,
	}

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
			disabled = function() return not (BUI.AS and IsAddOnLoaded(addonName)) end,
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
		name = L['Profiles'],
		args = {
		},
	}

	local optionOrder = 1
	for i, v in ipairs(SupportedProfiles) do
		local addon, addonName = unpack(v)
		E.Options.args.benikui.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = 'execute',
			name = addonName,
			desc = L['This will create and apply profile for ']..addonName,
			buttonElvUI = true,
			func = function()
				if addon == 'DBM-Core' then
					BUI:LoadDBMProfile()
				elseif addon == 'BigWigs' then
					BUI:LoadBigWigsProfile()
				elseif addon == 'Details' then
					BUI:LoadDetailsProfile()
				elseif addon == 'InFlight_Load'then
					BUI:LoadInFlightProfile()
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
				elseif addon == 'ElvUI_VisualAuraTimers' then
					BUI:LoadVATProfile()
				elseif addon == 'AddOnSkins' then
					BUI:LoadAddOnSkinsProfile()
				end
				E:StaticPopup_Show('PRIVATE_RL')
			end,
			disabled = function() return not IsAddOnLoaded(addon) end,
		}
	end

	-- New SquareMinimapButtons from ProjectAzilroka
	E.Options.args.benikui.args.skins.args.profiles.args.SquareMinimapButtons = {
		order = optionOrder + 1,
		type = 'execute',
		name = smb,
		desc = L['This will create and apply profile for ']..smb,
		buttonElvUI = true,
		func = function()
			BUI:LoadSMBProfile()
			E:StaticPopup_Show('PRIVATE_RL')
			print(BUI.profileStrings[1]..smb)
		end,
		disabled = function() return (BUI.SLE or not (BUI.PA and _G.ProjectAzilroka.db['SMB'])) end,
	}

	-- New stAddOnManager from ProjectAzilroka
	E.Options.args.benikui.args.skins.args.profiles.args.stAddOnManager = {
		order = optionOrder + 1,
		type = 'execute',
		name = stAM,
		desc = L['This will create and apply profile for ']..stAM,
		buttonElvUI = true,
		func = function()
			BUI:LoadStamProfile()
			E:StaticPopup_Show('PRIVATE_RL')
			print(BUI.profileStrings[1]..stAM)
		end,
		disabled = function() return not (BUI.PA and _G.ProjectAzilroka.db['stAM']) end,
	}
end

tinsert(BUI.Config, SkinTable)