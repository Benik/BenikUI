
local Locale = GetLocale()
local benikUIfont
if Locale == "ruRU" then
	benikUIfont = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE_RU.TTF"
else
	benikUIfont = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
	DAMAGE_TEXT_FONT = benikUIfont;
	UNIT_NAME_FONT = benikUIfont;
	f:UnregisterEvent("ADDON_LOADED")
end)
