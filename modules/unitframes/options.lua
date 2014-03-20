local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

-- Defaults
P['ufb'] = {
	['barshow'] = true,
	['barheight'] = 20,
	['detachPortrait'] = false,
	['portraitWidth'] = 150,
	['portraitHeight'] = 150,
	['shadowPortrait'] = false,
}

local function ufTable()
	E.Options.args.unitframe.args.general.args.ufb = {
		order = 3,
		type = 'group',
		name = BUI.Title,
		guiInline = true,
		args = {
			eframes = {
				order = 1,
				type = 'group',
				name = BUI:cOption(L["Empty Frames"]),
				guiInline = true,
				get = function(info) return E.db.ufb[ info[#info] ] end,
				set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangePlayer(); UFB:ArrangeTarget(); end,	
				args = {
					barshow = {
						order = 1,
						type = "toggle",
						name = SHOW,
						desc = L["Show the Empty frames (Player and Target)."],	
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
				width = "full",
				disabled = function() return E.db.unitframe.units.player.portrait.overlay end,
			},
			PlayerPortraitWidth = {
				order = 2,
				type = "range",
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},	
			PlayerPortraitHeight = {
				order = 3,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
				min = 10, max = 250, step = 1,
			},
			PlayerPortraitShadow = {
				order = 4,
				type = "toggle",
				name = L["Shadow"],
				desc = L["Add shadow under the portrait"],
				disabled = function() return not E.db.ufb.detachPlayerPortrait end,
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
		set = function(info, value) E.db.ufb[ info[#info] ] = value; UFB:ArrangeTarget(); UF:Update_TargetFrame() end,
		args = {		
			detachTargetPortrait = {
				order = 1,
				type = "toggle",
				name = L["Detach Portrait"],
				width = "full",
				disabled = function() return E.db.unitframe.units.target.portrait.overlay end,
			},
			getPlayerPortraitSize = {
				order = 2,
				type = "toggle",
				name = L["Player Size"],
				desc = L["Copy Player portrait width and height"],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
			TargetPortraitWidth = {
				order = 3,
				type = "range",
				name = L["Width"],
				desc = L["Change the detached portrait width"],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},	
			TargetPortraitHeight = {
				order = 4,
				type = "range",
				name = L["Height"],
				desc = L["Change the detached portrait height"],
				disabled = function() return E.db.ufb.getPlayerPortraitSize or not E.db.ufb.detachTargetPortrait end,
				min = 10, max = 250, step = 1,
			},
			TargetPortraitShadow = {
				order = 5,
				type = "toggle",
				name = L["Shadow"],
				desc = L["Add shadow under the portrait"],
				disabled = function() return not E.db.ufb.detachTargetPortrait end,
			},
		},
	}
end

table.insert(E.BuiConfig, ufTargetTable)