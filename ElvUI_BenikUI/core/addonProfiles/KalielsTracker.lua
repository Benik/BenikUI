local BUI, E, L, V, P, G = unpack(select(2, ...))
local ClearRealm = string.gsub(E.myrealm, "%s+", "")

function BUI:LoadKalielsProfile()
    local font, fontsize
    local key = BUI.Title..E.myname.."-"..ClearRealm -- Kaliel doesn't like spaces in the profile name
    local KT = _G.LibStub('AceAddon-3.0'):GetAddon('!KalielsTracker', true)

	if E.private.benikui.expressway == true then
		font = "Expressway"
		fontsize = 12
	else
		font = "Bui Prototype"
		fontsize = 11
    end

    if KalielsTrackerDB['profiles'][key] == nil then
        KalielsTrackerDB["profiles"][key] = {
            ["xOffset"] = -216,
            ["soundQuest"] = false,
            ["bgrInset"] = 0,
            ["font"] = font,
            ["fontSize"] = fontsize,
            ["hdrBgr"] = 1,
            ["hdrCollapsedTxt"] = 1,
            ["progressBar"] = "BuiFlat",
        }
        if KT then
            KT.db:SetProfile(key)
        end

		if BUI.isInstallerRunning == false then -- don't print during Install, when applying profile that doesn't exist
			BUI:Print(format(BUI.profileStrings[1], L['Kaliels Tracker']))
		end
	else
		BUI:Print(format(BUI.profileStrings[2], L['Kaliels Tracker']))
    end
end