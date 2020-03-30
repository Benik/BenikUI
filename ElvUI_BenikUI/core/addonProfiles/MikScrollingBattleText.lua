local BUI, E, L, V, P, G = unpack(select(2, ...))

function BUI:LoadMSBTProfile()
	local font
	local key = BUI.AddonProfileKey
	local addonName = GetAddOnMetadata('MikScrollingBattleText', 'Title')

	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end
	if MSBTProfiles_SavedVars['profiles'][key] == nil then
		MSBTProfiles_SavedVars['profiles'][key] = {
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
		MikSBT.Profiles.SelectProfile(key)

		if BUI.isInstallerRunning == false then -- don't print during Install, when applying profile that doesn't exist
			BUI:Print(BUI.profileStrings[1], addonName)
		end
	else
		BUI:Print(BUI.profileStrings[2], addonName)
	end
end