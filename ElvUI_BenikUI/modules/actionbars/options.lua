local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BAB = E:GetModule('BuiActionbars');
local tinsert = table.insert

local function abTable()
	E.Options.args.actionbar.args.bab = {
		order = 20,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		args = {
			transBack = {
				order = 1,
				type = 'toggle',
				name = L['Transparent Backdrops'],
				desc = L['Applies transparency in all actionbar backdrops and actionbar buttons.'],
				get = function(info) return E.db.bab[ info[#info] ] end,
				set = function(info, value) E.db.bab[ info[#info] ] = value; BAB:TransparentBackdrops() end,	
			},
			requestStop = {
				order = 2,
				type = 'toggle',
				name = L['Request Stop button'],
				get = function(info) return E.db.bab[ info[#info] ] end,
				set = function(info, value) E.db.bab[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
			},
			general = {
				order = 2,
				type = 'group',
				name = BUI:cOption(L['Switch Buttons']),
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = SHOW,
						desc = L['Show small buttons over Actionbar 1 or 2 decoration, to show/hide Actionbars 3 or 5.'],
						get = function(info) return E.db.bab[ info[#info] ] end,
						set = function(info, value) E.db.bab[ info[#info] ] = value; BAB:ShowButtons() end,	
					},
					chooseAb = {
						order = 1,
						type = 'select',
						name = L['Show in:'],
						desc = L['Choose Actionbar to show to'],
						values = {
							['BAR1'] = L['Bar 1'],
							['BAR2'] = L['Bar 2'],
						},
						disabled = function() return not E.db.bab.enable end,
						get = function(info) return E.db.bab[ info[#info] ] end,
						set = function(info, value) E.db.bab[ info[#info] ] = value; BAB:ShowButtons() end,	
					},
				},
			},
		},
	}
end

tinsert(BUI.Config, abTable)