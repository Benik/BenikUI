local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadMSBTProfile()
	MSBTProfiles_SavedVars['profiles']['BenikUI'] = {
		["scrollAreas"] = {
			["Incoming"] = {
				["behavior"] = "MSBT_NORMAL",
				["offsetY"] = -161,
				["offsetX"] = -330,
				["animationStyle"] = "Straight",
			},
			["Outgoing"] = {
				["direction"] = "Up",
				["offsetX"] = 287,
				["behavior"] = "MSBT_NORMAL",
				["offsetY"] = -161,
				["animationStyle"] = "Straight",
			},
			["Static"] = {
				["offsetX"] = -21,
				["offsetY"] = -231,
			},
		},
		["normalFontName"] = "Bui Prototype",
		["critFontName"] = "Bui Prototype",
		["creationVersion"] = MikSBT.VERSION.."."..MikSBT.SVN_REVISION,
	}
	MikSBT.Profiles.SelectProfile('BenikUI')
end