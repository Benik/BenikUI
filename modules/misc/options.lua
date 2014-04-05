local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');

if E.db.xprep == nil then E.db.xprep = {} end

-- Defaults
P['xprep'] = {
	['show'] = "REP",
	['textStyle'] = 'UNIT',
}

local function xprepTable()
	E.Options.args.bui.args.xprep = {
		order = 7,
		type = 'group',
		name = L["XP - Rep"],
		guiInline = true,
		args = {
			show = {
				order = 1,
				type = "select",
				name = L["Show in PlayerBar"],
				values = {
					['NONE'] = L['None'],
					['REP'] = L['Reputation'],
					['XP'] = L['Experience'],
				},
				get = function(info) return E.db.xprep[ info[#info] ] end,
				set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:EnableDisable_ReputationBar(); BXR:EnableDisable_ExperienceBar(); end,
			},
			textStyle = {
				order = 2,
				type = "select",
				name = L["Copy Font Style from"],
				values = {
					['DAFAULT'] = DEFAULT,
					['DATA'] = L['Datatexts'],
					['UNIT'] = L['Unitframes'],
				},
				get = function(info) return E.db.xprep[ info[#info] ] end,
				set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:ChangeRepXpFont(); end,
			},
		},
	}
end

table.insert(E.BuiConfig, xprepTable)