local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadDBMProfile()
	DBM:CreateProfile('BenikUI')
	
	local font
	if E.private.benikui.expressway == true then
		font = "Interface\\AddOns\\ElvUI\\media\\fonts\\Expressway.ttf"
	else
		font = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
	end

	DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontShadow"] = true
	DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontStyle"] = "NONE"
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Flat.tga"
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["Scale"] = 1
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["FontSize"] = 12
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["HugeScale"] = 1
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["Font"] = font
	DBM_AllSavedOptions["BenikUI"]["WarningFont"] = font
	DBM_AllSavedOptions["BenikUI"]["SpecialWarningFont"] = font
	
	DBM:ApplyProfile('BenikUI')
end
