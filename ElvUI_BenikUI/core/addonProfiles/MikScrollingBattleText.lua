local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadMSBTProfile()
	local font
	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end

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
		["normalFontName"] = font,
		["critFontName"] = font,
		["creationVersion"] = MikSBT.VERSION.."."..MikSBT.SVN_REVISION,
	}
	MikSBT.Profiles.SelectProfile('BenikUI')
end