local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BAB = E:GetModule('BuiActionbars');

local tinsert = table.insert
local SHOW = SHOW

local function abTable()
	E.Options.args.actionbar.args.benikui = {
		order = 20,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		args = {
			transparent = {
				order = 1,
				type = 'toggle',
				name = L['Transparent Backdrops'],
				desc = L['Applies transparency in all actionbar backdrops and actionbar buttons.'],
				get = function(info) return E.db.benikui.actionbars[ info[#info] ] end,
				set = function(info, value) E.db.benikui.actionbars[ info[#info] ] = value; BAB:TransparentBackdrops() end,	
			},
			requestStop = {
				order = 2,
				type = 'toggle',
				name = L['Request Stop button'],
				get = function(info) return E.db.benikui.actionbars[ info[#info] ] end,
				set = function(info, value) E.db.benikui.actionbars[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,	
			},
			toggleButtons = {
				order = 2,
				type = 'group',
				name = BUI:cOption(L['Switch Buttons']),
				guiInline = true,
				get = function(info) return E.db.benikui.actionbars.toggleButtons[ info[#info] ] end,
				set = function(info, value) E.db.benikui.actionbars.toggleButtons[ info[#info] ] = value; BAB:ShowButtons() end,
				args = {
					enable = {
						order = 1,
						type = 'toggle',
						name = SHOW,
						desc = L['Show small buttons over Actionbar 1 or 2 decoration, to show/hide Actionbars 3 or 5.'],
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
						disabled = function() return not E.db.benikui.actionbars.toggleButtons.enable end,
					},
				},
			},
		},
	}
end

tinsert(BUI.Config, abTable)