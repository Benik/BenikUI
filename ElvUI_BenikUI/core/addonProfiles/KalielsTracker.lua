local BUI, E, L, V, P, G = unpack((select(2, ...)))
local ClearRealm = string.gsub(E.myrealm, "%s+", "")

function BUI:LoadKalielsProfile()
	if not BUI:IsAddOnEnabled('!KalielsTracker') then return end

	local format = string.format
	local UnitName, GetRealmName = UnitName, GetRealmName

	local font, fontsize
	local key = BUI.Title..E.myname.."-"..ClearRealm

	if E.private.benikui.expressway == true then
		font = "Expressway"
		fontsize = 12
	else
		font = "Bui Prototype"
		fontsize = 11
	end

	if not KalielsTrackerDB then KalielsTrackerDB = {} end
	if not KalielsTrackerDB.profiles then KalielsTrackerDB.profiles = {} end

	if KalielsTrackerDB.profiles[key] == nil then
		KalielsTrackerDB.profiles[key] = {
			["soundQuest"] = false,
			["bgrInset"] = 0,
			["font"] = font,
			["fontSize"] = fontsize,
			["hdrBgr"] = 1,
			["hdrCollapsedTxt"] = 1,
			["progressBar"] = "BuiFlat",
		}

		local playerKey = UnitName("player").." - "..GetRealmName()
		KalielsTrackerDB.profileKeys[playerKey] = key

		if BUI.isInstallerRunning == false then 
			BUI:Print(format(BUI.profileStrings[1], L['Kaliels Tracker']))
		end
	else
		BUI:Print(format(BUI.profileStrings[2], L['Kaliels Tracker']))
	end
end