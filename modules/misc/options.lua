local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');
local M = E:GetModule('Misc');

if E.db.xprep == nil then E.db.xprep = {} end

-- Defaults
P['xprep'] = {
	['show'] = "REP",
	['text'] = true,
	['textStyle'] = 'UNIT',
}

local function XpRepPositions(value)
	if value == 'REP' then
		BXR:CreateRepStatus()
	elseif value == 'XP' then
		BXR:CreateXPStatus()
	else
		BXR:RevertXpRep()
	end
	M:EnableDisable_ReputationBar()
	M:EnableDisable_ExperienceBar()
end

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
				set = function(info, value) E.db.xprep[ info[#info] ] = value; XpRepPositions(value); end,
			},
			text = {
				order = 2,
				type = "toggle",
				name = L["Hide Text"],
				desc = L["Hides the XP or Rep text from the statusbars"],
				get = function(info) return E.db.xprep[ info[#info] ] end,
				set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:ShowHideRepXpText(); end,
			},
			textStyle = {
				order = 3,
				type = "select",
				name = L["Copy Font Style from"],
				values = {
					['DAFAULT'] = DEFAULT,
					['DATA'] = L['Datatexts'],
					['UNIT'] = L['Unitframes'],
				},
				disabled = function() return E.db.xprep.text end,
				get = function(info) return E.db.xprep[ info[#info] ] end,
				set = function(info, value) E.db.xprep[ info[#info] ] = value; BXR:ChangeRepXpFont(); end,
			},
		},
	}
end

table.insert(E.BuiConfig, xprepTable)