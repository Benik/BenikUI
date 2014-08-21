local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

-- Defaults
P['ufb'] = {
	['barshow'] = true,
	['barheight'] = 20,
	['detachPlayerPortrait'] = false,
	['PlayerPortraitWidth'] = 110,
	['PlayerPortraitHeight'] = 85,
	['PlayerPortraitShadow'] = false,
	['PlayerPortraitTransparent'] = true,
	['detachTargetPortrait'] = false,
	['getPlayerPortraitSize'] = true,
	['TargetPortraitWidth'] = 110,
	['TargetPortraitHeight'] = 85,
	['TargetPortraitShadow'] = false,
	['TargetPortraitTransparent'] = true,
	['powerstatusbar'] = "BuiFlat",
}

local function ufTable()
	E.Options.args.unitframe.args.general.args.ufb = {
		order = 2,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		args = {
			powerstatusbar = {
				type = "select", dialogControl = 'LSM30_Statusbar',
				order = 1,
				name = BUI:cOption(L["PowerBar"])..BUI.newsign,
				desc = L["Power statusbar texture."],
				values = AceGUIWidgetLSMlists.statusbar,
				get = function(info) return E.db.ufb[ info[#info] ] end,				
				set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:Update_PowerStatusBar() end,
			},
			eframes = {
				order = 2,
				type = 'group',
				name = BUI:cOption(L["Empty Frames"]),
				guiInline = true,
				get = function(info) return E.db.ufb[ info[#info] ] end,
				set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); UFB:ArrangeTarget(); end,	
				args = {
					barshow = {
						order = 1,
						type = "toggle",
						name = ENABLE,
						desc = L["Enable the Empty frames (Player and Target)."],
					},
					barheight = {
						order = 2,
						type = "range",
						name = L["Height"],
						desc = L["Change the Empty frames height (Player and Target)."],
						disabled = function() return not E.db.ufb.barshow end,
						min = 10, max = 50, step = 1,
					},
				},
			},
		},
	}
end
table.insert(E.BuiConfig, ufTable)

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.portrait.args.ufb = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.ufb[ info[#info] ] end,
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); end,
		args = {		
			detachPlayerPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				set = function(info, value)
					E.db.ufb[ info[#info] ] = value;
					if value == true then
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 0
						E.db.unitframe.units.player.portrait.width = 0
					else
						E.Options.args.unitframe.args.player.args.portrait.args.width.min = 15
						E.db.unitframe.units.player.portrait.width = 45
					end
					UF:CreateAndUpdateUF('player')
				end,
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitTransparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				desc = L["Makes the portrait backdrop transparent"],
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitShadow = {
				order = 3,
				type = "toggle",
				name = L["Shadow"],
				desc = L["Add shadow under the portrait"],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
			},
			PlayerPortraitWidth = {
				order = 4,
				type = "range",
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},	
			PlayerPortraitHeight = {
				order = 5,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},
		},
	}
end
table.insert(E.BuiConfig, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.portrait.args.ufb = {
		order = 10,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		get = function(info) return E.db.ufb[ info[#info] ] end,
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangeTarget(); end,
		args = {		
			detachTargetPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				set = function(info, value)
					E.db.ufb[ info[#info] ] = value;
					--Easiest way to properly set new width of various elements on the target frame
					--such as classbar, stagger, power etc. The alternative is to include a lot of code
					--in UFB:ArrangePlayer() to reposition these elements.
					if value == true then
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 0
						E.db.unitframe.units.target.portrait.width = 0
					else
						E.Options.args.unitframe.args.target.args.portrait.args.width.min = 15
						E.db.unitframe.units.target.portrait.width = 45
					end
					UF:CreateAndUpdateUF('target')
				end,
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			TargetPortraitTransparent = {
				order = 2,
				type = "toggle",
				name = L["Transparent"],
				desc = L["Makes the portrait backdrop transparent"],
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			TargetPortraitShadow = {
				order = 3,
				type = "toggle",
				name = L["Shadow"],
				desc = L["Add shadow under the portrait"],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			getPlayerPortraitSize = {
				order = 4,
				type = "toggle",
				name = L["Player Size"],
				desc = L["Copy Player portrait width and height"],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			TargetPortraitWidth = {
				order = 5,
				type = "range",
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},	
			TargetPortraitHeight = {
				order = 6,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},
		},
	}
end
table.insert(E.BuiConfig, ufTargetTable)