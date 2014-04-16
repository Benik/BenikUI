local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');
local UFB = E:GetModule('BuiUnits');

if E.db.xprep == nil then E.db.xprep = {} end

-- Defaults
P['xprep'] = {
	['show'] = "REP",
	['textStyle'] = 'UNIT',
	['mouseOver'] = true,
}

local function xprepTable()
	E.Options.args.bui.args.config.args.xprep = {
		order = 30,
		type = 'group',
		name = L["XP - Rep"],
		disabled = function() return not E.db.ufb.barshow end,
		get = function(info) return E.db.xprep[ info[#info] ] end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["XP - Rep"],
			},
			show = {
				order = 2,
				type = "select",
				name = L["Show in PlayerBar"],
				desc = L["Empty Frames must be enabled \n(in UnitFrames options)"],
				values = {
					['NONE'] = L['None'],
					['REP'] = L['Reputation'],
					['XP'] = L['Experience'],
				},
				set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:EnableDisable_ReputationBar(); BXR:EnableDisable_ExperienceBar(); end,
			},
			general = {
				order = 3,
				type = 'group',
				name = L["Text"],
				guiInline = true,
				args = {
					textStyle = {
						order = 1,
						type = "select",
						name = L["Copy Font Style from"],
						values = {
							['DAFAULT'] = DEFAULT,
							['DATA'] = L['DataTexts'],
							['UNIT'] = L['UnitFrames'],
						},
						set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:ChangeRepXpFont(); end,
					},
					textFormat = {
						order = 2,
						type = 'select',
						name = L["Text Format"],
						values = {
							NONE = NONE,
							PERCENT = L["Percent"],
							CURMAX = L["Current - Max"],
							CURPERC = L["Current - Percent"],
						},
						set = function(info, value) E.db.xprep[ info[#info] ] = value; if E.db.xprep.show == 'XP' then BXR:UpdateExperience() elseif E.db.xprep.show == 'REP' then BXR:UpdateReputation() end; end,
					},
					mouseOver = {
						order = 3,
						type = "toggle",
						name = L["Hide PlayerBar text values"],
						desc = L["Hides health, power and custom text values when mousing over, if their yOffset is"].." < -10",
						set = function(info, value) E.db.xprep[ info[#info] ] = value end,
					},
				},
			},
		},
	}
end

table.insert(E.BuiConfig, xprepTable)