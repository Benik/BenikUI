local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadDBMProfile()
	DBM:CreateProfile('BenikUI')
	
	-- Warnings
	DBM_AllSavedOptions["BenikUI"]["WarningFont"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
	DBM_AllSavedOptions["BenikUI"]["SpecialWarningFont"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
	DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontShadow"] = true
	DBM_AllSavedOptions["BenikUI"]["SpecialWarningFontStyle"] = "NONE"
	
	-- Bars
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\Flat.tga"
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["Font"] = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["Scale"] = 1
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["FontSize"] = 12
	DBT_AllPersistentOptions["BenikUI"]["DBM"]["HugeScale"] = 1
	
	DBM:ApplyProfile('BenikUI')
end
