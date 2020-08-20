local BUI, E, L, V, P, G = unpack(select(2, ...))

local ClearRealm = string.gsub(E.myrealm, "%s+", "")

function BUI:LoadDBMProfile()
	local profileName = "BenikUI"..E.myname.."-"..ClearRealm -- DBM doesn't like spaces in the profile name

	if DBM_AllSavedOptions[profileName] == nil then
		DBM:CreateProfile(profileName)

		local font
		if E.private.benikui.expressway == true then
			font = "Interface\\AddOns\\ElvUI\\media\\fonts\\Expressway.ttf"
		else
			font = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
		end

		DBM_AllSavedOptions[profileName]["SpecialWarningFontShadow"] = true
		DBM_AllSavedOptions[profileName]["SpecialWarningFontStyle"] = "NONE"
		DBT_AllPersistentOptions[profileName]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Flat.tga"
		DBT_AllPersistentOptions[profileName]["DBM"]["Scale"] = 1
		DBT_AllPersistentOptions[profileName]["DBM"]["FontSize"] = 12
		DBT_AllPersistentOptions[profileName]["DBM"]["HugeScale"] = 1
		DBT_AllPersistentOptions[profileName]["DBM"]["Font"] = font
		DBT_AllPersistentOptions[profileName]["DBM"]["BarYOffset"] = 16
		DBT_AllPersistentOptions[profileName]["DBM"]["HugeBarYOffset"] = 16
		DBM_AllSavedOptions[profileName]["WarningFont"] = font
		DBM_AllSavedOptions[profileName]["SpecialWarningFont"] = font

		DBM:ApplyProfile(profileName)
		if BUI.isInstallerRunning == false then
			print(BUI.profileStrings[1]..L['Deadly Boss Mods'])
		end
	else
		print(BUI.Title.."- "..L['Deadly Boss Mods']..BUI.profileStrings[2])
	end
end
