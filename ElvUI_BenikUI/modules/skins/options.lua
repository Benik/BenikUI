local BUI, E, _, V, P, G = unpack((select(2, ...)))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')

local tinsert, format = table.insert, string.format
local ipairs, unpack = ipairs, unpack

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LoadAddOn = C_AddOns.LoadAddOn

local ADDONS = ADDONS
local OBJECTIVES_TRACKER_LABEL = OBJECTIVES_TRACKER_LABEL

local DecorElvUIAddons = {
	{'ElvUI_LocPlus', L['LocationPlus'], 'locplus'},
	{'ElvUI_SLE', L['Shadow & Light'], 'sle'},
	{'ElvUI_WindTools', L['WindTools'], 'wt'},
	{'ElvUI_MerathilisUI', L['MerathilisUI'], 'mer'},
	{'ElvUI_Options', L['ElvUI Options'], 'elv'},
}

local DecorAddonSkins = {
	
	{'TinyDPS', L['TinyDPS'], 'tinydps'},
	{'AtlasLoot', L['AtlasLoot'], 'atlasloot'},
	{'Altoholic', L['Altoholic'], 'altoholic'},
	{'Clique', L['Clique'], 'clique'},
	{'oRA3', L['oRA3'], 'ora'},
	{'Pawn', L['Pawn'], 'pawn'},

	{'BigWigs', L['BigWigs'], 'bigwigs'},
	{'ZygorGuidesViewer', L['Zygor Guides'], 'zygor'},
	{'Immersion', L['Immersion'], 'immersion'},

	{'TinyInspect', L['TinyInspect'], 'tinyinspect'},
	{'ArkInventory', L['Ark Inventory'], 'arkinventory'},
	{'Storyline', L['Storyline'], 'storyline'},
	{'ClassTactics', L['ClassTactics'], 'classTactics'},
	{'Hekili', L['Hekili'], 'hekili'},
	{'WoWPro', L['WoWPro'], 'wowpro'},
}

local SkinsForAddons = {
	{'InFlight', L['InFlight'], 'inflight'},
	{'!KalielsTracker', L['Kaliels Tracker'], 'kt'},
	{'TomTom', L['TomTom'], 'tomtom'},
	{'Baganator', L['Baganator'], 'baganator'},
	{'AllTheThings', L['All The Things'], 'alltheThings'},
	{'MinimapButtonButton', L['MinimapButtonButton'], 'minimapbb'},
	{'Skada', L['Skada'], 'skada'},
	{'BugSack', L['BugSack'], 'bugSack'},
}

local SupportedProfiles = {
	{'AddOnSkins', 'AddOnSkins'},
	{'BigWigs', 'BigWigs'},
	{'DBM-Core', 'Deadly Boss Mods'},
	{'Details', 'Details'},
	{'ElvUI_LocPlus', 'Location Plus'},
	{'InFlight', 'InFlight'},
	{'Pawn', 'Pawn'},
	{'Skada', 'Skada'},
	{'ProjectAzilroka', 'Project Azilroka'},
	{'!KalielsTracker', 'Kaliels Tracker'},
}

BUI.profileStrings = {
	[1] = L['Successfully created and applied profile(s) for |cffffff00%s|r'],
	[2] = L['|cffffff00%s|r profile for this character already exists. Aborting.'],
}

local pa = L['Project Azilroka']

local function SkinTable()
	E.Options.args.benikui.args.skins = {
		order = 100,
		type = 'group',
		name = BUI:cOption(ADDONS, "orange"),
		childGroups = "tab",
		args = {
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
		name = L['ElvUI AddOns'],
		get = function(info) return E.db.benikui.skins.elvuiAddons[ info[#info] ] end,
		set = function(info, value) E.db.benikui.skins.elvuiAddons[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
		args = {
			},
		}

	local elvorder = 0
	for _, v in ipairs(DecorElvUIAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.benikui.args.skins.args.elvuiaddons.args[addonOption] = {
			order = elvorder + 1,
			type = 'toggle',
			name = addonString,
			desc = format('%s '..addonString..' %s', L['Enable/Disable'], L['decor.']),
			disabled = function() return not BUI:IsAddOnEnabled(addonName) or not E.db.benikui.general.benikuiStyle end,
		}
	end

	E.Options.args.benikui.args.skins.args.variousSkins = {
		order = 5,
		type = 'group',
		name = L['Skins'],
		get = function(info) return E.db.benikui.skins.variousSkins[ info[#info] ] end,
		set = function(info, value) E.db.benikui.skins.variousSkins[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
		args = {
			blizzard = {
				order = 1,
				type = 'group',
				name = L['Blizzard'],
				guiInline = true,
				args = {
					talkingHead = {
						order = 1,
						type = 'toggle',
						name = L["TalkingHead"],
					},
					objectiveTracker = {
						order = 2,
						type = 'toggle',
						name = OBJECTIVES_TRACKER_LABEL,
					},
				},
			},
			addOns = {
				order = 2,
				type = 'group',
				name = L['AddOns'],
				guiInline = true,
				args = {
				},
			}
		},
	}

	for _, v in ipairs(SkinsForAddons) do
		local addonName, addonString, addonOption = unpack( v )
		E.Options.args.benikui.args.skins.args.variousSkins.args.addOns.args[addonOption] = {
			order = 3,
			type = 'toggle',
			name = addonString,
			desc = format('%s '..addonString..' %s', L['Enable/Disable'], L['skin.']),
			disabled = function() return not BUI:IsAddOnEnabled(addonName) end,
		}
	end

	E.Options.args.benikui.args.skins.args.variousSkins.args.dbm = {
		order = 3,
		type = 'group',
		name = L['DBM'],
		guiInline = true,
		disabled = function() return not BUI:IsAddOnEnabled("DBM-Core") end,
		args = {
			dbmSkin = {
				order = 1,
				type = 'toggle',
				name = L['Skin'],
				get = function(info) return E.db.benikui.skins.variousSkins[ info[#info] ] end,
				set = function(info, value) E.db.benikui.skins.variousSkins[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
			},
			dbmHalfBar = {
				order = 2,
				type = 'toggle',
				name = L['Half Bar'],
				get = function(info) return E.db.benikui.skins.variousSkins[ info[#info] ] end,
				set = function(info, value) E.db.benikui.skins.variousSkins[ info[#info] ] = value; end,
				disabled = function() return not E.db.benikui.skins.variousSkins.dbmSkin or not BUI:IsAddOnEnabled("DBM-Core") end,
			},
		},
	}

	E.Options.args.benikui.args.skins.args.variousSkins.args.bigwigs = {
		order = 4,
		type = 'group',
		name = L['BigWigs'],
		guiInline = true,
		disabled = function() return not BUI:IsAddOnEnabled("BigWigs") end,
		args = {
			bigwigsSkin = {
				order = 1,
				type = 'toggle',
				name = L['Skin'],
				get = function(info) return E.db.benikui.skins.variousSkins[ info[#info] ] end,
				set = function(info, value) E.db.benikui.skins.variousSkins[ info[#info] ] = value; E:StaticPopup_Show('CONFIG_RL') end,
			},
			bigwigsHalfBar = {
				order = 2,
				type = 'toggle',
				name = L['Half Bar'],
				get = function(info)
					if not IsAddOnLoaded("BigWigs_Plugins") then
						LoadAddOn("BigWigs_Plugins")
					end
					if BigWigs then
						local barsPlugin = BigWigs:GetPlugin("Bars", true)
						if barsPlugin and barsPlugin.db and barsPlugin.db.profile then
							local isHalfBar = (barsPlugin.db.profile.barStyle == BUI.Title..'Half Bar')
							E.db.benikui.skins.variousSkins[ info[#info] ] = isHalfBar

							return isHalfBar
						end
					end

					return E.db.benikui.skins.variousSkins[ info[#info] ]
				end,
				set = function(info, value) E.db.benikui.skins.variousSkins[ info[#info] ] = value;
					if not IsAddOnLoaded("BigWigs_Plugins") then
						LoadAddOn("BigWigs_Plugins")
					end
					if BigWigs then
						local barsPlugin = BigWigs:GetPlugin("Bars", true)
						if barsPlugin and barsPlugin.db and barsPlugin.db.profile then
							if value then
								barsPlugin.db.profile.barStyle = BUI.Title..'Half Bar'
							else
								barsPlugin.db.profile.barStyle = BUI.Title
							end
						end
					end
				end,
				disabled = function() return not E.db.benikui.skins.variousSkins.bigwigsSkin or not BUI:IsAddOnEnabled("BigWigs") end,
			},
		},
	}

	E.Options.args.benikui.args.skins.args.profiles = {
		order = 6,
		type = 'group',
		name = L['Profiles'],
		args = {
		},
	}

	local optionOrder = 1
	for _, v in ipairs(SupportedProfiles) do
		local addon, addonName = unpack(v)
		E.Options.args.benikui.args.skins.args.profiles.args[addon] = {
			order = optionOrder + 1,
			type = 'execute',
			name = addonName,
			desc = L['This will create and apply profile for ']..addonName,
			func = function()
				if addon == 'DBM-Core' then
					BUI:LoadDBMProfile()
				elseif addon == 'BigWigs' then
					BUI:LoadBigWigsProfile()
				elseif addon == 'Details' then
					BUI:LoadDetailsProfile()
				elseif addon == 'InFlight'then
					BUI:LoadInFlightProfile()
				elseif addon == 'ElvUI_LocPlus' then
					BUI:LoadLocationPlusProfile()
				elseif addon == 'Pawn' then
					BUI:LoadPawnProfile()
				elseif addon == 'Skada' then
					BUI:LoadSkadaProfile()
				elseif addon == 'AddOnSkins' then
					BUI:LoadAddOnSkinsProfile()
				elseif addon == 'ProjectAzilroka' then
					BUI:LoadPAProfile()
				elseif addon == '!KalielsTracker' then
					BUI:LoadKalielsProfile()
				end
				if addon ~= 'BigWigs' then
					E:StaticPopup_Show('CONFIG_RL')
				end
			end,
			disabled = function() return not BUI:IsAddOnEnabled(addon) end,
		}
	end
end

tinsert(BUI.Config, SkinTable)
